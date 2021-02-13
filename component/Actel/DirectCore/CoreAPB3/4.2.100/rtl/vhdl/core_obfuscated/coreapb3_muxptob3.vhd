-- Actel Corporation Proprietary and Confidential
-- Copyright 2010 Actel Corporation.  All rights reserved.
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
-- Revision Information:
-- 05Feb10              Production Release Version 3.0
-- SVN Revision Information:
-- SVN $Revision: 24054 $
-- SVN $Date: 2014-12-08 16:13:40 +0530 (Mon, 08 Dec 2014) $
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
entity CAPB3li is
port (CAPB3ii: in std_logic_vector(16 downto 0);
prdatas0: in std_logIC_VECTOR(31 downto 0);
prdatas1: in std_logic_vector(31 downto 0);
prDATAS2: in std_LOGIC_VECTOR(31 downto 0);
prdatas3: in STD_LOGIC_vector(31 downto 0);
prdatas4: in std_logIC_VECTOR(31 downto 0);
PRDATAS5: in Std_logic_vector(31 downto 0);
PRDatas6: in STD_LOGIC_vector(31 downto 0);
prdatas7: in std_LOGIC_VECTOR(31 downto 0);
PRDATAS8: in STD_LOGIC_VECTOR(31 downto 0);
prdATAS9: in STD_LOGIC_VEctor(31 downto 0);
prdatas10: in std_logic_vector(31 downto 0);
Prdatas11: in STD_LOGIC_vector(31 downto 0);
PRDATAS12: in std_logiC_VECTOR(31 downto 0);
PRDATAS13: in std_logic_veCTOR(31 downto 0);
prdataS14: in STD_LOGIC_Vector(31 downto 0);
PRDATAS15: in STD_LOGIC_VECtor(31 downto 0);
PRDATAS16: in STD_LOGIC_VECTOr(31 downto 0);
CAPB3O0: in std_logic_vector(16 downto 0);
CAPB3L0: in STD_LOGIC_Vector(16 downto 0);
PREADY: out std_logic;
pslvERR: out STD_LOGIC;
PRDATA: out std_logic_vector(31 downto 0));
end entity CAPB3li;

architecture CAPB3i0 of CAPB3li is

constant CAPB3o1: STD_LOGIC_VECTOR(4 downto 0) := "00000";

constant CAPB3l1: std_logic_vectoR(4 downto 0) := "00001";

constant CAPB3i1: STd_logic_vector(4 downto 0) := "00010";

constant CAPB3OOL: std_lOGIC_VECTOR(4 downto 0) := "00011";

constant CAPB3Lol: STD_LOGIC_VECTOR(4 downto 0) := "00100";

constant CAPB3iol: std_logiC_VECTOR(4 downto 0) := "00101";

constant CAPB3oll: std_logic_vector(4 downto 0) := "00110";

constant CAPB3lll: STD_LOGIC_vector(4 downto 0) := "00111";

constant CAPB3ill: std_logic_vectOR(4 downto 0) := "01000";

constant CAPB3oil: std_logic_vector(4 downto 0) := "01001";

constant CAPB3LIL: Std_logic_vector(4 downto 0) := "01010";

constant CAPB3iil: std_logic_VECTOR(4 downto 0) := "01011";

constant CAPB3O0L: std_logic_vector(4 downto 0) := "01100";

constant CAPB3l0l: std_logic_vector(4 downto 0) := "01101";

constant CAPB3i0l: Std_logic_vector(4 downto 0) := "01110";

constant CAPB3o1L: std_logic_veCTOR(4 downto 0) := "01111";

constant CAPB3l1l: std_logic_vector(4 downto 0) := "10000";

signal CAPB3i1l: STD_LOGic;

signal CAPB3ooi: STD_LOGIC;

signal CAPB3loi: STD_LOGIC_vector(31 downto 0);

signal CAPB3ioi: STD_LOGIC_VECTOr(4 downto 0);

signal CAPB3oli: STD_LOGIC_VECTor(31 downto 0);

begin
CAPB3OLI <= ( others => '0');
CAPB3ioi(4) <= CAPB3II(16);
CAPB3IOI(3) <= CAPB3ii(15) or CAPB3II(14)
or CAPB3ii(13)
or CAPB3II(12)
or CAPB3ii(11)
or CAPB3ii(10)
or CAPB3II(9)
or CAPB3II(8);
CAPB3ioi(2) <= CAPB3II(15) or CAPB3ii(14)
or CAPB3II(13)
or CAPB3ii(12)
or CAPB3ii(7)
or CAPB3II(6)
or CAPB3II(5)
or CAPB3Ii(4);
CAPB3ioi(1) <= CAPB3II(15) or CAPB3ii(14)
or CAPB3ii(11)
or CAPB3ii(10)
or CAPB3ii(7)
or CAPB3ii(6)
or CAPB3ii(3)
or CAPB3ii(2);
CAPB3IOI(0) <= CAPB3II(15) or CAPB3ii(13)
or CAPB3II(11)
or CAPB3ii(9)
or CAPB3ii(7)
or CAPB3ii(5)
or CAPB3ii(3)
or CAPB3iI(1);
process (CAPB3ioi,CAPB3ii,prdatas0,CAPB3oli,prdatas1,prdatas2,prdatas3,prdatas4,PRDATas5,PRDATAS6,PRDATAS7,PRDATAS8,prdatas9,prdatas10,PRDatas11,PRDATAS12,prdATAS13,prdatas14,PRDATAS15,prdataS16)
begin
case CAPB3ioi is
when CAPB3O1 =>
if ((CAPB3II(0)) = '1') then
CAPB3LOI(31 downto 0) <= PRDATAS0(31 downto 0);
else
CAPB3loi(31 downto 0) <= CAPB3OLI(31 downto 0);
end if;
when CAPB3l1 =>
CAPB3loi(31 downto 0) <= prdatas1(31 downto 0);
when CAPB3i1 =>
CAPB3loi(31 downto 0) <= PRDATas2(31 downto 0);
when CAPB3ool =>
CAPB3loi(31 downto 0) <= prdatas3(31 downto 0);
when CAPB3LOL =>
CAPB3LOI(31 downto 0) <= prdatas4(31 downto 0);
when CAPB3iol =>
CAPB3LOI(31 downto 0) <= prdatas5(31 downto 0);
when CAPB3oll =>
CAPB3loi(31 downto 0) <= PRDATAS6(31 downto 0);
when CAPB3lll =>
CAPB3loi(31 downto 0) <= PRDATAS7(31 downto 0);
when CAPB3ILL =>
CAPB3LOI(31 downto 0) <= PRDATAS8(31 downto 0);
when CAPB3oil =>
CAPB3loi(31 downto 0) <= prdaTAS9(31 downto 0);
when CAPB3LIL =>
CAPB3LOI(31 downto 0) <= PRDAtas10(31 downto 0);
when CAPB3iil =>
CAPB3loi(31 downto 0) <= prdatas11(31 downto 0);
when CAPB3o0l =>
CAPB3loi(31 downto 0) <= Prdatas12(31 downto 0);
when CAPB3l0l =>
CAPB3LOI(31 downto 0) <= PRDATAS13(31 downto 0);
when CAPB3I0L =>
CAPB3loi(31 downto 0) <= prdatas14(31 downto 0);
when CAPB3o1l =>
CAPB3loi(31 downto 0) <= PRDatas15(31 downto 0);
when CAPB3l1l =>
CAPB3LOI(31 downto 0) <= PRDAtas16(31 downto 0);
when others =>
CAPB3loi(31 downto 0) <= CAPB3oli(31 downto 0);
end case;
end process;
process (CAPB3Ioi,CAPB3ii,CAPB3O0)
begin
case CAPB3ioi is
when CAPB3o1 =>
if ((CAPB3ii(0)) = '1') then
CAPB3I1L <= CAPB3O0(0);
else
CAPB3i1l <= '1';
end if;
when CAPB3l1 =>
CAPB3i1l <= CAPB3o0(1);
when CAPB3i1 =>
CAPB3I1L <= CAPB3o0(2);
when CAPB3ool =>
CAPB3I1L <= CAPB3O0(3);
when CAPB3lol =>
CAPB3I1L <= CAPB3O0(4);
when CAPB3iol =>
CAPB3I1L <= CAPB3O0(5);
when CAPB3OLL =>
CAPB3i1l <= CAPB3O0(6);
when CAPB3lll =>
CAPB3i1L <= CAPB3o0(7);
when CAPB3ill =>
CAPB3i1l <= CAPB3O0(8);
when CAPB3OIL =>
CAPB3i1L <= CAPB3o0(9);
when CAPB3lil =>
CAPB3I1L <= CAPB3o0(10);
when CAPB3IIl =>
CAPB3I1L <= CAPB3o0(11);
when CAPB3o0l =>
CAPB3I1L <= CAPB3O0(12);
when CAPB3l0l =>
CAPB3I1l <= CAPB3o0(13);
when CAPB3I0L =>
CAPB3i1l <= CAPB3o0(14);
when CAPB3O1L =>
CAPB3i1l <= CAPB3O0(15);
when CAPB3L1L =>
CAPB3i1l <= CAPB3o0(16);
when others =>
CAPB3i1l <= '1';
end case;
end process;
process (CAPB3IOI,CAPB3ii,CAPB3L0)
begin
case CAPB3ioi is
when CAPB3o1 =>
if ((CAPB3ii(0)) = '1') then
CAPB3ooi <= CAPB3L0(0);
else
CAPB3ooi <= '0';
end if;
when CAPB3L1 =>
CAPB3OOI <= CAPB3L0(1);
when CAPB3i1 =>
CAPB3ooi <= CAPB3l0(2);
when CAPB3OOL =>
CAPB3OOI <= CAPB3l0(3);
when CAPB3LOL =>
CAPB3ooi <= CAPB3l0(4);
when CAPB3iol =>
CAPB3OOI <= CAPB3L0(5);
when CAPB3Oll =>
CAPB3OOi <= CAPB3L0(6);
when CAPB3lll =>
CAPB3OOI <= CAPB3L0(7);
when CAPB3ILL =>
CAPB3ooi <= CAPB3L0(8);
when CAPB3oil =>
CAPB3ooi <= CAPB3L0(9);
when CAPB3lil =>
CAPB3Ooi <= CAPB3l0(10);
when CAPB3iil =>
CAPB3OOI <= CAPB3l0(11);
when CAPB3o0l =>
CAPB3OOI <= CAPB3l0(12);
when CAPB3l0l =>
CAPB3ooi <= CAPB3L0(13);
when CAPB3i0l =>
CAPB3OOI <= CAPB3l0(14);
when CAPB3o1l =>
CAPB3ooi <= CAPB3L0(15);
when CAPB3l1l =>
CAPB3ooI <= CAPB3L0(16);
when others =>
CAPB3ooi <= '0';
end case;
end process;
prEADY <= CAPB3I1L;
pslverr <= CAPB3ooi;
PRDATA <= CAPB3LOI(31 downto 0);
end architecture CAPB3I0;
