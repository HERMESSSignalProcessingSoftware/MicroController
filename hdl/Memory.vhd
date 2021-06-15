----------------------------------------------------------------------------------
-- Company: REXUS HERMESS MESS II 
-- Engineer: Robin Grimsmann
-- 
-- Create Date:    25.02.2021 
-- Design Name: MESS II
-- Module Name: Memory Top Level Design REV 2
-- Project Name: HERMESS
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
-- Calculation of the number of pages: 512.000.000 bit of Memory => 64.000.000 MByte of Memory
-- => 64 Mbyte / 512 byte = 125000 Pages 
-- One Page contains:
-- Starting at 0x00 (offset in byte), one line contains 8 byte of data and a ninth byte of 0x00 as seperator 
-- +------------------------------+----+
-- |          METADATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 1 DATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 2 DATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 3 DATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 4 DATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 5 DATA            |0x00|
-- +------------------------------+----+
-- |    STAMP # 6 DATA            |0x00|
-- +------------------------------+----+
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.00 -  Update logic
--                  First 512 bytes are just for internal use, you may not write to this mememory.
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Memory is
  generic (
    addrbreite : integer := 9;
    wortbreite : integer := 32
  );
  port (
    clk                 : in std_logic;
    nReset              : in std_logic;
    enable              : in std_logic;
    databus             : in std_logic_vector(383 downto 0);
    dataReady           : in std_logic_vector(5 downto 0);
    dataReadyReset      : out std_logic; -- One signal to trigger the reset in each stamp module
    WatchdogGo          : in std_logic; -- If the watchdog detectes an error: he will give the go to save the data anyway
    -- Define signals of apb 3
    PADDR               : in std_logic_vector(11 downto 0);
    PSEL                : in std_logic;
    PENABLE             : in std_logic;
    PWRITE              : in std_logic;
    PWDATA              : in std_logic_vector((wortbreite - 1) downto 0);
    PREADY              : out std_logic;
    PRDATA              : out std_logic_vector((wortbreite - 1) downto 0);
    --SPI Signals
    MISO                : in std_logic;
    MOSI                : out std_logic;
    SCLK                : out std_logic;
    nCS1                : out std_logic;
    nCS2                : out std_logic
  ) ;
end Memory;

architecture arch of Memory is
  component Timestamp is
      port (
        clk         : in std_logic;
        nReset      : in std_logic;
        enable      : in std_logic; 
        getTime     : in std_logic;
        timestamp   : out std_logic_vector(31 downto 0)
      ) ;
    end component Timestamp;

    component ram IS
        GENERIC(
            MAXWIDTH : INTEGER := wortbreite;
            ADDRWIDTH : INTEGER := addrbreite -- Correction: 
        );
        PORT(
            clk          : IN STD_LOGIC;
            nReset	  	 : IN STD_LOGIC; -- correction: The customer wants a nREset signal, it was missing. 
            din          : IN STD_LOGIC_VECTOR(wortbreite-1 DOWNTO 0);  --Daten Eingang
            adr          : IN STD_LOGIC_VECTOR(addrbreite-1 DOWNTO 0); -- Correction use different address bus size than databus size
            writeEN      : IN STD_LOGIC;                              --enabled den schreib vorgang
            dout         : OUT STD_LOGIC_VECTOR(wortbreite-1 DOWNTO 0)   --Daten Ausgang
        );
    END component ram;

    component spi_master IS
        GENERIC(
            slaves  : INTEGER := 2;  --number of spi slaves
            d_width : INTEGER := wortbreite); --data bus width
        PORT(
            clock   : IN     STD_LOGIC;                             --system clock
            reset_n : IN     STD_LOGIC;                             --asynchronous reset
            enable  : IN     STD_LOGIC;                             --initiate transaction
            cpol    : IN     STD_LOGIC;                             --spi clock polarity
            cpha    : IN     STD_LOGIC;                             --spi clock phase
            cont    : IN     STD_LOGIC;                             --continuous mode command
            clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
            addr    : IN     INTEGER;                               --address of slave
            tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
            miso    : IN     STD_LOGIC;                             --master in, slave out
            sclk    : OUT    STD_LOGIC;                             --spi clock
            ss_n    : OUT    STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
            mosi    : OUT    STD_LOGIC;                             --master out, slave in
            busy    : OUT    STD_LOGIC;                             --busy / data ready signal
            rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
    END component  spi_master;

    -- Signal definitions
    -- Bus Signals
    -- Address busses
    signal InternalAddr2Memory      : std_logic_vector((addrbreite - 1) downto 0);
    -- Data busse
    signal InternalData2Memory      : std_logic_vector((wortbreite - 1) downto 0);
    signal InternalDataFromMem      : std_logic_vector((wortbreite - 1) downto 0);
    -- Enable Signals
    signal enableSPI                : std_logic;
    signal enableTimestampGen       : std_logic;
    -- Read = High, ReadWrite Memory signal
    signal WriteEnable              : std_logic;
    -- Signals for the TimeStamp generator 
    signal getTime                  : std_logic;
    signal TimeStampValue           : std_logic_vector(31 downto 0);
    -- Extra reset signal for Conveter, resets state machine    
    -- Signals for SPI
    signal ContiniousSPI            : std_logic;
    signal SPIaddr                  : integer range 0 to 1;
    signal InternalBusy             : std_logic;
    -- SPI Transmit Register
    signal SPITransmitReg           : std_logic_vector((wortbreite - 1) downto 0);
    -- SPI Recive Register          
    signal SPIRecReg                : std_logic_vector((wortbreite - 1) downto 0);
    -- Config status Register
    signal ConfigStatusReg          : std_logic_vector((wortbreite - 1) downto 0);
    -- Befehlsregister  
    signal CommandReg               : std_logic_vector((wortbreite - 1) downto 0);
    signal Command                  : std_logic_vector(7 downto 0);
    -- Working Register
    signal StampFSMR1               : std_logic_vector((wortbreite -1) downto 0);
    signal StampFSMR2               : std_logic_vector((wortbreite -1) downto 0);
    signal StampFSMR3               : std_logic_vector((wortbreite -1) downto 0);
    signal StampFSMPC               : std_logic_vector((wortbreite -1) downto 0);
    -- Create Shadoregs for Stamp data
    signal Stamp1ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp1ShadowReg2         : std_logic_vector(31 downto 0);
    --
    signal Stamp2ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp2ShadowReg2         : std_logic_vector(31 downto 0);
    --      
    signal Stamp3ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp3ShadowReg2         : std_logic_vector(31 downto 0);
    --      
    signal Stamp4ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp4ShadowReg2         : std_logic_vector(31 downto 0);
    --      
    signal Stamp5ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp5ShadowReg2         : std_logic_vector(31 downto 0);
    --      
    signal Stamp6ShadowReg1         : std_logic_vector(31 downto 0);
    signal Stamp6ShadowReg2         : std_logic_vector(31 downto 0);
    -- Create Startaddr reg     
    signal StartAddrReg             : std_logic_vector(31 downto 0);
    signal CurrentAddrReg           : std_logic_vector(31 downto 0);
    -- Defining the Statemachine for controllunit
    type typeCUState is (Waiting, Preparing, CopyShadow, Init, Init1, STAMP1, STAMP2, STAMP3, STAMP4, STAMP5, STAMP6, END1, END2, END3, Locked);
    signal ControllUnitState        : typeCUState;
    type typeStampSubstate is (Prepare, Working, Working1);
    signal ControllUnitSubState     : typeStampSubstate;
    -- Definining the APB state machine
    type APBStateType is (APBWaiting, APBReading, APBWriting);
    signal APBState                  : APBStateType;
    -- SPI State machine for reading the memory
    -- The page size of the memory in case there will be an memory update
    signal MemoryPageSize           : integer range 0 to (2**16) -1;
    --
    type SPIStateType      is (READY, STARTTRANSMIT, TRANSMIT, DONE, WAITING);
    signal SPIState                 : SPIStateType;
    -- 
    type ReadMemoryStateMachineType is (CMD, ADDR, WAITING, DATEN, SAVING, E1, CopyShadow1, CopyShadow2, E2);
    signal ReadMemoryState : ReadMemoryStateMachineType;
    
    type APB3ReadMemoryLimitedType is (Init, Waiting, S1, SignalEnd, E1, E2);
    signal APB3ReadMemoryLimitedState : APB3ReadMemoryLimitedType;
    -- Save State Machine state for locking
    signal ReadMemoryShadowReg    : std_logic_vector((wortbreite - 1) downto 0);
    begin
        
        TimeStampGen : Timestamp 
                    port map (
                        clk => clk,
                        nReset => nReset,
                        enable => enableTimestampGen,
                        getTime => getTime,
                        timestamp => TimeStampValue
                    );
                                    
        intRam     : ram generic map( wortbreite, addrbreite)
                      port map (
                          clk => clk,
                          nReset => nReset,
                          din => InternalData2Memory,
                          adr => InternalAddr2Memory,
                          writeEN => WriteEnable,
                          dout => InternalDataFromMem
                      );

        SPI : spi_master    generic map(slaves => 2, d_width => wortbreite) 
                            port map (
                                clock => clk,
                                reset_n => nReset,
                                enable => enableSPI,
                                cpol => '1',
                                cpha => '1',
                                cont => ContiniousSPI,
                                clk_div => 4,
                                addr => SPIaddr,
                                tx_data => SPITransmitReg,
                                miso => MISO,
                                sclk => SCLK,
                                ss_n(0) => nCS1,
                                ss_n(1) => nCS2,
                                mosi => MOSI,
                                busy => InternalBusy,
                                rx_data => SPIRecReg
                            );

    mainProcess : process( clk, nReset )
    variable PageAddr               : integer; -- The page addr
    variable IsFirstRun             : integer range 0 to 1; -- the indicator that is not the first run
    variable MemoryCnt              : integer range 0 to (2**addrbreite) - 1;
    variable ReadMemoryLimitedCnt   : integer range 0 to (2**9) - 1;
    variable TempCounter            : integer range 0 to (2**addrbreite) - 1;
    variable Counter                : integer range 0 to (2**8) - 1;
    variable MemoryCntPrefetched    : std_logic_vector((2**addrbreite) -1 downto 0); 
  --  variable Command                : std_logic_vector(7 downto 0);
    variable ReadMemoryCounter      : integer range 0 to 15;
    variable PageAddrNonShifted     : std_logic_vector(23 downto 0);
    variable ReadMemoryAddrCounter  : integer range 0 to (2**9) - 1;

    begin
        if (nReset = '0') then
            -- Init PRDATA 
            PRDATA <= (others => '0');
            -- Pagesize default
            MemoryPageSize          <= 16#200#;
            -- Do the main init
            ControllUnitState       <= Waiting;
            ControllUnitSubState    <= Prepare;
            --FormerCUFSMSubstate     <= Prepare;
            --FormerCUFSMState        <= Waiting;

            -- dataReady Reset
            dataReadyReset          <= '0';
            -- REgisters        
            StampFSMR1                      <= (others => '0');
            StampFSMR2                      <= (others => '0');
            StampFSMR3                      <= (others => '0');
            StampFSMPC                      <= (others => '0');
            ConfigStatusReg         <= (others => '0');
            -- Shadow regs      
            Stamp1ShadowReg1        <= (others => '0');
            Stamp1ShadowReg2        <= (others => '0');
            Stamp2ShadowReg1        <= (others => '0');
            Stamp2ShadowReg2        <= (others => '0');
            Stamp3ShadowReg1        <= (others => '0');
            Stamp3ShadowReg2        <= (others => '0');
            Stamp4ShadowReg1        <= (others => '0');
            Stamp4ShadowReg2        <= (others => '0');
            Stamp5ShadowReg1        <= (others => '0');
            Stamp5ShadowReg2        <= (others => '0');
            Stamp6ShadowReg1        <= (others => '0');
            Stamp6ShadowReg2        <= (others => '0');
            -- SPI REgister     
            SPITransmitReg          <= (others => '0');
           -- SPIRecReg               <= (others => '0');
            --  
            enableTimestampGen      <= '0';
            getTime                 <= '0';
            -- Input signals of     the converter
            --InternalAddrCu2Mux      <= (others => '0');
            -- Signals of SPI
            enableSPI               <= '0';
            ContiniousSPI           <= '0';
            --Integer:
            SPIaddr                 <= 0;
            PageAddr                := 0;
            Counter                 := 0;
            MemoryCnt               := 2; -- 0x00, 0x01 are for CU cmd and Spi cmd 0x02 start of region to transmit to memory device
            ReadMemoryLimitedCnt    := 16#082#;
            TempCounter             := 0;
            IsFirstRun              := 0;
            -- CurrentAddrReg
            CurrentAddrReg          <= (others => '0');
            StartAddrReg            <= (others => '0');
            -- Memory addr Reg
            MemoryCntPrefetched     := (others => '0');
            -- Signals of ram
            WriteEnable             <= '0';
            InternalData2Memory     <= (others => '0');
            InternalAddr2Memory     <= (others => '0');
            --  APB Bus
            APBState                <= APBWaiting;
            CommandReg              <= (others => '0');    
            Command                 <= (others => '0');
            --
            SPIState                <= WAITING;
            ReadMemoryState         <= E2;
            ReadMemoryCounter       := 0;
            ReadMemoryAddrCounter   := 16#82#;
            --
            APB3ReadMemoryLimitedState <= E2;
            ReadMemoryShadowReg     <= (others => '0');
        elsif (rising_edge(clk)) then
            -- Functions of the main Memory part
            if (enable = '1') then
                enableTimestampGen <= '1';
                -- Allow the dapi to block the state machine
                if (ConfigStatusReg(2) = '1') then 
                    --FormerCUFSMState <= ControllUnitState;
                    --FormerCUFSMSubstate <= ControllUnitSubstate;
                    ControllUnitState       <= Locked;
                end if;
                case ControllUnitState is 
                    when Locked => 
                        if (ConfigStatusReg(2) = '0') then 
                            ControllUnitState       <= Waiting;
                            ControllUnitSubstate    <= Prepare;
                        end if; 
                    when Waiting =>
                        ConfigStatusReg(30) <= '1'; -- Indicating that the CU is waiting for the stamps to provide data 
                        if (dataready = "111111" or WatchdogGo = '1') then
                            -- Start addr of the external memory
                            if (IsFirstRun = 0) then
                                PageAddr := to_integer(unsigned(StartAddrReg));
                                StampFSMR3       <= StartAddrReg;
                                SPIaddr  <= to_integer(unsigned(ConfigStatusReg(0 downto 0)));
                                IsFirstRun      := 1;
                            else
                                PageAddr := to_integer(unsigned(CurrentAddrReg));
                                StampFSMR3       <= CurrentAddrReg;
                            end if;
                            --Pre fetch page addr
                            StampFSMR1                  <= std_logic_vector(to_unsigned(PageAddr, StampFSMR1'length));
                            MemoryCnt           := 2;
                            ControllUnitState   <= Preparing;
                            --MemoryCntPrefetched := std_logic_vector(to_unsigend(MemoryCnt + 1, MemoryCntPrefetched'length));
                        end if;
                    -- Calculate the new page addr
                    when Preparing => 
                        -- for example:
                        -- ConfigStatusReg(0) = 0
                        -- ConfigStatusReg(1) = 0
                        -- => Do not increase addr
                        -- ConfigStatusReg(1) = 1
                        -- => Increase addr
                        ConfigStatusReg(30) <= '0';
                        if (ConfigStatusReg(1) /= ConfigStatusReg(0)) then 
                            CurrentAddrReg      <= std_logic_vector(to_unsigned(PageAddr + MemoryPageSize, CurrentAddrReg'length)); -- Add 512 byte to the address to start at the next page
                        end if ;
                        InternalAddr2Memory <= (others => '0'); -- addr bus stall 
                        ControllUnitState <= Init;
                    when Init => 
                        -- Write spi command and addr to memory
                        InternalAddr2Memory(7 downto 0)                  <= X"01";
                        InternalData2Memory(31 downto 24)    <= X"12"; 
                        InternalData2Memory(23 downto 0)     <= StampFSMR1(31 downto 8);
                        StampFSMPC <= X"00000001"; -- Spi cmd is stored here
                        WriteEnable                   <= '1';    
                        ControllUnitState <= Init1;
                    when Init1 =>  -- Write rest of addr plus page identifier
                        InternalAddr2Memory(7 downto 0)                  <= X"02";
                        InternalData2Memory(31 downto 24)    <= StampFSMR1(7 downto 0); 
                        InternalData2Memory(23 downto 0)     <= X"7FFFFF";
                        -- Use the counter to stay in this state for 2 clk rising edges, to prevent overAPBWriting the mux settings to early
                        getTime             <= '1';
                        ControllUnitState   <= CopyShadow;
                        ControllUnitSubstate <= Prepare; -- Writes TS to memory 
                    when CopyShadow =>  -- make a copy of the data bus, then proceed with stamp 1
                        ConfigStatusReg(30) <= '0'; -- Setting CU to processing stamp data
                        -- Fill shadow regs with data
                        Stamp1ShadowReg1        <= databus(383 downto 352);
                        Stamp1ShadowReg2        <= databus(351 downto 320);
                        Stamp2ShadowReg1        <= databus(319 downto 288);
                        Stamp2ShadowReg2        <= databus(287 downto 256);
                        Stamp3ShadowReg1        <= databus(255 downto 224);
                        Stamp3ShadowReg2        <= databus(223 downto 192);
                        --      --      
                        Stamp4ShadowReg1        <= databus(191 downto 160);
                        Stamp4ShadowReg2        <= databus(159 downto 128);
                        Stamp5ShadowReg1        <= databus(127 downto 96);
                        Stamp5ShadowReg2        <= databus(95 downto 64);
                        Stamp6ShadowReg1        <= databus(63 downto 32);
                        Stamp6ShadowReg2        <= databus(31 downto 0);
                        dataReadyReset          <= '1'; -- Reset the signal in the STAMP Component
                        ControllUnitSubstate    <= Prepare;
                        ControllUnitState       <= Stamp1;
                    when Stamp1 =>
                        case ControllUnitSubState is
                           when Prepare =>
                                -- Turn of timestamp activation
                                getTime      <= '1';
                                WriteEnable  <= '1';    
                               -- Write timestamp to 
                                InternalData2Memory <= TimeStampValue;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 1, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                           when Working => 
                                dataReadyReset          <= '0'; -- End dataReadyReset here
                                --getTime <= '0'; -- useless here 
                                InternalData2Memory     <= Stamp1ShadowReg1;
                                InternalAddr2Memory     <= std_logic_vector(to_unsigned(MemoryCnt + 2, InternalAddr2Memory'length));
                                ControllUnitSubState    <= Working1;
                           when Working1 =>
                                InternalData2Memory <= Stamp1ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 3, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= Stamp2;
                        end case;
                    when Stamp2 =>
                        case ControllUnitSubState is
                            when Prepare =>
                                getTime <= '0'; -- turn it off here 
                                ControllUnitSubState <= Working;
                            when Working => 
                                InternalData2Memory <= Stamp2ShadowReg1;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 4, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working1;
                            when Working1 =>
                                InternalData2Memory <= Stamp2ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 5, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= Stamp3;
                        end case; 
                    when Stamp3 =>
                        case ControllUnitSubState is
                            when Prepare =>
                                -- Write timestamp to 
                                ControllUnitSubState <= Working;
                            when Working => 
                                InternalData2Memory <= Stamp3ShadowReg1;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 6, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working1;
                            when Working1 =>
                                InternalData2Memory <= Stamp3ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 7, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= Stamp4;
                        end case; 
                    when Stamp4 =>
                        case ControllUnitSubState is
                            when Prepare =>
                                -- Write timestamp to 
                                ControllUnitSubState <= Working;
                            when Working => 
                                InternalData2Memory <= Stamp4ShadowReg1;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 8, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working1;
                            when Working1 =>
                                InternalData2Memory <= Stamp4ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 9, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= Stamp5;
                        end case; 
                    when Stamp5 => 
                        case ControllUnitSubState is
                            when Prepare => 
                                ControllUnitSubState <= Working;
                            when Working => 
                                InternalData2Memory <= Stamp5ShadowReg1;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 10, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working1;
                            when Working1 =>
                                InternalData2Memory <= Stamp5ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 11, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= Stamp6;
                        end case; 
                    when Stamp6 =>
                        case ControllUnitSubState is
                            when Prepare =>
                                ControllUnitSubState <= Working;
                            when Working => 
                                InternalData2Memory <= Stamp6ShadowReg1;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 12, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working1;
                            when Working1 =>
                                InternalData2Memory <= Stamp6ShadowReg2;
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 13, InternalAddr2Memory'length));
                                ControllUnitSubState <= Working;
                                ControllUnitState <= End1;
                        end case; 
                    when End1 =>
                        case ControllUnitSubstate is 
                            when Working =>
                                InternalData2Memory <= (others => '0'); -- Write following word to 0x0000000
                                InternalAddr2Memory <= std_logic_vector(to_unsigned(MemoryCnt + 14, InternalAddr2Memory'length));
                                MemoryCnt := MemoryCnt + 14;
                                ControllUnitSubstate <= Working1;
                            when Working1 =>
                                StampFSMR2          <= std_logic_vector(to_unsigned(MemoryCnt, StampFSMR2'length));
                                WriteEnable <= '0';  
                                if (MemoryCnt = 128) then -- 2 + 126
                                    -- Its time to start transmission of the data
                                    ControllUnitState <= End2;
                                    ControllUnitSubstate <= Prepare;
                                else
                                    if (dataready = "111111" or WatchdogGo = '1') then
                                        ControllUnitSubstate <= Prepare;
                                        ControllUnitState   <= CopyShadow;
                                        ConfigStatusReg(30) <= '1';
                                    end if;
                                end if;
                            when others => 
                                if (dataready = "111111" or WatchdogGo = '1') then
                                    ControllUnitSubstate <= Prepare;
                                    ControllUnitState   <= Stamp1;
                                    ConfigStatusReg(30) <= '1';
                                end if;
                            -- Do nothing here 
                        end case;
                            -- Check if page is full if full -> End 2 else Waiting for Stamp 1 with drdy = X"3f" -> Stamp 1 
                            -- if change to Stamp1 set ControllUnitSubstate to Prepare
                    when End2 => 
                        case ControllUnitSubstate is 
                            when Prepare => 
                                -- Get value from memory
                                --TempCounter := TO_INTEGER(UNSIGNED(StampFSMPC));
                                --TempCounter := TempCounter + TXCounter;
                                InternalAddr2Memory <= StampFSMPC((addrbreite - 1) downto 0);--std_logic_vector(to_unsigned(TempCounter, InternalAddr2Memory'length));
                                ConfigStatusReg(29) <= '1'; -- Mark SPI busy
                                ControllUnitSubstate <= Working;
                            when Working => 
                                -- 128 + 1 to include the 0x00000000 at the end of the last dataset
                                if (TempCounter = 129) then 
                                    ControllUnitSubstate <= Prepare;
                                    ControllUnitState   <= End3;
                                    --TXCounter := 0;
                                else 
                                    --TXCounter := TXCounter + 1;
                                    TempCounter := TO_INTEGER(UNSIGNED(StampFSMPC));
                                    TempCounter := TempCounter + 1;
                                    StampFSMPC <= std_logic_vector(to_unsigned(TempCounter, StampFSMPC'length));
                                    ControllUnitSubstate <= Working1;
                                end if;

                            when Working1 =>
                                    enableSPI <= '1'; 
                                    -- Read value form memory 
                                    if (InternalBusy = '0') then
                                        SPITransmitReg <= InternalDataFromMem;
                                        ControllUnitSubState <= Prepare;
                                    else
                                        enableSPI <= '0';
                                    end if;
                            when others =>
                                        --
                        end case;
                    when End3 => 
                        TempCounter := 0; -- Reset the Counter for the next spi transmit op
                        enableSPI <= '0';
                        ConfigStatusReg(29) <= '0'; -- Mark SPI free
                        -- toggle left right
                        if  (SPIaddr = 1) then
                            SPIaddr <= 0;
                            ConfigStatusReg(1) <= '0';
                            ConfigStatusReg(31) <= '0';
                        else 
                            SPIaddr <= 1;
                            ConfigStatusReg(1) <= '1';
                            ConfigStatusReg(31) <= '1';
                        end if;
                        ControllUnitSubstate <= Prepare;
                        ControllUnitState    <= Waiting;
                    when others => 
                        enableSPI <= '0';
                        getTime <= '0';
                        ControllUnitSubstate <= Prepare;
                        ControllUnitState <= Waiting;
                    end case;
            else 
                enableTimestampGen <= '0';
            end if; -- End enable if 
            --   PADDR       : in std_logic_vector(12 downto 0);
            --   PSEL        : in std_logic;
            --   PENABLE     : in std_logic;
            --   PWRITE      : in std_logic;
            --   PWDATA      : out std_logic_vector(wortbreite - 1 downto 0);
            --   PREADY      : in std_logic;
            --   PRDATA      : in std_logic_vector(wortbreite - 1 downto 0);
            case APBState is 
                when APBWaiting => 
                    if ((PENABLE = '1') and (PWRITE = '1') and (PSEL = '1')) then 
                        APBState <= APBWriting;
                    elsif ((PWRITE = '0' AND PSEL = '1')) then
                        APBState <= APBReading;
                    end if;
                    PREADY <= '0';
                when APBWriting => 
                    case PADDR is 
                        when X"034" => 
                            StartAddrReg <= PWDATA; 
                            PREADY <= '1';
                        when X"03C" => 
                            SPITransmitReg <= PWDATA;
                            SPIState <= READY;
                            PREADY <= '1';
                        when X"044" =>
                            -- Just write the bits that are defined to be written
                            ConfigStatusReg <= PWDATA;
                            --ConfigStatusReg(0) <= PWDATA(0);
                            --ConfigStatusReg(2) <= PWDATA(2);
                            --ConfigStatusReg(23 downto 8) <= PWDATA(23 downto 8);
                            MemoryPageSize  <= to_integer(unsigned(PWDATA(23 downto 8))); 
                            PREADY <= '1';
                        when X"048" => 
                            CommandReg      <= PWDATA;
                            Command         <= PWDATA((wortbreite - 1) downto (wortbreite - 8));
                            PREADY <= '1'; 
                        when others => -- ReadOnly Regs do nothing at all
                            -- Error addr unknown 
                            PREADY <= '1';
                    end case;
                    APBState <= APBWaiting;
                when APBReading =>
                    -- Read from register
                    case PADDR is 
                        when X"004" => 
                            PRDATA <= Stamp1ShadowReg1;
                            PREADY <= '1';
                        when X"008" =>
                            PRDATA <= Stamp1ShadowReg2;
                            PREADY <= '1';
                        when X"00C" => 
                            PRDATA <= Stamp2ShadowReg1;
                            PREADY <= '1';
                        when X"010" =>
                            PRDATA <= Stamp2ShadowReg2;
                            PREADY <= '1';
                        when X"014" => 
                            PRDATA <= Stamp3ShadowReg1;
                            PREADY <= '1';
                        when X"018" =>
                            PRDATA <= Stamp3ShadowReg2;
                            PREADY <= '1';
                        when X"01C" => 
                            PRDATA <= Stamp4ShadowReg1;
                            PREADY <= '1';
                        when X"020" =>
                            PRDATA <= Stamp4ShadowReg2;
                            PREADY <= '1';
                        when X"024" => 
                            PRDATA <= Stamp5ShadowReg1;
                            PREADY <= '1';
                        when X"028" =>
                            PRDATA <= Stamp5ShadowReg2;
                            PREADY <= '1';
                        when X"02C" => 
                            PRDATA <= Stamp6ShadowReg1;
                            PREADY <= '1';
                        when X"030" =>
                            PRDATA <= Stamp6ShadowReg1;
                            PREADY <= '1';
                        when X"034" => 
                            PRDATA <= StartAddrReg; 
                            PREADY <= '1';
                        when X"038" =>
                            PRDATA <= CurrentAddrReg;
                            PREADY <= '1';
                        when X"03C" => 
                            PRDATA <= SPITransmitReg;
                            PREADY <= '1';
                        when X"040" => 
                            PRDATA <= SPIRecReg;
                            PREADY <= '1';
                        when X"044" =>
                            PRDATA <= ConfigStatusReg;
                            PREADY <= '1';
                        when X"048" =>
                            PRDATA <= CommandReg;
                            PREADY <= '1';
                        when X"04C" => -- read memory line by line starting at 0x82 bis 0x82 + 128 
                            -- Make sure that the driver will read always 128 byte of date otherwise it will be reading old data 
                            APB3ReadMemoryLimitedState <= Init;
                            PRDATA <= ReadMemoryShadowReg;
                            PREADY <= '1';
                        when others => 
                            PREADY <= '1';
                            -- Error addr unknown 
                    end case;
                    APBState <= APBWaiting;
                    -- End of APBReading
                when others => 
                APBState <= APBWaiting;
            end case;

             case APB3ReadMemoryLimitedState is 
                when Init => 
                    if (ConfigStatusReg(4) = '1') then -- Memory is loaded
                        InternalAddr2Memory <= std_logic_vector(to_unsigned(ReadMemoryLimitedCnt, InternalAddr2Memory'length));
                        ReadMemoryLimitedCnt := ReadMemoryLimitedCnt + 1;
                        APB3ReadMemoryLimitedState <= Waiting;
                    else 
                        APB3ReadMemoryLimitedState <= E2;
                    end if;
                when Waiting => -- Give him some time to fetch the content of the memory
                    APB3ReadMemoryLimitedState <= S1;
                when S1   => 
                    ReadMemoryShadowReg <= InternalDataFromMem;
                    if (ReadMemoryLimitedCnt = 258) then
                        APB3ReadMemoryLimitedState    <= E1;
                    else 
                        APB3ReadMemoryLimitedState    <= SignalEnd;
                    end if;
                    --PREADY <= '1'; -- signal the MCU that the data is ready
                when SignalEnd => 
                    --PREADY <= '0'; -- Stay here until Someone writes to 0x4c again to trigger the next read
                when E1   => 
                    ReadMemoryLimitedCnt := 16#83#; -- Reset to basis value if everything is read
                    APB3ReadMemoryLimitedState <= E2;
                    ConfigStatusReg(4) <= '0'; -- Signal: Memory Reading done load memory first to use this part again
                    --PREADY <= '0'; -- Reset Preday becasue we are outside of the APB Statemachine, the controller is waiting for this to toggle
                when E2 => -- Waiting state is initial set, will be set if all data was read
            end case;

            case Command is 
                when X"01" | X"11" => 
                -- TODO: Create a state machine to recive the data into memory starting at word 128 
                    ReadMemoryState <= CMD;
                    ConfigStatusReg(2) <= '1';
                    ConfigStatusReg(3) <= '1'; -- Signal: reading in Progress
                    ConfigStatusReg(4) <= '0'; -- Memory not loaded yet
                    --ConfigStatusReg(31) <= std_logic(to_unsigned(SPIaddr, 1)(0)); --Saved in CU Statemachine after changing SPI
                    if (Command = X"11") then 
                        SPIaddr <= 1;
                    else 
                        SPIaddr <= 0;
                    end if;
                    Command <= (others => '0');
                    
                when X"02" => 
                    if (SPIState = READY) then
                        SPIaddr <= 0;
                        SPIState <= STARTTRANSMIT;
                    end if;
                    Command <= (others => '0');
                when X"12" => 
                    if (SPIState = READY) then
                        SPIaddr <= 1;
                        SPIState <= STARTTRANSMIT;
                    end if;
                    Command <= (others => '0');
                when X"03" => 
                    SPIState <= READY;
                    Command <= (others => '0');
                when others => 
                    --enableSPI       <= '0';
                    dataReadyReset  <= '0';
                    --Command <= (others => '0');
            end case;
            case SPIState is 
                when READY =>
                    -- Waiting to rec cmd 0x02 | 0x12
                when STARTTRANSMIT => 
                    enableSPI <= '1';
                    ConfigStatusReg(29) <= '1';
                    SPIState <= TRANSMIT;
                when TRANSMIT =>
                    if (Counter > 2 and InternalBusy = '0') then
                        Counter     := 0;
                        --ConfigStatusReg(2) <= '0'; -- release lock CU FSM
                        ConfigStatusReg(29) <= '0'; -- Mark SPI busy
                        SPIState    <= DONE;
                        SPIaddr     <= to_integer(unsigned(ConfigStatusReg(31 downto 31))); -- Reset  SPI Addr for writing 
                    elsif (Counter > 2 and InternalBusy = '1') then
                        enableSPI <= '0'; -- Just enable SPI for a few moments, the data will be coming after that 
                    else
                        Counter := Counter + 1;
                    end if;
                when DONE => 
                    ConfigStatusReg(29) <= '0'; -- mark SPI Free
                    Command <= (others => '0');
                    SPIState <= WAITING;
                when WAITING => 
                    -- Do nothing
                end case;
            case ReadMemoryState is 
                when CMD => 
                    if (ReadMemoryCounter = 2) then
                        if (InternalBusy = '0') then 
                            ReadMemoryState <= ADDR;
                            ReadMemoryCounter := 0;
                        end if;
                        enableSPI <= '0';
                    else 
                        SPITransmitReg <= X"00000013";
                        enableSPI <= '1';
                        ReadMemoryCounter := ReadMemoryCounter + 1;
                    end if;
                    -- Make sure the fsm stays in this state until the transmision is completed
                when ADDR =>
                    if (ReadMemoryCounter = 2) then
                        if (InternalBusy = '0') then 
                            ReadMemoryState <= WAITING;
                            ReadMemoryCounter := 0;
                        end if;
                        enableSPI <= '0';
                    else 
                        SPITransmitReg(31 downto 8) <= CommandReg(23 downto 0); -- Hopfully 0x0000 0200
                        SPITransmitReg(7 downto 0) <= X"00";
                        -- SPITransmitReg <= X"00000012";
                        -- Set up the addr transmitted at the 23 bit afte 
                        enableSPI <= '1';
                        ReadMemoryCounter := ReadMemoryCounter + 1;
                    end if; 
                when WAITING => -- Wait 8 cycle here to give the controller a bit time 
                    if (ReadMemoryCounter /= 15) then
                        ReadMemoryCounter := ReadMemoryCounter + 1;
                    else
                        ReadMemoryCounter := 0;
                        ReadMemoryState <= DATEN;
                    end if;
                    SPITransmitReg <= (others => '0'); -- make sure that the Transmit register is set to 0x00000000
                when DATEN =>
                    WriteEnable <= '0';
                    if (ReadMemoryCounter = 2) then 
                        if (InternalBusy = '0') then 
                            ReadMemoryState     <= SAVING;
                            ReadMemoryCounter := 0;
                        end if;
                        enableSPI           <= '0';
                        
                    else
                        ReadMemoryCounter   := ReadMemoryCounter + 1;
                        enableSPI           <= '1'; 
                    end if;
                when SAVING => 
                    --TODO: SPIRecReg auf Datenbus schreiben plus addr auf Addrbus
                    InternalData2Memory <= SPIRecReg;
                    InternalAddr2Memory <= std_logic_vector(to_unsigned(ReadMemoryAddrCounter, InternalAddr2Memory'length));
                    WriteEnable <= '1';
                    if (ReadMemoryAddrCounter /= 258) then -- Basis addr + 128 words
                        ReadMemoryAddrCounter := ReadMemoryAddrCounter + 1;
                        ReadMemoryState <= DATEN;
                    else 
                        -- Exit read memory here
                        ReadMemoryAddrCounter := 16#82#;
                        ReadMemoryState <= E1;
                        WriteEnable <= '0'; -- Turn of WriteEnable to not block the CU
                        -- Extention to fix 4C Read Problem:
                    end if;
                when E1 => 
                    ConfigStatusReg(2) <= '0';  -- Release lock
                    ConfigStatusReg(3) <= '0'; -- Signal Reading Done
                    SPIaddr <= to_integer(unsigned(ConfigStatusReg(31 downto 31))); -- Reset  SPI Addr for writing 
                    --APB3ReadMemoryLimitedState <= Init; -- Enables the state machine if the data is loaded to memory
                    ConfigStatusReg(4) <= '1';
                    ReadMemoryState <= CopyShadow1;
                    -- Extention to fix 4C Read Problem
                    InternalAddr2Memory <= '0' & X"82"; 
                when CopyShadow1 =>  -- Wait until the memory presents its data
                    ReadMemoryState     <= CopyShadow2;
                when CopyShadow2 => 
                    ReadMemoryShadowReg <= InternalDataFromMem;
                    ReadMemoryState     <= E2; 
                when E2 => -- Waiting state, do nothing
                when others => 
                    -- Well CHange to e1
                    ReadMemoryAddrCounter   := 16#82#;
                    ReadMemoryState <= E2;
            end case;
        end if; -- clk Rising if 
    end process ; -- mainProcess
end architecture;