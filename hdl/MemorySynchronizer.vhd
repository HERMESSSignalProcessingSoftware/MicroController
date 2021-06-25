----------------------------------------------------------------------------------
-- Company: REXUS HERMESS MESS II 
-- Engineer: Robin Grimsmann
-- 
-- Create Date:    20.06.2021
-- Design Name: MESS II
-- Module Name: Memory Top Level Design REV 3
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
-- Revision 2.00 - Update of SPI Logic
-- Revision 3.00 - Rewrite due to logic problems and updated usecase describtion
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity MemorySynchronizer is
  
  port (
    clk                     : in std_logic;
    nReset                  : in std_logic;
    IN_enable               : in std_logic;
    IN_databus              : in std_logic_vector(383 downto 0);
    IN_newAvails            : in std_logic_vector(5 downto 0);
    IN_requestSync          : in std_logic_vector(5 downto 0);
    dataReadyReset          : out std_logic; -- One signal to trigger the reset in each stamp module
    SynchronizerInterrupt   : out std_logic;
    ReadInterrupt           : out std_logic;
    ADCResync               : out std_logic; 
    -- Define signals of apb 3
    PADDR               : in std_logic_vector(11 downto 0);
    PSEL                : in std_logic;
    PENABLE             : in std_logic;
    PWRITE              : in std_logic;
    PWDATA              : in std_logic_vector(31 downto 0);
    PREADY              : out std_logic;
    PRDATA              : out std_logic_vector(31 downto 0);
    PSLVERR             : OUT STD_LOGIC-- not supported by this component
  ) ;
end MemorySynchronizer;

architecture arch of MemorySynchronizer is

    component Timestamp is
        port (
          clk         : in std_logic;
          nReset      : in std_logic;
          enable      : in std_logic; 
          getTime     : in std_logic;
          timestamp   : out std_logic_vector(31 downto 0)
        ) ;
    end component Timestamp;
      
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
    -- System Register
    signal SynchStatusReg           : std_logic_vector(31 downto 0);
    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
    --	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
	--  |PS|PR|U |AE|  |  |O6|O5|O4|O3|O2|O1|RE|RE|RE|RE|RE|RE|RE|RE|R6|R5|R4|R3|R2|R1|M6|M5|M4|M3|M2|M1|
	--  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- M1 - M6: Bitmask for every stamp which has not provied a newAvails signal
    -- R1 - R6: Bitmask for every stamp which is requesting a Resync 
    -- RE: 8 bit counter: the number of ResyncEvents 
    -- O1 - O6: StatusReg2 overflow marker. Means that the difference to the timestamp register is bigger than the size of 5 bits
    -- AE: APB Error Address not known
    -- U: Unused
    -- PR: Pending Reading Interrupt
    -- PS: Pending Synchronizer Interrupt
    -- Timer and Prescaler
    signal SynchStatusReg2          : std_logic_vector(31 downto 0);
    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
    --	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
	--  |U |U |S6|S6|S6|S6|S6|S5|S5|S5|S5|S5|S4|S4|S4|S4|S4|S3|S3|S3|S3|S3|S2|S2|S2|S2|S2|S1|S1|S1|S1|S1|
	--  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- U: Unused 
    -- S1 5 bit counter; relative distance to the Timestamp value
    signal ResetTimerValueReg       : std_logic_vector(31 downto 0);
    signal WaitingTimerValueReg     : std_logic_vector(31 downto 0); -- Possible use without a prescaler for this one:  fclk = 50Mhz -> Tclk = 20ns; (2**32 -1) * Tclk = 85.89s 
    signal ResyncTimerValueReg      : std_logic_vector(31 downto 0); -- without prescaler, see above. If this timer is running, even a fully requested resync will not be happening
    -- 
    signal ConfigReg                : std_logic_vector(31 downto 0);
    -- detailed description of the config reg:
    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
    --	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
	--  |EI|CS|CR|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |U |2 |2 |2 |U |1 |1 |1 |
	--  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- 1. Number of minimal neccessary newAvail Signals default: 4
    -- 2. Number of Request Resync signals, below this number: Dont care
    --                                      above this number: Run Resync Event
    -- EI: Enable Interrupts 
    -- CS: Clear SynchronizerInterrupt
    -- CR: Clear Read Interrupt
    -- U - Unused
    type MemorySyncState_t is (Start, ResyncEvent, S1, S2, End1, Error1, Error2);
    signal MemorySyncState : MemorySyncState_t;
    type APBStateType is (APBWaiting, APBReading, APBWriting);
    signal APBState                  : APBStateType;

    -- timestamp generator signals
    signal enableTimestampGen       : std_logic;
    signal getTime                  : std_logic;
    signal TimeStampValue           : std_logic_vector(31 downto 0);
    -- 
    signal TimeStampReg             : std_logic_vector(31 downto 0);
begin
    TimeStampGen : Timestamp 
                    port map (
                        clk => clk,
                        nReset => nReset,
                        enable => enableTimestampGen,
                        getTime => getTime,
                        timestamp => TimeStampValue
                    );

    process(clk, nReset)
    -- Number of minimal neccessary newAvail Signals default: 4 
    -- Belongs to ConfigReg Nr. 1
    variable numberOfnewAvails            : INTEGER RANGE 0 to 2**3 -1;

    -- Usually there are 6 STAMPS, to you need to cover the numbers 0 - 6; 
    -- is the real number below this threshold, the system dont cares
    -- Belongs to ConfigReg Nr. 2
    variable NumberOfPendingResyncRequest : INTEGER RANGE 0 to 2**3 - 1; 

    -- Implement the counter 
    variable ResetTimerCounter      : INTEGER;
    variable ResyncTimerCounter     : INTEGER;
    variable WaitingTimerCounter    : INTEGER;

    -- State related variables
    variable ResyncEventPullDownCounter      : INTEGER RANGE 0 to 16;

    variable S1TimeStampValue                : std_logic_vector(31 downto 0);

    variable Error1Counter                   : Integer Range 0 to 2;
    variable END_ONE_COUNTER                 : Integer Range 0 to 4;
    -- Functionen
    function NUMBEROF( DIN : std_logic_vector(5 downto 0) ) 
        return INTEGER is 
        -- Variable definition
            variable k : integer := 0;
        begin
            for i in 0 to (DIN'length - 1) loop
                if (DIN(i) = '1') then
                    k := k + 1;
                end if; 
            end loop;
            return k;
    end NUMBEROF;

    procedure COPY_AND_MARK_DATA(
        newAvails : std_logic_vector(5 downto 0);
        data      : std_logic_vector(383 downto 0)) is 
    -- variable definition
        variable OldTimeStamp : Integer;
        variable NewTimeStamp : Integer;
        variable Temp         : Integer;
    begin
        OldtimeStamp := TO_INTEGER(UNSIGNED(TimeStampReg));
        -- Update SynchstatusReg(5 downto 0)
        SynchStatusReg(5 downto 0) <= not newAvails;
        -- Copy data
        if (IN_newAvails(0) = '1' AND Stamp1ShadowReg1 = x"00000000") then 
            Stamp1ShadowReg1        <= data(383 downto 352);
            Stamp1ShadowReg2        <= data(351 downto 320);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(20) <= '1';
            end if;
            SynchStatusReg2(4 downto 0 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if; -- end of StatusReg2 filling
        if (IN_newAvails(1) = '1' AND Stamp2ShadowReg1 = X"00000000") then 
            Stamp2ShadowReg1        <= data(319 downto 288);
            Stamp2ShadowReg2        <= data(287 downto 256);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(21) <= '1';
            end if;
            SynchStatusReg2(10 downto 6 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if;
        if (IN_newAvails(2) = '1' AND Stamp3ShadowReg1 = X"00000000") then 
            Stamp3ShadowReg1        <= data(255 downto 224);
            Stamp3ShadowReg2        <= data(223 downto 192);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(22) <= '1';
            end if;
            SynchStatusReg2(15 downto 11 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if;
        if (IN_newAvails(3) = '1' AND Stamp4ShadowReg1 = X"00000000") then 
            Stamp4ShadowReg1        <= data(191 downto 160);
            Stamp4ShadowReg2        <= data(159 downto 128);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(23) <= '1';
            end if;
            SynchStatusReg2(20 downto 16 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if;
        if (IN_newAvails(4) = '1' AND Stamp5ShadowReg1 = X"00000000") then 
            Stamp5ShadowReg1        <= data(127 downto 96);
            Stamp5ShadowReg2        <= data(95 downto 64);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(24) <= '1';
            end if;
            SynchStatusReg2(25 downto 21 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if;
        if (IN_newAvails(5) = '1' AND Stamp6ShadowReg1 = X"00000000") then 
            Stamp6ShadowReg1        <= data(63 downto 32);
            Stamp6ShadowReg2        <= data(31 downto 0);
            -- Update timestamp bits in SR2
            NewTimeStamp := TO_INTEGER(UNSIGNED(TimeStampValue));
            Temp := NewTimeStamp - OldTimeStamp;
            if (Temp > (2**5 -1)) then 
            -- Set Overflow bit
                SynchStatusReg(25) <= '1';
            end if;
            SynchStatusReg2(30 downto 26 ) <= std_logic_vector(to_unsigned(Temp, 5));
        end if;
    end COPY_AND_MARK_DATA;

    begin 
        if (nReset = '0') then
            -- Init Stamp Shadow Registers
            Stamp1ShadowReg1    <= (others => '0');
            Stamp1ShadowReg2    <= (others => '0');
            Stamp2ShadowReg1    <= (others => '0');
            Stamp2ShadowReg2    <= (others => '0');
            Stamp3ShadowReg1    <= (others => '0');
            Stamp3ShadowReg2    <= (others => '0');
            Stamp4ShadowReg1    <= (others => '0');
            Stamp4ShadowReg2    <= (others => '0');
            Stamp5ShadowReg1    <= (others => '0');
            Stamp5ShadowReg2    <= (others => '0');
            Stamp6ShadowReg1    <= (others => '0');
            Stamp6ShadowReg2    <= (others => '0');   
            --
            TimeStampReg        <= (others => '0');
            -- Init System Registers
            SynchStatusReg          <= (others => '0');
            SynchStatusReg2         <= (others => '0');
            ResetTimerValueReg      <= (others => '1'); -- Start with a really high number to avoid initial system failure
            WaitingTimerValueReg    <= (others => '1'); -- Start with a really high number to avoid initial system failure
            ResyncTimerValueReg     <= (others => '1'); -- Start with a really high number to avoid initial system failure
            -- Clear Config Reg
            ConfigReg               <= X"00000044";
            -- init state machines
            MemorySyncState <= Start;
            APBState        <= APBWaiting;
            -- Init signals form the component
            dataReadyReset          <= '0';
            ADCResync               <= '1'; 
            SynchronizerInterrupt   <= '0';
            ReadInterrupt           <= '0';
            PREADY                  <= '0';
            PRDATA                  <= (others => '0');
            
            -- disable timestamp 
            enableTimestampGen      <= '0';
            -- Init Variables
            -- Init values are the default values, they are not confirmed valid
            numberOfnewAvails              := 4;
            NumberOfPendingResyncRequest   := 4;
            ResetTimerCounter              := TO_INTEGER(UNSIGNED(ResetTimerValueReg));
            ResyncTimerCounter             := 0; -- Initial value to allow fast resyncEvent and then use the counter in the proper way
            WaitingTimerCounter            := TO_INTEGER(UNSIGNED(ResyncTimerValueReg));

            -- Init state related variables
            ResyncEventPullDownCounter     := 0;
            S1TimeStampValue               := (others => '0');
            Error1Counter                  := 0;
            --
            getTime                        <= '0';
            -- Not supported
            PSLVERR <= '0';
        elsif (rising_edge(clk)) then 
            if (IN_enable = '1') then 
                enableTimestampGen      <= '1';
                case MemorySyncState is 
                    when Start => 
                        ResetTimerCounter := ResetTimerCounter - 1;
                        dataReadyReset <= '0'; -- keep it down here e
                        if (ResyncTimerCounter /= 0) then 
                            ResyncTimerCounter := ResyncTimerCounter - 1;
                        end if; -- Count down bedinnung für den ResyncTimer
                        
                        if (ResetTimerCounter = 0 and IN_newAvails /= X"3F") then 
                            MemorySyncState <= Error1;
                        elsif (ResetTimerCounter /= 0 and NUMBEROF(IN_newAvails) > 0) then -- Most likly case
                            -- Main action bring data to mss and to memory
                            MemorySyncState <= S1;
                            -- Set GetTime = 1 to optain the value 
                        elsif (ResyncTimerCounter = 0 and NUMBEROF(IN_requestSync) >= NumberOfPendingResyncRequest) then 
                            -- Requested Resync will be done
                            MemorySyncState <= ResyncEvent;
                        end if;
                        -- Fill Status Reg with Information about the STAMPS
                        if (IN_requestSync(0) = '1') then 
                            SynchStatusReg(6) <= '1'; -- 11 10 9  8  7  
                        end if;
                        if (IN_requestSync(1) = '1') then 
                            SynchStatusReg(7) <= '1'; -- 11 10 9  8  7  
                        end if;
                        if (IN_requestSync(2) = '1') then
                            SynchStatusReg(8) <= '1'; -- 11 10 9  8  7  
                        end if;
                        if (IN_requestSync(3) = '1') then
                            SynchStatusReg(9) <= '1'; -- 11 10 9  8  7  
                        end if;
                        if (IN_requestSync(4) = '1') then
                            SynchStatusReg(10) <= '1'; -- 11 10 9  8  7  
                        end if;
                        if (IN_requestSync(5) = '1') then
                            SynchStatusReg(11) <= '1'; -- 11 10 9  8  7  
                        end if;
                    when ResyncEvent => 
                        ResyncTimerCounter := TO_INTEGER(UNSIGNED(ResyncTimerValueReg)); -- Reload the counter 
                        if (ResyncEventPullDownCounter >= 0 and ResyncEventPullDownCounter < 7) then 
                            ResyncEventPullDownCounter := ResyncEventPullDownCounter + 1;
                            ADCResync <= '0';
                        else
                            ResyncEventPullDownCounter := 0;
                            ADCResync <= '1';
                            MemorySyncState <= Start; 
                        end if;
                    when S1 => 
                        -- Continue Counting the active counter 
                        if (ResetTimerCounter /= 0) then
                            ResetTimerCounter := ResetTimerCounter - 1;
                        end if;
                        if (ResyncTimerCounter /= 0) then 
                            ResyncTimerCounter := ResyncTimerCounter - 1;
                        end if; -- Count down bedinnung für den ResyncTimer
                        if (WaitingTimerCounter < TO_INTEGER(UNSIGNED(WaitingTimerValueReg)) AND 
                            WaitingTimerCounter > 0) then -- just count if someone has done the first step
                            WaitingTimerCounter := WaitingTimerCounter - 1;
                        end if;
                        -- Own actions
                        if (WaitingTimerCounter = TO_INTEGER(UNSIGNED(WaitingTimerValueReg))) then -- First time in this case
                            TimeStampReg <= TimeStampValue; -- Save the timestamp
                            WaitingTimerCounter := WaitingTimerCounter - 1; 
                            -- Load new timestamp here
                        elsif (WaitingTimerCounter = (TO_INTEGER(UNSIGNED(WaitingTimerValueReg)) - 2 ) -- 2 becase the if case will do -1 and the next cycle in S1 will do an other
                                    AND NUMBEROF(IN_newAvails) /= 6) then -- Just do it to wait for one cycle to prevent reading TimeStampReg in the same cycle as writing it
                            COPY_AND_MARK_DATA(IN_newAvails, IN_databus);
                        elsif (WaitingTimerCounter = 1 OR NUMBEROF(IN_newAvails) = 6) then  
                            if (NUMBEROF(IN_newAvails) >= numberOfnewAvails) then 
                                COPY_AND_MARK_DATA(IN_newAvails, IN_databus);
                                MemorySyncState <= End1;
                            else 
                                MemorySyncState <= S2;
                            end if;
                            WaitingTimerCounter := TO_INTEGER(UNSIGNED(WaitingTimerValueReg)); -- because of the last line
                        end if;
                    when S2 => -- Case for: not all available stamps returned a value
                        if (ResyncTimerCounter /= 0) then 
                            ResyncTimerCounter := ResyncTimerCounter - 1;
                            MemorySyncState <= Start;
                        else 
                            MemorySyncState <= ResyncEvent;
                        end if;
                        COPY_AND_MARK_DATA(IN_newAvails, IN_databus);
                        TimeStampReg    <= TimeStampValue;
                        ReadInterrupt   <= '1';
                        SynchStatusReg(30) <= '1';
                        SynchStatusReg(26) <= '1';
                    when End1 =>
                        if (END_ONE_COUNTER < 2) then
                            dataReadyReset <= '1';
                            END_ONE_COUNTER := END_ONE_COUNTER + 1;
                        else 
                            dataReadyReset <= '0';
                            END_ONE_COUNTER := 0;
                            MemorySyncState <= Start;
                            ResetTimerCounter := TO_INTEGER(UNSIGNED(ResetTimerValueReg));
                            if (ConfigReg(31) = '1') then
                                ReadInterrupt <= '1';
                            end if;
                            SynchStatusReg(30) <= '1';
                        end if;
                    when Error1 =>
                        SynchronizerInterrupt <= '1';
                        SynchStatusReg(31) <= '1';
                        COPY_AND_MARK_DATA(IN_newAvails, IN_databus);
                        TimeStampReg <= TimeStampValue;
                    when others => 
                        -- Well Ignore this case
                        MemorySyncState <= Start;
                end case; -- END CASE MemorySyncState
            else 
                enableTimestampGen      <= '0';
            end if; -- End enable 

            -- 
            IF (CONFIGREG(30) = '1' ) THEN-- Clear Sync Interrupt
                SynchronizerInterrupt <= '0';
                CONFIGREG(30) <= '0'; -- Reset the clear bit
                SynchStatusReg(31) <= '0';
            END IF;

            IF (CONFIGREG(29) = '1') THEN -- Clear the ReadInterrupt
                ReadInterrupt <= '0';
                CONFIGREG(29) <= '0'; -- Reset the clear bit
                SynchStatusReg(30) <= '0';          
            END IF;

            case APBState is 
                when APBWaiting => 
                    if ((PENABLE = '1') AND (PWRITE = '1') AND (PSEL = '1')) then 
                        APBState <= APBWriting;
                    elsif ((PWRITE = '0' AND PSEL = '1')) then
                        APBState <= APBReading;
                    end if;
                    PREADY <= '0';
                when APBWriting => 
                    case PADDR is 
                        when X"004" => 
                            Stamp1ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"008" => 
                            Stamp1ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"00C" => 
                            Stamp2ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"010" => 
                            Stamp2ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"014" => 
                            Stamp3ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"018" => 
                            Stamp3ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"01C" => 
                            Stamp4ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"020" => 
                            Stamp4ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"024" => 
                            Stamp5ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"028" => 
                            Stamp5ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"02C" => 
                            Stamp6ShadowReg1 <= (others => '0');
                            PREADY <= '1';
                        when X"030" => 
                            Stamp6ShadowReg2 <= (others => '0');
                            PREADY <= '1';
                        when X"034" =>
                            SynchStatusReg(25 downto 0) <= (others => '0');
                            SynchStatusReg(28) <= '0'; -- Reset of the APB Address ERROR bit
                            PREADY <= '1';
                        when X"038" => 
                            ConfigReg <= PWDATA;
                            numberOfnewAvails               := TO_INTEGER(UNSIGNED(ConfigReg(2 downto 0)));
                            NumberOfPendingResyncRequest    := TO_INTEGER(UNSIGNED(ConfigReg(6 downto 4)));
                            PREADY <= '1';
                        when X"03C" => 
                            ResetTimerValueReg <= PWDATA;   
                            ResetTimerCounter              := TO_INTEGER(UNSIGNED(PWDATA)); 
                            PREADY <= '1';
                        when X"040" =>
                            WaitingTimerValueReg <= PWDATA;
                            WaitingTimerCounter            := TO_INTEGER(UNSIGNED(PWDATA));
                            PREADY <= '1';
                        when X"044" =>
                            ResyncTimerValueReg <= PWDATA;
                            PREADY <= '1';
                            -- Do not reload the counter here
                            -- ResyncTimerCounter             := TO_INTEGER(UNSIGNED(PWDATA));
                        when X"048" => 
                            TimeStampReg <= (others => '0');
                            PREADY <= '1';
                        when X"04C" => 
                            SynchStatusReg2 <= (others => '0');
                            PREADY <= '1';
                        when others => 
                            SynchStatusReg(28) <= '1';
                            PREADY <= '1';
                    end case; -- and Writing addr case 
                    APBState <= APBWaiting;
                when APBReading =>
                    case PADDR is 
                        when X"004" => 
                            PRDATA <= Stamp1ShadowReg1;
                        when X"008" =>
                            PRDATA <= Stamp1ShadowReg2;
                        when X"00C" => 
                            PRDATA <= Stamp2ShadowReg1;
                        when X"010" =>
                            PRDATA <= Stamp2ShadowReg2;
                        when X"014" => 
                            PRDATA <= Stamp3ShadowReg1;
                        when X"018" =>
                            PRDATA <= Stamp3ShadowReg2;
                        when X"01C" => 
                            PRDATA <= Stamp4ShadowReg1;
                        when X"020" =>
                            PRDATA <= Stamp4ShadowReg2;
                        when X"024" => 
                            PRDATA <= Stamp5ShadowReg1;
                        when X"028" =>
                            PRDATA <= Stamp5ShadowReg2;
                        when X"02C" => 
                            PRDATA <= Stamp6ShadowReg1;
                        when X"030" =>
                            PRDATA <= Stamp6ShadowReg2;
                        when X"034" => 
                            PRDATA <= SynchStatusReg;
                        when X"038" => 
                            PRDATA <= ConfigReg;
                        when X"03C" => 
                            PRDATA <= ResetTimerValueReg;
                        when X"040" =>
                            PRDATA <= WaitingTimerValueReg;
                        when X"044" =>
                            PRDATA <= ResyncTimerValueReg;
                        when X"048" => 
                            PRDATA <= TimeStampReg;
                        when X"04C" => 
                            PRDATA <= SynchStatusReg2;
                        when others => 
                            PRDATA <= X"AFFEDEAD";
                    end case; -- end Reading addr case
                    APBState <= APBWaiting;
                    PREADY <= '1';
                when others => 
                    APBState <= APBWaiting;
                    PREADY <= '1';
            end case; -- End of APB Reading FSM
        end if; -- end risign_edge
    end process;
end arch ; -- arch