----------------------------------------------------------------------------------
-- Company: REXUS HERMESS MESS II 
-- Engineer: Robin Grimsmann
-- 
-- Create Date:    25.02.2021 
-- Design Name: MESS II
-- Module Name: Memory Timestamp TB
-- Project Name: HERMESS
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Generates a timestamp 
-- delta value = fcpu / 2* 25 = 50Mhz / 2 * 25 => T = 1 / delta value = 1us 
-- 
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.00 - Updated Prescaler value to 25
--                
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Timestamp_tb is

end Timestamp_tb;
architecture behaviour of Timestamp_tb is
    --type t_tate is (S1, S2);
    --signal state : t_tate;
    component Timestamp is
        port (
          clk         : in std_logic;
          nReset      : in std_logic;
          enable      : in std_logic; 
          getTime     : in std_logic;
          timestamp   : out std_logic_vector(31 downto 0)
        ) ;
    end component Timestamp;
    signal clk         : std_logic := '0';
    signal nReset      : std_logic := '1';
    signal enable      : std_logic := '0'; 
    signal getTime     : std_logic; -- Unsed
    signal TS   : std_logic_vector(31 downto 0);
begin

    dut : Timestamp Port map(clk => clk, nReset => nReset, enable => enable, getTime => getTime, timestamp => TS);
    clk <= not clk after 10 ns;
    nReset <= '0' after 5 ns, '1' after 25 ns;
    enable <= '1' after 1 us;
end behaviour ; -- behaviour