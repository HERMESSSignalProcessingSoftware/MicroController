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
--  File          : rxblock.vhd
--
--  Dependencies  : none 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Receiver block
--
--  Designer      : JU
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 30-March-2007
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


entity rxblock is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk          : in  std_logic;   -- System Clock
          mr           : in  std_logic;   -- Master Reset
          cs           : in  std_logic;   -- Chip Select
          rd           : in  std_logic;   -- Read Enable
          rclk_enb     : in  std_logic;   -- Receiver Clock enable
          sin_org      : in  std_logic;   -- Internal Serial input 
          fcreg1       : in  std_logic;   -- Receiver FIFO reset bit
          prevrdlsr    : in  std_logic;   -- Previous LSR read flag
          lcreg        : in  std_logic_vector(5 downto 0);  -- Line Control register 

          write_rxfifo : out std_logic;   -- Write Receiver fifo enable
          rxbaud       : out std_logic;   -- 
          frame_size   : out std_logic_vector(3 downto 0);
          rxf          : out std_logic_vector(10 downto 0) -- Receiver Fifo Data
          );
end rxblock;

architecture rtl of rxblock is

   signal state                      : RX_STATE_MACHINE;
   signal rxreg                      : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal lcreg3210                  : std_logic_vector(3 downto 0);
   signal pe_pre, parity             : std_logic;
   signal rxbaud_int                 : std_logic;
   signal not_break_check            : std_logic;
   signal counter8_value, rxbaud_ref : std_logic_vector(2 downto 0);
   signal write_rxfifo_done          : std_logic;
   signal startbit_stable            : std_logic;
   signal areset              : std_logic;
   signal sreset              : std_logic;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';

   rxbaud <= rxbaud_int;

   rxf(10 downto 3) <= rxreg;

   process(clk, areset)
   begin
      if areset = '1' then
         rxbaud_ref <= "001";
      elsif clk'event and clk = '1' then
         if sreset = '1' then
            rxbaud_ref <= "001";
	     else
            if (rclk_enb = '1') and (sin_org = '0' and state = WAITING_START) then
               if (counter8_value = "000") then
                  rxbaud_ref <= "111";
               else
                  rxbaud_ref <= counter8_value;
               end if;
            end if;
         end if;
      end if;
   end process;

   process(clk, areset)
   begin
      if areset = '1' then
         startbit_stable <= '1';
      elsif clk'event and clk = '1' then
         if sreset = '1' then
            startbit_stable <= '1';
	     else
            if (rclk_enb = '1') then
               if (state = WAITING2) then
                  if (sin_org = '1') then
                     startbit_stable <= '0';
                  end if;
               else
                  startbit_stable <= '1';
               end if;
            end if;
         end if;
      end if;
   end process;

-----------------
-- STATE MACHINE 
-----------------
   state_process : process(clk, areset)
   begin
      if areset = '1' then
         state            <= WAITING_START;
         pe_pre           <= '0';
         not_break_check  <= '0';
         rxreg            <= (others => '0');
         rxf(ADDR_WIDTH-1 downto 0)  <= "000";
         write_rxfifo     <= '0';
         write_rxfifo_done <= '0';
         parity           <= '0';
      elsif clk'event and clk = '1' then
        if sreset = '1' then
           state            <= WAITING_START;
           pe_pre           <= '0';
           not_break_check  <= '0';
           rxreg            <= (others => '0');
           rxf(ADDR_WIDTH-1 downto 0)  <= "000";
           write_rxfifo     <= '0';
           write_rxfifo_done <= '0';
           parity           <= '0';
	    else
           if (rclk_enb = '1') then
              write_rxfifo <= '0';
              if (startbit_stable = '0') then
                 state <= WAITING_START;
              elsif rxbaud_int = '1' or (state = WAITING_START or state = WAITING2) then
        
                 case state is
        
                    when WAITING_START => rxf(ADDR_WIDTH-1 downto 0) <= "000";
                                          write_rxfifo_done <= '0';
                                          pe_pre <= '0';
                                          parity <= not lcreg(4);
                                          rxreg <= (others => '0');
                                          if (sin_org = START) then
                                             not_break_check <= '1';
                                             state <= WAITING2;
                                          else
                                             state <= WAITING_START;
                                             not_break_check <= '0';
                                          end if;
                    when WAITING2 => if (sin_org /= START) then
                                        state <= WAITING_START;
                                     else
                                        if (rxbaud_int = '1') then
                                           state <= REC1_BIT0;
                                        end if;
                                     end if;
        
                    when REC1_BIT0 => state <= REC2_BIT0;
                    when REC2_BIT0 => state <= REC1_BIT1;
                                      rxreg(0) <= sin_org;
                                      if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
        
                    when REC1_BIT1 => state <= REC2_BIT1;
                    when REC2_BIT1 => if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      state <= REC1_BIT2;
                                      rxreg(1) <= sin_org;
        
                    when REC1_BIT2 => state <= REC2_BIT2;
                    when REC2_BIT2 => if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      state <= REC1_BIT3;
                                      rxreg(2) <= sin_org;
        
                    when REC1_BIT3 => state <= REC2_BIT3;
                    when REC2_BIT3 => if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      state <= REC1_BIT4;
                                      rxreg(3) <= sin_org;
        
                    when REC1_BIT4 => state <= REC2_BIT4;
                    when REC2_BIT4 => rxreg(4) <= sin_org;
                                      if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      if (lcreg(0) = '0' and lcreg(1) = '0' and lcreg(3) = '1') then
                                         state <= REC1_PARITY;  -- 5 bits, parity
                                      elsif (lcreg(0) = '0' and lcreg(1) = '0' and lcreg(3) = '0') then
                                         state <= REC1_STOP0;  -- 5 bits, no parity
                                      else
                                         state <= REC1_BIT5;  -- 6 bits or more
                                      end if;
        
                    when REC1_BIT5 => state <= REC2_BIT5;
                    when REC2_BIT5 => rxreg(5) <= sin_org;
                                      if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      if (lcreg(0) = '1' and lcreg(1) = '0' and lcreg(3) = '1') then
                                         state <= REC1_PARITY;  -- 6 bits, parity
                                      elsif (lcreg(0) = '1' and lcreg(1) = '0' and lcreg(3) = '0') then
                                         state <= REC1_STOP0;  -- 6 bits, no parity
                                      else
                                         state <= REC1_BIT6;  -- 7 bits or more
                                      end if;
        
                    when REC1_BIT6 => state <= REC2_BIT6;
                    when REC2_BIT6 => rxreg(6) <= sin_org;
                                      if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      if (lcreg(0) = '0' and lcreg(1) = '1' and lcreg(3) = '1') then
                                         state <= REC1_PARITY;  -- 7 bits, parity
                                      elsif (lcreg(0) = '0' and lcreg(1) = '1' and lcreg(3) = '0') then
                                         state <= REC1_STOP0;  -- 7 bits, no parity
                                      else
                                         state <= REC1_BIT7;  -- 8 bits
                                      end if;
        
                    when REC1_BIT7 => state <= REC2_BIT7;
                    when REC2_BIT7 => rxreg(7) <= sin_org;
                                      if (sin_org = '1') then
                                         not_break_check <= '0';
                                         parity <= not parity;
                                      end if;
                                      if (lcreg(3) = '1') then
                                         state <= REC1_PARITY;  -- parity
                                      else
                                         state <= REC1_STOP0;  -- no parity
                                      end if;
        
                    when REC1_PARITY => state <= REC2_PARITY;
                    when REC2_PARITY => if (sin_org = '1') then
                                           not_break_check <= '0';
                                        end if;
                                        if (lcreg(5) = '1') then  -- STICK PARITY
                                           if (sin_org = not lcreg(4)) then
                                              pe_pre <= '0';
                                           else
                                              pe_pre <= '1';
                                           end if;
                                        else                  -- no STICK
                                           if (sin_org = parity) then
                                              pe_pre <= '0';
                                           else
                                              pe_pre <= '1';
                                           end if;
                                        end if;
                                        state <= REC1_STOP0;  -- stop
        
                    when REC1_STOP0 => state <= REC2_STOP0;
                    when REC2_STOP0 => 
                                       rxf(0) <= pe_pre;
                                       if (sin_org = '1') then
                                          not_break_check <= '0';
                                       end if;
                                       if (sin_org /= STOP) then
                                          rxf(1) <= '1';
                                          if write_rxfifo_done = '0' then
                                             write_rxfifo <= '1';
                                             write_rxfifo_done <= '1';
                                          end if;
                                          -- If not_break_check is 1; it is break interrupt
                                          if (not_break_check = '0') then
                                             state <= WAITING_START;
                                          else             
                                             rxf(2) <= '1';
                                          end if;
                                       elsif (lcreg(2) = '0') then
                                          state <= WAITING_START;  -- 1 STOP bit
                                          if write_rxfifo_done = '0' then
                                             write_rxfifo <= '1';
                                          end if;
                                       elsif (lcreg(1) = '0' and lcreg(0) = '0') then
                                          state <= REC2_STOP1;  -- 1.5 STOP bits
                                       else
                                          state <= REC1_STOP1;  -- 2 STOP bits
                                       end if;
        
                    when REC1_STOP1 => state <= REC2_STOP1;
                    when REC2_STOP1 => if (sin_org /= STOP) then
                                          rxf(1) <= '1';
                                          if write_rxfifo_done = '0' then
                                             write_rxfifo <= '1';
                                             write_rxfifo_done <= '1';
                                          end if;
                                          -- If not_break_check is 1; it is break interrupt
                                          if (not_break_check = '0') then
                                             state <= WAITING_START;
                                          else     -- not_break_check = '1'
                                             rxf(2) <= '1';
                                          end if;
                                       else
                                          state <= WAITING_START;  -- No more TX data
                                          if write_rxfifo_done = '0' then
                                             write_rxfifo <= '1';
                                          end if;
                                       end if;
                                       not_break_check <= '1';
                 end case;
              end if;
              if (fcreg1 = '1') then
                 rxreg <= (others => '0');
                 rxf(ADDR_WIDTH-1 downto 0)  <= "000";
              end if;
           end if;
           if (prevrdlsr = '1' and (rd = '0' or cs = '0')) then
              rxf(ADDR_WIDTH-1 downto 0)  <= "000";
           end if;
        end if;  -- Reset & Clock
      end if;  -- Reset & Clock
   end process;

---------------------------
-- Generate RCLK/8 counter
---------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         counter8_value <= "000";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            counter8_value <= "000";
	     else
            if (rclk_enb = '1') then
               if counter8_value = "111" then
                  counter8_value <= "000";
               else
                  counter8_value <= counter8_value +1;
               end if;
            end if;
         end if;
      end if;
   end process;

   process(counter8_value, rxbaud_ref)
   begin
      if (counter8_value = rxbaud_ref) then
         rxbaud_int <= '1';
      else
         rxbaud_int <= '0';
      end if;
   end process;

--------------------------------
-- Number of stop bits checking
--------------------------------
   lcreg3210 <= lcreg(3 downto 0);

   process(lcreg3210)
   begin
      case lcreg3210 is
         when "0000" =>  -- 1 STOP BIT  --> 
            frame_size <= "0111";       -- 5-bit, parity off
         when "1000" =>
            frame_size <= "1000";       -- 5-bit, parity on
         when "0001" =>
            frame_size <= "1000";       -- 6-bit, parity off
         when "1001" =>
            frame_size <= "1001";       -- 6-bit, parity on
         when "0010" =>
            frame_size <= "1001";       -- 7-bit, parity off
         when "1010" =>
            frame_size <= "1010";       -- 7-bit, parity on
         when "0011" =>
            frame_size <= "1010";       -- 8-bit, parity off
         when "1011" =>
            frame_size <= "1011";       -- 8-bit, parity on

         when "0100" =>  -- 2 STOP bits  -->
            frame_size <= "1000";       -- 5-bit, parity off
         when "1100" =>
            frame_size <= "1001";       -- 5-bit, parity on
         when "0101" =>
            frame_size <= "1001";       -- 6-bit, parity off
         when "1101" =>
            frame_size <= "1010";       -- 6-bit, parity on
         when "0110" =>
            frame_size <= "1010";       -- 7-bit, parity off
         when "1110" =>
            frame_size <= "1011";       -- 7-bit, parity on
         when "0111" =>
            frame_size <= "1011";       -- 8-bit, parity off
         when others =>
            frame_size <= "1100";       -- 8-bit, parity on
      end case;
   end process;

end rtl ;   -- rxblock

