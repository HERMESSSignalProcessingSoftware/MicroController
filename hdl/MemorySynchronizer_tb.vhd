library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity MemorySynchronizer_tb is
end MemorySynchronizer_tb;

architecture testbench of MemorySynchronizer_tb is


    component MemorySynchronizer is
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
          PRDATA              : out std_logic_vector(31 downto 0)
        ) ;
    end component MemorySynchronizer;
    
    signal clk                      : std_logic := '0';
    signal nReset                   : std_logic := '1';
    signal IN_enable                : std_logic := '0';
    signal IN_databus               : std_logic_vector(383 downto 0);
    signal IN_newAvails             : std_logic_vector(5 downto 0);
    signal IN_requestSync           : std_logic_vector(5 downto 0);
    signal dataReadyReset           : std_logic; -- One signal to trigger the reset in each stamp module
    signal SynchronizerInterrupt    : std_logic;
    signal ReadInterrupt            : std_logic;
    signal ADCResync                : std_logic; 
    signal PADDR                    : std_logic_vector(11 downto 0);
    signal PSEL                     : std_logic := '0';
    signal PENABLE                  : std_logic := '0';
    signal PWRITE                   : std_logic := '0';
    signal PWDATA                   : std_logic_vector(31 downto 0) := (others => '0');
    signal PREADY                   : std_logic;
    signal PRDATA                   : std_logic_vector(31 downto 0);
begin

  DUT : MemorySynchronizer PORT MAP(
    clk                   => clk,                  
    nReset                => nReset,
    IN_enable             => IN_enable,            
    IN_databus            => IN_databus,           
    IN_newAvails          => IN_newAvails,         
    IN_requestSync        => IN_requestSync,       
    dataReadyReset        => dataReadyReset,       
    SynchronizerInterrupt => SynchronizerInterrupt,
    ReadInterrupt         => ReadInterrupt,
    ADCResync             => ADCResync,       
    PADDR                 => PADDR,           
    PSEL                  => PSEL,               
    PENABLE               => PENABLE,              
    PWRITE                => PWRITE,             
    PWDATA                => PWDATA,              
    PREADY                => PREADY,              
    PRDATA                => PRDATA              
  );


-- Init this massiv datebus
IN_databus(383 downto 320) <=  X"1111111112121212"; 
IN_databus(319 downto 256) <=  X"2121212122222222"; 
IN_databus(255 downto 192) <=  X"3131313132323232"; 
IN_databus(191 downto 128) <=  X"4141414142424242";
IN_databus(127 downto 64)  <=  X"5151515152525252";
IN_databus(63 downto 0)    <=  X"6161616162626262"; 
                               

-- Do the configuration of the Sync first
--if ((PENABLE = '1') and (PWRITE = '1') and (PSEL = '1')) then 
--APBState <= APBWriting;
--elsif ((PWRITE = '0' AND PSEL = '1')) then
--APBState <= APBReading;
--end if;


-- REgister 
-- 0x38 ConfigReg
-- 0x3C ResetTimerValueReg
-- 0x40 WaitingTimerValueReg
-- 0x44 ResyncTimerValueReg

-- CONFIG REG
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
-- 
-- signal ResetTimerValueReg       : std_logic_vector(31 downto 0);
-- signal WaitingTimerValueReg     : std_logic_vector(31 downto 0); -- Possible use without a prescaler for this one:  fclk = 50Mhz -> Tclk = 20ns; (2**32 -1) * Tclk = 85.89s 
-- signal ResyncTimerValueReg      : std_logic_vector(31 downto 0); -- without prescaler, see above. If this timer is running, even a fully requested resync will not be happening


clk <= not clk after 20 ns; -- 50Mhz clk 
process
  procedure HANDLE_INTERRUPT is
    begin
        wait until rising_edge(clk);
        PWRITE  <= '1';
        PSEL    <= '1';
        PENABLE <= '1';
        wait until rising_edge(clk);
        PADDR   <= X"038";
        PWDATA  <= X"E0000044"; -- Reset interrupts
        wait until rising_edge(clk); -- 
        wait until rising_edge(clk);
        ASSERT readInterrupt = '0' report "Read interrupt was not reseted";
        wait for 50 ns;
        PWRITE  <= '0';
        PSEL    <= '0';
        PENABLE <= '0';
  end procedure HANDLE_INTERRUPT;

  procedure READREGS (
    NOTProvided : std_logic_vector(5 downto 0)
  ) is
  begin
    Report "START OF REGISTER READING";
    PSEL <= '1';
    wait until rising_edge(clk);
    PADDR   <= X"004";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(0) = '0') then 
      assert PRDATA = X"11111111" report "STAMP1Reg1 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP1Reg1 does not match";
    end if;
    PADDR   <= X"008";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(0) = '0') then 
      assert PRDATA = X"12121212" report "STAMP1Reg2 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP1Reg2 does not match";
    end if;
    PADDR   <= X"00C";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(1) = '0') then 
      assert PRDATA = X"21212121" report "STAMP2Reg1 does not match";
    else                           
      assert PRDATA = X"00000000" report "STAMP2Reg1 does not match";
    end if;                          
    
    PADDR   <= X"010";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(1) = '0') then
      assert PRDATA = X"22222222" report "STAMP2Reg2 does not match";
    else                          
      assert PRDATA = X"00000000" report "STAMP2Reg2 does not match";
    end if;                       
    PADDR   <= X"014";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(2) = '0') then
      assert PRDATA = X"31313131" report "STAMP3Reg1 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP3Reg1 does not match";
    end if;
    PADDR   <= X"018";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(2) = '0') then
      assert PRDATA = X"32323232" report "STAMP3Reg2 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP3Reg2 does not match";
    end if;
    PADDR   <= X"01C";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(3) = '0') then
      assert PRDATA = X"41414141" report "STAMP4Reg1 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP4Reg1 does not match";
    end if;
    PADDR   <= X"020";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(3) = '0') then
      assert PRDATA = X"42424242" report "STAMP4Reg2 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP4Reg2 does not match";
    end if;
    PADDR   <= X"024";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(4) = '0') then
      assert PRDATA = X"51515151" report "STAMP5Reg1 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP5Reg1 does not match";
    end if;
    PADDR   <= X"028";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(4) = '0') then
      assert PRDATA = X"52525252" report "STAMP5Reg2 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP5Reg2 does not match";
    end if;
    PADDR   <= X"02C";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(5) = '0') then
      assert PRDATA = X"61616161" report "STAMP6Reg1 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP6Reg1 does not match";
    end if;
    PADDR   <= X"030";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    if (NOTProvided(5) = '0') then
      assert PRDATA = X"62626262" report "STAMP6Reg2 does not match";
    else 
      assert PRDATA = X"00000000" report "STAMP6Reg2 does not match";
    end if;
    Report "END OF Register Reading!";
    PSEL <= '0';
    wait until rising_edge(clk);
  end procedure READREGS;

  procedure DO_RESET is
  begin 
    nReset <= '0';
    PADDR   <=  X"000";
    PWDATA  <=  X"00000000";
    PSEL    <=  '0';
    IN_enable <= '0';
    IN_newAvails <= "000000";
    IN_requestSync <= "000000";
    wait for 30 ns;
    nReset <= '1';
  end procedure DO_RESET;

  procedure BASIC_APB_INIT is 
  begin
    PSEL    <=  '1';
    PENABLE <=  '1';
    PWRITE  <=  '1';
    wait until rising_edge(clk);
    PADDR <= X"038";
    PWDATA  <= X"80000044";
    wait until rising_edge(PREADY);
    PADDR <= X"03C";
    PWDATA  <= X"000009C4";
    wait until rising_edge(PREADY);
    PADDR <= X"040";
    PWDATA  <= X"00000096";
    wait until rising_edge(PREADY);
    PADDR <= X"044";
    PWDATA  <=  X"000001F4";
    wait until rising_edge(PREADY);     
    wait until rising_edge(clk);
    PSEL    <=  '0';
    PENABLE <= '0';
    PWRITE <= '0';
  end procedure BASIC_APB_INIT;

  variable StartTime : time;
  variable EndTime : time;
  variable Temp    : Integer;
    begin
        report "Started simulation";
        DO_RESET;
        wait until rising_edge(clk);
        nREset <= '1';
        wait for 30 ns;
        -- APB action here 
        BASIC_APB_INIT;
        wait for 100 ns;
        IN_enable <=  '1';
        -- Finised init 
        IN_newAvails <= "111111"; -- Test START -> S1 -> END1 with ReadInterrupt -> START
        wait until rising_edge(dataReadyReset);
        IN_newAvails <= "000000";
        wait until rising_edge(ReadInterrupt);
        HANDLE_INTERRUPT;
        wait until rising_edge(clk); -- to prevent the SR1(28) bit (APB addr error) to pop up, workes saw it, thats why I addes these
        PSEL <= '0';
        -- READ REGS
        READREGS("000000");
        report "FINISHED all STAMPS provided data in time test";
        wait for 1 us;
        IN_newAvails   <=   "010100";
        wait until rising_edge(clk);
        wait for 3 us;
        IN_newAvails   <=   "111100"; -- Status reg should contain this bit mask
        wait until rising_edge(clk);
        wait until rising_edge(dataReadyReset);
        report "Update new Availables, all cleared!";
        IN_newAvails <= "000000";
        wait until rising_edge(ReadInterrupt);
        HANDLE_INTERRUPT;
        wait until rising_edge(clk);
        READREGS("000011");
        wait until rising_edge(clk);
        -- Read the status reg 0x34
        PSEL <= '1';
        wait until rising_edge(clk);
        PADDR   <= X"034";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        ASSERT PRDATA(5 downto 0) = "000011" report "BITMASK of SR1 (5:0) does not match";
        wait until rising_edge(clk);
        PSEL <= '0';
        report "Fished Test of Missing stamp values, no errors? passed!";
        -- continue with a reqest event, let assume at first three of them later for do want that ADCResync should be touched
        IN_requestSync <= "001100"; -- Not enough for resyncing
        wait for 1 us;
        IN_requestSync <= "001101"; -- Not enough for resyncing
        wait for 1 us;
        IN_requestSync <= "101101"; -- Not enough for resyncing
        wait until falling_edge(ADCResync);
        IN_requestSync  <= "000000";
        StartTime := now;
        wait until rising_edge(clk);
        ASSERT ADCResync = '0' report "Falling Edge was not provied";
        wait until rising_edge(ADCResync);
        EndTime := now;
        report "Duration: " & time'image(EndTime - StartTime);
        Temp := (EndTime - StartTime) / 20 ns;
        report "Cycles: " & integer'image(Temp);
        Assert (Temp * 20 ns) > 250 ns report "Estimated downtime of ADCResync signal was violated";
        report "END OF first Resync START -> RESYNCEvent with falling level on ADCResync";
        -- continue with missing STAMPS (START -> S1 -> S2) ADCReSync signal should not be touched 
        report "START OF ResyncTest START -> S1 -> S2 -> START";
        wait for 2 us;
        IN_newAvails <= "110000"; --  zuwenige Signale und timer auslaufen lassen für übergang auf s2
        wait for 6 us;
        for i in 0 to 10 loop
          wait until rising_edge(clk);
          ASSERT ADCResync = '1' report "ADC Resync was pulled down due to software malfunction";
        end loop;
        if (ReadInterrupt = '1') then -- Reached S2
          IN_newAvails <= "000000";
          HANDLE_INTERRUPT;
          report "Cleared newAvails";
        end if;
        wait until rising_edge(clk);
        READREGS("001111");
        wait until rising_edge(clk);
        report "END OF START -> S1 -> S2 not entering Rsync test!";
        report "START OF TEST no stamp has ever provided data";
        wait for 100 us;
        ASSERT SynchronizerInterrupt = '1' report "SynchronizerInterrupt was not triggerd";
        HANDLE_INTERRUPT;
        DO_RESET;
        BASIC_APB_INIT;
        -- continue with all missing stamps SyncInterrupt has to be trown 
        
        report "END OF TEST";
        wait;
end process;

end testbench ; -- testbench