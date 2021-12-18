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
--  File          : fifoctrl.vhd
--
--  Dependencies  : uart_fifo.vhd 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Fifo controller
--
--  Designer      : JU
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 30-May-2007
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

entity fifoctrl is
   generic(SYNC_RESET: INTEGER := 0);
   port ( clk           : in  std_logic;     -- System clock
          mr            : in  std_logic;     -- Master reset
          cs            : in  std_logic;     -- Chip Select
          rd            : in  std_logic;     -- Read Enable
          wr            : in  std_logic;     -- Write Enable
          rclk_enb      : in  std_logic;     -- Receiver Clock Enable
          write_rxfifo  : in  std_logic;     -- Write Receiver fifo enable
          read_txfifo   : in  std_logic;     -- Read Transmitter fifo enable
          wrthr_rdrbr   : in  std_logic;     -- Write THR or Read RBR
          wrfcr_rdiir   : in  std_logic;     -- Write FCR or Read IIR
          read_lsr      : in  std_logic;     -- Read Line Status Register enable
          d             : in  std_logic_vector(DATA_WIDTH-1 downto 0);   -- data bus input
          fcreg         : in  std_logic_vector(5 downto 0);              -- Fifo Control register
          rxf           : in  std_logic_vector(10 downto 0);             -- Receiver Fifo Data
          lsreg         : in  std_logic_vector(DATA_WIDTH-1 downto 0);   -- Line Status Register

          prevrdlsr     : out std_logic;     -- previous lsr read controller
          lsreg_b2      : out std_logic;     -- Line Status register bit 2
          lsreg_b3      : out std_logic;     -- Line Status register bit 3 
          lsreg_b4      : out std_logic;     -- Line Status register bit 4 
          lsreg_b7      : out std_logic;     -- Line Status register bit 7 
          txfifo_empty  : out std_logic;     -- Transmitter Fifo Empty Flag
          txfifo_2char  : out std_logic;     -- Transmitter Fifo has 2 characters
          txfifo_1char  : out std_logic;     -- Transmitter Fifo has 1 characters
          rxfifo_full   : out std_logic;     -- Receiver Fifo Full Flag
          rxfifo_empty  : out std_logic;     -- Receiver Fifo Empty Flag
          rxrdyn        : out std_logic;     -- Receiver Ready 
          txrdyn        : out std_logic;     -- Transmitter Ready 
          trig          : out std_logic_vector(3 downto 0);     -- 
          rxfifo_value  : out std_logic_vector(4 downto 0);     -- Receiver Fifo value
          rbreg         : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Receiver Buffer register
          threg         : out std_logic_vector(DATA_WIDTH-1 downto 0)   -- Transmitter Hold register
          );
end fifoctrl;

architecture rtl of fifoctrl is

   signal rxwr_addr        : std_logic_vector(3 downto 0);
   signal rxrd_addr        : std_logic_vector(3 downto 0);
   signal txwr_addr        : std_logic_vector(3 downto 0);
   signal txrd_addr        : std_logic_vector(3 downto 0);
   signal rxerr_fifo       : std_logic_vector(15 downto 0);
   signal rxerr_fifo_mask  : std_logic_vector(15 downto 0);
   signal txfifo_value     : std_logic_vector(4 downto 0);
   signal rxfifo_value_int : std_logic_vector(4 downto 0);
   signal trig_int         : std_logic_vector(3 downto 0);
   signal fcreg54          : std_logic_vector(1 downto 0);
   signal rbreg_rxf        : std_logic_vector(2 downto 0);
   signal txfifo_full      : std_logic;
   signal txrdyn_fifo      : std_logic;
   signal rxrdyn_fifo      : std_logic;
   signal rxfifo_wr        : std_logic;
   signal txfifo_empty_int : std_logic;
   signal rxfifo_full_int  : std_logic;
   signal rxfifo_empty_int : std_logic;
   signal fcreg0           : std_logic;
   signal lsreg5           : std_logic;
   signal lsreg0           : std_logic;
   signal lsreg1           : std_logic;
   signal prevrd_lsr       : std_logic;
   --signal prevrd_rbr       : std_logic;
   signal txfifo_halffull  : std_logic;
   signal rxfifo_halffull  : std_logic;
   signal txfifo_wr        : std_logic;
   signal rdlsr_reset_lsregb2 : std_logic;
   signal new_rdaddr       : std_logic_vector(3 downto 0); 
   signal rdlsr_reset_lsregb2_2  : std_logic;  
   
   signal rdlsr_reset_lsregb3 : std_logic;
   signal rdlsr_reset_lsregb4 : std_logic;
   signal areset              : std_logic;
   signal sreset              : std_logic;

   component uart_fifo
      generic (FIFOREG     : integer range 0 to 1 := 0);
      port ( clk           : in  std_logic; 
             wr            : in  std_logic;
             mr            : in  std_logic;
             reset_rxfifo  : in  std_logic;
             reset_txfifo  : in  std_logic;
             txfifo_wr     : in  std_logic;
             rxfifo_wr     : in  std_logic;
             d             : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             rxf           : in  std_logic_vector(10 downto 0);
             rxwr_addr     : in  std_logic_vector(3 downto 0);
             rxrd_addr     : in  std_logic_vector(3 downto 0);
             txwr_addr     : in  std_logic_vector(3 downto 0);
             txrd_addr     : in  std_logic_vector(3 downto 0);
             threg         : out std_logic_vector(DATA_WIDTH-1 downto 0);
             rbreg         : out std_logic_vector(DATA_WIDTH-1 downto 0);
             rbreg_rxf     : out std_logic_vector(2 downto 0)
             );
   end component;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';
   txfifo_empty <= txfifo_empty_int;
   rxfifo_full <= rxfifo_full_int;
   rxfifo_empty <= rxfifo_empty_int;
   rxfifo_value <= rxfifo_value_int;
   prevrdlsr <= prevrd_lsr;
   trig <= trig_int;

   fcreg0 <= fcreg(0);
   lsreg5 <= lsreg(5);
   lsreg0 <= lsreg(0);
   lsreg1 <= lsreg(1);

   rxfifo_wr <= '1' when (write_rxfifo = '1' and (rxfifo_full_int = '0' or fcreg0 = '0')) else '0';
   txfifo_wr <= '1' when (wrthr_rdrbr = '1' and txfifo_full = '0') else '0';

---------------------
-- Select TXRDY mode
---------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         txrdyn    <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            txrdyn    <= '0';
	     else
            if (fcreg0 = '0' or (fcreg0 = '1' and fcreg(3) = '0')) then       -- norm mode
               txrdyn <= not lsreg5;       -- THRE
            else
               txrdyn <= txrdyn_fifo;      -- mode1
            end if;
         end if;
      end if;
   end process;

--------------------------
-- Select RXRDY mode
--------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         rxrdyn   <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxrdyn   <= '1';
	     else
            if (fcreg0 = '0' or (fcreg0 = '1' and fcreg(3) = '0')) then       -- norm mode
               rxrdyn <= not lsreg0;       -- DR
            else
               rxrdyn <= rxrdyn_fifo;      -- mode1
            end if;
         end if;
      end if;
   end process;

-------------------------
-- Trigger level checking
-------------------------

   fcreg54 <= fcreg(5) & fcreg(4);

   process(fcreg54)
   begin
      case fcreg54 is
         when "00"   => trig_int <= "0001";
         when "01"   => trig_int <= "0100";
         when "10"   => trig_int <= "1000";
         when others => trig_int <= "1110";
      end case;
   end process;

   -------------------------------------------
   -- Receive Data Ready in Mode1
   -------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         rxrdyn_fifo <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxrdyn_fifo <= '1';
	     else
            if ((fcreg0 = '1' and fcreg(1) = '0' and rd = '1' and 
                wrthr_rdrbr = '1' and rxfifo_empty_int = '0' and
                rxfifo_value_int = "00001") or  -- no more characters in the FIFO
               -- changing the FIFO mode or reset Receiver FIFO will set RXRDYN
               (fcreg0 = '1' and fcreg(1) = '1' and rclk_enb = '1') or
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1')))) then
               rxrdyn_fifo <= '1';
            end if;
            if (rclk_enb = '1' and fcreg0 = '1' and fcreg(1) = '0' and 
                write_rxfifo = '1' and rxfifo_full_int = '0' and
                (rxfifo_value_int + 1 >= trig_int)) then 
               rxrdyn_fifo <= '0';
            end if;
         end if;
      end if;
   end process;

   -------------------------------------------
   -- Previous Read LSR and RBR Enables
   -------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         prevrd_lsr <= '0';
         --prevrd_rbr <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            prevrd_lsr <= '0';
	     else
            prevrd_lsr <= rd and read_lsr;
            --prevrd_rbr <= rd and wrthr_rdrbr;
         end if;
      end if;
   end process;


-----------------------------------------
-- the received data character have PE
-- In the fifo mode this PE is associated with the particular
-- character in the fifo it applies to. This error is revealed to the
-- CPU when its associated character is at the top of the fifo
-----------------------------------------

process(areset, clk)
	begin
		if (areset = '1') then
			rdlsr_reset_lsregb2_2 <= '0';
		elsif (clk'event and clk = '1') then
			if (sreset = '1') then
				rdlsr_reset_lsregb2_2 <= '0';
			else
				rdlsr_reset_lsregb2_2 <= rdlsr_reset_lsregb2; 
			end if;
		end if;
	end process;
	
 process(areset, clk)
   begin
      if (areset = '1') then
         lsreg_b2 <= '0';
         rdlsr_reset_lsregb2 <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_b2 <= '0';
            rdlsr_reset_lsregb2 <= '0';
	     else
            -- Detect PE error during data is shifted in
            -- to the first location of the FIFO (rxfifo_empty)
            if (write_rxfifo = '1' and lsreg(2) = '0' and rxf(0) = '1' and (fcreg0 = '0' or
               (rxfifo_empty_int = '1' and fcreg0 = '1' and fcreg(1) = '0'))) or
            -- When the error data is at the first location of the FIFO (rbreg_rxf)
               (fcreg0 = '1' and rxfifo_empty_int = '0' and lsreg(2) = '0' and
                rbreg_rxf(0) = '1' and rdlsr_reset_lsregb2 = '0') then
               lsreg_b2 <= '1';    -- set PE
               rdlsr_reset_lsregb2 <= '0';
            -- Reading LSR or 
            -- no error at the first location of the FIFO
            -- changing the FIFO mode or reset Receiver FIFO will reset PE
            elsif ((prevrd_lsr = '1' and (rd = '0' or cs = '0') and lsreg(2) = '1') or
               (rbreg_rxf(0) /= '1' and write_rxfifo = '0') or
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (rclk_enb = '1' and fcreg(1) = '1') or
		   	   (rxrd_addr /= new_rdaddr))
		   	   then
               lsreg_b2 <=  '0';   -- reset PE
               if (rxrd_addr /= new_rdaddr) then
      	  	   rdlsr_reset_lsregb2 <= '0';
               elsif (rbreg_rxf(0) = '1' ) then  -- reading LSR while rbreg_rxf(0)
		     rdlsr_reset_lsregb2 <= '1';
		   else
		      rdlsr_reset_lsregb2 <= '0';
	            end if;
            end if;
         end if;
      end if;
   end 	process;		
	

process(areset, clk)
	begin
		if (areset = '1') then
			new_rdaddr <= "0000";
		elsif (clk'event and clk = '1') then
			if (sreset = '1') then
				new_rdaddr <= "0000";
			else
				new_rdaddr <= rxrd_addr;
			end if;
		end if;
	end process;	
			
		
-----------------------------------------
-- the received data character have FE
-- In the fifo mode this FE is associated with the particular
-- character in the fifo it applies to. This error is revealed to the
-- CPU when its associated character is at the top of the fifo
-----------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         lsreg_b3 <= '0';
         rdlsr_reset_lsregb3 <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_b3 <= '0';
            rdlsr_reset_lsregb3 <= '0';
	     else
            -- Detect FE error during data is shifted in
            -- to the first location of the FIFO (rxfifo_empty)
            if (write_rxfifo = '1' and lsreg(3) = '0' and rxf(1) = '1' and (fcreg0 = '0' or
                (rxfifo_empty_int = '1' and fcreg0 = '1' and fcreg(1) = '0'))) or
            -- When the error data is at the first location of the FIFO (rbreg_rxf)
               (fcreg0 = '1' and rxfifo_empty_int = '0' and lsreg(3) = '0' and 
                rbreg_rxf(1) = '1' and rdlsr_reset_lsregb3 = '0') then
               lsreg_b3 <= '1';    -- set FE
               rdlsr_reset_lsregb3 <= '0';
            
            -- Reading LSR or 
            -- no error at the first location of the FIFO
            -- changing the FIFO mode or reset Receiver FIFO will reset FE
            elsif ((prevrd_lsr = '1' and (rd = '0' or cs = '0') and lsreg(3) = '1') or
                (rbreg_rxf(1) /= '1' and write_rxfifo = '0') or
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (rclk_enb = '1' and fcreg(1) = '1') or 
		   	   (rxrd_addr  /= new_rdaddr))
		   	   then
               lsreg_b3 <=  '0';   -- reset FE			
               if (rxrd_addr /= new_rdaddr) then
	           rdlsr_reset_lsregb3 <= '0';
               elsif (rbreg_rxf(1) = '1') then  -- reading LSR while rbreg_rxf(0)			
		   	   rdlsr_reset_lsregb3 <= '1';
	        else
		    rdlsr_reset_lsregb3 <= '0';
                end if;
             end if;			
         end if;		
      end if;
   end process;

-----------------------------------------
-- the received data character have BI
-- In the fifo mode this BI is associated with the particular
-- character in the fifo it applies to. This error is revealed to the
-- CPU when its associated character is at the top of the fifo
-----------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         lsreg_b4 <= '0';
         rdlsr_reset_lsregb4 <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_b4 <= '0';
            rdlsr_reset_lsregb4 <= '0';
	     else
            -- Detect BI error during data is shifted in
            -- to the first location of the FIFO (rxfifo_empty)
            if (write_rxfifo = '1' and lsreg(4) = '0' and rxf(2) = '1' and (fcreg0 = '0' or
               (rxfifo_empty_int = '1' and fcreg0 = '1' and fcreg(1) = '0'))) or
            -- When the error data is at the first location of the FIFO (rbreg_rxf)
               (fcreg0 = '1' and rxfifo_empty_int = '0' and lsreg(4) = '0' and
                rbreg_rxf(2) = '1' and rdlsr_reset_lsregb4 = '0') then
               lsreg_b4 <= '1';    -- set BI
               rdlsr_reset_lsregb4 <= '0';
            end if;
            -- Reading LSR or 
            -- no error at the first location of the FIFO
            -- changing the FIFO mode or reset Receiver FIFO will reset BI
            if ((prevrd_lsr = '1' and (rd = '0' or cs = '0') and lsreg(4) = '1') or
               (rbreg_rxf(2) /= '1' and write_rxfifo = '0') or
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (rclk_enb = '1' and fcreg(1) = '1')) then
               lsreg_b4 <=  '0';   -- reset BI
               end if;
	       if (rbreg_rxf(2) = '1') then  -- reading LSR while rbreg_rxf(2)
                  rdlsr_reset_lsregb4 <= '1';
               else
                  rdlsr_reset_lsregb4 <= '0';
               end if;
            end if;
         end if;
   end process;

--------------------------------
-- LSREG7 signal transmit logic
---------------------------------
   -- rxerr_fifo bit will be set if there is any error in the data in the RxFIFO
   -- It is reset when reading rbr
   process(areset, clk)
   begin
      if (areset = '1') then
         rxerr_fifo <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxerr_fifo <= (others => '0');
	     else
            -- writing data to the receiver fifo
            if (rclk_enb = '1' and write_rxfifo = '1' and rxfifo_full_int = '0') then
               rxerr_fifo(conv_integer(rxwr_addr)) <= (rxf(2) or rxf(1) or rxf(0));
            -- reading rbr
            elsif (fcreg0 = '1' and fcreg(1) = '0' and wrthr_rdrbr = '1' and
               rd = '1' and rxfifo_empty_int = '0') then
               rxerr_fifo(conv_integer(rxrd_addr)) <= '0';
            end if;
         end if;
      end if;
   end process;
 
   -- mask current reading address
   rxerr_fifo_mask <= "1111111111111110" when rxrd_addr = "0000" else
                      "1111111111111101" when rxrd_addr = "0001" else
                      "1111111111111011" when rxrd_addr = "0010" else
                      "1111111111110111" when rxrd_addr = "0011" else
                      "1111111111101111" when rxrd_addr = "0100" else
                      "1111111111011111" when rxrd_addr = "0101" else
                      "1111111110111111" when rxrd_addr = "0110" else
                      "1111111101111111" when rxrd_addr = "0111" else
                      "1111111011111111" when rxrd_addr = "1000" else
                      "1111110111111111" when rxrd_addr = "1001" else
                      "1111101111111111" when rxrd_addr = "1010" else
                      "1111011111111111" when rxrd_addr = "1011" else
                      "1110111111111111" when rxrd_addr = "1100" else
                      "1101111111111111" when rxrd_addr = "1101" else
                      "1011111111111111" when rxrd_addr = "1110" else
                      "0111111111111111" when rxrd_addr = "1111" else
                      "1111111111111111";

   process(areset, clk)
   begin 
      if (areset = '1') then
         lsreg_b7 <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            lsreg_b7 <= '0';
	     else
            -- sets LSREG(7) bit if there are any error in the data that's
            -- written to the FIFO
            if (write_rxfifo = '1' and (rxf(2) = '1' or rxf(1) = '1' or rxf(0) = '1') and
               rxfifo_full_int = '0' and lsreg(7) = '0' and fcreg0 = '1') then
               lsreg_b7 <= '1';
            -- Reading LSR and no more errors in the following data in the FIFO
            -- will clear lsreg_b7
            -- masking out the current data that has error
            end if;
	    if ((prevrd_lsr = '1' and (rd = '0' or cs = '0') and 
                lsreg(7) = '1' and  (rxerr_fifo and rxerr_fifo_mask) = "0000000000000000") or
               -- In 16450 mode, bit7 of LSR is cleared
                (fcreg0 = '0') or
               -- changing the FIFO mode or reset Receiver FIFO will reset
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (rclk_enb = '1' and fcreg(1) = '1')) then
               lsreg_b7 <= '0';     -- resetting
            end if;
         end if;
      end if;
   end process;


---------------------------------------
-- XMIT FIFO Ready Enable in Mode1
---------------------------------------
   process(areset,clk)
   begin
      if (areset = '1') then
         txrdyn_fifo <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            txrdyn_fifo <= '0';
	     else
            -- become inactive when the Xmit fifo is completely full
            if (fcreg0 = '1' and fcreg(2) = '0' and wrthr_rdrbr = '1' and wr = '1' and
               txfifo_full = '0' and txfifo_value = 15) then
               txrdyn_fifo <= '1';
            end if;
            -- there are no characters in the Xmit fifo, it will be active
            if (fcreg0 = '1' and fcreg(2) = '0' and read_txfifo = '1' and
               txfifo_empty_int = '0' and txfifo_value = 1) or
               -- changing the FIFO mode or reset Transceiver FIFO will set TXRDYn
               (fcreg0 = '1' and fcreg(2) = '1') or
               (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) then
               txrdyn_fifo <= '0';
            end if;
         end if;
      end if;
   end process;

----------------------------------------
-- Address pointer for RCVR FIFO write
-- Line status register bits 0 and 2 set
----------------------------------------
   RXFIFOwr : process(areset, clk)
   begin
      if (areset = '1') then
         rxwr_addr <= "0000";   --Resetting RCVR FIFO
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxwr_addr <= "0000";   --Resetting RCVR FIFO
	     else
            if (rclk_enb = '1') then
               if (fcreg0 = '1' and fcreg(1) = '0') and
                  (write_rxfifo = '1' and rxfifo_full_int = '0') then
                  if (rxwr_addr = "1111") then
                     rxwr_addr <= "0000";
                  else
                     rxwr_addr <= rxwr_addr + 1;
                  end if;
               end if;
               if (fcreg0 = '0') then
                  rxwr_addr <= "0000";
               end if;
            end if;
            -- changing the FIFO mode or reset Receiver FIFO will clear the FIFO
            if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (fcreg(1) = '1') then
               rxwr_addr <= "0000";
            end if;
         end if;
      end if;
   end process;

--------------------------------------
-- Address pointer for RCVR FIFO read 
--------------------------------------
   RXFIFOre : process(areset, clk)
   begin
      if (areset = '1') then
         rxrd_addr <= "0000";   --Resetting RCVR FIFO
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxrd_addr <= "0000";   --Resetting RCVR FIFO
	     else
           if (fcreg0 = '1' and fcreg(1) = '0' and wrthr_rdrbr = '1' and rd = '1' and
              rxfifo_empty_int = '0') then
              if (rxrd_addr = "1111") then
                 rxrd_addr <= "0000";
              else
                 rxrd_addr <= rxrd_addr + 1;
              end if;
           end if;
           -- changing the FIFO mode or reset Receiver FIFO will clear the FIFO
           if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
              (fcreg0 = '0' and d(0) = '1'))) or (fcreg(1) = '1') or (fcreg0 = '0') then
              rxrd_addr <= "0000";
           end if;
         end if;
      end if;
   end process;

---------------------------------------
-- Generate FIFO empty and full signals
---------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         rxfifo_halffull <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rxfifo_halffull <= '0';
	     else
            if (rxfifo_value_int > HALFFULLVALUE) then
               rxfifo_halffull <= '1';
            else
               rxfifo_halffull <= '0';
            end if;
            -- changing the FIFO mode or reset Receiver FIFO will clear the FIFO
            if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (fcreg(1) = '1') then
               rxfifo_halffull <= '0';
            end if;
         end if;
      end if;
   end process;

   process(rxwr_addr, rxrd_addr, rxfifo_halffull)
   begin
      if (rxwr_addr > rxrd_addr) then
         rxfifo_value_int <= '0' & (rxwr_addr - rxrd_addr);
      elsif (rxwr_addr = rxrd_addr) and (rxfifo_halffull = '0') then
         rxfifo_value_int <= "00000";
      else
         rxfifo_value_int <= (FIFOMAXVALUE - ('0' & rxrd_addr)) + ('0' & rxwr_addr);
      end if;
   end process;

   process(rxfifo_value_int, fcreg0, lsreg1)
   begin
      if (rxfifo_value_int = FIFOMAXVALUE and fcreg0 = '1') or (lsreg1 = '1' and fcreg0 = '0') then
         rxfifo_full_int <= '1';
      else
         rxfifo_full_int <= '0';
      end if;
   end process;
 
   process(rxfifo_value_int, fcreg0, lsreg0)
   begin
      if (rxfifo_value_int = "00000" and fcreg0 = '1') or (lsreg0 = '0' and fcreg0 = '0') then
         rxfifo_empty_int <= '1';
      else
         rxfifo_empty_int <= '0';
      end if;
   end process;


---------------------------------------
-- Address pointer for XMIT FIFO write
---------------------------------------
   TXFIFOwr : process(areset, clk)
   begin
      if (areset = '1') then
         txwr_addr <= "0000";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            txwr_addr <= "0000";
	     else
           if (fcreg0 = '1' and fcreg(2) = '0' and wrthr_rdrbr = '1' and wr = '1' and
              txfifo_full = '0') then
              if (txwr_addr = "1111") then
                 txwr_addr <= "0000";
              else
                 txwr_addr <= txwr_addr + 1;
              end if;
           end if;
           -- changing the FIFO mode or reset transceiver FIFO will clear the FIFO
           if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
              (fcreg0 = '0' and d(0) = '1'))) or (fcreg(2) = '1') or (fcreg0 = '0') then
              txwr_addr <= "0000";
           end if;
         end if;
      end if;
   end process;

-----------------------------------------
-- Address pointer for XMIT FIFO read
-----------------------------------------
   TXFIFOre : process(areset, clk)
   begin
      if (areset = '1') then
         txrd_addr <= "0000";
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            txrd_addr <= "0000";
	     else
           if (fcreg0 = '1' and fcreg(2) = '0') and
              (read_txfifo = '1' and txfifo_empty_int = '0') then
              if (txrd_addr = "1111") then
                  txrd_addr <= "0000";
              else
                  txrd_addr <= txrd_addr + 1;
              end if;
            end if;
            -- changing the FIFO mode or reset transceiver FIFO will clear the FIFO
            if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (fcreg(2) = '1') or (fcreg0 = '0') then
               txrd_addr <= "0000";
            end if;
         end if;
      end if;
   end process;

   process(areset, clk)
   begin
      if (areset = '1') then
         txfifo_halffull <= '0';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            txfifo_halffull <= '0';
	     else
            if (txfifo_value > HALFFULLVALUE) then
               txfifo_halffull <= '1';
            else
               txfifo_halffull <= '0';
            end if;
            -- changing the FIFO mode or reset Receiver FIFO will clear the FIFO
            if (wrfcr_rdiir = '1' and wr = '1' and ((fcreg0 = '1' and d(0) = '0') or
               (fcreg0 = '0' and d(0) = '1'))) or (fcreg(2) = '1') then
               txfifo_halffull <= '0';
            end if;
         end if;
      end if;
   end process;

   process(txwr_addr, txrd_addr, txfifo_halffull)
   begin
      if (txwr_addr > txrd_addr) then
         txfifo_value <= '0' & (txwr_addr - txrd_addr);
      elsif (txwr_addr = txrd_addr) and (txfifo_halffull = '0') then
         txfifo_value <= "00000";
      else
         txfifo_value <= (FIFOMAXVALUE - ('0' & txrd_addr)) + ('0' & txwr_addr);
      end if;
   end process;
 
   process(txfifo_value)
   begin
      if (txfifo_value = FIFOMAXVALUE) then
         txfifo_full <= '1';
      else
         txfifo_full <= '0';
      end if;
   end process;
 
   process(txfifo_value)
   begin
      if (txfifo_value = "00010") then
         txfifo_2char <= '1';
      else
         txfifo_2char <= '0';
      end if;
   end process;
 
   process(txfifo_value)
   begin
      if (txfifo_value = "00001") then
         txfifo_1char <= '1';
      else
         txfifo_1char <= '0';
      end if;
   end process;
 
   process(txfifo_value, fcreg0, lsreg5)
   begin
      if (txfifo_value = "00000" and fcreg0 = '1') or (lsreg5 = '1' and fcreg0 = '0') then
         txfifo_empty_int <= '1';
      else
         txfifo_empty_int <= '0';
      end if;
   end process;
 

-----------------------------------------------------
-- FIFO TYPE MAP (fifo_ram or fifo_reg)
-----------------------------------------------------
   u1 : uart_fifo
   generic map ( FIFOREG => 0)
   port map (
      clk           => clk,
      wr            => wr,
      mr            => mr,
      reset_rxfifo  => fcreg(1),
      reset_txfifo  => fcreg(2),
      txfifo_wr     => txfifo_wr,
      rxfifo_wr     => rxfifo_wr,
      d             => d,
      rxf           => rxf,
      rxwr_addr     => rxwr_addr,
      rxrd_addr     => rxrd_addr,
      txwr_addr     => txwr_addr,
      txrd_addr     => txrd_addr,
      threg         => threg,
      rbreg         => rbreg,
      rbreg_rxf     => rbreg_rxf);

end rtl;  -- fifoctrl                        
