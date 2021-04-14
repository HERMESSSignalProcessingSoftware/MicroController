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
--  File          : rwcontrol.vhd
--
--  Dependencies  : none
--
--  Model Type    : Synthesizable Core
--
--  Description   : Core16550 rwcontrol
--
--  Designer      : JU
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 4-Dec-2006
--
--  Version       : 1H20N00S00
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

entity rwcontrol is
   generic(SYNC_RESET: INTEGER := 0);
   port ( cs          : in  std_logic;   -- Latched Chip Select
          rd          : in  std_logic;   -- Read Enable
          mr          : in  std_logic;   -- Master Reset
          clk         : in  std_logic;   -- System Clock
          fcreg0      : in  std_logic;   -- Fifo Control Register bit0
          a           : in  std_logic_vector(ADDR_WIDTH-1 downto 0); -- Latched address
          rbreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Receiver buffer register
          dmreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- MSB divisor register
          dlreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- LSB divisor register
          iereg       : in  std_logic_vector(3 downto 0);   -- Interrupt enable register
          iireg       : in  std_logic_vector(3 downto 0);   -- Interrupt Status register
          lcreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Line control register
          lsreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Line status register
          mcreg       : in  std_logic_vector(4 downto 0);             -- Modem control register
          msreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Modem status register
          sreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Scratch pad register

          ena_ier     : out std_logic;   -- Interrupt Enable register enable
          ena_lcr     : out std_logic;   -- Line control register enable
          ena_mcr     : out std_logic;   -- Modem control register enable
          ena_sr      : out std_logic;   -- Scratch pad register enable
          read_msr    : out std_logic;   -- Read Modem status register enable
          wrfcr_rdiir : out std_logic;   -- Write FCR or Read IIR enable
          read_lsr    : out std_logic;   -- Read line status register enable
          wrthr_rdrbr : out std_logic;   -- Write THR or Read RBR enable
          write_dlr   : out std_logic;   -- Write LSB divisor register enable
          write_dmr   : out std_logic;   -- Write MSB divisor register enable
          ddis        : out std_logic;   -- Data bus driver disable
          d           : out std_logic_vector(DATA_WIDTH-1 downto 0); -- Synchronous Data Output Bus
          msrl        : out std_logic_vector(3 downto 0); -- msreg latched
		  msrpres     : out std_logic_vector(3 downto 0) -- msreg latched
          );
end rwcontrol;

architecture rtl of rwcontrol is

   signal lcreg7        : std_logic;
   signal lcreg_a       : std_logic_vector(3 downto 0);
   signal d_out_000     : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal d_out_001     : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal dmux_out      : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal rbreg_latched : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal msreg_latched : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal areset              : std_logic;
   signal sreset              : std_logic;
begin
   areset <= '0' when (SYNC_RESET=1) else mr;
   sreset <= mr when (SYNC_RESET=1) else '0';

   lcreg7 <= lcreg(7);

-----------------------------------------
-- Select the register when CPU reads it
-----------------------------------------
   process (a, d_out_000, d_out_001, iireg, lcreg, mcreg, msreg_latched, sreg, lsreg, fcreg0)
   begin
      case a is
         when "000"  => dmux_out <= d_out_000;   -- Receiver buffer register or LSB of Divisor Latch
         when "001"  => dmux_out <= d_out_001;   -- Interrupt enable register or MSB of Divisor Latch
         when "010"  => dmux_out <= (fcreg0 & fcreg0 & "00" & iireg);  -- Interrupt status register
         when "011"  => dmux_out <= lcreg;       -- Line control register
         when "100"  => dmux_out <= ("000" & mcreg);   -- Modem control register
         when "101"  => dmux_out <= lsreg;       -- Line status register
         when "110"  => dmux_out <= msreg_latched;       -- Modem status register
         when others => dmux_out <= sreg;        -- Scratch register
      end case;
   end process;

   lcreg_a <= (lcreg7 & a);

--------------------------------------------------
-- Asynchronous Output Data 
--------------------------------------------------
   d <= dmux_out;
   msrl(3 downto 0) <= msreg_latched(3 downto 0);
   
 ---------------------------------
-- Shadow MSR Register
---------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         msrpres(3 downto 0) <= "0000";  
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            msrpres(3 downto 0) <= "0000";  
	     else
            msrpres(3 downto 0) <= msreg(3 downto 0);
         end if;
      end if;
   end process;
---------------------------------------------------
-- Select RBREG IEREG DLREG or DMREG to output MUX
---------------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         rbreg_latched <= (others => '0');
		 msreg_latched <= (others => '0');
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            rbreg_latched <= (others => '0');
		    msreg_latched <= (others => '0');
	     else
            if (rd = '0' or cs = '0') then
               rbreg_latched <= rbreg;
		   	   msreg_latched <= msreg;
            end if;
         end if;
      end if;
   end process;
  

   process(lcreg7, rbreg_latched, dlreg)
   begin
      if (lcreg7 = '0') then
         d_out_000 <= rbreg_latched;    -- Receive buffer register from RCVR FIFO
      else
         d_out_000 <= dlreg;            -- divisor (latch) LSB register
      end if;
   end process;

   process(lcreg7, iereg, dmreg)
   begin
      if (lcreg7 = '0') then
         d_out_001 <= ("0000" & iereg); -- Interrupt enable register
      else
         d_out_001 <= dmreg;            -- divisor (latch) MSB register
      end if;
   end process;

-----------------------------------------------------
-- Generate enable signals when writing to registers
-----------------------------------------------------
   process (cs, lcreg_a)
   begin
      wrthr_rdrbr<= '0';
      write_dlr  <= '0';
      write_dmr  <= '0';
      ena_ier    <= '0';
      ena_lcr    <= '0';
      ena_mcr    <= '0';
      ena_sr     <= '0';
      read_msr   <= '0';
      read_lsr   <= '0';
      wrfcr_rdiir<= '0';
      if (cs = '1') then                -- WRITE operation
         case lcreg_a is
            when "0000"        => wrthr_rdrbr <= '1';      -- THR (write) or RBR (read)
            when "0001"        => ena_ier     <= '1';      -- Interrupt enable register
            when "1000"        => write_dlr   <= '1';      -- divisor (latch) LSB register
            when "1001"        => write_dmr   <= '1';      -- divisor (latch) MSB register
            when "0010"|"1010" => wrfcr_rdiir <= '1';      -- FCR (write) or IIR (read)
            when "0011"|"1011" => ena_lcr     <= '1';      -- Line control register   
            when "0100"|"1100" => ena_mcr     <= '1';      -- MODEM control register   
            when "0101"|"1101" => read_lsr    <= '1';      -- Line Status register   
            when "0110"|"1110" => read_msr    <= '1';      -- MODEM STATUS register   
            when others        => ena_sr      <= '1';      -- "0111"|"1111" Scratch register   
         end case;
      end if;
   end process;

--------------------------------------------------
-- Synchronize Output Data 
--------------------------------------------------
   process(areset, clk)
   begin
      if (areset = '1') then
         ddis <= '1';
      elsif (clk'event and clk = '1') then
         if (sreset = '1') then
            ddis <= '1';
	     else
            if (cs = '1') then
               ddis <= not(rd);
            else
               ddis <= '1';
            end if;
         end if;
      end if;
   end process;

end rtl;


