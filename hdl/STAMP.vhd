--------------------------------------------------------------------------------
-- HERMESS Project
-- 
-- This is designed for use with 3 ADS114x on a shared SPI bus.
-- 
-- ADDRESS:
-- Always usable Modifiers:
-- 1XXX XXXX        Atomic operation
-- X1XX XXXX        Reset status register after finishing operation
-- Writing to ADCs:
-- XX00 1XXX        Polling request: Only exits once the drdy line goes down again.
-- XX00 XXX1        ADC for DMS1 (write only the least significant 16 bits)
-- XX00 XX1X        ADC for DMS2 (write only the least significant 16 bits)
-- XX00 X1XX        ADC for PT100 (write only the least significant 16 bits)
-- Other registers and commands:
-- XX00 0000        NOP
-- XX00 1000        Last ADC reading (read only the least significant 16 bits)
-- XX01 0000        DMS1 & DMS2 (read only)
-- XX01 1000        Temp & Status register (read only)
-- XX10 0000        Access 32 bit configuration register
-- XX11 1000        Access 32 bit dummy register
-- All others are undefined and enable FLOMESS legacy mode (unpredictable behavior)
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;



ENTITY STAMP IS
    GENERIC(
        async_threshold : INTEGER RANGE 0 TO 63 := 63;
        stamp_id : INTEGER RANGE 0 TO 7 := 0
    );
    PORT(
        new_avail : OUT STD_LOGIC; -- goes high, when new data of both DMS are available
        request_resync : OUT STD_LOGIC; -- goes high, when there is an offset
        -- apb3 ports
        PCLK : IN STD_LOGIC;
        PRESETN : IN STD_LOGIC; -- does only reset the block, not the ADCs
        PADDR : IN STD_LOGIC_VECTOR(7 downto 0);
        PSEL : IN STD_LOGIC;
        PENABLE : IN STD_LOGIC;
        PWRITE : IN STD_LOGIC;
        PWDATA : IN STD_LOGIC_VECTOR(31 downto 0);
        PRDATA : OUT STD_LOGIC_VECTOR(31 downto 0);
        PREADY : OUT STD_LOGIC;
        PSLVERR : OUT STD_LOGIC; -- not supported by this component
        -- the SPI ports
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
    type component_state_t is (fsm_idle, fsm_apb_setup, fsm_apb_access, fsm_spi_setup, fsm_spi_access);
    signal component_state : component_state_t;
    type spi_request_for_t is (srf_dms1, srf_dms2, srf_temp, srf_apb);
    signal spi_request_for : spi_request_for_t;
    signal apb_is_atomic : STD_LOGIC;
    signal apb_is_reset : STD_LOGIC;
    signal apb_spi_finished : STD_LOGIC;
    signal async_state : INTEGER RANGE 0 TO 2;
    -- contains internal spi signals
    signal spi_enable : STD_LOGIC;
    signal spi_busy : STD_LOGIC;
    signal spi_tx_data : STD_LOGIC_VECTOR(15 downto 0);
    signal spi_rx_data : STD_LOGIC_VECTOR(15 downto 0);
    -- contains all status bits
    signal status_register : STD_LOGIC_VECTOR(0 to 15);
    signal status_dms1_newVal : STD_LOGIC; -- indicates, if there has been a new reading since last pulling
    signal status_dms2_newVal : STD_LOGIC;
    signal status_temp_newVal : STD_LOGIC;
    signal status_dms1_overwrittenVal : STD_LOGIC; -- indicates, this value was overwritten before it was read
    signal status_dms2_overwrittenVal : STD_LOGIC;
    signal status_temp_overwrittenVal : STD_LOGIC;
    signal status_async_cycles : INTEGER RANGE 0 TO 63;
	-- contains the last measured values
    signal measurement_dms1 : STD_LOGIC_VECTOR(15 downto 0);
	signal measurement_dms2 : STD_LOGIC_VECTOR(15 downto 0);
	signal measurement_temp : STD_LOGIC_VECTOR(15 downto 0);
    -- configuration register
    signal config : STD_LOGIC_VECTOR(0 TO 31);
    signal conf_reset : STD_LOGIC; -- resets this module
    signal conf_continuous : STD_LOGIC; -- enables the automatic reading of data on drdy
    -- the dummy register for apb testing
    signal dummy : STD_LOGIC_VECTOR(31 downto 0);

    
BEGIN
    -- initialize the SPI master module
    -- we do not use their chip select though, but our own
    spi : ENTITY work.spi_master
        GENERIC MAP(3, 16)
        PORT MAP(PCLK, PRESETN, spi_enable, '0', '1', '0', 1, 0, spi_tx_data,
            spi_miso, spi_clock, open, spi_mosi, spi_busy, spi_rx_data);
    
    -- define constants
    PSLVERR <= '0';

    -- define the status register
    status_register(0) <= status_dms1_newVal;
    status_register(1) <= status_dms2_newVal;
    status_register(2) <= status_temp_newVal;
    status_register(3) <= status_dms1_overwrittenVal;
    status_register(4) <= status_dms2_overwrittenVal;
    status_register(5) <= status_temp_overwrittenVal;
    status_register(6) <= request_resync;
    status_register(7 to 12) <= STD_LOGIC_VECTOR(to_unsigned(status_async_cycles, 6));
    status_register(13 to 15) <= STD_LOGIC_VECTOR(to_unsigned(stamp_id, 3));
    -- define the configuration register
    conf_reset <= config(0);
    conf_continuous <= config(1);
    
    
    PROCESS (PRESETN, PCLK, conf_reset)
        variable next_state : component_state_t;
    BEGIN
        -- trigger component reset
        IF (PRESETN = '0' OR conf_reset = '1') THEN
            new_avail <= '0';
            request_resync <= '0';
            PREADY <= '0';
            spi_dms1_cs <= '1';
            spi_dms2_cs <= '1';
            spi_temp_cs <= '1';
            component_state <= fsm_idle;
            async_state <= 0;
            spi_enable <= '0';
            status_dms1_newVal <= '0';
            status_dms2_newVal <= '0';
            status_temp_newVal <= '0';
            status_dms1_overwrittenVal <= '0';
            status_dms2_overwrittenVal <= '0';
            status_temp_overwrittenVal <= '0';
            status_async_cycles <= 0;
            dummy <= x"FFFFFFFF";
            -- do not reset because of keeping the state accross resync
            config <= x"00000000";
        
        
        ELSIF (rising_edge(PCLK)) THEN
            next_state := component_state;
            CASE component_state IS
                WHEN fsm_idle =>
                    -- read the incoming data from the adcs
                    IF (conf_continuous = '1') THEN
                        spi_tx_data <= x"FFFF";
                        -- inform uC, that there are new data available
                        IF (status_dms1_newVal = '1' AND status_dms2_newVal = '1') THEN
                            new_avail <= '1';
                        ELSE
                            new_avail <= '0';
                        END IF;
                        -- initialize spi communication if there are new data
                        IF (ready_dms1 = '0') THEN
                            spi_dms1_cs <= '0';
                            spi_enable <= '1';
                            spi_request_for <= srf_dms1;
                            next_state := fsm_spi_setup;
                        ELSIF (ready_dms2 = '0') THEN
                            spi_dms2_cs <= '0';
                            spi_enable <= '1';
                            spi_request_for <= srf_dms2;
                            next_state := fsm_spi_setup;
                        ELSIF (ready_temp = '0') THEN
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
                    
                    -- make sure not to accidentally skip an apb transfer
                    PREADY <= '0';
                
                
                -- just wait for the spi master to start working
                WHEN fsm_spi_setup =>
                    IF (spi_busy = '1') THEN
                        spi_enable <= '0';
                        next_state := fsm_spi_access;
                    END IF;
                
                
                -- wait for the spi master to complete operation
                WHEN fsm_spi_access =>
                    IF (spi_busy = '0') THEN
                        -- reset the chip select
                        spi_dms1_cs <= '1';
                        spi_dms2_cs <= '1';
                        spi_temp_cs <= '1';
                        
                        -- in case DMS1 was the requested adc
                        IF (spi_request_for = srf_dms1) THEN
                            status_dms1_overwrittenVal <= status_dms1_newVal;
                            status_dms1_newVal <= '1';
                            measurement_dms1 <= spi_rx_data;
                            IF (async_state < 2) THEN
                                async_state <= async_state + 1;
                            END IF;
                            next_state := fsm_idle;
                        -- in case DMS1 was the requested adc
                        ELSIF (spi_request_for = srf_dms2) THEN
                            status_dms2_overwrittenVal <= status_dms2_newVal;
                            status_dms2_newVal <= '1';
                            measurement_dms2 <= spi_rx_data;
                            IF (async_state < 2) THEN
                                async_state <= async_state + 1;
                            END IF;
                            next_state := fsm_idle;
                        -- in case temp was the requested adc
                        ELSIF (spi_request_for = srf_temp) THEN
                            status_temp_overwrittenVal <= status_temp_newVal;
                            status_temp_newVal <= '1';
                            measurement_temp <= spi_rx_data;
                            next_state := fsm_idle;
                        -- in case the request was triggered by apb
                        ELSIF (spi_request_for = srf_apb) THEN
                            next_state := fsm_apb_access;
                            apb_spi_finished <= '1';
                        END IF;
                    END IF;
                
                
                -- the apb setup phase
                WHEN fsm_apb_setup =>
                    PREADY <= '0';
                    IF (PENABLE = '1') THEN
                        apb_is_atomic <= PADDR(7);
                        apb_is_reset <= PADDR(6);
                        apb_spi_finished <= '0';
                        next_state := fsm_apb_access;
                    END IF;
                
                
                -- is in access phase
                WHEN fsm_apb_access =>
                    -- return to another state, if enable is 0
                    IF (PENABLE = '0') THEN
                        PREADY <= '0';
                        IF (apb_is_reset = '1') THEN
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
                        END IF;
                        IF (apb_is_atomic = '0') THEN
                            next_state := fsm_idle;
                        ELSE
                            next_state := fsm_apb_setup;
                        END IF;
                    
                    -- Addr: NOP
                    ELSIF (PADDR(5 downto 0) = "000000") THEN
                        PREADY <= '1';
                    
                    -- Addr: Write to ADC
                    ELSIF (PADDR(5 downto 3) = "000" AND PWRITE = '1') THEN
                        -- write via spi
                        IF (apb_spi_finished = '0') THEN
                            IF (PADDR(0) = '1') THEN
                                spi_dms1_cs <= '0';
                            END IF;
                            IF (PADDR(1) = '1') THEN
                                spi_dms2_cs <= '0';
                            END IF;
                            IF (PADDR(2) = '1') THEN
                                spi_temp_cs <= '0';
                            END IF;
                            spi_tx_data <= PWDATA(15 downto 0);
                            spi_enable <= '1';
                            spi_request_for <= srf_apb;
                            next_state := fsm_spi_setup;
                        -- signal the finishing of spi transfer
                        ELSIF (PADDR(3) = '0'
                        OR (PADDR(3) = '1' AND ready_dms1 = '0' AND PADDR(0) = '1')
                        OR (PADDR(3) = '1' AND ready_dms2 = '0' AND PADDR(1) = '1')
                        OR (PADDR(3) = '1' AND ready_temp = '0' AND PADDR(2) = '1')) THEN
                            PREADY <= '1';
                        END IF;
                    
                    -- Addr: Last ADC reading
                    ELSIF (PADDR(5 downto 0) = "001000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= x"0000";
                        PRDATA(15 downto 0) <= spi_rx_data;
                        PREADY <= '1';
                    
                    -- Addr: DMS1 and DMS2 measurement
                    ELSIF (PADDR(5 downto 0) = "010000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= measurement_dms1;
                        PRDATA(15 downto 0) <= measurement_dms2;
                        PREADY <= '1';
                        
                    -- Addr: temp measurement and status register
                    ELSIF (PADDR(5 downto 0) = "011000" AND PWRITE = '0') THEN
                        PRDATA(31 downto 16) <= measurement_temp;
                        PRDATA(15 downto 0) <= status_register;
                        PREADY <= '1';
                        
                    -- Addr: Access configuration register
                    ELSIF (PADDR(5 downto 0) = "100000") THEN
                        PREADY <= '1';
                        IF (PWRITE = '0') THEN
                            PRDATA <= config;
                        ELSE
                            config <= PWDATA;
                        END IF;
                    
                    -- Addr: Access dummy register
                    ELSIF (PADDR(5 downto 0) = "111000") THEN
                        PREADY <= '1';
                        IF (PWRITE = '0') THEN
                            PRDATA <= dummy;
                        ELSE
                            dummy <= PWDATA;
                        END IF;
                    
                    -- Ignore all non defined actions
                    ELSE
                        PREADY <= '1';
                    END IF;
            END CASE;
            component_state <= next_state;
            
            
            -- update the async_cycles counter
            IF (async_state = 0) THEN
                status_async_cycles <= 0;
            ELSIF (async_state = 1) THEN
                status_async_cycles <= status_async_cycles + 1;
                IF (status_async_cycles >= async_threshold) THEN
                    async_state <= 2;
                    request_resync <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

   
END architecture_STAMP;
