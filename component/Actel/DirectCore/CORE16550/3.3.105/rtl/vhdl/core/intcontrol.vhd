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
--  File          : intcontrol.vhd
--
--  Dependencies  : none 
--
--  Model Type    : Synthesizable Core
--
--  Description   : interrupt controller
--
--  Designer      : JV
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 23-January-2007
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

entity intcontrol is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk           : in  std_logic;   -- System Clock
          cs            : in  std_logic;   -- Chip Select
          rd            : in  std_logic;   -- Read Enable
          wr            : in  std_logic;   -- Write Enable
          mr            : in  std_logic;   -- Master Reset
          rclk_enb      : in  std_logic;   -- Receiver Clock enable
          d0            : in  std_logic;   -- data input bit0
          d1            : in  std_logic;   -- data input bit1
          rxbaud        : in  std_logic;
          rxfifo_empty  : in  std_logic;   -- Receiver Empty Full Flag
          txfifo_empty  : in  std_logic;   -- Transmitter Fifo Empty flag
          write_rxfifo  : in  std_logic;   -- Write Receiver fifo enable
          read_txfifo   : in  std_logic;   -- Read Transceiver fifo enable
          wrfcr_rdiir   : in  std_logic;   -- Read Interrupt Status Register Enable
          ena_ier       : in  std_logic;   -- Interrupt Enable register enable
          wrthr_rdrbr   : in  std_logic;   -- Write THR or Read RBR enable
          fcreg0        : in  std_logic;
          fcreg1        : in  std_logic;
          fcreg2        : in  std_logic;
          rxfifo_full   : in  std_logic;   -- Receiver Fifo Full Flag
          txfifo_2char  : in  std_logic;  -- Transmitter fifo has 2 chars
          stop_state    : in  std_logic;
          lsreg         : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Line status register
          msreg         : in  std_logic_vector(3 downto 0);     -- Modem status register
          iereg         : in  std_logic_vector(3 downto 0);     -- Interrupt Enable register
          frame_size    : in  std_logic_vector(3 downto 0);     -- 
          rxfifo_value  : in  std_logic_vector(4 downto 0);     -- 
          trig          : in  std_logic_vector(3 downto 0);     -- 

          intr          : out std_logic;   -- Interrupt
          iireg         : out std_logic_vector(3 downto 0)  -- Interrupt Status register
          );
end intcontrol;

architecture rtl of intcontrol is

   signal interrupt0  : std_logic;
   signal interrupt2  : std_logic;
   signal interrupt3  : std_logic;
   signal interrupt1  : std_logic;
   signal interrupt1f : std_logic;

   signal toint  : std_logic;
   signal topre  : std_logic;
   signal rbrint : std_logic;
   signal thrint : std_logic;
   signal tx_2char_event : std_logic;
   signal stop_bit_tx_rupt : std_logic;
   signal delay_read_txfifo : std_logic;
   signal frame_counter0 : std_logic_vector(4 downto 0);
   signal frame_counter1 : std_logic_vector(1 downto 0);
   signal iireg_net :  std_logic_vector(3 downto 0)  ;
   signal areset : std_logic;
   signal sreset : std_logic;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';

   iireg <= iireg_net;

-------------------------------------------
-- Generate receiver line status interrupt 
-------------------------------------------
   process(lsreg, iereg)
   begin  -- OE              PE              FE              BI
      if ((lsreg(1) = '1' or lsreg(2) = '1' or lsreg(3) = '1' or lsreg(4) = '1') and
          iereg(2) = '1') then
         interrupt0 <= '1';
      else
         interrupt0 <= '0';
      end if;
   end process;

-----------------------------------------------------------------------
-- Generate Recieved Data Available  or Trigger Level Reached interrupt 
-----------------------------------------------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
        rbrint <= '0';
      elsif (clk'event and clk = '1') then
        if (sreset = '1') then
          rbrint <= '0';
	    else
          if (wrthr_rdrbr = '1' and rd = '1' and ((fcreg0 = '1' and (rxfifo_value <= trig)) or
             (fcreg0 = '0'))) or
             -- changing the FIFO mode or reset Receiver FIFO will reset rbrint
             (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '0' and d0 = '1') or
              (fcreg0 = '1' and d0 = '0'))) or (fcreg1 = '1' and fcreg0 = '1') then
             rbrint <= '0';
          elsif (rclk_enb = '1' and fcreg1 = '0' and write_rxfifo = '1' and
              ((fcreg0 = '1' and rxfifo_full = '0' and (rxfifo_value + 1 >= trig)) or
              (fcreg0 = '0'))) then
             rbrint <= '1';
          end if;
        end if;
      end if;
   end process;

-------------------------------------
-- Generate Timeout interrupt 
-------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         frame_counter0 <= "00000";
         frame_counter1 <= "00";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            frame_counter0 <= "00000";
            frame_counter1 <= "00";
	     else
            if (rclk_enb = '1' and rxbaud = '1' and rxfifo_empty = '0') then
               if (topre = '0') then
                  frame_counter0 <= "00000";
                  frame_counter1 <= "00";
               elsif (frame_counter0 < (frame_size & '0')) then
                  frame_counter0 <= frame_counter0 + 1;
               else 
                  frame_counter0 <= "00000";
                  if (frame_counter1 < 3) then
                     frame_counter1 <= frame_counter1 + 1;
                  else
                     frame_counter1 <= "00";
                  end if;
               end if;
            end if;
         end if;
      end if;
   end process;

   process(areset,clk)
   begin
      if (areset = '1') then
         topre <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            topre <= '0';
	     else
            if (wrthr_rdrbr = '1' and rd = '1') or (rclk_enb = '1' and write_rxfifo = '1') or
              -- changing the FIFO mode or reset Receiver FIFO will reset toint
              ((wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '0' and d0 = '1') or
               (fcreg0 = '1' and d0 = '0'))) or (fcreg1 = '1' and fcreg0 = '1')) then
               topre <= '0';
            end if;
            if (rclk_enb = '1' and rxbaud = '1' and rxfifo_empty = '0' and fcreg1 = '0') then
               topre <= '1';
            end if;
          end if;
       end if;
   end process;

   -- TimeOut Interrupt
   process(areset,clk)
   begin
      if (areset = '1') then
         toint <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            toint <= '0';
	     else
            -- Reading the Receiver Buffer reg to reset the timeout interrupt
            if (wrthr_rdrbr = '1' and rd = '1') or
              -- changing the FIFO mode or reset Receiver FIFO will reset toint
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '0' and d0 = '1') or
               (fcreg0 = '1' and d0 = '0'))) or (fcreg1 = '1' and fcreg0 = '1') then
               toint <= '0';
            end if;
            if (rclk_enb = '1' and rxbaud = '1' and rxfifo_empty = '0') then  
               if (topre = '1' and (frame_counter0 = (frame_size & '0')) and 
                  (frame_counter1 = 3)) then
                  toint <= '1';
               end if;
            end if;
         end if;
      end if;
   end process;

------------------------------------------------------------------------
-- Generate Recieved Data Available  or Trigger Level Reached interrupt 
-- Generate Timeout interrupt 
------------------------------------------------------------------------
   process(rbrint, toint, iereg)
   begin
      if (rbrint= '1' and iereg(0) = '1') then
         interrupt1 <= '1';
      else
         interrupt1 <= '0';
      end if;
      if (toint = '1' and iereg(0) = '1') then
         interrupt1f <= '1';
      else
         interrupt1f <= '0';
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         delay_read_txfifo <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            delay_read_txfifo <= '0';
	     else
            delay_read_txfifo <= read_txfifo;
         end if;
      end if;
   end process;

---------------------------------------------------------
-- Generate Transmitter Holding Register Empty interrupt 
---------------------------------------------------------
-- For fifo mode, the transmitter FIFO empty indications will be delayed 1 character time
-- minus the last stop bit time whenever the following occurs: THRE = 1 and
-- there have not been at least 2 bytes at the same time in the transmit FIFO, since
-- the last THRE = 1
-- If only one character is loaded to fifo, the interrupt occurs at the end of
-- the character
---------------------------------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         thrint <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            thrint <= '1';
	     else
            -- reading IIR reg or writing to the Xmit Holding reg will reset the interrupt 
            -- NJS Change via Microsemi July 17, 2004
            if (wrfcr_rdiir = '1' and iireg_net = "0010" and rd = '1') or 
               (wrthr_rdrbr = '1' and wr = '1') or
            -- changing FIFO mode to 16450 will reset THRE 
               (wrfcr_rdiir = '1' and wr = '1' and fcreg0 = '1' and d0 = '0') then
               thrint <= '0';
            end if;
            -- changing FIFO mode to 16550 or reset Trasnceiver Fifo will cause THRE 
            if ((wrfcr_rdiir = '1' and wr = '1' and fcreg0 = '0' and d0 = '1') or
                (rclk_enb = '1' and fcreg0 = '1' and fcreg2 = '1') or
                -- enable the interrupt in the middle of THRE (lsreg5 active)
               (ena_ier = '1' and wr = '1' and d1 = '1' and lsreg(5) = '1') or
               (delay_read_txfifo = '1' and txfifo_empty = '1' and 
               (tx_2char_event = '1' or fcreg0 = '0')) or
               (stop_state = '1' and txfifo_empty = '1' and stop_bit_tx_rupt = '1')) then
               thrint <= '1';
            end if;
         end if;
      end if;
   end process;

   process(clk, areset)
   begin
      if (areset = '1') then
         tx_2char_event <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            tx_2char_event <= '0';
	     else
            if (txfifo_2char = '1' and lsreg(5) = '0') then
               tx_2char_event <= '1';
            elsif (lsreg(5) = '1') then   -- THRE=1
               tx_2char_event <= '0';
            end if;
         end if;
      end if;
   end process;

   process(clk, areset)
   begin
      if (areset = '1') then
         stop_bit_tx_rupt <= '0' ;
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            stop_bit_tx_rupt <= '0' ;
	     else
             if (delay_read_txfifo = '1' and thrint = '0' and txfifo_empty = '1') and
                (tx_2char_event = '0' and fcreg0 = '1') then
                stop_bit_tx_rupt <= '1' ;
             elsif (stop_state = '1' and thrint = '0' and txfifo_empty = '1' and
                stop_bit_tx_rupt = '1') or (stop_state = '1' and stop_bit_tx_rupt = '1') then
                stop_bit_tx_rupt <= '0' ;
             end if;
          end if;
       end if;
   end process;

   process(thrint, iereg)
   begin
      if (thrint = '1' and iereg(1) = '1') then
         interrupt2 <= '1';
      else
         interrupt2 <= '0';
      end if;
   end process;

-------------------------------------------
-- Generate receiver line status interrupt
-------------------------------------------
   process(msreg, iereg)
   begin  -- CTS            DSR              RI              DCD
      if ((msreg(0) = '1' or msreg(1) = '1' or msreg(2) = '1' or msreg(3) = '1') and
          iereg(3) = '1') then
         interrupt3 <= '1';
      else
         interrupt3 <= '0';
      end if;
   end process;

-------------------------------------
-- Generate interrupts and priorities
-------------------------------------
   --process(interrupt0, interrupt1, interrupt1f, interrupt2, interrupt3)
   process(areset, clk)
   begin
      if (areset = '1') then
         intr <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            intr <= '0';
	     else
           if (interrupt0 = '1' or interrupt1 = '1' or interrupt1f = '1' or
               interrupt2 = '1' or interrupt3 = '1') then
              intr <= '1';
           else
              intr <= '0';
           end if;
         end if;
      end if;
   end process;

   -- If we have sync. iireg_net, the data of iireg_net is not valid when sync. read iireg_net
   process(areset, clk)
   begin
      if (areset = '1') then
         iireg_net <= "0001";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            iireg_net <= "0001";
	     else
            if (rd = '0' or cs = '0') then
               if (interrupt0 = '1') then                 -- highest
                  iireg_net <= "0110";
               elsif (interrupt1 = '1') then              -- 2.
                  iireg_net <= "0100";
               elsif (interrupt1f = '1') then             -- 2.
                  iireg_net <= "1100";
               elsif (interrupt2 = '1') then              -- 3.
                  iireg_net <= "0010";
               elsif (interrupt3 = '1') then              -- 4.
                  iireg_net <= "0000";
               else
                  iireg_net <= "0001";
               end if;
            end if;
         end if;
      end if;
   end process;

end rtl ;   -- intcont

