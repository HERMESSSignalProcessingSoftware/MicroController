----------------------------------------------------------------------------------
-- Company: REXUS HERMESS MESS II 
-- Engineer: Robin Grimsmann
-- 
-- Create Date:    25.02.2021 
-- Design Name: MESS II
-- Module Name: Memory Timestamp
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

entity Timestamp is
  port (
    clk         : in std_logic;
    nReset      : in std_logic;
    enable      : in std_logic; 
    getTime     : in std_logic;
    timestamp   : out std_logic_vector(31 downto 0)
  ) ;
end Timestamp;
architecture behaviour of Timestamp is
    type t_tate is (S1, S2);
    signal state : t_tate;
begin

    process (clk, nReset) 
    variable Counter    : Integer; -- 32 bit counter register
    variable prescaler  : Integer range 0 to  51;
    begin 
        if (nReset = '0') then
            state <= S1;
            Counter := 0;
            timestamp <= (others => '0');
            prescaler := 0;
        elsif (rising_edge(clk)) then
            if (enable = '1') then 
                case State is 
                    when S1 =>  -- Counting
                        if (prescaler = 24) then 
                            Counter := Counter + 1;
                            prescaler := 0;
                        else 
                            prescaler := prescaler + 1;
                        end if;
                        timestamp <=  std_logic_vector(to_unsigned(Counter, timestamp'length));
                    when S2 => -- Ignore this case
                        timestamp <=  std_logic_vector(to_unsigned(Counter, timestamp'length));
                        state <= S1;
                    when others => 
                        state <= S1;
                end case;
            end if;
        end if;
    end process ; -- 

end behaviour ; -- behaviour