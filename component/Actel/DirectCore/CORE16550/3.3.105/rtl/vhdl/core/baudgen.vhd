------------------------------------------------------------------------
--
-- Copyright (c) 2002-2007 Microsemi Corp.
--
-- Please review the terms of the license agreement before using this
-- file.  If you are not an authorized user, please destroy this source
-- code file and notify Microsemi Corp immediately that you inadvertently received
-- an unauthorized copy.
------------------------------------------------------------------------
--
--  Project       : Core16550 Synchronous UART
--
--  File          : baudgen.vhd
--
--  Dependencies  : None
--
--  Model Type    : Synthesizable Core
--
--  Description   : Baud Generator
--
--  Designer      : JV
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 23-April-2002
--
--  Version       : 1H20N00S00
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

entity baudgen is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk          : in  std_logic;      -- System Clock
          mr           : in  std_logic;      -- Master Reset
          dlreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);   -- Divisory Register (LSB)
          dmreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);   -- Divisory Register (MSB)

          rclk_enb     : out std_logic;      -- Receiver Clock Enable
          baudoutn     : out std_logic;      -- Baud-Out
          txbaud       : out std_logic       -- Transmitter baud
          );
end baudgen;

architecture rtl of baudgen is

   -- Counter signals for baud generator 
   signal counter_value, cmax : std_logic_vector(15 downto 0);
   signal counter8_value : std_logic_vector(ADDR_WIDTH-1 downto 0);
   -- signals for baud select and baud clk
   signal baudout_rise        : std_logic;
   signal baudout_sync        : std_logic;
   signal baudout_inv         : std_logic;
   signal baud_clk            : std_logic;
   signal prevbaudout_sync    : std_logic;
   signal reset_counter_value : std_logic;
   signal areset              : std_logic;
   signal sreset              : std_logic;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';
   baudoutn <= not baudout_inv;

   -- Receiver clock enable
   rclk_enb <= ((not(prevbaudout_sync) and baudout_sync) or baud_clk);

-- -------------------------------------------------------------------------
-- Generate BAUD GENERATOR counter
-- It will start generate bautout (count counter_value) when
-- both write_dmr and write_dlr are inactive (address is not "000" or "001")
----------------------------------------------------------------------------
   cmax <= ((dmreg & dlreg) - "0000000000000001");

   reset_counter_value <= '1' when ((counter_value >= cmax) and 
                                   ((dmreg & dlreg(7 downto 1)) /= ZERO16(15 downto 1))) else '0';

   process(areset,clk)
   begin
      if (areset = '1') then
         counter_value <= TWO16;
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            counter_value <= TWO16;
	     else
            --if (counter_value >= cmax) and ((dmreg & dlreg(7 downto 1)) /= ZERO16(15 downto 1)) then
            if (reset_counter_value = '1') then
               counter_value   <= ZERO16;
            else
               counter_value <= counter_value + "0000000000000001";
            end if;
         end if;
      end if;
   end process;

-----------------------------------------------------------------------
-- Baud Generator
-- baud_clk is used to select the clk (for N = 0 or 1) or baudout_sync
-- baudout_rise is used for the counter to enable the transmitter baud 
-- baudout_sync is used for baudoutn when N > 1
-----------------------------------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         baudout_sync <= '0';
         baudout_rise <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            baudout_sync <= '0';
            baudout_rise <= '0';
	     else
            if ((dmreg & dlreg(7 downto 1)) = ZERO16(15 downto 1)) then  -- N = 1 or 0
               baudout_sync <= '0';
               baudout_rise <= '1';
            else                                  -- N >= 2
               case counter_value is
                  when ONE16 => baudout_sync <= '0'; baudout_rise <= '1';
                  when TWO16 => baudout_rise <= '0'; baudout_sync <= '0';
                  when OTHERS => baudout_sync <= '1'; baudout_rise <= '0';
               end case;
            end if;
         end if;
      end if;
   end process;
 
   process(dmreg, dlreg)
   begin
      if ((dmreg & dlreg(7 downto 1)) = ZERO16(15 downto 1)) then  -- N = 1 or 0
         baud_clk <= '1';
      else
         baud_clk <= '0';
      end if;
   end process;

   process(clk, baud_clk, baudout_sync)
   begin
      if (baud_clk = '1') then
         baudout_inv <= clk;
      else
         baudout_inv <= not baudout_sync;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         prevbaudout_sync <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            prevbaudout_sync <= '0';
	     else
            prevbaudout_sync <= baudout_sync;
         end if;
      end if;
   end process;

-------------------------------------------
-- Generate Transmitter BAUDOUT/16 counter 
-------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         counter8_value <= "000";
         txbaud <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            counter8_value <= "000";
            txbaud <= '0';
         else
            txbaud <= '0';
            if (baudout_rise = '1') then
               if (counter8_value = "111") then
                  counter8_value <= "000";
               else
                  counter8_value <= counter8_value + 1;
               end if;
               if counter8_value = "000" then
                  txbaud <= '1';
               end if;
            end if;
         end if;
      end if;
   end process;

end rtl;  -- baudgen

