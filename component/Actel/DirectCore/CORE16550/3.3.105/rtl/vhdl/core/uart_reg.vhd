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
--  File          : uart_reg.vhd
--
--  Dependencies  : none 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Core16550 registers
--
--  Designer      : JU
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
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

entity uart_reg is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk           : in  std_logic;  -- System Clock
          mr            : in  std_logic;  -- Master Reset
          cs            : in  std_logic;  -- Chip Select
          rd            : in  std_logic;  -- Read Enable
          wr            : in  std_logic;  -- Write Enable
          rclk_enb      : in  std_logic;  -- Receiver Clock Enable
          wrthr_rdrbr   : in  std_logic;  -- Write THR or read RBR enable
          write_dlr     : in  std_logic;  -- Write LSB divisor register enable
          write_dmr     : in  std_logic;  -- Write MSB divisor register enable
          ena_ier       : in  std_logic;  -- Interrupt Enable register enable
          ena_lcr       : in  std_logic;  -- Line control register enable
          ena_mcr       : in  std_logic;  -- Modem control register enable
          ena_sr        : in  std_logic;  -- Scratch pad register enable
          read_msr      : in  std_logic;  -- Read Modem status register enable
          wrfcr_rdiir   : in  std_logic;  -- Write FCR or read IIR enable
          prevrdlsr     : in  std_logic;  -- previous lsr read controller
          ctsn          : in  std_logic;  -- Clear To Send Enable
          dsrn          : in  std_logic;  -- Data Set Ready
          dcdn          : in  std_logic;  -- Data Carrier Detect
          rin           : in  std_logic;  -- Ring indicator
          sin           : in  std_logic;  -- Serial Input
          read_txfifo   : in  std_logic;  -- Read Transmitter fifo enable
          txfifo_empty  : in  std_logic;  -- Transmitter Fifo Empty Flag
          txfifo_1char  : in  std_logic;  -- Transmitter Fifo has 1 characters
          write_rxfifo  : in  std_logic;  -- Write Receiver fifo enable
          rxfifo_full   : in  std_logic;  -- Receiver Fifo Full Flag
          lsreg_b2      : in  std_logic;  -- Line Status register bit 2
          lsreg_b3      : in  std_logic;  -- Line Status register bit 3 
          lsreg_b4      : in  std_logic;  -- Line Status register bit 4 
          lsreg_b7      : in  std_logic;  -- Line Status register bit 7 
          temt          : in  std_logic;  -- Transmitter Fifo Empty
          sout_org      : in  std_logic;  -- Internal Serial output signal
          rxfifo_value  : in  std_logic_vector(4 downto 0);     -- Receiver Fifo value
          d             : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data input bus

          sin_org       : out std_logic;  -- Internal Serial input signal
          rtsn          : out std_logic;  -- Request To send
          dtrn          : out std_logic;  -- Data terminal ready
          out1n         : out std_logic;  -- Ouput 1
          out2n         : out std_logic;  -- Ouput 2
          sout          : out std_logic;  -- Serial output
          dmreg         : out std_logic_vector(DATA_WIDTH-1 downto 0); -- MSB divisor register
          dlreg         : out std_logic_vector(DATA_WIDTH-1 downto 0); -- LSB divisor register
          iereg         : out std_logic_vector(3 downto 0);            -- Interrupt Enable register
          lcreg         : out std_logic_vector(DATA_WIDTH-1 downto 0); -- Line control register
          lsreg         : out std_logic_vector(DATA_WIDTH-1 downto 0); -- Line status register
          mcreg         : out std_logic_vector(4 downto 0);            -- Modem control register
          msreg         : out std_logic_vector(DATA_WIDTH-1 downto 0); -- Modem status register
          fcreg         : out std_logic_vector(5 downto 0);            -- Fifo Control register
          sreg          : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Scratch pad register
          msrl          : in  std_logic_vector(3 downto 0);  -- msreg_latched
		  msrpres       : in  std_logic_vector(3 downto 0)   -- msreg shadow register

);
end uart_reg;

architecture rtl of uart_reg is

   signal cts_org, dsr_org, ri_org, dcd_org  : std_logic;
   signal prev_cts, prev_dsr, prev_ri, prev_dcd : std_logic;

   signal fcreg_int : std_logic_vector(5 downto 0);
   signal lsreg_int : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal mcreg_int : std_logic_vector(4 downto 0);
   signal reset_fcreg1 : std_logic;
   signal reset_fcreg2 : std_logic;
   signal read_msr_latched : std_logic; 
   signal areset : std_logic;
   signal sreset : std_logic;
   
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';

   fcreg   <= fcreg_int;
   mcreg   <= mcreg_int;
   lsreg   <= lsreg_int;

   lsreg_int(2) <= lsreg_b2;
   lsreg_int(3) <= lsreg_b3;
   lsreg_int(4) <= lsreg_b4;
   lsreg_int(6) <= temt;
   lsreg_int(7) <= lsreg_b7;

--------------------------
-- Local loopback feature
--------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         sout     <= '1';
         rtsn     <= '1';
         dtrn     <= '1';
         out1n    <= '1';
         out2n    <= '1';
         msreg(4) <= '0';
         msreg(5) <= '0';
         msreg(6) <= '0';
         msreg(7) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            sout     <= '1';
            rtsn     <= '1';
            dtrn     <= '1';
            out1n    <= '1';
            out2n    <= '1';
            msreg(4) <= '0';
            msreg(5) <= '0';
            msreg(6) <= '0';
            msreg(7) <= '0';
	     else
            if (mcreg_int(4) = '1') then        -- LOOP
               sout     <= '1';
               msreg(4) <= mcreg_int(1);
               msreg(5) <= mcreg_int(0);
               msreg(6) <= mcreg_int(2);
               msreg(7) <= mcreg_int(3);
               rtsn     <= '1';
               dtrn     <= '1';
               out1n    <= '1';
               out2n    <= '1';
            else
               sout     <= sout_org;
               msreg(4) <= not ctsn;
               msreg(5) <= not dsrn;
               msreg(6) <= not rin;
               msreg(7) <= not dcdn;
               rtsn     <= not mcreg_int(1);
               dtrn     <= not mcreg_int(0);
               out1n    <= not mcreg_int(2);
               out2n    <= not mcreg_int(3);
            end if;
         end if;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         sin_org <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            sin_org <= '1';
	     else
            if (mcreg_int(4) = '1') then        -- LOOP
               sin_org  <= sout_org;
            else
               sin_org  <= sin;
            end if;
         end if;
      end if;
   end process;

   process(mcreg_int, ctsn, dsrn, rin, dcdn)
   begin
      if (mcreg_int(4) = '1') then        -- LOOP
         dsr_org  <= not mcreg_int(0);
         cts_org  <= not mcreg_int(1);
         ri_org   <= not mcreg_int(2);
         dcd_org  <= not mcreg_int(3);
      else
         dsr_org  <= dsrn;
         cts_org  <= ctsn;
         ri_org   <= rin;
         dcd_org  <= dcdn;
      end if;
   end process;

-----------------------------
-- Interrupt enable register
-----------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         iereg <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            iereg <= (others => '0');
	     else
            if (ena_ier = '1' and wr = '1') then
               iereg <= d(3 downto 0);
            end if;
         end if;
      end if;
   end process;

-------------------------
-- Line control register
-------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         lcreg <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lcreg <= (others => '0');
	     else
           if (ena_lcr = '1' and wr = '1') then
              lcreg <= d;
           end if;
         end if;
      end if;
   end process;

----------------------------------
-- Line Status Bit 0 - Data Ready
----------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         lsreg_int(0) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_int(0) <= '0';
	     else
            -- read all Receiver buffer reg or fifo data or reset the receiver fifo register will
            -- or changing the FIFO mode will reset the DR 
            if (wrthr_rdrbr = '1' and rd = '1' and (rxfifo_value = "00001" or fcreg_int(0) = '0')) or
               (rclk_enb = '1' and fcreg_int(1) = '1') or (wrfcr_rdiir = '1' and wr = '1' and 
               ((fcreg_int(0) = '1' and d(0) = '0') or (fcreg_int(0) = '0' and d(0) = '1'))) then
               lsreg_int(0) <= '0';
            end if;
            -- Data is transferred into the Receiver buffer reg or the FIFO will set the DR
            if (rclk_enb = '1' and fcreg_int(1) = '0' and write_rxfifo = '1' and
               ((fcreg_int(0) = '1' and rxfifo_full = '0') or (fcreg_int(0) = '0'))) then
               lsreg_int(0) <= '1'; 
            end if;
         end if;
      end if;
   end process;

----------------------------------------
-- LINE STATUS register bit 1
----------------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         lsreg_int(1) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_int(1) <= '0';
	     else
            if (prevrdlsr = '1' and (rd = '0' or cs = '0') and fcreg_int(1) = '0') or
               -- changing the FIFO mode or reset Receiver FIFO will reset OE
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg_int(0) = '1' and d(0) = '0') or
               (fcreg_int(0) = '0' and d(0) = '1'))) or (rclk_enb = '1' and fcreg_int(1) = '1') then
               lsreg_int(1) <= '0';
            end if;
            if (write_rxfifo = '1' and ((rxfifo_full = '1') or
               (lsreg_int(0) = '1' and fcreg_int(0) = '0'))) then 
               lsreg_int(1) <= '1';
            end if;
         end if;
      end if;
   end process;

----------------------------------------
-- LINE STATUS register bit 5 
----------------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         lsreg_int(5) <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_int(5) <= '1';
	     else
            if (wrthr_rdrbr = '1' and wr = '1') then
               lsreg_int(5) <= '0';
            end if;
            if ((read_txfifo = '1' and (fcreg_int(0) = '0' or
                (fcreg_int(0) = '1' and txfifo_empty = '0' and txfifo_1char = '1'))) or
               -- changing the FIFO mode or reset Trasnceiver FIFO will clear FIFO
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg_int(0) = '1' and d(0) = '0') or
               (fcreg_int(0) = '0' and d(0) = '1'))) or (fcreg_int(2) = '1')) then
               lsreg_int(5) <= '1';
            end if;
         end if;
      end if;
   end process;

------------------------------
-- MODEM control register
------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         mcreg_int <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            mcreg_int <= (others => '0');
	     else
            if (ena_mcr = '1' and wr = '1') then
               mcreg_int <= d(4 downto 0);
            end if;
         end if;
      end if;
   end process;

--------------------
-- Scratch register
--------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         sreg <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            sreg <= (others => '0');
	     else
            if (ena_sr = '1' and wr = '1') then
               sreg <= d;
            end if;
         end if;
      end if;
   end process;

------------------------------
-- Divisor latch LSB register
------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         dlreg <= "00000001";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            dlreg <= "00000001";
	     else
            if (write_dlr = '1' and wr = '1') then
               dlreg <= d;
            end if;
         end if;
      end if;
   end process;

------------------------------
-- Divisor latch MSB register
------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         dmreg <= "00000000";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            dmreg <= "00000000";
	     else
            if (write_dmr = '1' and wr = '1') then
               dmreg <= d;
            end if;
         end if;
      end if;
   end process;


-------------------------
-- FIFO control register
-------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         fcreg_int(5 downto 0) <= "000001";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            fcreg_int(5 downto 0) <= "000001";
	     else
            if (wrfcr_rdiir = '1' and wr = '1') then
               if (d(0) = '1') then
                  fcreg_int(5 downto 4) <= d(7 downto 6);
                  fcreg_int(3 downto 0) <= d(3 downto 0);
               else
                  fcreg_int(5 downto 0) <= "000000";
               end if;
            end if;
            if (reset_fcreg1 = '1' and fcreg_int(1) = '1') then
               fcreg_int(1) <= '0';
            end if;
            if (reset_fcreg2 = '1' and fcreg_int(2) = '1') then
               fcreg_int(2) <= '0';
            end if;
         end if;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         reset_fcreg1 <= '0';
         reset_fcreg2 <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            reset_fcreg1 <= '0';
            reset_fcreg2 <= '0';
	     else
            reset_fcreg1 <= '0';
            reset_fcreg2 <= '0';
            if (rclk_enb = '1' and fcreg_int(1) = '1') then
               reset_fcreg1 <= '1';
            end if;
            if (fcreg_int(2) = '1') then
               reset_fcreg2 <= '1';
            end if;
         end if;
      end if;
   end process;

   process(clk)
   begin
     -- if (mr = '1') then
     --    prev_dsr <= '1';
     --    prev_cts <= '1';
     --    prev_ri  <= '1';
     --    prev_dcd <= '1';
      if (clk'event and clk = '1') then
         prev_dsr <= dsr_org;
         prev_cts <= cts_org;
         prev_ri  <= ri_org;
         prev_dcd <= dcd_org;
      end if;
   end process;

  ---------------------------------
--  msr_read sync
---------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         read_msr_latched <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            read_msr_latched <= '0';
	     else
            read_msr_latched <= read_msr;
         end if;
      end if;
   end process;   
---------------------------------
-- Indicate change in CTS signal
---------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         msreg(0) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            msreg(0) <= '0';
	     else
            if (cts_org = '1' and prev_cts = '0') or
               (cts_org = '0' and prev_cts = '1') then
               msreg(0) <= '1';
            elsif (read_msr_latched = '1' and (msrl(0) = msrpres(0))) then
               msreg(0) <= '0';
            end if;
         end if;
      end if;
   end process;

---------------------------------
-- Indicate change in DSR signal
---------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         msreg(1) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            msreg(1) <= '0';
	     else
            if (dsr_org = '1' and prev_dsr = '0') or
               (dsr_org = '0' and prev_dsr = '1') then
               msreg(1) <= '1';
            elsif (read_msr_latched = '1' and (msrl(1) = msrpres(1))) then
               msreg(1) <= '0';
            end if;
         end if;
      end if;
   end process;

---------------------------------
-- Indicate change in DCD signal
---------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         msreg(3) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            msreg(3) <= '0';
	     else
            if (dcd_org = '1' and prev_dcd = '0') or
               (dcd_org = '0' and prev_dcd = '1') then
               msreg(3) <= '1';
            elsif (read_msr_latched = '1' and (msrl(3) = msrpres(3))) then
               msreg(3) <= '0';
            end if;
         end if;
      end if;
   end process;

-------------------------------------
-- Indicate rising edge in RI signal
-------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         msreg(2) <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            msreg(2) <= '0';
	     else
            if (ri_org = '1' and prev_ri = '0') then
               msreg(2) <= '1';
            elsif (read_msr_latched = '1' and (msrl(2) = msrpres(2))) then
               msreg(2) <= '0';
            end if;
         end if;
      end if;
   end process;

end rtl;  -- uart_reg

