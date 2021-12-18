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
use ieee.std_logic_1164.all;
use ieee.Std_logic_ARITH.all;
use IEEE.std_logic_uNSIGNED.all;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_Clock_gen is
generic (bauD_VAL_FRCTN_EN: integer := 0;
sync_rESET: integer := 0); port (clk: in STD_LOGIC;
reset_n: in STD_LOGIC;
baud_val: in STD_LOGIC_Vector(12 downto 0);
baud_val_fraction: in STd_logic_vector(2 downto 0);
CUARTo: out STD_LOGIC;
CUARTl: out STD_LOGIC);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_Clock_gen;

architecture CUARTi of CoreUARTapb_C0_CoreUARTapb_C0_0_Clock_gen is

signal CUARTol: std_logic_vector(12 downto 0);

signal CUARTll: std_logic;

signal CUARTIL: std_LOGIC;

signal CUARToi: STD_LOGIC_vector(3 downto 0);

signal CUARTli: STD_logic;

signal CUARTIi: sTD_LOGIC;

signal CUARTO0: Std_logic;

begin
CUARTII <= '1' when (sYNC_RESET = 1) else
reSET_N;
CUARTO0 <= RESET_N when (SYNC_RESET = 1) else
'1';
CUARTL0:
if (BAUD_VAL_FRCTN_EN = 1)
generate
CUARTi0:
process (clk,CUARTII)
begin
if (CUARTii = '0') then
CUARTLI <= '0';
elsif (cLK'EVENT and clk = '1') then
if (CUARTo0 = '0') then
CUARTli <= '0';
else
if (CUARTol = "0000000000001") then
CUARTLI <= '1';
else
CUARTli <= '0';
end if;
end if;
end if;
end process CUARTI0;
CUARTO1:
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTol <= "0000000000000";
CUARTLL <= '0';
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTOL <= "0000000000000";
CUARTll <= '0';
else
case BAUd_val_fraction is
when "000" =>
if (CUARTOL = "0000000000000") then
CUARTOL <= BAUD_VAL;
CUARTll <= '1';
else
CUARTOL <= CUARTOL-'1';
CUARTLL <= '0';
end if;
when "001" =>
if (CUARTol = "0000000000000") then
if (CUARToi(2 downto 0) = "111" and CUARTli = '1') then
CUARTol <= CUARTol;
CUARTll <= '0';
else
CUARTOL <= baud_vAL;
CUARTll <= '1';
end if;
else
CUARTol <= CUARTOL-'1';
CUARTLl <= '0';
end if;
when "010" =>
if (CUARTol = "0000000000000") then
if (CUARTOI(1 downto 0) = "11" and CUARTli = '1') then
CUARTOL <= CUARTOL;
CUARTLL <= '0';
else
CUARTol <= baud_val;
CUARTll <= '1';
end if;
else
CUARTol <= CUARTOL-'1';
CUARTll <= '0';
end if;
when "011" =>
if (CUARTOL = "0000000000000") then
if ((((CUARToi(2) = '1') or (CUARToi(1) = '1')) and CUARTOI(0) = '1') and (CUARTli = '1')) then
CUARTol <= CUARTOL;
CUARTll <= '0';
else
CUARTol <= baud_val;
CUARTLL <= '1';
end if;
else
CUARTol <= CUARTol-'1';
CUARTll <= '0';
end if;
when "100" =>
if (CUARTol = "0000000000000") then
if (CUARTOI(0) = '1' and CUARTli = '1') then
CUARTOL <= CUARTOL;
CUARTLL <= '0';
else
CUARTol <= baud_val;
CUARTll <= '1';
end if;
else
CUARTOl <= CUARTOL-'1';
CUARTLL <= '0';
end if;
when "101" =>
if (CUARTol = "0000000000000") then
if (((CUARTOI(2) = '1' and CUARToi(1) = '1') or CUARTOI(0) = '1') and CUARTLI = '1') then
CUARTOl <= CUARTol;
CUARTLL <= '0';
else
CUARTol <= baud_val;
CUARTll <= '1';
end if;
else
CUARTOL <= CUARTol-'1';
CUARTLL <= '0';
end if;
when "110" =>
if (CUARTOL = "0000000000000") then
if ((CUARToi(1) = '1' or CUARToi(0) = '1') and CUARTli = '1') then
CUARTol <= CUARTol;
CUARTll <= '0';
else
CUARTOL <= BAUD_VAL;
CUARTLL <= '1';
end if;
else
CUARTol <= CUARTol-'1';
CUARTll <= '0';
end if;
when "111" =>
if (CUARTol = "0000000000000") then
if (((CUARToi(1) = '1' or CUARToi(0) = '1') or CUARTOI(2 downto 0) = "100") and CUARTLI = '1') then
CUARTOL <= CUARTol;
CUARTll <= '0';
else
CUARTol <= baud_val;
CUARTlL <= '1';
end if;
else
CUARTOL <= CUARTol-'1';
CUARTLL <= '0';
end if;
when others =>
if (CUARTol = "0000000000000") then
CUARTol <= BAUD_Val;
CUARTLL <= '1';
else
CUARTOL <= CUARTOL-'1';
CUARTLL <= '0';
end if;
end case;
end if;
end if;
end process CUARTo1;
end generate;
CUARTl1:
if (BAUD_val_frctn_en = 0)
generate
CUARTi1:
process (clk,CUARTii)
begin
if (CUARTII = '0') then
CUARTOL <= "0000000000000";
CUARTLL <= '0';
elsif (clk'event and CLK = '1') then
if (CUARTo0 = '0') then
CUARTol <= "0000000000000";
CUARTLL <= '0';
else
if (CUARTol = "0000000000000") then
CUARTol <= baud_val;
CUARTll <= '1';
else
CUARTol <= CUARTOL-'1';
CUARTll <= '0';
end if;
end if;
end if;
end process CUARTi1;
end generate;
CUARTool:
process (clk,CUARTii)
begin
if (CUARTIi = '0') then
CUARTOI <= "0000";
CUARTil <= '0';
elsif (CLK'EVENT and clk = '1') then
if (CUARTO0 = '0') then
CUARTOI <= "0000";
CUARTil <= '0';
else
if (CUARTLL = '1') then
CUARToi <= CUARToi+'1';
if (CUARToi = "1111") then
CUARTil <= '1';
else
CUARTil <= '0';
end if;
end if;
end if;
end if;
end process;
CUARTl <= CUARTil and CUARTll;
CUARTO <= CUARTLL;
end CUARTI;
