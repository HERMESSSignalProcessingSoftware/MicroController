--------------------------------------------------------------------------------
-- HERMESS Project
-- 
-- This is designed for use with 3 ADS114x on a shared SPI bus.
-- 
-- ADDRESS:
-- Always usable Modifiers:
-- 1XXX XXXX 0000       Atomic operation
-- X1XX XXXX 0000       Reset status register after finishing operation
-- Writing to ADCs:
-- XX00 1XXX 0000       Polling request: Only exits once the drdy line goes down again.
-- XX00 XXX1 0000       ADC for DMS1 (write only the least significant 16 bits)
-- XX00 XX1X 0000       ADC for DMS2 (write only the least significant 16 bits)
-- XX00 X1XX 0000       ADC for PT100 (write only the least significant 16 bits)
-- Other registers and commands:
-- XX00 0000 0000       NOP
-- XX00 1000 0000       Last ADC reading (read only the least significant 16 bits)
-- XX01 0000 0000       DMS1 & DMS2 (read only)
-- XX01 1000 0000       Temp & Status register (read only)
-- XX10 0000 0000       Access 32 bit configuration register
-- XX11 1000 0000       Access 32 bit dummy register
-- All others are undefined and enable FLOMESS legacy mode (unpredictable behavior)
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY STAMP IS
    GENERIC(
        async_prescaler : INTEGER RANGE 0 TO 65535 := 2500 -- 16 bit; default 0.05ms @ 50MHz
    );
    PORT(
        -- general IO for interfacing with other FPGA components
        new_avail : OUT STD_LOGIC; -- goes high, when new data of both DMS are available
        request_resync : OUT STD_LOGIC; -- goes high, when there is an offset
        data_frame : OUT STD_LOGIC_VECTOR(63 downto 0); -- [DMS1, DMS2, TEMP, STATUS]
        reset_status : IN STD_LOGIC; -- will reset status register (including new_avail) when
                -- high. Note, that it should be kept high, until new_avail went low again,
                -- as ongoing SPI communications blocks this feature to prevent racing conditions
        -- apb3 ports
        PCLK : IN STD_LOGIC;
        PRESETN : IN STD_LOGIC; -- does only reset the block, not the ADCs
        PADDR : IN STD_LOGIC_VECTOR(11 downto 0);
        PSEL : IN STD_LOGIC;
        PENABLE : IN STD_LOGIC;
        PWRITE : IN STD_LOGIC;
        PWDATA : IN STD_LOGIC_VECTOR(31 downto 0);
        PRDATA : OUT STD_LOGIC_VECTOR(31 downto 0);
        PREADY : OUT STD_LOGIC;
        PSLVERR : OUT STD_LOGIC; -- not supported by this component
        -- the adc SPI ports
        spi_clock : OUT STD_LOGIC; -- period: <= 520ns
        spi_miso : IN STD_LOGIC;
        spi_mosi : OUT STD_LOGIC;
        spi_dms1_cs : OUT STD_LOGIC;
        spi_dms2_cs : OUT STD_LOGIC;
        spi_temp_cs : OUT STD_LOGIC;
        -- the adc interrupt input pins
        ready_dms1 : IN STD_LOGIC;
        ready_dms2 : IN STD_LOGIC;
        ready_temp : IN STD_LOGIC
    );
END STAMP;



ARCHITECTURE architecture_STAMP of STAMP IS
    -- state machines
    type component_state_t is (fsm_idle, fsm_apb_setup, fsm_apb_access,
            fsm_apb_teardown, fsm_spi_setup, fsm_spi_access);
    signal component_state : component_state_t;
    type spi_request_for_t is (srf_dms1, srf_dms2, srf_temp, srf_apb);
    signal spi_request_for : spi_request_for_t;
    signal async_state : INTEGER RANGE 0 TO 2; -- 0=normal; 1=first DMS read; 2=async, when conf_async_threshold exceeded
    -- signal containing information about whether a drdy flank occured
    signal drdy_flank_detected_dms1 : STD_LOGIC;
    signal drdy_flank_detected_dms2 : STD_LOGIC;
    signal drdy_flank_detected_temp : STD_LOGIC;
    -- global variable signals
    signal apb_is_atomic : STD_LOGIC;
    signal apb_is_reset : STD_LOGIC;
    signal apb_spi_finished : STD_LOGIC;
    signal async_prescaler_count : INTEGER RANGE 0 TO 65535;
    signal delay_counter : INTEGER;
    -- contains internal spi signals
    signal spi_enable : STD_LOGIC;
    signal spi_busy : STD_LOGIC;
    signal spi_tx_data : STD_LOGIC_VECTOR(15 downto 0);
    signal spi_rx_data : STD_LOGIC_VECTOR(15 downto 0);
    -- configuration register
    signal config : STD_LOGIC_VECTOR(31 downto 0);
    signal conf_reset : STD_LOGIC; -- resets this module
    signal conf_continuous : STD_LOGIC; -- enables the automatic reading of data on drdy
    signal conf_async_threshold : INTEGER;
    signal conf_stamp_id : STD_LOGIC_VECTOR(2 downto 0);
    -- contains all status bits
    signal status_register : STD_LOGIC_VECTOR(15 downto 0);
    signal status_dms1_newVal : STD_LOGIC; -- indicates, if there has been a new reading since last pulling
    signal status_dms2_newVal : STD_LOGIC;
    signal status_temp_newVal : STD_LOGIC;
    signal status_dms1_overwrittenVal : STD_LOGIC; -- indicates, this value was overwritten before it was read
    signal status_dms2_overwrittenVal : STD_LOGIC;
    signal status_temp_overwrittenVal : STD_LOGIC;
    signal status_async_cycles : INTEGER RANGE 0 TO 63; -- signed int of prescaled cylces, DMS1 - DMS2 offset
	-- contains the last measured values
    signal measurement_dms1 : STD_LOGIC_VECTOR(15 downto 0);
	signal measurement_dms2 : STD_LOGIC_VECTOR(15 downto 0);
	signal measurement_temp : STD_LOGIC_VECTOR(15 downto 0);
    -- the dummy register for apb testing
    signal dummy : STD_LOGIC_VECTOR(31 downto 0);

    
BEGIN
    -- initialize the SPI master module
    -- we do not use their chip select though, but our own
    spi : ENTITY work.spi_master
        GENERIC MAP(1, 16)
        PORT MAP(PCLK, PRESETN, spi_enable, '0', '1', '0', 15, 0, spi_tx_data,
            spi_miso, spi_clock, open, spi_mosi, spi_busy, spi_rx_data);
    
    -- define constants
    PSLVERR <= '0';

    -- define the data frame
    data_frame(63 downto 48) <= measurement_dms1;
    data_frame(47 downto 32) <= measurement_dms2;
    data_frame(31 downto 16) <= measurement_temp;
    data_frame(15 downto 0) <= status_register;
    
    -- define the configuration register
    conf_reset <= config(31);
    conf_continuous <= config(30);
    conf_async_threshold <= to_integer(unsigned(config(29 downto 24)));
    conf_stamp_id <= config(2 downto 0);
    -- define the status register
    status_register(15) <= status_dms1_newVal;
    status_register(14) <= status_dms2_newVal;
    status_register(13) <= status_temp_newVal;
    status_register(12) <= status_dms1_overwrittenVal;
    status_register(11) <= status_dms2_overwrittenVal;
    status_register(10) <= status_temp_overwrittenVal;
    status_register(9) <= request_resync;
    status_register(8 downto 3) <= STD_LOGIC_VECTOR(to_unsigned(status_async_cycles, 6));
    status_register(2 downto 0) <= conf_stamp_id;
    
    
    PROCESS (PRESETN, PCLK)
        variable next_state : component_state_t;
        
        -- resets the the inter STAMP (not the ADCs).
        -- hardreset addtionally resets the internal configuration.
        PROCEDURE proc_reset_stamp (constant hardreset : in BOOLEAN) IS BEGIN
            new_avail <= '0';
            request_resync <= '0';
            PREADY <= '0';
            async_prescaler_count <= 0;
            delay_counter <= 0;
            spi_dms1_cs <= '1';
            spi_dms2_cs <= '1';
            spi_temp_cs <= '1';
            component_state <= fsm_idle;
            async_state <= 0;
            drdy_flank_detected_dms1 <= '0';
            drdy_flank_detected_dms2 <= '0';
            drdy_flank_detected_temp <= '0';
            spi_enable <= '0';
            status_dms1_newVal <= '0';
            status_dms2_newVal <= '0';
            status_temp_newVal <= '0';
            status_dms1_overwrittenVal <= '0';
            status_dms2_overwrittenVal <= '0';
            status_temp_overwrittenVal <= '0';
            status_async_cycles <= 0;
            dummy <= x"00000000";
            -- do not reset config for keeping the state accross resync
            IF (hardreset) THEN
                config <= (others => '0');
            ELSE
                config(31) <= '0'; -- conf_reset
            END IF;
        END PROCEDURE;
        
        -- resets only the status register
        PROCEDURE proc_reset_status IS BEGIN
            new_avail <= '0';
            status_dms1_newVal <= '0';
            status_dms2_newVal <= '0';
            status_temp_newVal <= '0';
            status_dms1_overwrittenVal <= '0';
            status_dms2_overwrittenVal <= '0';
            status_temp_overwrittenVal <= '0';
            IF (async_state = 1) THEN
                async_state <= 0;
            END IF;
        END PROCEDURE;
    BEGIN
        -- trigger component reset
        IF (PRESETN = '0') THEN
            proc_reset_stamp(true);
        
        
        ELSIF (rising_edge(PCLK)) THEN
            next_state := component_state;
            CASE component_state IS
                WHEN fsm_idle =>
                    IF (conf_reset = '1') THEN
                        proc_reset_stamp(false);
                    END IF;
                    IF (reset_status = '1') THEN
                        proc_reset_status;
                    END IF;
                    
                    -- this delay will be > 0, whenever spi has finished and a chip select must settle
                    -- for at least tcspw (~1.25us)
                    IF (delay_counter = 0) THEN
                        -- read the incoming data from the adcs
                        IF (conf_continuous = '1') THEN
                            spi_tx_data <= x"FFFF";
                            -- inform uC, that there are new data available
                            IF (status_dms1_newVal = '1' AND status_dms2_newVal = '1') THEN
                                new_avail <= '1';
                            ELSE
                                new_avail <= '0';
                            END IF;
                            
                            --  initialize spi communication if there are new data
                            IF (drdy_flank_detected_dms1 = '1') THEN
                                spi_dms1_cs <= '0';
                                spi_enable <= '1';
                                spi_request_for <= srf_dms1;
                                next_state := fsm_spi_setup;
                            ELSIF (drdy_flank_detected_dms2 = '1') THEN
                                spi_dms2_cs <= '0';
                                spi_enable <= '1';
                                spi_request_for <= srf_dms2;
                                next_state := fsm_spi_setup;
                            ELSIF (drdy_flank_detected_temp = '1') THEN
                                spi_temp_cs <= '0';
                                spi_enable <= '1';
                                spi_request_for <= srf_temp;
                                next_state := fsm_spi_setup;
                            END IF;
                        ELSE
                            new_avail <= '0';
                        END IF;
                        
                        -- if no adc will be read, listen on the APB3, if there is a request pending
                        IF (PSEL = '1' AND next_state = fsm_idle) THEN
                            next_state := fsm_apb_setup;
                        END IF;
                    ELSE
                        delay_counter <= delay_counter - 1;
                    END IF;
                    
                    -- make sure not to accidentially skip an apb transfer
                    PREADY <= '0';
                
                
                -- just wait for the spi master to start working
                WHEN fsm_spi_setup =>
                    IF (spi_busy = '1') THEN
                        spi_enable <= '0';
                        next_state := fsm_spi_access;
                        delay_counter <= 90;
                    END IF;
                
                
                -- wait for the spi master to complete operation
                WHEN fsm_spi_access =>
                    IF (spi_busy = '0') THEN
                        -- wait for minimum 1,75us (~90clk) to fulfill adc tsccs
                        IF (delay_counter = 0) THEN
                            -- in case DMS1 was the requested adc
                            IF (spi_request_for = srf_dms1) THEN
                                status_dms1_overwrittenVal <= status_dms1_newVal;
                                status_dms1_newVal <= '1';
                                measurement_dms1 <= spi_rx_data;
                                IF (async_state < 2) THEN
                                    async_state <= async_state + 1;
                                    status_async_cycles <= 1;
                                END IF;
                                next_state := fsm_idle;
                                spi_dms1_cs <= '1';
                                drdy_flank_detected_dms1 <= '0';
                            -- in case DMS2 was the requested adc
                            ELSIF (spi_request_for = srf_dms2) THEN
                                status_dms2_overwrittenVal <= status_dms2_newVal;
                                status_dms2_newVal <= '1';
                                measurement_dms2 <= spi_rx_data;
                                IF (async_state < 2) THEN
                                    async_state <= async_state + 1;
                                    status_async_cycles <= -1;
                                END IF;
                                next_state := fsm_idle;
                                spi_dms2_cs <= '1';
                                drdy_flank_detected_dms2 <= '0';
                            -- in case temp was the requested adc
                            ELSIF (spi_request_for = srf_temp) THEN
                                status_temp_overwrittenVal <= status_temp_newVal;
                                status_temp_newVal <= '1';
                                measurement_temp <= spi_rx_data;
                                next_state := fsm_idle;
                                spi_temp_cs <= '1';
                                drdy_flank_detected_temp <= '0';
                            -- in case the request was triggered by apb
                            ELSIF (spi_request_for = srf_apb) THEN
                                next_state := fsm_apb_access;
                                apb_spi_finished <= '1';
                            END IF;
                            -- in fsm_idle wait for at least 65clk (>1.25us) for tcspw
                            delay_counter <= 65;
                        ELSE
                            delay_counter <= delay_counter - 1;
                        END IF;
                    END IF;
                
                
                -- the apb setup phase
                WHEN fsm_apb_setup =>
                    PREADY <= '0';
                    IF (PENABLE = '1') THEN
                        apb_is_atomic <= PADDR(11);
                        apb_is_reset <= PADDR(10);
                        apb_spi_finished <= '0';
                        next_state := fsm_apb_access;
                    END IF;
                
                
                -- is in access phase
                WHEN fsm_apb_access =>
                    -- Addr: NOP
                    IF (PADDR(9 downto 0) = "0000000000") THEN
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                    
                    -- Addr: Write to ADC
                    ELSIF ((PADDR(4) = '1' OR PADDR(5) = '1' OR PADDR(6) = '1') AND PWRITE = '1') THEN
                        -- initialize spi transfer
                        IF (apb_spi_finished = '0') THEN
                            spi_dms1_cs <= NOT(PADDR(4));
                            spi_dms2_cs <= NOT(PADDR(5));
                            spi_temp_cs <= NOT(PADDR(6));
                            spi_tx_data <= PWDATA(15 downto 0);
                            spi_enable <= '1';
                            spi_request_for <= srf_apb;
                            next_state := fsm_spi_setup;
                        -- signal the finishing of spi transfer, but wait until drdy has
                        -- gone low, if address modifier demands it
                        ELSIF (PADDR(7) = '0'
                        OR (PADDR(7) = '1' AND ready_dms1 = '0' AND PADDR(4) = '1')
                        OR (PADDR(7) = '1' AND ready_dms2 = '0' AND PADDR(5) = '1')
                        OR (PADDR(7) = '1' AND ready_temp = '0' AND PADDR(6) = '1')) THEN
                            PREADY <= '1';
                            next_state := fsm_apb_teardown;
                        END IF;
                    
                    -- Addr: Last ADC reading
                    ELSIF (PADDR(9 downto 0) = "0010000000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= x"0000";
                        PRDATA(15 downto 0) <= spi_rx_data;
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                    
                    -- Addr: DMS1 and DMS2 measurement
                    ELSIF (PADDR(9 downto 0) = "0100000000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= measurement_dms1;
                        PRDATA(15 downto 0) <= measurement_dms2;
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                        
                    -- Addr: temp measurement and status register
                    ELSIF (PADDR(9 downto 0) = "0110000000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= measurement_temp;
                        PRDATA(15 downto 0) <= status_register;
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                        
                    -- Addr: Access configuration register
                    ELSIF (PADDR(9 downto 0) = "1000000000") THEN
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                        IF (PWRITE = '0') THEN
                            PRDATA <= config;
                        ELSE
                            config <= PWDATA;
                        END IF;
                    
                    -- Addr: Access dummy register
                    ELSIF (PADDR(9 downto 0) = "1110000000") THEN
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                        IF (PWRITE = '0') THEN
                            PRDATA <= dummy;
                        ELSE
                            dummy <= PWDATA;
                        END IF;
                    
                    -- Ignore all non defined actions
                    ELSE
                        PREADY <= '1';
                        next_state := fsm_apb_teardown;
                    END IF;
                    
                    
                WHEN fsm_apb_teardown =>
                    -- return to another state, if enable is 0
                    IF (PENABLE = '0') THEN
                        PREADY <= '0';
                        IF (apb_is_reset = '1') THEN
                            proc_reset_status;
                        END IF;
                        IF (apb_is_atomic = '0') THEN
                            next_state := fsm_idle;
                            spi_dms1_cs <= '1';
                            spi_dms2_cs <= '1';
                            spi_temp_cs <= '1';
                        ELSE
                            next_state := fsm_apb_setup;
                        END IF;
                    END IF;
                    
                
                WHEN others =>
                    next_state := fsm_idle;
                    
            END CASE;
            component_state <= next_state;
            
            
            -- use prescaler for async counting
            async_prescaler_count <= async_prescaler_count + 1;
            IF (async_prescaler_count >= async_prescaler) THEN
                async_prescaler_count <= 0;
                
                -- update the status_async_cycles counter
                IF (async_state = 0) THEN
                    status_async_cycles <= 0;
                ELSIF (async_state = 1) THEN
                    IF (status_async_cycles < 0) THEN
                        status_async_cycles <= status_async_cycles - 1;
                    ELSE
                        status_async_cycles <= status_async_cycles + 1;
                    END IF;
                    IF (status_async_cycles >= conf_async_threshold) THEN
                        async_state <= 2;
                        request_resync <= '1';
                    END IF;
                END IF;
            END IF;
            
            
            -- find drdy signals and store them until the component has time to process it
            IF (ready_dms1 = '0') THEN
                drdy_flank_detected_dms1 <= '1';
            END IF;
            IF (ready_dms2 = '0') THEN
                drdy_flank_detected_dms2 <= '1';
            END IF;
            IF (ready_temp = '0') THEN
                drdy_flank_detected_temp <= '1';
            END IF;
        END IF;
    END PROCESS;

   
END architecture_STAMP;
