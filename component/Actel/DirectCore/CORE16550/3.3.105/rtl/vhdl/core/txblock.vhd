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
--  File          : txblock.vhd
--
--  Dependencies  : none 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Transceiver block
--
--  Designer      : JU
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 20-May-2003
--
--  Version       : 1H20N00S00
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

entity txblock is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk          : in  std_logic;  -- System Clock
          mr           : in  std_logic;  -- Master Reset
          txbaud       : in  std_logic;  -- Transmitter Baud
          txfifo_empty : in  std_logic;  -- Transmitter Fifo Empty flag
          lcreg        : in  std_logic_vector(6 downto 0);  -- Line Control register
          threg        : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Transmitter holding register

          temt         : out std_logic;  -- Transmitter Fifo empty
          stop_state   : out std_logic;
          read_txfifo  : out std_logic;  -- Read Transmitter fifo enable
          sout_org     : out std_logic   -- Internal Serial output
          );
end txblock;

architecture rtl of txblock is

   signal state       : TX_STATE_MACHINE;
   signal next_state  : TX_STATE_MACHINE;
   signal tsreg       : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal parity      : std_logic;
   signal break       : std_logic;
   signal sout_bit    : std_logic;
   signal sout_int    : std_logic;
   signal temt1       : std_logic;
   signal parity_lcreg4, invert_parity : std_logic;
   signal areset              : std_logic;
   signal sreset              : std_logic;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';

   sout_org <= sout_int;

   stop_state <= '1' when (state = SEND1_STOP0) else '0';

----------------------------------------------------
-- Force SOUT to ZERO when there is break condition 
----------------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         sout_int  <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            sout_int  <= '1';
	     else
            if (break = '1') then
               sout_int <= '0';
            else
               if (txbaud = '1') then
                  sout_int <= sout_bit;
               end if;
            end if;
         end if;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         break <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            break <= '0';
	     else
            break <= lcreg(6);
         end if;
      end if;
   end process;

-----------------------
-- TEMT bit generation 
-----------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         temt <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            temt <= '1';
	     else
            if (txbaud = '1' and txfifo_empty = '1' and temt1 = '1') then
               temt <= '1';
            end if;
            if txfifo_empty = '0' then
               temt <= '0';
            end if;
         end if;
      end if;
   end process;

   --------------------------------------------
   -- Read Transmitter Holding Register Enable
   --------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         tsreg <= (others => '0');
         read_txfifo <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            tsreg <= (others => '0');
            read_txfifo <= '0';
	     else
            read_txfifo <= '0';
            if (txbaud = '1') then
               if ((state = WAITING1 or state = SEND2_STOP1) and txfifo_empty = '0') or  -- SEND_START
                  (state = SEND2_STOP0 and txfifo_empty = '0' and lcreg(2) = '0') then   -- 1 STOP BIT
                  tsreg <= threg;
                  read_txfifo <= '1';
               end if;
            end if;
         end if;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         parity <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            parity <= '0';
	     else
            if (txbaud = '1') then
               if parity_lcreg4 = '1' then
                  parity <= not lcreg(4);
               end if;
               if invert_parity = '1' then
                  parity <= not parity;
               end if;
            end if;
         end if;
      end if;
   end process;

-----------------------------
-- STATE MACHINE
-----------------------------
   state_process : process(clk, areset)
   begin
      if (areset = '1') then
         state <= WAITING1;
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            state <= WAITING1;
	     else
            if (txbaud = '1') then
               state <= next_state;
            end if;
         end if;
      end if;
   end process;
 
   state_combo_process : process(state, parity, lcreg, tsreg, txfifo_empty, sout_int)
   begin
      next_state <= state;
      invert_parity <= '0';
      parity_lcreg4 <= '0';
      sout_bit <= sout_int;
      temt1 <= '0';

      case state is
         when WAITING1 => sout_bit <= '1';
                          parity_lcreg4 <= '1';
                          if (txfifo_empty = '0') then   -- SEND_START
                             next_state <= SEND_START1;
                             temt1 <= '0';
                             sout_bit <= START;
                          else
                             next_state <= WAITING1;
                             temt1 <= '1';
                             sout_bit <= '1';
                          end if;

         when SEND_START1  => next_state <= SEND_START2;
         when SEND_START2  => next_state <= SEND1_BIT0;
                              sout_bit <= tsreg(0);      -- LSB
                              if (tsreg(0) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT0   => next_state <= SEND2_BIT0;
         when SEND2_BIT0   => next_state <= SEND1_BIT1;
                              sout_bit <= tsreg(1);      --1
                              if (tsreg(1) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT1   => next_state <= SEND2_BIT1;
         when SEND2_BIT1   => next_state <= SEND1_BIT2;
                              sout_bit <= tsreg(2);      --2
                              if (tsreg(2) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT2   => next_state <= SEND2_BIT2;
         when SEND2_BIT2   => next_state <= SEND1_BIT3;
                              sout_bit <= tsreg(3);      --3
                              if (tsreg(3) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT3   => next_state <= SEND2_BIT3;
         when SEND2_BIT3   => next_state <= SEND1_BIT4;
                              sout_bit <= tsreg(4);      --4
                              if (tsreg(4) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT4   => next_state <= SEND2_BIT4;
         when SEND2_BIT4   => if (lcreg(0) = '0' and lcreg(1) = '0' and lcreg(3) = '1') then
                                 next_state <= SEND1_PARITY;  -- 5 bits, parity
                                 if (lcreg(5) = '1') then
                                    sout_bit <= not lcreg(4);
                                 else
                                    sout_bit <= parity;
                                 end if;
                              elsif (lcreg(0) = '0' and lcreg(1) = '0' and lcreg(3) = '0') then
                                 next_state <= SEND1_STOP0;   -- 5 bits, no parity
                                 sout_bit <= STOP;
                              else
                                 next_state <= SEND1_BIT5;    -- 6 bits or more
                                 sout_bit <= tsreg(5);   -- 5
                              end if;
                              if (tsreg(5) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT5   => next_state <= SEND2_BIT5;
         when SEND2_BIT5   => if (lcreg(0) = '1' and lcreg(1) = '0' and
                                 lcreg(3) = '1') then
                                 next_state <= SEND1_PARITY;  -- 6 bits, parity
                                 if (lcreg(5) = '1') then
                                    sout_bit <= not lcreg(4);
                                 else
                                    sout_bit <= parity;
                                 end if;
                              elsif (lcreg(0) = '1' and lcreg(1) = '0' and
                                 lcreg(3) = '0') then
                                 next_state <= SEND1_STOP0;   -- 6 bits, no parity
                                 sout_bit <= STOP;
                              else
                                 next_state <= SEND1_BIT6;    -- 7 bits or more
                                 sout_bit <= tsreg(6);   --6
                              end if;
                              if (tsreg(6) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT6   => next_state <= SEND2_BIT6;
         when SEND2_BIT6   => if (lcreg(0) = '0' and lcreg(1) = '1' and
                                 lcreg(3) = '1') then
                                 next_state <= SEND1_PARITY;  -- 7 bits, parity
                                 if (lcreg(5) = '1') then
                                    sout_bit <= not lcreg(4);
                                 else
                                    sout_bit <= parity;
                                 end if;
                              elsif (lcreg(0) = '0' and lcreg(1) = '1' and
                                 lcreg(3) = '0') then
                                 next_state <= SEND1_STOP0;   -- 7 bits, no parity
                                 sout_bit <= STOP;      -- 7
                              else
                                 next_state <= SEND1_BIT7;    -- 8 bits
                                 sout_bit <= tsreg(7);   --7
                              end if;
                              if (tsreg(7) = '1') then
                                 invert_parity <= '1';
                              end if;

         when SEND1_BIT7   => next_state <= SEND2_BIT7;
         when SEND2_BIT7   => if (lcreg(3) = '1') then
                                 next_state <= SEND1_PARITY;  -- parity
                                 if (lcreg(5) = '1') then
                                    sout_bit <= not lcreg(4);
                                 else
                                    sout_bit <= parity;
                                 end if;
                              else
                                 next_state <= SEND1_STOP0;   -- no parity
                                 sout_bit <= STOP;      -- STOP1
                              end if;

         when SEND1_PARITY => next_state <= SEND2_PARITY;
         when SEND2_PARITY => next_state <= SEND1_STOP0;   -- stop
                              sout_bit <= STOP;      --  STOP1 bit

         when SEND1_STOP0  => next_state <= SEND2_STOP0;
         when SEND2_STOP0  => if (lcreg(2) = '0' and txfifo_empty = '1') then
                                 next_state <= WAITING1;      -- 1 STOP bit
                                 sout_bit <= '1';        --  STOP1 bit
                                 temt1 <= '1';
                              elsif (lcreg(2) = '0') then
                                 next_state <= SEND_START1 ;
                                 sout_bit <= START;    -- START
                                 parity_lcreg4 <= '1';
                                 temt1 <= '0';
                              elsif (lcreg(1) = '0' and lcreg(0) = '0') then
                                 next_state <= SEND2_STOP1; -- 1.5 STOP bits
                                 sout_bit <= STOP;    -- STOP1
                              else
                                 next_state <= SEND1_STOP1; -- 2 STOP bits
                                 sout_bit <= STOP;    -- STOP1
                              end if;

         when SEND1_STOP1 => next_state <= SEND2_STOP1;
         when SEND2_STOP1 => if (txfifo_empty = '0') then -- SEND_BIT0
                                next_state <= SEND_START1 ;
                                temt1 <= '0';
                                sout_bit <= START;        -- START
                                parity_lcreg4 <= '1';
                             else
                                next_state <= WAITING1;  -- 1 STOP bit
                                temt1 <= '1';
                                sout_bit <= '1';    --  ONE
                             end if;
      end case ;
   end process;

end rtl ;   -- txblock

