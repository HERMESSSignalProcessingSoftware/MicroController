-- Actel Corporation Proprietary and Confidential
--  Copyright 2008 Actel Corporation.  All rights reserved.
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--  Revision Information:
-- Jun09    Revision 4.1
-- Aug10    Revision 4.2
-- SVN Revision Information:
-- SVN $Revision: 8508 $
-- SVN $Date: 2009-06-15 16:49:49 -0700 (Mon, 15 Jun 2009) $
library ieee;
use ieee.STD_LOgic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_RX_ASYNC is
generic (sync_reset: integer := 0;
Rx_fifo: integer := 0); port (clk: in std_logic;
CUARTo: in STD_LOGIC;
reset_n: in std_logic;
bit8: in STD_LOGIC;
PARITY_EN: in std_logic;
ODd_n_even: in std_LOGIC;
CUARTi1l: in std_logic;
CUARTl0i: in std_LOGIC;
CUARTlo0: in STD_LOGIC;
RX: in std_logic;
OVErflow: out std_loGIC;
parity_err: out STD_logic;
CUARTi01: out std_lOGIC;
CUARTo11: out STD_LOGIC;
CUARTOO0: out std_logic;
CUARTio0: out STD_LOGIC;
CUARTI0I: out std_logic;
CUARTlil: out std_LOGIC;
CUARTLOI: out STD_LOGIC_VECTOR(7 downto 0);
CUARTo0l: out stD_LOGIC);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_Rx_async;

architecture CUARTLOL of CoreUARTapb_C0_CoreUARTapb_C0_0_Rx_async is

type CUARTol0i is (CUARTil0,CUARTLL0i,CUARTil0i,CUARTOI0I);

signal CUARTo01: CUARTol0i;

signal CUARTLI0I: STD_LOGIC_VECTOR(3 downto 0);

signal CUARTII0I: STD_LOGIC;

signal CUARTo00i: std_logic_vector(8 downto 0);

signal CUARTL00I: STD_LOGIC;

signal CUARTI00I: std_logic_vector(3 downto 0);

signal CUARTO10I: STD_LOGIC;

signal CUARTL10I: sTD_LOGIC_VECTOR(2 downto 0);

signal CUARTi10i: STD_Logic;

signal CUARToo1i: std_logic_vector(1 downto 0);

signal CUARTlo1i: STD_LOGIC_VECTOR(1 downto 0);

signal CUARTIO1I: std_logic_vectOR(3 downto 0);

signal CUARTOL1I: std_logiC;

signal CUARTLL1I: STD_LOGIC;

signal CUARTIL1I: std_logic;

signal CUARTOI1I: std_logic;

signal CUARTli1I: std_logic;

signal CUARTii1i: std_logic;

signal CUARTO01i: sTD_LOGIC;

signal CUARTL01i: STD_LOGIC;

signal CUARTI01I: std_logic_vECTOR(7 downto 0);

signal CUARTo11I: std_logic_vector(1 downto 0);

signal CUARTl11i: STD_LOgic;

signal CUARTii: STD_LOGIC;

signal CUARTo0: STD_LOGIC;

begin
CUARTii <= '1' when (sync_reset = 1) else
reset_n;
CUARTO0 <= reset_n when (sync_reset = 1) else
'1';
CUARTOO0 <= CUARTLI1I;
CUARTi01 <= CUARTil1i;
overflow <= CUARTOL1I;
PARITY_ERR <= CUARTll1i;
CUARTi0i <= CUARTII1I;
CUARTLIL <= CUARTl01i;
CUARTLOI <= CUARTI01I;
CUARTo0l <= CUARTl11i;
CUARTo11 <= '1' when (CUARTo01 = CUARTil0) else
'0';
CUARTio0 <= CUARTO01i;
CUARTo11i <= BIT8&PARITY_EN;
CUARTI11I:
process (clk,CUARTiI)
begin
if (CUARTII = '0') then
CUARTl10i <= "111";
elsif (CLK'event and clK = '1') then
if (CUARTO0 = '0') then
CUARTl10i <= "111";
else
if (CUARTo = '1') then
CUARTL10I(1 downto 0) <= CUARTl10i(2 downto 1);
CUARTl10i(2) <= RX;
end if;
end if;
end if;
end process CUARTi11i;
process (CUARTl10i)
begin
case CUARTL10I is
when "000" =>
CUARTii0i <= '0';
when "001" =>
CUARTII0I <= '0';
when "010" =>
CUARTii0i <= '0';
when "011" =>
CUARTii0i <= '1';
when "100" =>
CUARTII0I <= '0';
when "101" =>
CUARTii0i <= '1';
when "110" =>
CUARTii0i <= '1';
when others =>
CUARTII0i <= '1';
end case;
end process;
CUARTOOO0:
process (CLK,CUARTII)
begin
if (CUARTII = '0') then
CUARTli0i <= "0000";
elsif (clk'event and CLK = '1') then
if (CUARTO0 = '0') then
CUARTLI0I <= "0000";
else
if (CUARTO = '1') then
if ((CUARTo = '1' and CUARTO01 = CUARTil0
and (CUARTII0I = '1' or CUARTli0i = "1000")) or (CUARTO01 = CUARToi0I and (CUARTLI0I = "0110"))) then
CUARTli0i <= "0000";
else
CUARTLI0I <= CUARTli0i+"0001";
end if;
end if;
end if;
end if;
end process CUARTOOO0;
CUARTloo0:
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARToL1I <= '0';
elsif (clk'event and clk = '1') then
if (CUARTO0 = '0') then
CUARTOL1I <= '0';
else
if (CUARTO = '1') then
if (CUARTI10I = '1') then
CUARTol1i <= '1';
end if;
end if;
if (CUARTi1l = '1') then
CUARTol1i <= '0';
end if;
end if;
end if;
end process CUARTloo0;
CUARTIoo0:
process (CLK,CUARTII)
begin
if (CUARTII = '0') then
CUARTil1i <= '0';
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTil1i <= '0';
else
if (CUARTO = '1') then
if (CUARToi1i = '1') then
CUARTil1i <= '1';
elsif (CUARTLo0 = '1') then
CUARTIl1i <= '0';
end if;
elsif (CUARTLO0 = '1') then
CUARTIL1I <= '0';
else
CUARTIL1I <= CUARTil1i;
end if;
end if;
end if;
end process CUARTioo0;
CUARTolo0:
process (CLK,CUARTII)
begin
if (CUARTII = '0') then
CUARTIO1I <= "1001";
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTIO1I <= "1001";
else
if ((CUARTo = '1') and (CUARTo01 = CUARTIL0)
and (CUARTli0i = "1000")) then
case (CUARTo11i) is
when "00" =>
CUARTIO1I <= "0111";
when "01" =>
CUARTIO1I <= "1000";
when "10" =>
CUARTio1I <= "1000";
when "11" =>
CUARTIO1I <= "1001";
when others =>
CUARTIO1I <= "1001";
end case;
else
CUARTio1i <= CUARTio1i;
end if;
end if;
end if;
end process;
CUARTllo0:
process (clk,CUARTii)
begin
if (CUARTII = '0') then
CUARTO01 <= CUARTIL0;
CUARTI01i <= "00000000";
CUARTI10i <= '0';
CUARToi1i <= '0';
CUARTLI1i <= '0';
elsif (clK'event and CLK = '1') then
if (CUARTO0 = '0') then
CUARTo01 <= CUARTil0;
CUARTI01I <= "00000000";
CUARTI10I <= '0';
CUARTOi1i <= '0';
CUARTli1i <= '0';
else
if (CUARTo = '1') then
CUARTI10I <= '0';
CUARTOi1i <= '0';
CUARTli1i <= '0';
case CUARTo01 is
when CUARTil0 =>
if (CUARTLI0I = "1000") then
CUARTo01 <= CUARTll0i;
else
CUARTo01 <= CUARTIl0;
end if;
when CUARTLL0I =>
if (CUARTI00I = CUARTio1I) then
CUARTo01 <= CUARTIL0i;
CUARTi10i <= CUARTo10i;
if (CUARTO10i = '0') then
CUARTI01I <= (BIT8 and CUARTO00I(7))&CUARTo00i(6 downto 0);
end if;
else
CUARTO01 <= CUARTll0i;
end if;
when CUARTIL0I =>
if (CUARTli0i = "1110") then
if (CUARTII0I = '0') then
CUARTOI1I <= '1';
end if;
elsif (CUARTli0i = "1111") then
CUARTLI1I <= '1';
CUARTo01 <= CUARToI0I;
else
CUARTo01 <= CUARTil0i;
end if;
when CUARToi0i =>
if ((CUARTII0I = '1') or (CUARTLI0I = "0110")) then
CUARTO01 <= CUARTIL0;
else
CUARTO01 <= CUARToi0i;
end if;
when others =>
CUARTO01 <= CUARTil0;
end case;
end if;
end if;
end if;
end process CUARTLLO0;
CUARToo1i <= biT8&PARITY_EN;
CUARTilo0:
process (CLK,CUARTII)
begin
if (CUARTII = '0') then
CUARTO00I(8 downto 0) <= "000000000";
CUARTI00I <= "0000";
elsif (clk'event and CLK = '1') then
if (CUARTO0 = '0') then
CUARTo00i(8 downto 0) <= "000000000";
CUARTI00i <= "0000";
else
if (CUARTO = '1') then
if (CUARTo01 = CUARTil0) then
CUARTo00i(8 downto 0) <= "000000000";
CUARTI00I <= "0000";
else
if (CUARTLI0I = "1111") then
CUARTi00i <= CUARTI00I+"0001";
case CUARToo1I is
when "00" =>
CUARTo00i(5 downto 0) <= CUARTO00I(6 downto 1);
CUARTo00i(6) <= CUARTII0I;
when "11" =>
CUARTO00I(7 downto 0) <= CUARTo00i(8 downto 1);
CUARTo00i(8) <= CUARTIi0i;
when others =>
CUARTo00i(6 downto 0) <= CUARTO00I(7 downto 1);
CUARTO00I(7) <= CUARTii0i;
end case;
end if;
end if;
end if;
end if;
end if;
end process CUARTilo0;
CUARToio0:
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTl00i <= '0';
elsif (clk'event and clk = '1') then
if (CUARTO0 = '0') then
CUARTL00I <= '0';
else
if (CUARTo = '1') then
if (CUARTLi0i = "1111" and PARIty_en = '1') then
CUARTL00I <= CUARTl00i xor CUARTii0i;
end if;
if ((CUARTo01 = CUARTIL0I)) then
CUARTl00I <= '0';
end if;
end if;
end if;
end if;
end process CUARToio0;
CUARTLO1i <= BIT8&ODD_N_EVEN;
CUARTlio0:
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTll1i <= '0';
elsif (CLK'EVENT and Clk = '1') then
if (CUARTo0 = '0') then
CUARTLL1I <= '0';
else
if ((CUARTO = '1' and parity_en = '1') and CUARTLI0I = "1111") then
case CUARTLO1I is
when "00" =>
if (CUARTi00i = "0111") then
CUARTll1i <= CUARTL00I xor CUARTii0i;
end if;
when "01" =>
if (CUARTI00I = "0111") then
CUARTll1i <= not (CUARTl00i xor CUARTII0I);
end if;
when "10" =>
if (CUARTi00i = "1000") then
CUARTll1I <= CUARTL00I xor CUARTII0i;
end if;
when "11" =>
if (CUARTi00i = "1000") then
CUARTll1i <= not (CUARTL00i xor CUARTii0i);
end if;
when others =>
CUARTLl1i <= '0';
end case;
end if;
if (CUARTl0i = '1') then
CUARTll1I <= '0';
end if;
end if;
end if;
end process CUARTLIo0;
CUARTiio0:
process (clk,CUARTii)
begin
if (CUARTII = '0') then
CUARTo10i <= '0';
CUARTL11I <= '1';
CUARTII1I <= '0';
CUARTO01I <= '0';
elsif (clk'event and CLK = '1') then
if (CUARTo0 = '0') then
CUARTo10i <= '0';
CUARTL11I <= '1';
CUARTII1I <= '0';
CUARTo01i <= '0';
else
CUARTL11I <= '1';
CUARTii1i <= '0';
CUARTo01i <= '0';
if (CUARTO = '1') then
if (BIT8 = '1') then
if (PARITY_EN = '1') then
if (CUARTI00I = "1001" and CUARTO01 = CUARTll0I) then
CUARTL11I <= '0';
CUARTII1I <= '1';
CUARTO01I <= '1';
if (RX_Fifo = 2#0#) then
CUARTo10i <= '1';
end if;
end if;
else
if (CUARTI00I = "1000" and CUARTo01 = CUARTLL0I) then
CUARTl11i <= '0';
CUARTII1I <= '1';
CUARTo01i <= '1';
if (RX_Fifo = 2#0#) then
CUARTo10i <= '1';
end if;
end if;
end if;
else
if (parity_en = '1') then
if (CUARTi00i = "1000" and CUARTO01 = CUARTll0i) then
CUARTl11I <= '0';
CUARTii1i <= '1';
CUARTO01I <= '1';
if (rx_fifo = 2#0#) then
CUARTo10i <= '1';
end if;
end if;
else
if (CUARTi00i = "0111" and CUARTO01 = CUARTll0i) then
CUARTL11I <= '0';
CUARTii1i <= '1';
CUARTO01I <= '1';
if (Rx_fifo = 2#0#) then
CUARTO10I <= '1';
end if;
end if;
end if;
end if;
end if;
if (CUARTI1l = '1') then
CUARTO10I <= '0';
end if;
end if;
end if;
end process CUARTiio0;
CUARTl01i <= CUARTO10I;
end architecture CUARTlol;
