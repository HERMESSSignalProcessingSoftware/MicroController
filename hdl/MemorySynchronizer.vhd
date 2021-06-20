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
    -- Define signals of apb 3
    PADDR               : in std_logic_vector(11 downto 0);
    PSEL                : in std_logic;
    PENABLE             : in std_logic;
    PWRITE              : in std_logic;
    PWDATA              : in std_logic_vector(31 downto 0);
    PREADY              : out std_logic;
    PRDATA              : out std_logic_vector(31 downto 0)
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
	--  |PS|PR|U |AE|  |  |  |  |  |  |  |  |RE|RE|RE|RE|RE|RE|RE|RE|R6|R5|R4|R3|R2|R1|M6|M5|M4|M3|M2|M1|
	--  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- M1 - M6: Bitmask for every stamp which has not provied a newAvails signal
    -- R1 - R6: Bitmask for every stamp which is requesting a Resync 
    -- RE: 8 bit counter: the number of ResyncEvents 
    -- AE: APB Error Address not known
    -- U: Unused
    -- PR: Pending Reading Interrupt
    -- PS: Pending Synchronizer Interrupt
    -- Timer and Prescaler
    signal SynchTimerPrescalerReg   : std_logic_vector(31 downto 0);
    signal SynchTimerValueReg       : std_logic_vector(31 downto 0);
    signal WaitingTimer             : std_logic_vector(31 downto 0); -- Possible use without a prescaler for this one:  fclk = 50Mhz -> Tclk = 20ns; (2**32 -1) * Tclk = 85.89s 
    signal ResyncPeriodeReg         : std_logic_vector(31 downto 0); -- without prescaler, see above. If this timer is running, even a fully requested resync will not be happening
    -- 
    signal ConfigReg                : std_logic_vector(31 downto 0);
    -- detailed description of the config reg:
    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
    --	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
	--  |EI|CS|CR|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |3 |3 |3 |3 |U |2 |2 |2 |U |1 |1 |1 |
	--  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    -- 1. Number of minimal neccessary newAvail Signals default: 4
    -- 2. Number of Request Resync signals, below this number: Dont care
    --                                      above this number: Run Resync Event
    -- 3. Number of maxiamal allowed Resync Events. NOTE 0xF: Dont care -> unlimited Resync
    --    Maximum of 14 tries until the System will do !!!
    -- EI: Enable Interrupts 
    -- CS: Clear SynchronizerInterrupt
    -- CR: Clear Read Interrupt
    -- U - Unused
    type MemorySyncState_t is (Start, ResyncEvent, S1, S2, End1, Error1, Error2);
    signal MemorySyncState : MemorySyncState_t;
    type APBStateType is (APBWaiting, APBReading, APBWriting);
    signal APBState                  : APBStateType;
begin
    process(clk, nReset)
    -- Number of minimal neccessary newAvail Signals default: 4 
    -- Belongs to ConfigReg Nr. 1
    variable numberOfnewAvails            : INTEGER RANGE 0 to 2**3 -1;

    -- Usually there are 6 STAMPS, to you need to cover the numbers 0 - 6; 
    -- is the real number below this threshold, the system dont cares
    -- Belongs to ConfigReg Nr. 2
    variable NumberOfPendingResyncRequest : INTEGER RANGE 0 to 2**3 - 1; 

    -- The number of allowd resync events due to config Register bits 8 - 11
    -- Belongs to ConfigReg Nr. 3
    variable NumberOfResyncEvents         : INTEGER RANGE 0 to 2**4 - 1; 

    variable 
    
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
            -- Init System Registers
            SynchStatusReg          <= (others => '0');
            SynchTimerPrescalerReg  <= (others => '0');
            SynchTimerValueReg      <= (others => '1'); -- Start with a really high number to avoid initial system failure
            WaitingTimer            <= (others => '1'); -- Start with a really high number to avoid initial system failure
            ResyncPeriodeReg        <= (others => '1'); -- Start with a really high number to avoid initial system failure
            -- Clear Config Reg
            ConfigReg               <= (others => '0');
            -- init state machines
            MemorySyncState <= Start;
            APBState        <= APBWaiting;
            -- Init signals form the component
            SynchronizerInterrupt   <= '0';
            ReadInterrupt           <= '0';
            PREADY                  <= '0';
            PRDATA                  <= (others => '0');
            -- Init Variables
            -- Init values are the default values, they are not confirmed valid
            numberOfnewAvails              := 4;
            NumberOfPendingResyncRequest   := 4;
            NumberOfResyncEvents           := 3; 
        elsif (rising_edge(clk)) then 
            if (IN_enable = '1') then 

            end if; -- End enable 

            case APBState is 
                when APBWaiting => 
                    if ((PENABLE = '1') and (PWRITE = '1') and (PSEL = '1')) then 
                        APBState <= APBWriting;
                    elsif ((PWRITE = '0' AND PSEL = '1')) then
                        APBState <= APBReading;
                    end if;
                    PREADY <= '0';
                when APBWriting => 
                    PREADY <= '1';
                    case PADDR is 
                        when X"038" => 
                            PRDATA <= ConfigReg;
                        when X"03C" => 
                            PRDATA <= SynchTimerPrescalerReg;
                        when X"040" => 
                            PRDATA <= SynchTimerValueReg;    
                        when X"044" =>
                            PRDATA <= WaitingTimer;
                        when X"04C" =>
                            PRDATA <= ResyncPeriodeReg;
                        when others => 
                            SynchStatusReg(28) = '1';
                    end case; -- and Writing addr case 
                when APBReading =>
                    PREADY <= '1';
                    case PADDR is 
                        when X"004" => 
                            PRDATA <= Stamp1ShadowReg1;
                            Stamp1ShadowReg1 <= (others => '0');
                        when X"008" =>
                            PRDATA <= Stamp1ShadowReg2;
                            Stamp1ShadowReg2 <= (others => '0');
                        when X"00C" => 
                            PRDATA <= Stamp2ShadowReg1;
                            Stamp2ShadowReg1 <= (others => '0');
                        when X"010" =>
                            PRDATA <= Stamp2ShadowReg2;
                            Stamp2ShadowReg2 <= (others => '0');
                        when X"014" => 
                            PRDATA <= Stamp3ShadowReg1;
                            Stamp3ShadowReg1 <= (others => '0');
                        when X"018" =>
                            PRDATA <= Stamp3ShadowReg2;
                            Stamp3ShadowReg2 <= (others => '0');
                        when X"01C" => 
                            PRDATA <= Stamp4ShadowReg1;
                            Stamp4ShadowReg1 <= (others => '0');
                        when X"020" =>
                            PRDATA <= Stamp4ShadowReg2;
                            Stamp4ShadowReg2 <= (others => '0');
                        when X"024" => 
                            PRDATA <= Stamp5ShadowReg1;
                            Stamp5ShadowReg1 <= (others => '0');
                        when X"028" =>
                            PRDATA <= Stamp5ShadowReg2;
                            Stamp5ShadowReg2 <= (others => '0');
                        when X"02C" => 
                            PRDATA <= Stamp6ShadowReg1;
                            Stamp6ShadowReg1 <= (others => '0');
                        when X"030" =>
                            PRDATA <= Stamp6ShadowReg2;
                            Stamp6ShadowReg2 <= (others => '0');
                        when X"034" => 
                            PRDATA <= SynchStatusReg;
                            SynchStatusReg(11 downto 0) <= (others => '0'); -- Clear bitmasks
                        when X"038" => 
                            PRDATA <= ConfigReg;
                        when X"03C" => 
                            PRDATA <= SynchTimerPrescalerReg;
                        when X"040" => 
                            PRDATA <= SynchTimerValueReg;    
                        when X"044" =>
                            PRDATA <= WaitingTimer;
                        when X"04C" =>
                            PRDATA <= ResyncPeriodeReg;
                        when others => 
                            PRDATA <= X"AFFEDEAD";
                    end case; -- end Reading addr case
            end case; -- End of APB Reading FSM
        end if; -- end risign_edge
    end process;
end arch ; -- arch