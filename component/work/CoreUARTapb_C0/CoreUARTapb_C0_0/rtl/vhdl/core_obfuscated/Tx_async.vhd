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
library iEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigneD.all;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_TX_async is
generic (sync_reset: INTEGER := 0;
TX_FIFO: INTEGER := 0); port (CLK: in STD_Logic;
CUARTl: in STD_logic;
RESET_N: in std_logic;
CUARTl0L: in STD_Logic;
CUARTi0l: in STD_LOGIC_vector(7 downto 0);
CUARTO1L: in std_logic_vectoR(7 downto 0);
CUARTL11: in STd_logic;
CUARTI11: in std_logic;
BIT8: in STD_LOGIC;
parity_en: in STD_LOGIC;
odd_n_even: in STD_LOGIC;
TXRDY: out std_logic;
tx: out std_logic;
CUARTlii: out std_logic);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_Tx_async;

architecture CUARTLOL of CoreUARTapb_C0_CoreUARTapb_C0_0_Tx_async is

constant CUARTO0O0: integer := 0;

constant CUARTl0o0: INTEGER := 1;

constant CUARTi0o0: INTEGEr := 2;

constant CUARTo1o0: integer := 3;

constant CUARTL1O0: intEGER := 4;

constant CUARTi1o0: INTEGER := 5;

constant CUARTool0: integer := 6;

signal CUARTlol0: INTEGER;

signal CUARTIOL0: std_LOGIC;

signal CUARToll0: STD_LOGIc_vector(7 downto 0);

signal CUARTlll0: STD_LOGic_vector(3 downto 0);

signal CUARTILL0: std_logiC;

signal CUARToil0: STD_LOGic;

signal CUARTlil0: STD_LOgic;

signal CUARTiil0: STD_LOGIC;

signal CUARTii: STD_LOGIC;

signal CUARTO0: STd_logic;

function to_integer(VAL: STD_LOGIC_Vector)
return integer is
constant CUARTOOoi: STD_LOGIC_VECTOR(val'HIGH-VAL'LOW downto 0) := VAL;
variable CUARTlooi: integer := 0;
begin
for CUARTIOOI in CUARToooi'range
loop
if (CUARToOOI(CUARTiooi) = '1') then
CUARTLOOI := CUARTLOOI+(2**CUARTIOOI);
end if;
end loop;
return (CUARTLOOI);
end TO_INteger;

begin
CUARTII <= '1' when (Sync_reset = 1) else
reset_n;
CUARTo0 <= RESet_n when (sync_reset = 1) else
'1';
txrdy <= CUARTlil0;
TX <= CUARTiil0;
CUARTo0l0:
process (CLK,CUARTii)
begin
if (not CUARTIi = '1') then
CUARTIOL0 <= '1';
elsif (clk'event and CLK = '1') then
if (not CUARTo0 = '1') then
CUARTIOL0 <= '1';
else
if (tx_fifo = 2#0#) then
if (CUARTl = '1') then
if (CUARTLOL0 = CUARTI0o0) then
CUARTiol0 <= '1';
end if;
end if;
if (CUARTl0l = '1') then
CUARTIOL0 <= '0';
end if;
else
CUARTIOl0 <= not CUARTI11;
end if;
end if;
end if;
end process CUARTO0L0;
CUARTL0L0:
process (clk,CUARTii)
begin
if (not CUARTII = '1') then
CUARTlol0 <= CUARTO0O0;
CUARTOLL0 <= "00000000";
CUARTOIL0 <= '1';
elsif (clk'event and CLK = '1') then
if (not CUARTo0 = '1') then
CUARTlol0 <= CUARTO0O0;
CUARTOLL0 <= "00000000";
CUARToil0 <= '1';
else
if (CUARTl = '1' or CUARTlol0 = CUARTo0o0
or CUARTLOL0 = CUARTOOL0
or CUARTlol0 = CUARTl0o0) then
CUARTOIL0 <= '1';
case CUARTlol0 is
when CUARTO0O0 =>
if (tx_fifo = 2#0#) then
if (not CUARTiol0 = '1') then
CUARTlol0 <= CUARTl0o0;
else
CUARTLOL0 <= CUARTo0o0;
end if;
else
if (CUARTL11 = '0') then
CUARTOIL0 <= '0';
CUARTlol0 <= CUARTool0;
else
CUARTLOL0 <= CUARTo0o0;
CUARToil0 <= '1';
end if;
end if;
when CUARTL0O0 =>
CUARTLOl0 <= CUARTi0o0;
when CUARTi0o0 =>
if (TX_FIFO = 2#0#) then
CUARTolL0 <= CUARTI0L;
else
CUARToll0 <= CUARTo1l;
end if;
CUARTlol0 <= CUARTo1o0;
when CUARTO1O0 =>
if (BIt8 = '1') then
if (CUARTlll0 = "0111") then
if (PARITY_EN = '1') then
CUARTlol0 <= CUARTl1o0;
else
CUARTLOL0 <= CUARTi1o0;
end if;
else
CUARTLOL0 <= CUARTO1O0;
end if;
else
if (CUARTLLL0 = "0110") then
if (PArity_en = '1') then
CUARTlol0 <= CUARTL1O0;
else
CUARTlol0 <= CUARTI1O0;
end if;
else
CUARTLOL0 <= CUARTo1o0;
end if;
end if;
when CUARTl1o0 =>
CUARTLOL0 <= CUARTi1o0;
when CUARTI1O0 =>
CUARTlol0 <= CUARTo0o0;
when CUARTool0 =>
CUARTLOL0 <= CUARTL0O0;
when others =>
CUARTlOL0 <= CUARTo0o0;
end case;
end if;
end if;
end if;
end process CUARTl0l0;
CUARTlii <= CUARToil0;
CUARTi0l0:
process (clk,CUARTii)
begin
if (not CUARTii = '1') then
CUARTlll0 <= "0000";
elsif (CLK'EVENT and clk = '1') then
if (not CUARTo0 = '1') then
CUARTLll0 <= "0000";
else
if (CUARTl = '1') then
if (CUARTlol0 /= CUARTo1O0) then
CUARTlll0 <= "0000";
else
CUARTlll0 <= CUARTlll0+"0001";
end if;
end if;
end if;
end if;
end process CUARTI0L0;
CUARTO1L0:
process (clk,CUARTii)
begin
if (not CUARTii = '1') then
CUARTiil0 <= '1';
elsif (clk'event and clk = '1') then
if (not CUARTo0 = '1') then
CUARTiil0 <= '1';
else
if (CUARTL = '1' or CUARTlol0 = CUARTo0o0
or CUARTloL0 = CUARTOol0
or CUARTlol0 = CUARTl0o0) then
case CUARTlol0 is
when CUARTo0o0 =>
CUARTIIL0 <= '1';
when CUARTl0o0 =>
CUARTiil0 <= '1';
when CUARTi0o0 =>
CUARTiiL0 <= '0';
when CUARTo1o0 =>
CUARTiil0 <= CUARToll0(TO_INTEGER(CUARTLLL0));
when CUARTL1O0 =>
CUARTiil0 <= odd_n_even xor CUARTILL0;
when CUARTi1o0 =>
CUARTIIL0 <= '1';
when others =>
CUARTiil0 <= '1';
end case;
end if;
end if;
end if;
end process CUARTO1l0;
CUARTL1L0:
process (CLK,CUARTii)
begin
if (not CUARTii = '1') then
CUARTill0 <= '0';
elsif (Clk'EVENT and CLK = '1') then
if (not CUARTO0 = '1') then
CUARTill0 <= '0';
else
if ((CUARTl and parity_en) = '1') then
if (CUARTLOL0 = CUARTo1o0) then
CUARTILL0 <= CUARTill0 xor CUARToll0(TO_INTEGER(CUARTLLL0));
else
CUARTill0 <= CUARTILL0;
end if;
end if;
if (CUARTlol0 = CUARTI1O0) then
CUARTill0 <= '0';
end if;
end if;
end if;
end process CUARTl1l0;
CUARTLIL0 <= CUARTiol0;
end architecture CUARTlol;
