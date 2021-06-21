library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity MemorySynchronizer_tb is
end MemorySynchronizer_tb;

architecture testbench of MemorySynchronizer_tb is


    component MemorySynchronizer_tb is
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
      end component MemorySynchronizer_tb;
    signal clk                      : std_logic;
    signal nReset                   : std_logic;
    signal IN_enable                : std_logic;
    signal IN_databus               : std_logic_vector(383 downto 0);
    signal IN_newAvails             : std_logic_vector(5 downto 0);
    signal IN_requestSync           : std_logic_vector(5 downto 0);
    signal dataReadyReset           : std_logic; -- One signal to trigger the reset in each stamp module
    signal SynchronizerInterrupt    : std_logic;
    signal ReadInterrupt            : std_logic;
    signal ADCResync                : std_logic; 
    -- Define signals of apb 3 
    signal PADDR                    : std_logic_vector(11 downto 0);
    signal PSEL                     : std_logic;
    signal PENABLE                  : std_logic;
    signal PWRITE                   : std_logic;
    signal PWDATA                   : std_logic_vector(31 downto 0);
    signal PREADY                   : std_logic;
    signal PRDATA                   : std_logic_vector(31 downto 0);

begin

end testbench ; -- testbench