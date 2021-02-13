-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2011 Microsemi Corporation.  All rights reserved.
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
-- Revision Information:
-- 05Feb10              Production Release Version 3.0
-- SVN Revision Information:
-- SVN $Revision: 24054 $
-- SVN $Date: 2014-12-08 16:13:40 +0530 (Mon, 08 Dec 2014) $
library IEEe;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_std.all;
entity coreaPB3 is
generic (Apb_dwidth: integer range 8 to 32 := 32;
iaddr_option: integer range 0 to 17 := 0;
apbslot0enaBLE: Integer range 0 to 1 := 1;
APBSLOT1ENABLE: integer range 0 to 1 := 1;
apbslot2enablE: integer range 0 to 1 := 1;
APBSLOT3ENABLE: INTEGER range 0 to 1 := 1;
apbslOT4ENABLE: integer range 0 to 1 := 1;
APBSLot5enable: INTEGER range 0 to 1 := 1;
apbslot6enable: intEGER range 0 to 1 := 1;
APBSLOT7enable: integer range 0 to 1 := 1;
APBSLOT8enable: integer range 0 to 1 := 1;
apbslot9enable: INTEGER range 0 to 1 := 1;
apbslot10enaBLE: INTEGER range 0 to 1 := 1;
apbslot11enable: INTEGER range 0 to 1 := 1;
apBSLOT12ENABLE: integer range 0 to 1 := 1;
apbslot13enable: inteGER range 0 to 1 := 1;
apbslot14ENABLE: INTEGER range 0 to 1 := 1;
APBSLOT15Enable: integer range 0 to 1 := 1;
sc_0: integer range 0 to 1 := 1;
SC_1: iNTEGER range 0 to 1 := 0;
sc_2: integer range 0 to 1 := 0;
SC_3: INTEGER range 0 to 1 := 0;
sc_4: integer range 0 to 1 := 0;
SC_5: INTEGER range 0 to 1 := 0;
SC_6: INTEGER range 0 to 1 := 0;
sc_7: INTEGER range 0 to 1 := 0;
SC_8: INTEGER range 0 to 1 := 0;
SC_9: INTEGER range 0 to 1 := 0;
sc_10: integer range 0 to 1 := 0;
SC_11: INTEGER range 0 to 1 := 0;
SC_12: INTEGER range 0 to 1 := 0;
sc_13: INTEGER range 0 to 1 := 0;
sc_14: INTEGER range 0 to 1 := 0;
sc_15: integer range 0 to 1 := 0;
MADDR_BITS: integer range 12 to 32 := 32;
UPR_NIBBLE_POSN: integer range 2 to 8 := 7;
FAMILY: INTEger range 1 to 1000 := 19); port (IADDR: in STD_LOGIC_VECTOR(31 downto 0);
PRESETN: in STD_LOGIC;
pclk: in std_logic;
PADDR: in STD_Logic_vector(31 downto 0);
pwrite: in stD_LOGIC;
penable: in std_logic;
PSEL: in std_logic;
PWDATA: in STD_LOGIC_VECTOR(31 downto 0);
PRDATA: out STD_LOGIC_vector(31 downto 0);
PREADY: out STD_LOGIC;
PSLVERR: out STD_LOGIC;
paddrs: out std_lOGIC_VECTOR(31 downto 0);
pwrites: out STD_LOGIC;
penables: out STD_LOGIC;
pwdatas: out std_logic_vector(31 downto 0);
PSELS0: out std_logic;
psels1: out std_logic;
PSELS2: out std_logic;
PSELS3: out STD_logic;
psels4: out std_logic;
PSELS5: out STD_LOGIc;
psels6: out STD_LOGIC;
PSELS7: out STD_LOGIC;
psels8: out std_logic;
PSELS9: out std_logic;
PSELS10: out stD_LOGIC;
PSELS11: out std_lOGIC;
PSELS12: out STD_LOGIC;
PSELS13: out std_lOGIC;
PSELS14: out STD_LOGIC;
PSELS15: out std_logic;
PSELS16: out std_logic;
prdatas0: in std_logic_vector(31 downto 0);
prdatas1: in std_logic_veCTOR(31 downto 0);
prdATAS2: in STD_LOGIC_VECTOR(31 downto 0);
PRDATAS3: in STD_logic_vector(31 downto 0);
PRDATAS4: in STD_LOGIC_VECTOR(31 downto 0);
PRDATAS5: in STD_Logic_vector(31 downto 0);
PRDATAS6: in std_logic_vecTOR(31 downto 0);
prdataS7: in std_LOGIC_VECTOR(31 downto 0);
prdatas8: in std_logic_VECTOR(31 downto 0);
prdataS9: in std_logic_vector(31 downto 0);
PRDATas10: in STD_LOGIC_VECTOR(31 downto 0);
prdatas11: in stD_LOGIC_VECTOR(31 downto 0);
prdatas12: in STD_LOGIC_VECTOR(31 downto 0);
PRDATAS13: in STD_LOGIC_VECTOr(31 downto 0);
PRDATAS14: in stD_LOGIC_VECTOR(31 downto 0);
PRDATAS15: in std_logic_vector(31 downto 0);
prdatas16: in STD_Logic_vector(31 downto 0);
PREADYS0: in std_logic;
PREADys1: in std_logic;
PREADYS2: in std_logic;
PREADYS3: in std_logic;
preadys4: in STD_LOGIC;
preadys5: in std_logic;
PREADys6: in std_logic;
PREADYS7: in STD_logic;
preadys8: in std_loGIC;
PREADYS9: in std_logic;
PREADYS10: in STD_LOGIC;
preadys11: in STD_LOGIC;
PREADYS12: in Std_logic;
preadys13: in std_lOGIC;
PREADYS14: in STD_LOGIC;
PREADYS15: in STD_LOGIC;
preadys16: in STD_LOGIC;
PSLVERRs0: in STD_LOGic;
Pslverrs1: in STD_logic;
pslverrs2: in std_logic;
pslverrs3: in std_logic;
pslverrs4: in STd_logic;
PSLVERRS5: in STD_LOGIC;
PSLVERRS6: in stD_LOGIC;
PSLVERRS7: in std_lOGIC;
pslverrs8: in STD_LOGIC;
PSLVERRS9: in sTD_LOGIC;
pslverrs10: in std_logic;
pslverrs11: in STD_LOgic;
PSLVERRS12: in STD_LOGIC;
PSLVERRS13: in std_LOGIC;
pslverrs14: in Std_logic;
PSLVERRS15: in STD_LOGIC;
PSLVERRS16: in std_logic);
end entity COREAPB3;

architecture CAPB3lli of coreapb3 is

function CAPB3ili(VAL: in INTEGER)
return integer is
variable V: INTeger;
variable CAPB3oii: integer;
begin
v := val;
CAPB3oii := 0;
while (v > 1)
loop
v := V/2;
CAPB3oii := CAPB3oii+1;
end loop;
return (CAPB3oii);
end CAPB3ILI;

function CAPB3LII(CAPB3iii: in boolean)
return NATURAL is
variable CAPB3o0i: NATUral range 0 to 1;
begin
if (CAPB3III) then
CAPB3o0i := 1;
else
CAPB3o0i := 0;
end if;
return CAPB3o0i;
end CAPB3LII;

function CAPB3L0i(FAMILY: integer)
return intEGER is
variable CAPB3I0I: integer := 0;
begin
if (FAMILY = 25) then
CAPB3i0i := 1;
else
CAPB3i0i := 0;
end if;
return CAPB3i0i;
end CAPB3L0i;

constant CAPB3o1i: integer := 0;

constant CAPB3l1i: integer := 1;

constant CAPB3i1i: integer := 2;

constant CAPB3OO0: INTEGER := 3;

constant CAPB3lo0: integer := 4;

constant CAPB3io0: integer := 5;

constant CAPB3ol0: integer := 6;

constant CAPB3ll0: INTEGER := 7;

constant CAPB3Il0: integer := 8;

constant CAPB3OI0: INTEGER := 9;

constant CAPB3li0: INTEGER := 10;

constant CAPB3II0: INTEGER := 11;

constant CAPB3o00: integer := 12;

constant CAPB3L00: INTEGER := 13;

constant CAPB3I00: INTEGER := 14;

constant CAPB3o10: INTEGER := 15;

constant CAPB3l10: INTEGER := 16;

constant CAPB3I10: intEGER := 17;

constant CAPB3oo1: STD_LOGIC_VECtor(15 downto 0) := STD_logic_vector(to_unsIGNED((APBSLOT0ENABLE*(2**0)),
16));

constant CAPB3LO1: STD_logic_vector(15 downto 0) := std_loGIC_VECTOR(TO_UNSIGNED((APBSLOT1ENAble*(2**1)),
16));

constant CAPB3io1: STD_LOGIC_VECtor(15 downto 0) := stD_LOGIC_VECTOR(to_uNSIGNED((APBSLOT2Enable*(2**2)),
16));

constant CAPB3OL1: STD_LOgic_vector(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned((apbslot3enable*(2**3)),
16));

constant CAPB3LL1: STD_LOGIC_VECTOr(15 downto 0) := STD_LOGIc_vector(to_unsigned((apbslot4enaBLE*(2**4)),
16));

constant CAPB3IL1: STD_Logic_vector(15 downto 0) := std_logic_vector(TO_UNSIGNED((apbslot5enaBLE*(2**5)),
16));

constant CAPB3OI1: STD_LOGIC_VECtor(15 downto 0) := STD_LOGIC_vector(TO_UNSIGNED((APBSLOT6ENABLE*(2**6)),
16));

constant CAPB3li1: std_logic_vector(15 downto 0) := STD_LOGIC_VECtor(to_unsigned((APBSLot7enable*(2**7)),
16));

constant CAPB3ii1: std_logic_vector(15 downto 0) := STD_LOGIC_VECTOR(TO_unsigned((apbSLOT8ENABLE*(2**8)),
16));

constant CAPB3o01: STD_Logic_vector(15 downto 0) := sTD_LOGIC_VECTOR(to_unsigned((APBSLOT9ENABLE*(2**9)),
16));

constant CAPB3l01: STd_logic_vector(15 downto 0) := std_logic_vector(TO_UNSIGNED((apbslot10enable*(2**10)),
16));

constant CAPB3I01: STD_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED((apbslot11enable*(2**11)),
16));

constant CAPB3O11: std_LOGIC_VECTOR(15 downto 0) := STD_LOGIC_vector(to_unsigned((apbslot12enable*(2**12)),
16));

constant CAPB3l11: STD_logic_vector(15 downto 0) := std_logic_vector(TO_UNSIGned((APBSLOT13enable*(2**13)),
16));

constant CAPB3I11: STD_LOGIC_VECTOR(15 downto 0) := STD_logic_vector(TO_UNSIGNED((APBSLOT14ENABLE*(2**14)),
16));

constant CAPB3oool: STD_LOGIC_VECTor(15 downto 0) := STD_LOGIC_VECTOR(to_unsigned((apBSLOT15ENABLE*(2**15)),
16));

constant CAPB3LOOL: std_logic_vector(17 downto 0) := std_logic_vector(to_unsigNED((2**Iaddr_option),
18));

constant SYNC_RESET: integer := CAPB3L0I(family);

constant CAPB3IOOL: INTEger := (sc_15*(2**15))+(SC_14*(2**14))+(sc_13*(2**13))+(SC_12*(2**12))+(sc_11*(2**11))+(SC_10*(2**10))+(sc_9*(2**9))+(sc_8*(2**8))+(SC_7*(2**7))+(SC_6*(2**6))+(SC_5*(2**5))+(sc_4*(2**4))+(SC_3*(2**3))+(sc_2*(2**2))+(sc_1*(2**1))+(SC_0*(2**0));

constant CAPB3olol: std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(CAPB3iool,
16));

constant CAPB3llol: std_logic_vector(15 downto 0) := (CAPB3olol(15) and not (CAPB3LOOL(17)))&(CAPB3OLOL(14) and not (CAPB3lool(16)))&(CAPB3OLOL(13) and not (CAPB3lool(15)))&(CAPB3olol(12) and not (CAPB3lOOL(14)))&(CAPB3olol(11) and not (CAPB3LOOL(13)))&(CAPB3OLOL(10) and not (CAPB3lool(12)))&(CAPB3olol(9) and not (CAPB3LOOL(11)))&(CAPB3OLOL(8) and not (CAPB3lool(10)))&(CAPB3olol(7) and not (CAPB3lool(9)))&(CAPB3olol(6) and not (CAPB3Lool(8)))&(CAPB3olol(5) and not (CAPB3lool(7)))&(CAPB3olol(4) and not (CAPB3lool(6)))&(CAPB3OLOL(3) and not (CAPB3LOOL(5)))&(CAPB3OLOL(2) and not (CAPB3lool(4)))&(CAPB3OLOL(1) and not (CAPB3lool(3)))&(CAPB3olol(0) and not (CAPB3lool(2)));

constant CAPB3ilol: std_lOGIC_VECTOR(15 downto 0) := CAPB3OO1(15)&CAPB3OO1(14)&CAPB3Oo1(13)&CAPB3OO1(12)&CAPB3OO1(11)&CAPB3oo1(10)&CAPB3OO1(9)&CAPB3oo1(8)&CAPB3Oo1(7)&CAPB3oo1(6)&CAPB3OO1(5)&CAPB3OO1(4)&CAPB3oo1(3)&CAPB3oo1(2)&CAPB3oo1(1)&((CAPB3OO1(0) or CAPB3OLOL(0)) or CAPB3lool(2));

constant CAPB3OIol: std_logic_vector(15 downto 0) := CAPB3LO1(15)&CAPB3LO1(14)&CAPB3lo1(13)&CAPB3lo1(12)&CAPB3LO1(11)&CAPB3LO1(10)&CAPB3lo1(9)&CAPB3lo1(8)&CAPB3lo1(7)&CAPB3LO1(6)&CAPB3lo1(5)&CAPB3lo1(4)&CAPB3lo1(3)&CAPB3LO1(2)&((CAPB3lo1(1)) or CAPB3lool(3))&CAPB3lo1(0);

constant CAPB3LIOL: Std_logic_vector(15 downto 0) := CAPB3IO1(15)&CAPB3IO1(14)&CAPB3IO1(13)&CAPB3io1(12)&CAPB3io1(11)&CAPB3IO1(10)&CAPB3io1(9)&CAPB3io1(8)&CAPB3io1(7)&CAPB3IO1(6)&CAPB3IO1(5)&CAPB3io1(4)&CAPB3io1(3)&((CAPB3io1(2) or CAPB3olol(2)) or CAPB3LOOL(4))&CAPB3IO1(1)&CAPB3IO1(0);

constant CAPB3iiol: STD_LOGIC_VECTOR(15 downto 0) := CAPB3OL1(15)&CAPB3ol1(14)&CAPB3ol1(13)&CAPB3ol1(12)&CAPB3ol1(11)&CAPB3OL1(10)&CAPB3oL1(9)&CAPB3OL1(8)&CAPB3ol1(7)&CAPB3OL1(6)&CAPB3OL1(5)&CAPB3ol1(4)&((CAPB3OL1(3) or CAPB3OLOL(3)) or CAPB3LOOL(5))&CAPB3OL1(2)&CAPB3ol1(1)&CAPB3OL1(0);

constant CAPB3o0oL: std_logic_veCTOR(15 downto 0) := CAPB3ll1(15)&CAPB3ll1(14)&CAPB3ll1(13)&CAPB3LL1(12)&CAPB3ll1(11)&CAPB3ll1(10)&CAPB3LL1(9)&CAPB3ll1(8)&CAPB3ll1(7)&CAPB3ll1(6)&CAPB3ll1(5)&((CAPB3LL1(4) or CAPB3olol(4)) or CAPB3lool(6))&CAPB3ll1(3)&CAPB3ll1(2)&CAPB3ll1(1)&CAPB3ll1(0);

constant CAPB3L0OL: STD_Logic_vector(15 downto 0) := CAPB3il1(15)&CAPB3IL1(14)&CAPB3IL1(13)&CAPB3il1(12)&CAPB3il1(11)&CAPB3il1(10)&CAPB3IL1(9)&CAPB3il1(8)&CAPB3il1(7)&CAPB3il1(6)&((CAPB3IL1(5) or CAPB3OLol(5)) or CAPB3lool(7))&CAPB3IL1(4)&CAPB3il1(3)&CAPB3il1(2)&CAPB3il1(1)&CAPB3il1(0);

constant CAPB3I0OL: STD_LOGIC_VEctor(15 downto 0) := CAPB3oi1(15)&CAPB3oi1(14)&CAPB3oi1(13)&CAPB3oi1(12)&CAPB3OI1(11)&CAPB3OI1(10)&CAPB3oi1(9)&CAPB3oi1(8)&CAPB3OI1(7)&((CAPB3oi1(6) or CAPB3olol(6)) or CAPB3lool(8))&CAPB3oi1(5)&CAPB3oi1(4)&CAPB3oi1(3)&CAPB3OI1(2)&CAPB3oi1(1)&CAPB3oi1(0);

constant CAPB3o1ol: STD_LOGIC_VECTOr(15 downto 0) := CAPB3li1(15)&CAPB3LI1(14)&CAPB3LI1(13)&CAPB3li1(12)&CAPB3li1(11)&CAPB3li1(10)&CAPB3LI1(9)&CAPB3LI1(8)&((CAPB3LI1(7) or CAPB3olol(7)) or CAPB3LOOL(9))&CAPB3LI1(6)&CAPB3LI1(5)&CAPB3LI1(4)&CAPB3li1(3)&CAPB3LI1(2)&CAPB3lI1(1)&CAPB3li1(0);

constant CAPB3L1OL: STD_LOGIC_VECTor(15 downto 0) := CAPB3ii1(15)&CAPB3II1(14)&CAPB3ii1(13)&CAPB3iI1(12)&CAPB3II1(11)&CAPB3ii1(10)&CAPB3II1(9)&((CAPB3ii1(8) or CAPB3olol(8)) or CAPB3lool(10))&CAPB3ii1(7)&CAPB3ii1(6)&CAPB3II1(5)&CAPB3II1(4)&CAPB3ii1(3)&CAPB3ii1(2)&CAPB3ii1(1)&CAPB3II1(0);

constant CAPB3i1ol: STd_logic_vector(15 downto 0) := CAPB3o01(15)&CAPB3o01(14)&CAPB3o01(13)&CAPB3O01(12)&CAPB3O01(11)&CAPB3o01(10)&((CAPB3o01(9) or CAPB3olol(9)) or CAPB3lOOL(11))&CAPB3O01(8)&CAPB3o01(7)&CAPB3O01(6)&CAPB3o01(5)&CAPB3o01(4)&CAPB3o01(3)&CAPB3O01(2)&CAPB3o01(1)&CAPB3O01(0);

constant CAPB3ooll: STD_LOGIC_VECTOR(15 downto 0) := CAPB3l01(15)&CAPB3l01(14)&CAPB3l01(13)&CAPB3l01(12)&CAPB3l01(11)&((CAPB3L01(10) or CAPB3olol(10)) or CAPB3LOOL(12))&CAPB3l01(9)&CAPB3L01(8)&CAPB3l01(7)&CAPB3L01(6)&CAPB3l01(5)&CAPB3L01(4)&CAPB3L01(3)&CAPB3l01(2)&CAPB3l01(1)&CAPB3L01(0);

constant CAPB3LOll: STD_LOGIC_VEctor(15 downto 0) := CAPB3I01(15)&CAPB3i01(14)&CAPB3I01(13)&CAPB3i01(12)&((CAPB3i01(11) or CAPB3olol(11)) or CAPB3LOOL(13))&CAPB3I01(10)&CAPB3i01(9)&CAPB3i01(8)&CAPB3I01(7)&CAPB3I01(6)&CAPB3I01(5)&CAPB3i01(4)&CAPB3I01(3)&CAPB3i01(2)&CAPB3i01(1)&CAPB3i01(0);

constant CAPB3iOLL: std_logic_vector(15 downto 0) := CAPB3o11(15)&CAPB3o11(14)&CAPB3O11(13)&((CAPB3o11(12) or CAPB3OLOL(12)) or CAPB3lool(14))&CAPB3O11(11)&CAPB3o11(10)&CAPB3o11(9)&CAPB3O11(8)&CAPB3O11(7)&CAPB3O11(6)&CAPB3O11(5)&CAPB3o11(4)&CAPB3O11(3)&CAPB3o11(2)&CAPB3o11(1)&CAPB3o11(0);

constant CAPB3OLLL: std_logic_vector(15 downto 0) := CAPB3L11(15)&CAPB3l11(14)&((CAPB3L11(13) or CAPB3OLOL(13)) or CAPB3lool(15))&CAPB3l11(12)&CAPB3l11(11)&CAPB3l11(10)&CAPB3l11(9)&CAPB3l11(8)&CAPB3l11(7)&CAPB3l11(6)&CAPB3l11(5)&CAPB3l11(4)&CAPB3l11(3)&CAPB3l11(2)&CAPB3l11(1)&CAPB3L11(0);

constant CAPB3llll: STD_logic_vector(15 downto 0) := CAPB3i11(15)&((CAPB3i11(14) or CAPB3olOL(14)) or CAPB3lool(16))&CAPB3i11(13)&CAPB3I11(12)&CAPB3i11(11)&CAPB3i11(10)&CAPB3I11(9)&CAPB3I11(8)&CAPB3I11(7)&CAPB3I11(6)&CAPB3i11(5)&CAPB3i11(4)&CAPB3i11(3)&CAPB3I11(2)&CAPB3I11(1)&CAPB3i11(0);

constant CAPB3ILLL: std_logic_vectoR(15 downto 0) := ((CAPB3OOOL(15) or CAPB3OLOL(15)) or CAPB3LOol(17))&CAPB3Oool(14)&CAPB3OOOL(13)&CAPB3oool(12)&CAPB3OOOl(11)&CAPB3oool(10)&CAPB3oool(9)&CAPB3oool(8)&CAPB3ooOL(7)&CAPB3OOOL(6)&CAPB3OOOL(5)&CAPB3oool(4)&CAPB3oool(3)&CAPB3oool(2)&CAPB3oool(1)&CAPB3oool(0);

component CAPB3li
port (CAPB3II: in std_logic_veCTOR(16 downto 0);
PRDATAS0: in STD_logic_vector(31 downto 0);
PRDATAS1: in std_logIC_VECTOR(31 downto 0);
PRDATAS2: in std_logic_vector(31 downto 0);
prdataS3: in stD_LOGIC_VECTOR(31 downto 0);
prdatas4: in STD_logic_vector(31 downto 0);
prdatAS5: in std_logic_vector(31 downto 0);
prdatAS6: in STD_LOGIC_VECtor(31 downto 0);
PRDATAS7: in STD_LOGIC_VECTOR(31 downto 0);
prdatas8: in std_logic_vector(31 downto 0);
prdatas9: in std_LOGIC_VECTOR(31 downto 0);
PRdatas10: in STD_LOGIC_VEctor(31 downto 0);
prdatas11: in STD_LOGIC_VECTOR(31 downto 0);
Prdatas12: in STD_LOGIC_vector(31 downto 0);
PRDATas13: in STD_LOGIC_Vector(31 downto 0);
PRDATAS14: in std_loGIC_VECTOR(31 downto 0);
PRDATAS15: in std_logiC_VECTOR(31 downto 0);
PRDATAS16: in STD_logic_vector(31 downto 0);
CAPB3O0: in STD_Logic_vector(16 downto 0);
CAPB3L0: in std_logic_vectOR(16 downto 0);
pready: out std_logic;
pslverr: out std_logic;
prdata: out std_logic_vectoR(31 downto 0));
end component;

component CAPB3o
generic (SYNC_RESET: INTEGER := 0;
apb_dwidth: integeR range 8 to 32;
MADdr_bits: inTEGER range 12 to 32);
port (PCLK: in std_logic;
presetn: in STD_LOGIC;
PENABLE: in STd_logic;
psel: in std_logic;
paddr: in STD_LOGIC_Vector(31 downto 0);
pwrite: in std_logic;
pwdata: in std_logIC_VECTOR(31 downto 0);
prdata: out STD_LOGIC_vector(31 downto 0);
CAPB3l: out STD_LOgic_vector(31 downto 0));
end component;

signal CAPB3LOI: STD_LOgic_vector(31 downto 0);

signal CAPB3OIll: STD_logic_vector(31 downto 0);

signal CAPB3lill: std_logic_vector(31 downto 0);

signal CAPB3iill: STD_LOGIC_VECTOR(31 downto 0);

signal CAPB3o0ll: std_logic_vector(31 downto 0);

signal CAPB3L0ll: std_logic_vector(31 downto 0);

signal CAPB3i0ll: std_logic_VECTOR(31 downto 0);

signal CAPB3O1LL: STD_LOGIC_VECTOr(31 downto 0);

signal CAPB3L1LL: sTD_LOGIC_VECTOR(31 downto 0);

signal CAPB3i1ll: STD_LOGIc_vector(31 downto 0);

signal CAPB3OOIL: std_logic_vector(31 downto 0);

signal CAPB3loil: STD_LOGIC_VECTOR(31 downto 0);

signal CAPB3ioil: std_logic_vector(31 downto 0);

signal CAPB3olil: STd_logic_vector(31 downto 0);

signal CAPB3LLIL: std_logic_vector(31 downto 0);

signal CAPB3ILIL: std_logic_vector(31 downto 0);

signal CAPB3oiil: Std_logic_vector(31 downto 0);

signal CAPB3liiL: std_logic_vector(31 downto 0);

signal CAPB3iiil: STD_LOGIC_vector(15 downto 0);

signal CAPB3O0IL: std_logic_vector(15 downto 0);

signal CAPB3l0il: std_logic_vector(15 downto 0);

signal CAPB3i0il: std_loGIC_VECTOR(15 downto 0);

signal CAPB3o1il: STD_LOGIC_VECTOR(3 downto 0);

signal CAPB3l: STD_LOGIC_VECTor(31 downto 0);

signal CAPB3L1IL: STD_LOgic_vector(31 downto 0);

signal CAPB3i1iL: std_logic_VECTOR(31 downto 0);

signal CAPB3OO0l: std_logic_vector(16 downto 0);

signal CAPB3lo0l: std_logic_vecTOR(16 downto 0);

signal CAPB3io0l: STD_LOGIc_vector(16 downto 0);

signal CAPB3OL0L: std_logic;

signal CAPB3LL0L: std_logic_vecTOR(31 downto 0);

signal CAPB3il0l: std_logic;

signal CAPB3oi0l: std_logic;

begin
CAPB3LL0L <= ( others => '0');
CAPB3IL0L <= '1';
CAPB3oi0L <= '0';
pwrites <= PWRITE;
penables <= penable;
PWDATAS <= PWDATA;
CAPB3O1IL <= PADDR((Maddr_bits-1) downto (maddr_bits-4));
process (Psel,CAPB3O1Il)
begin
if (psel = '1') then
case CAPB3o1il is
when "0000" =>
CAPB3i0il <= CAPB3ILOL;
when "0001" =>
CAPB3i0il <= CAPB3oiol;
when "0010" =>
CAPB3I0IL <= CAPB3LIOL;
when "0011" =>
CAPB3I0IL <= CAPB3iiol;
when "0100" =>
CAPB3I0IL <= CAPB3o0ol;
when "0101" =>
CAPB3i0IL <= CAPB3l0ol;
when "0110" =>
CAPB3i0il <= CAPB3I0ol;
when "0111" =>
CAPB3i0il <= CAPB3o1OL;
when "1000" =>
CAPB3i0il <= CAPB3L1OL;
when "1001" =>
CAPB3I0IL <= CAPB3i1ol;
when "1010" =>
CAPB3I0il <= CAPB3oOLL;
when "1011" =>
CAPB3I0IL <= CAPB3LOLL;
when "1100" =>
CAPB3i0il <= CAPB3ioll;
when "1101" =>
CAPB3I0IL <= CAPB3olll;
when "1110" =>
CAPB3i0il <= CAPB3llll;
when "1111" =>
CAPB3i0il <= CAPB3illl;
when others =>
CAPB3I0IL <= ( others => '0');
end case;
else
CAPB3I0IL <= ( others => '0');
end if;
end process;
CAPB3l0il(15) <= CAPB3i0il(15) and not (CAPB3LLOL(15));
CAPB3l0il(14) <= CAPB3I0IL(14) and not (CAPB3LLOL(14));
CAPB3l0il(13) <= CAPB3i0il(13) and not (CAPB3LLOL(13));
CAPB3L0IL(12) <= CAPB3I0IL(12) and not (CAPB3llol(12));
CAPB3L0IL(11) <= CAPB3i0il(11) and not (CAPB3llol(11));
CAPB3L0IL(10) <= CAPB3I0il(10) and not (CAPB3llol(10));
CAPB3l0il(9) <= CAPB3i0il(9) and not (CAPB3llol(9));
CAPB3l0il(8) <= CAPB3I0IL(8) and not (CAPB3LLOL(8));
CAPB3l0il(7) <= CAPB3i0il(7) and not (CAPB3llol(7));
CAPB3L0IL(6) <= CAPB3I0IL(6) and not (CAPB3llol(6));
CAPB3l0il(5) <= CAPB3i0il(5) and not (CAPB3llol(5));
CAPB3l0il(4) <= CAPB3I0IL(4) and not (CAPB3llol(4));
CAPB3L0IL(3) <= CAPB3i0il(3) and not (CAPB3llol(3));
CAPB3L0il(2) <= CAPB3i0il(2) and not (CAPB3llol(2));
CAPB3l0il(1) <= CAPB3i0il(1) and not (CAPB3LLOL(1));
CAPB3l0IL(0) <= CAPB3I0IL(0) and not (CAPB3llol(0));
CAPB3ol0l <= (CAPB3I0Il(15) and CAPB3llol(15)) or (CAPB3I0IL(14) and CAPB3LLOL(14))
or (CAPB3i0IL(13) and CAPB3llol(13))
or (CAPB3i0il(12) and CAPB3LLOL(12))
or (CAPB3i0il(11) and CAPB3LLOL(11))
or (CAPB3i0il(10) and CAPB3llol(10))
or (CAPB3I0Il(9) and CAPB3LLOL(9))
or (CAPB3i0il(8) and CAPB3LLOl(8))
or (CAPB3i0il(7) and CAPB3llol(7))
or (CAPB3i0il(6) and CAPB3LLOL(6))
or (CAPB3i0il(5) and CAPB3LLOL(5))
or (CAPB3I0il(4) and CAPB3llol(4))
or (CAPB3i0il(3) and CAPB3llol(3))
or (CAPB3i0il(2) and CAPB3LLOL(2))
or (CAPB3i0il(1) and CAPB3llol(1))
or (CAPB3i0il(0) and CAPB3llol(0));
PSELS16 <= CAPB3ol0l;
CAPB3LI0L:
if (iADDR_OPTION = CAPB3I1I)
generate
CAPB3oill(31 downto 0) <= CAPB3LIIL(31 downto 0);
end generate;
CAPB3II0L:
if (not (IADDR_OPTION = CAPB3i1i))
generate
CAPB3o00l:
if (Apbslot0enable = 1)
generate
CAPB3oill(31 downto 0) <= Prdatas0(31 downto 0);
end generate;
CAPB3L00L:
if (not (APBSLOT0ENable = 1))
generate
CAPB3oill(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3I00L:
if (IADDR_OPTIOn = CAPB3oo0)
generate
CAPB3LILL(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3o10l:
if (not (iaddr_option = CAPB3OO0))
generate
CAPB3l10l:
if (apbslot1eNABLE = 1)
generate
CAPB3LILL(31 downto 0) <= prdatas1(31 downto 0);
end generate;
CAPB3i10l:
if (not (apbslot1enable = 1))
generate
CAPB3lill(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3oo1l:
if (IADdr_option = CAPB3lo0)
generate
CAPB3iilL(31 downto 0) <= CAPB3liIL(31 downto 0);
end generate;
CAPB3lo1l:
if (not (IADDR_Option = CAPB3lo0))
generate
CAPB3io1l:
if (apbslot2enable = 1)
generate
CAPB3iill(31 downto 0) <= PRdatas2(31 downto 0);
end generate;
CAPB3ol1l:
if (not (APBSLOT2Enable = 1))
generate
CAPB3IILL(31 downto 0) <= CAPB3ll0l(31 downto 0);
end generate;
end generate;
CAPB3ll1l:
if (IADDR_OPTION = CAPB3io0)
generate
CAPB3O0LL(31 downto 0) <= CAPB3LIIL(31 downto 0);
end generate;
CAPB3IL1L:
if (not (IADDR_OPTION = CAPB3io0))
generate
CAPB3oi1l:
if (APBSLOT3enable = 1)
generate
CAPB3O0ll(31 downto 0) <= PRDATAS3(31 downto 0);
end generate;
CAPB3LI1L:
if (not (apbslot3enable = 1))
generate
CAPB3o0ll(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3iI1L:
if (IADDR_OPTION = CAPB3ol0)
generate
CAPB3L0LL(31 downto 0) <= CAPB3LIIL(31 downto 0);
end generate;
CAPB3O01L:
if (not (IADDR_OPTION = CAPB3OL0))
generate
CAPB3l01l:
if (Apbslot4enable = 1)
generate
CAPB3l0ll(31 downto 0) <= PRDATAS4(31 downto 0);
end generate;
CAPB3i01l:
if (not (APbslot4enable = 1))
generate
CAPB3l0ll(31 downto 0) <= CAPB3Ll0l(31 downto 0);
end generate;
end generate;
CAPB3O11L:
if (iaddr_option = CAPB3ll0)
generate
CAPB3I0LL(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3L11L:
if (not (iaddr_option = CAPB3ll0))
generate
CAPB3I11l:
if (apbSLOT5ENABLE = 1)
generate
CAPB3i0ll(31 downto 0) <= PRDATAS5(31 downto 0);
end generate;
CAPB3oooi:
if (not (apbslot5enABLE = 1))
generate
CAPB3I0ll(31 downto 0) <= CAPB3ll0l(31 downto 0);
end generate;
end generate;
CAPB3LOOI:
if (IADDR_option = CAPB3il0)
generate
CAPB3o1ll(31 downto 0) <= CAPB3LIIL(31 downto 0);
end generate;
CAPB3iooi:
if (not (iaddr_OPTION = CAPB3IL0))
generate
CAPB3OLOI:
if (apbslot6enable = 1)
generate
CAPB3o1ll(31 downto 0) <= PRDATAs6(31 downto 0);
end generate;
CAPB3lloi:
if (not (apbslot6enablE = 1))
generate
CAPB3O1LL(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3iloi:
if (IADDR_OPTION = CAPB3oi0)
generate
CAPB3l1ll(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3OIOI:
if (not (IADDR_OPTIOn = CAPB3oi0))
generate
CAPB3LIOI:
if (APBSLOT7ENABLe = 1)
generate
CAPB3L1LL(31 downto 0) <= prdatas7(31 downto 0);
end generate;
CAPB3iioi:
if (not (apbslot7enable = 1))
generate
CAPB3l1ll(31 downto 0) <= CAPB3lL0L(31 downto 0);
end generate;
end generate;
CAPB3o0oi:
if (iaddr_option = CAPB3LI0)
generate
CAPB3i1ll(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3L0OI:
if (not (IADDR_OPTION = CAPB3LI0))
generate
CAPB3I0OI:
if (APBSLOT8ENABLE = 1)
generate
CAPB3i1ll(31 downto 0) <= prdatas8(31 downto 0);
end generate;
CAPB3O1OI:
if (not (APBSLOT8ENable = 1))
generate
CAPB3i1ll(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3l1oi:
if (IADDR_OPTION = CAPB3Ii0)
generate
CAPB3ooil(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3i1oi:
if (not (IADDR_OPTION = CAPB3II0))
generate
CAPB3ooli:
if (apbslot9enable = 1)
generate
CAPB3OOIL(31 downto 0) <= PRDatas9(31 downto 0);
end generate;
CAPB3LOLI:
if (not (apbslot9ENABLE = 1))
generate
CAPB3ooil(31 downto 0) <= CAPB3ll0l(31 downto 0);
end generate;
end generate;
CAPB3ioli:
if (Iaddr_option = CAPB3O00)
generate
CAPB3loil(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3olli:
if (not (iaddr_option = CAPB3o00))
generate
CAPB3LLLI:
if (apbsloT10ENABLE = 1)
generate
CAPB3loil(31 downto 0) <= prdatas10(31 downto 0);
end generate;
CAPB3ILLI:
if (not (apbslot10ENABLE = 1))
generate
CAPB3LOIL(31 downto 0) <= CAPB3ll0l(31 downto 0);
end generate;
end generate;
CAPB3oili:
if (IADDR_option = CAPB3l00)
generate
CAPB3Ioil(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3lili:
if (not (iaddr_option = CAPB3l00))
generate
CAPB3iili:
if (apbslot11enable = 1)
generate
CAPB3IOIL(31 downto 0) <= prdatas11(31 downto 0);
end generate;
CAPB3o0li:
if (not (APBSLOT11ENABLE = 1))
generate
CAPB3iOIL(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3L0LI:
if (IADDr_option = CAPB3i00)
generate
CAPB3olil(31 downto 0) <= CAPB3Liil(31 downto 0);
end generate;
CAPB3I0LI:
if (not (iaddr_option = CAPB3i00))
generate
CAPB3o1li:
if (APBSLOt12enable = 1)
generate
CAPB3olil(31 downto 0) <= prdatas12(31 downto 0);
end generate;
CAPB3l1li:
if (not (APBSLOT12ENABLe = 1))
generate
CAPB3olil(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3i1li:
if (iaddr_option = CAPB3O10)
generate
CAPB3LLIL(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3ooii:
if (not (IADDR_OPTION = CAPB3o10))
generate
CAPB3LOII:
if (APBSLOT13ENABLE = 1)
generate
CAPB3llil(31 downto 0) <= prdatas13(31 downto 0);
end generate;
CAPB3IOII:
if (not (APbslot13enable = 1))
generate
CAPB3LLIL(31 downto 0) <= CAPB3ll0l(31 downto 0);
end generate;
end generate;
CAPB3OLII:
if (iaddr_option = CAPB3L10)
generate
CAPB3ILIL(31 downto 0) <= CAPB3liil(31 downto 0);
end generate;
CAPB3llii:
if (not (iaddr_option = CAPB3L10))
generate
CAPB3ILII:
if (APBSLOT14ENABLE = 1)
generate
CAPB3ILIL(31 downto 0) <= prdatas14(31 downto 0);
end generate;
CAPB3OIII:
if (not (APBSLOT14ENABLE = 1))
generate
CAPB3ILIL(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3LIII:
if (iaddr_option = CAPB3I10)
generate
CAPB3oiil(31 downto 0) <= CAPB3LIIL(31 downto 0);
end generate;
CAPB3iiii:
if (not (IADDR_OPTION = CAPB3i10))
generate
CAPB3O0II:
if (apbslot15enable = 1)
generate
CAPB3oiil(31 downto 0) <= PRDATAS15(31 downto 0);
end generate;
CAPB3L0II:
if (not (APBSLOT15ENABLE = 1))
generate
CAPB3OIIL(31 downto 0) <= CAPB3LL0L(31 downto 0);
end generate;
end generate;
CAPB3I0II:
if (iaddr_OPTION = CAPB3i1i)
generate
CAPB3iiil(0) <= CAPB3IL0L;
end generate;
CAPB3O1ii:
if (not (iaddr_option = CAPB3i1i))
generate
CAPB3L1II:
if (APBSLOT0ENABLE = 1)
generate
CAPB3iiil(0) <= preadys0;
end generate;
CAPB3I1II:
if (not (apbslot0enable = 1))
generate
CAPB3iiil(0) <= CAPB3IL0L;
end generate;
end generate;
CAPB3oo0i:
if (iaddr_optioN = CAPB3oo0)
generate
CAPB3IIIL(1) <= CAPB3IL0L;
end generate;
CAPB3Lo0i:
if (not (iaddr_option = CAPB3OO0))
generate
CAPB3io0i:
if (apbslot1enable = 1)
generate
CAPB3iiil(1) <= preadys1;
end generate;
CAPB3ol0i:
if (not (APBSLOT1ENAble = 1))
generate
CAPB3iiil(1) <= CAPB3IL0L;
end generate;
end generate;
CAPB3ll0i:
if (IADDR_OPTION = CAPB3lo0)
generate
CAPB3iiiL(2) <= CAPB3il0l;
end generate;
CAPB3il0i:
if (not (iaddr_option = CAPB3lo0))
generate
CAPB3oi0i:
if (apbslot2enABLE = 1)
generate
CAPB3IIIL(2) <= preadys2;
end generate;
CAPB3li0i:
if (not (apbslot2enable = 1))
generate
CAPB3IIIL(2) <= CAPB3IL0L;
end generate;
end generate;
CAPB3ii0i:
if (iaddr_option = CAPB3IO0)
generate
CAPB3iiil(3) <= CAPB3il0l;
end generate;
CAPB3O00I:
if (not (iaddr_option = CAPB3IO0))
generate
CAPB3L00I:
if (APBSLOT3ENABLE = 1)
generate
CAPB3iiil(3) <= preadys3;
end generate;
CAPB3i00i:
if (not (apbslot3enABLE = 1))
generate
CAPB3iiil(3) <= CAPB3IL0L;
end generate;
end generate;
CAPB3o10i:
if (iaddr_optION = CAPB3OL0)
generate
CAPB3IIIL(4) <= CAPB3il0l;
end generate;
CAPB3l10i:
if (not (IADDR_OPTion = CAPB3ol0))
generate
CAPB3I10I:
if (Apbslot4enable = 1)
generate
CAPB3IIIL(4) <= PREADYS4;
end generate;
CAPB3oo1i:
if (not (APBSLOt4enable = 1))
generate
CAPB3iiil(4) <= CAPB3IL0L;
end generate;
end generate;
CAPB3lo1i:
if (IADDR_OPTION = CAPB3ll0)
generate
CAPB3iiil(5) <= CAPB3IL0L;
end generate;
CAPB3io1i:
if (not (iaddr_option = CAPB3ll0))
generate
CAPB3OL1I:
if (apbslot5enablE = 1)
generate
CAPB3IIIL(5) <= preadys5;
end generate;
CAPB3ll1i:
if (not (apbslot5ENABLE = 1))
generate
CAPB3iiil(5) <= CAPB3il0l;
end generate;
end generate;
CAPB3IL1I:
if (IADDR_OPTIon = CAPB3il0)
generate
CAPB3iiil(6) <= CAPB3IL0L;
end generate;
CAPB3OI1I:
if (not (Iaddr_option = CAPB3il0))
generate
CAPB3LI1i:
if (APBSLOT6ENAble = 1)
generate
CAPB3iiil(6) <= PREADYS6;
end generate;
CAPB3II1I:
if (not (apBSLOT6ENABLE = 1))
generate
CAPB3iiil(6) <= CAPB3IL0L;
end generate;
end generate;
CAPB3O01I:
if (IADDR_OPTION = CAPB3OI0)
generate
CAPB3IIIL(7) <= CAPB3il0l;
end generate;
CAPB3L01I:
if (not (iaddr_option = CAPB3oi0))
generate
CAPB3I01I:
if (APBSLOT7ENABle = 1)
generate
CAPB3iiil(7) <= preadys7;
end generate;
CAPB3O11I:
if (not (apbsLOT7ENABLE = 1))
generate
CAPB3iiil(7) <= CAPB3IL0L;
end generate;
end generate;
CAPB3l11i:
if (IADDR_OPTION = CAPB3li0)
generate
CAPB3IIIL(8) <= CAPB3IL0L;
end generate;
CAPB3I11I:
if (not (iaddr_optION = CAPB3li0))
generate
CAPB3OOO0:
if (apbsLOT8ENABLE = 1)
generate
CAPB3iiiL(8) <= preadys8;
end generate;
CAPB3loo0:
if (not (APBSLOT8ENABLE = 1))
generate
CAPB3IIIL(8) <= CAPB3IL0L;
end generate;
end generate;
CAPB3ioo0:
if (iaddr_OPTION = CAPB3II0)
generate
CAPB3IIIL(9) <= CAPB3il0l;
end generate;
CAPB3OLO0:
if (not (IADDR_OPTIOn = CAPB3II0))
generate
CAPB3llo0:
if (apbslot9enable = 1)
generate
CAPB3iiil(9) <= PREADYS9;
end generate;
CAPB3ilo0:
if (not (apbslot9enable = 1))
generate
CAPB3IIIL(9) <= CAPB3IL0l;
end generate;
end generate;
CAPB3oio0:
if (iaddr_option = CAPB3o00)
generate
CAPB3iiil(10) <= CAPB3il0l;
end generate;
CAPB3lio0:
if (not (IADDR_OPTION = CAPB3o00))
generate
CAPB3iio0:
if (APBSlot10enable = 1)
generate
CAPB3IIIL(10) <= preadys10;
end generate;
CAPB3o0o0:
if (not (APBSLOT10ENABLE = 1))
generate
CAPB3IIIL(10) <= CAPB3IL0L;
end generate;
end generate;
CAPB3l0o0:
if (IADDR_OPTION = CAPB3L00)
generate
CAPB3IIIL(11) <= CAPB3il0l;
end generate;
CAPB3i0o0:
if (not (IADDR_OPTION = CAPB3L00))
generate
CAPB3o1o0:
if (apbslot11ENABLE = 1)
generate
CAPB3IIil(11) <= preadys11;
end generate;
CAPB3L1O0:
if (not (apbslot11enable = 1))
generate
CAPB3IIIL(11) <= CAPB3il0l;
end generate;
end generate;
CAPB3i1o0:
if (iaddr_option = CAPB3i00)
generate
CAPB3IIIL(12) <= CAPB3il0l;
end generate;
CAPB3ool0:
if (not (IADDR_OPtion = CAPB3i00))
generate
CAPB3lOL0:
if (APBSLOT12Enable = 1)
generate
CAPB3iiil(12) <= PReadys12;
end generate;
CAPB3iol0:
if (not (apbslot12ENABLE = 1))
generate
CAPB3iiil(12) <= CAPB3il0l;
end generate;
end generate;
CAPB3oll0:
if (IADDR_OPTION = CAPB3O10)
generate
CAPB3IIIL(13) <= CAPB3IL0L;
end generate;
CAPB3LLL0:
if (not (IADDR_OPTION = CAPB3O10))
generate
CAPB3ILL0:
if (APBSLOT13ENABLE = 1)
generate
CAPB3iiil(13) <= PREadys13;
end generate;
CAPB3oil0:
if (not (APBSLOT13ENABLE = 1))
generate
CAPB3iiil(13) <= CAPB3IL0L;
end generate;
end generate;
CAPB3LIL0:
if (iadDR_OPTION = CAPB3l10)
generate
CAPB3iiil(14) <= CAPB3IL0L;
end generate;
CAPB3IIL0:
if (not (iaddR_OPTION = CAPB3l10))
generate
CAPB3O0L0:
if (apbslot14eNABLE = 1)
generate
CAPB3IIIL(14) <= PREADYS14;
end generate;
CAPB3l0l0:
if (not (APBSLOT14enable = 1))
generate
CAPB3iiil(14) <= CAPB3il0l;
end generate;
end generate;
CAPB3i0l0:
if (iaddr_option = CAPB3I10)
generate
CAPB3Iiil(15) <= CAPB3IL0L;
end generate;
CAPB3o1l0:
if (not (IADDr_option = CAPB3i10))
generate
CAPB3l1l0:
if (APBSLOT15ENABLe = 1)
generate
CAPB3IIIL(15) <= PREADYS15;
end generate;
CAPB3i1l0:
if (not (apbslot15ENABLE = 1))
generate
CAPB3IIIL(15) <= CAPB3il0l;
end generate;
end generate;
CAPB3OOI0:
if (IADDr_option = CAPB3i1I)
generate
CAPB3o0il(0) <= CAPB3OI0L;
end generate;
CAPB3LOI0:
if (not (IADDR_OPTION = CAPB3I1I))
generate
CAPB3IOi0:
if (apbslot0enable = 1)
generate
CAPB3O0IL(0) <= pslverrs0;
end generate;
CAPB3oli0:
if (not (Apbslot0enable = 1))
generate
CAPB3o0il(0) <= CAPB3oi0l;
end generate;
end generate;
CAPB3LLI0:
if (iaddr_oPTION = CAPB3oo0)
generate
CAPB3o0il(1) <= CAPB3oi0l;
end generate;
CAPB3ILI0:
if (not (iaddr_oPTION = CAPB3oo0))
generate
CAPB3oii0:
if (APBSLOT1ENABLE = 1)
generate
CAPB3o0il(1) <= pslverrs1;
end generate;
CAPB3lii0:
if (not (apbsloT1ENABLE = 1))
generate
CAPB3O0IL(1) <= CAPB3OI0L;
end generate;
end generate;
CAPB3III0:
if (iaddr_option = CAPB3Lo0)
generate
CAPB3o0il(2) <= CAPB3OI0L;
end generate;
CAPB3O0I0:
if (not (iaddr_option = CAPB3LO0))
generate
CAPB3L0I0:
if (APBSLOT2ENAble = 1)
generate
CAPB3o0il(2) <= pslverrs2;
end generate;
CAPB3i0i0:
if (not (apbslot2enable = 1))
generate
CAPB3o0il(2) <= CAPB3oi0l;
end generate;
end generate;
CAPB3o1i0:
if (iaddr_option = CAPB3IO0)
generate
CAPB3O0IL(3) <= CAPB3OI0L;
end generate;
CAPB3l1i0:
if (not (iaDDR_OPTION = CAPB3io0))
generate
CAPB3I1I0:
if (APBSLot3enable = 1)
generate
CAPB3o0il(3) <= PSLVERRS3;
end generate;
CAPB3oo00:
if (not (apbSLOT3ENABLE = 1))
generate
CAPB3O0IL(3) <= CAPB3OI0L;
end generate;
end generate;
CAPB3lo00:
if (iaddr_OPTION = CAPB3OL0)
generate
CAPB3o0il(4) <= CAPB3OI0L;
end generate;
CAPB3IO00:
if (not (IADDR_OPTION = CAPB3ol0))
generate
CAPB3ol00:
if (APBSLOT4ENABLe = 1)
generate
CAPB3O0IL(4) <= PSLVERRS4;
end generate;
CAPB3ll00:
if (not (apbslot4ENABLE = 1))
generate
CAPB3o0il(4) <= CAPB3Oi0l;
end generate;
end generate;
CAPB3il00:
if (IADDR_OPTION = CAPB3ll0)
generate
CAPB3O0IL(5) <= CAPB3OI0L;
end generate;
CAPB3oi00:
if (not (IADDR_OPTIon = CAPB3LL0))
generate
CAPB3li00:
if (apbslot5enable = 1)
generate
CAPB3o0iL(5) <= PSLVErrs5;
end generate;
CAPB3ii00:
if (not (apbslot5enable = 1))
generate
CAPB3O0IL(5) <= CAPB3oi0L;
end generate;
end generate;
CAPB3O000:
if (iaddr_option = CAPB3IL0)
generate
CAPB3o0il(6) <= CAPB3oi0l;
end generate;
CAPB3l000:
if (not (Iaddr_option = CAPB3IL0))
generate
CAPB3I000:
if (apbslot6enable = 1)
generate
CAPB3o0iL(6) <= pslveRRS6;
end generate;
CAPB3O100:
if (not (APBSLOT6ENABLE = 1))
generate
CAPB3o0il(6) <= CAPB3oi0l;
end generate;
end generate;
CAPB3L100:
if (iaddr_option = CAPB3oi0)
generate
CAPB3o0il(7) <= CAPB3oi0L;
end generate;
CAPB3i100:
if (not (iADDR_OPTION = CAPB3OI0))
generate
CAPB3OO10:
if (APBSLOT7ENABLE = 1)
generate
CAPB3o0il(7) <= pslverrs7;
end generate;
CAPB3lo10:
if (not (apbslot7enable = 1))
generate
CAPB3O0IL(7) <= CAPB3oi0l;
end generate;
end generate;
CAPB3io10:
if (IADDR_OPTION = CAPB3LI0)
generate
CAPB3O0IL(8) <= CAPB3oi0l;
end generate;
CAPB3ol10:
if (not (IADDR_OPTION = CAPB3li0))
generate
CAPB3ll10:
if (apbslot8ENABLE = 1)
generate
CAPB3o0il(8) <= pslverrs8;
end generate;
CAPB3il10:
if (not (apbsLOT8ENABLE = 1))
generate
CAPB3O0IL(8) <= CAPB3oi0l;
end generate;
end generate;
CAPB3oi10:
if (IADDR_OPTION = CAPB3II0)
generate
CAPB3O0IL(9) <= CAPB3oi0l;
end generate;
CAPB3li10:
if (not (Iaddr_option = CAPB3ii0))
generate
CAPB3II10:
if (apbslot9enable = 1)
generate
CAPB3O0IL(9) <= pslverrs9;
end generate;
CAPB3o010:
if (not (apbslot9enable = 1))
generate
CAPB3o0il(9) <= CAPB3Oi0l;
end generate;
end generate;
CAPB3L010:
if (IADDR_OPTion = CAPB3O00)
generate
CAPB3o0il(10) <= CAPB3OI0L;
end generate;
CAPB3i010:
if (not (IAddr_option = CAPB3o00))
generate
CAPB3o110:
if (APBSLOT10enable = 1)
generate
CAPB3o0il(10) <= PSLVErrs10;
end generate;
CAPB3L110:
if (not (APBslot10enable = 1))
generate
CAPB3o0il(10) <= CAPB3oi0l;
end generate;
end generate;
CAPB3i110:
if (IADDR_OPTION = CAPB3l00)
generate
CAPB3o0il(11) <= CAPB3OI0L;
end generate;
CAPB3OOO1:
if (not (iaddr_optION = CAPB3L00))
generate
CAPB3loo1:
if (apbslot11enable = 1)
generate
CAPB3o0il(11) <= pslverrs11;
end generate;
CAPB3Ioo1:
if (not (APBSLOT11ENAble = 1))
generate
CAPB3O0IL(11) <= CAPB3oi0l;
end generate;
end generate;
CAPB3olo1:
if (iaddr_option = CAPB3i00)
generate
CAPB3o0il(12) <= CAPB3oi0l;
end generate;
CAPB3LLO1:
if (not (iaddr_option = CAPB3i00))
generate
CAPB3ilo1:
if (apbslot12ENABLE = 1)
generate
CAPB3o0il(12) <= PSLVERRS12;
end generate;
CAPB3OIO1:
if (not (APBSLOT12Enable = 1))
generate
CAPB3O0IL(12) <= CAPB3oi0l;
end generate;
end generate;
CAPB3lio1:
if (IADDR_OPTION = CAPB3o10)
generate
CAPB3o0il(13) <= CAPB3OI0L;
end generate;
CAPB3iio1:
if (not (iaddr_oPTION = CAPB3O10))
generate
CAPB3o0o1:
if (APBSLOT13enable = 1)
generate
CAPB3o0il(13) <= PSLVERRS13;
end generate;
CAPB3l0o1:
if (not (apbsloT13ENABLE = 1))
generate
CAPB3O0IL(13) <= CAPB3oi0l;
end generate;
end generate;
CAPB3i0o1:
if (IADDR_OPTION = CAPB3L10)
generate
CAPB3O0IL(14) <= CAPB3oi0l;
end generate;
CAPB3O1O1:
if (not (iaddr_option = CAPB3l10))
generate
CAPB3L1O1:
if (APBSLOT14enable = 1)
generate
CAPB3O0IL(14) <= Pslverrs14;
end generate;
CAPB3i1o1:
if (not (apbsLOT14ENABLE = 1))
generate
CAPB3o0il(14) <= CAPB3OI0L;
end generate;
end generate;
CAPB3OOL1:
if (IADDR_OPTION = CAPB3I10)
generate
CAPB3o0il(15) <= CAPB3OI0L;
end generate;
CAPB3loL1:
if (not (iaddr_option = CAPB3i10))
generate
CAPB3iol1:
if (APBSLOT15ENAble = 1)
generate
CAPB3o0il(15) <= PSLVERrs15;
end generate;
CAPB3OLL1:
if (not (APBSLOT15ENABLE = 1))
generate
CAPB3o0il(15) <= CAPB3OI0L;
end generate;
end generate;
CAPB3OO0L <= CAPB3ol0l&CAPB3L0IL(15 downto 0);
CAPB3lo0l <= PREADYS16&CAPB3iiil(15 downto 0);
CAPB3io0l <= PSLVERRS16&CAPB3o0il(15 downto 0);
CAPB3lll1: CAPB3LI
port map (CAPB3II => CAPB3oo0l,
prdatas0 => CAPB3OILL(31 downto 0),
Prdatas1 => CAPB3LIll(31 downto 0),
PRDatas2 => CAPB3iill(31 downto 0),
PRDATAS3 => CAPB3o0ll(31 downto 0),
prdatas4 => CAPB3l0ll(31 downto 0),
PRDAtas5 => CAPB3i0ll(31 downto 0),
prdatas6 => CAPB3O1LL(31 downto 0),
prdatas7 => CAPB3l1ll(31 downto 0),
PRDAtas8 => CAPB3i1ll(31 downto 0),
PRDATAS9 => CAPB3ooil(31 downto 0),
PRDATAS10 => CAPB3LOIL(31 downto 0),
prdatas11 => CAPB3IOIL(31 downto 0),
PRDATAS12 => CAPB3olil(31 downto 0),
prdatas13 => CAPB3llil(31 downto 0),
prdatas14 => CAPB3ILIL(31 downto 0),
prdatas15 => CAPB3OIIL(31 downto 0),
prdatas16 => PRDATAS16(31 downto 0),
CAPB3o0 => CAPB3lo0l,
CAPB3l0 => CAPB3io0l,
pready => pready,
pslverr => PSLVERR,
pRDATA => CAPB3loi(31 downto 0));
PRDATa(31 downto 0) <= CAPB3loi(31 downto 0);
CAPB3ILL1:
if (not (IADDR_OPTION = CAPB3I1I))
generate
psels0 <= CAPB3L0IL(0);
end generate;
CAPB3oil1:
if (IADDr_option = CAPB3I1I)
generate
PSELs0 <= '0';
end generate;
CAPB3lil1:
if (not (IADDR_OPTION = CAPB3oo0))
generate
PSELS1 <= CAPB3l0il(1);
end generate;
CAPB3iil1:
if (iaddr_option = CAPB3oo0)
generate
psels1 <= '0';
end generate;
CAPB3o0l1:
if (not (iaddr_optiON = CAPB3lo0))
generate
psels2 <= CAPB3l0il(2);
end generate;
CAPB3L0L1:
if (iaddr_option = CAPB3LO0)
generate
PSELS2 <= '0';
end generate;
CAPB3i0l1:
if (not (iaddr_option = CAPB3io0))
generate
psels3 <= CAPB3L0IL(3);
end generate;
CAPB3o1l1:
if (IADDR_OPTION = CAPB3io0)
generate
PSELS3 <= '0';
end generate;
CAPB3l1l1:
if (not (iADDR_OPTION = CAPB3ol0))
generate
psels4 <= CAPB3l0il(4);
end generate;
CAPB3I1L1:
if (iaddr_optiON = CAPB3ol0)
generate
psels4 <= '0';
end generate;
CAPB3OOI1:
if (not (IADDR_option = CAPB3LL0))
generate
PSELS5 <= CAPB3L0IL(5);
end generate;
CAPB3LOI1:
if (IADDR_OPTIon = CAPB3ll0)
generate
PSELS5 <= '0';
end generate;
CAPB3ioI1:
if (not (IADDR_OPTION = CAPB3il0))
generate
PSELS6 <= CAPB3l0il(6);
end generate;
CAPB3oli1:
if (iaddr_option = CAPB3il0)
generate
PSELS6 <= '0';
end generate;
CAPB3lli1:
if (not (iaddr_option = CAPB3oi0))
generate
psels7 <= CAPB3L0IL(7);
end generate;
CAPB3ili1:
if (iaddr_option = CAPB3OI0)
generate
psels7 <= '0';
end generate;
CAPB3oii1:
if (not (iADDR_OPTION = CAPB3LI0))
generate
psels8 <= CAPB3l0il(8);
end generate;
CAPB3lii1:
if (iaddr_optiON = CAPB3LI0)
generate
psels8 <= '0';
end generate;
CAPB3iii1:
if (not (iaddr_option = CAPB3II0))
generate
psels9 <= CAPB3L0IL(9);
end generate;
CAPB3O0i1:
if (Iaddr_option = CAPB3II0)
generate
PSELS9 <= '0';
end generate;
CAPB3l0i1:
if (not (IADDR_Option = CAPB3O00))
generate
psels10 <= CAPB3l0il(10);
end generate;
CAPB3i0i1:
if (iaddr_option = CAPB3o00)
generate
PSELS10 <= '0';
end generate;
CAPB3O1I1:
if (not (iaddr_OPTION = CAPB3l00))
generate
PSels11 <= CAPB3l0il(11);
end generate;
CAPB3L1I1:
if (iaDDR_OPTION = CAPB3L00)
generate
psels11 <= '0';
end generate;
CAPB3i1i1:
if (not (Iaddr_option = CAPB3I00))
generate
PSELS12 <= CAPB3L0IL(12);
end generate;
CAPB3OO01:
if (iaddr_optiON = CAPB3I00)
generate
PSELS12 <= '0';
end generate;
CAPB3lo01:
if (not (iaddr_option = CAPB3o10))
generate
psels13 <= CAPB3l0il(13);
end generate;
CAPB3io01:
if (IADDr_option = CAPB3o10)
generate
pSELS13 <= '0';
end generate;
CAPB3ol01:
if (not (iaddr_OPTION = CAPB3L10))
generate
PSELS14 <= CAPB3l0il(14);
end generate;
CAPB3ll01:
if (iaddr_optioN = CAPB3L10)
generate
psels14 <= '0';
end generate;
CAPB3IL01:
if (not (iaddr_option = CAPB3i10))
generate
psels15 <= CAPB3l0il(15);
end generate;
CAPB3oi01:
if (iaddr_option = CAPB3I10)
generate
psels15 <= '0';
end generate;
CAPB3li01:
if (iaddr_option = CAPB3o1i)
generate
CAPB3l <= ( others => '0');
end generate;
CAPB3ii01:
if (iaddr_optiON = CAPB3l1i)
generate
CAPB3L <= ( others => '0');
end generate;
CAPB3o001:
if (iaddr_option = CAPB3i1i)
generate
CAPB3L001: CAPB3o
generic map (sync_reset,
apb_dwidth,
MAddr_bits)
port map (PCLK,
PRESETN,
PENABLE,
CAPB3L0IL(0),
paddr,
pwrite,
pwdata,
CAPB3liil,
CAPB3l);
end generate;
CAPB3I001:
if (iaddR_OPTION = CAPB3oo0)
generate
CAPB3L001: CAPB3o
generic map (SYNC_RESET,
APB_DWIDTH,
MADDR_BITS)
port map (pclk,
presetN,
Penable,
CAPB3L0IL(1),
paddr,
PWRITE,
pwDATA,
CAPB3liil,
CAPB3l);
end generate;
CAPB3O101:
if (Iaddr_option = CAPB3LO0)
generate
CAPB3L001: CAPB3o
generic map (syNC_RESET,
apb_dwidth,
maddr_bits)
port map (PCLK,
PRESETN,
PENABLE,
CAPB3l0il(2),
PADDR,
pwRITE,
pwdaTA,
CAPB3LIIL,
CAPB3l);
end generate;
CAPB3l101:
if (iaddr_opTION = CAPB3io0)
generate
CAPB3l001: CAPB3o
generic map (sync_RESET,
apb_dwidth,
maddr_bits)
port map (PCLK,
PRESETN,
PENABLE,
CAPB3L0IL(3),
paddr,
PWRITE,
pwdata,
CAPB3liil,
CAPB3L);
end generate;
CAPB3i101:
if (iaddR_OPTION = CAPB3OL0)
generate
CAPB3l001: CAPB3o
generic map (synC_RESET,
apb_dwidth,
MADdr_bits)
port map (PCLK,
preseTN,
PENABLE,
CAPB3L0IL(4),
paddr,
pwritE,
pwdata,
CAPB3liil,
CAPB3L);
end generate;
CAPB3oo11:
if (iadDR_OPTION = CAPB3ll0)
generate
CAPB3L001: CAPB3o
generic map (sync_reset,
APB_DWIDTH,
madDR_BITS)
port map (pclk,
Presetn,
penable,
CAPB3L0il(5),
PADDR,
pwrite,
pwdATA,
CAPB3liil,
CAPB3L);
end generate;
CAPB3LO11:
if (IADdr_option = CAPB3IL0)
generate
CAPB3l001: CAPB3o
generic map (syNC_RESET,
apb_dwidth,
MADDR_BITS)
port map (PCLK,
PRESETN,
penabLE,
CAPB3l0il(6),
paddr,
PWRITE,
pwdata,
CAPB3liil,
CAPB3l);
end generate;
CAPB3io11:
if (IADDR_OPTION = CAPB3OI0)
generate
CAPB3L001: CAPB3o
generic map (SYNC_RESET,
Apb_dwidth,
maddr_bits)
port map (PCLK,
presetn,
penabLE,
CAPB3l0il(7),
PADdr,
pwrite,
PWdata,
CAPB3liil,
CAPB3l);
end generate;
CAPB3ol11:
if (iaddr_optION = CAPB3li0)
generate
CAPB3l001: CAPB3o
generic map (sync_reSET,
APB_dwidth,
MADDR_BITS)
port map (PCLk,
PRESETN,
PENABLE,
CAPB3l0il(8),
PADDR,
pwrite,
pwdata,
CAPB3liil,
CAPB3l);
end generate;
CAPB3ll11:
if (IADDR_OPTIOn = CAPB3II0)
generate
CAPB3l001: CAPB3o
generic map (SYNC_RESET,
apb_dwidth,
MADDR_BITS)
port map (PCLK,
presetn,
penable,
CAPB3l0il(9),
paddr,
PWRITE,
pwdata,
CAPB3Liil,
CAPB3L);
end generate;
CAPB3IL11:
if (IADDR_option = CAPB3o00)
generate
CAPB3L001: CAPB3o
generic map (sync_reset,
APB_DWIDTH,
maddr_bits)
port map (PCLK,
PRESETN,
penable,
CAPB3L0IL(10),
paddr,
PWRITE,
pwdata,
CAPB3LIIL,
CAPB3L);
end generate;
CAPB3OI11:
if (IADdr_option = CAPB3L00)
generate
CAPB3l001: CAPB3o
generic map (sync_reset,
apb_dwidth,
maddr_bits)
port map (PCLK,
PRESETN,
penable,
CAPB3l0il(11),
pADDR,
PWRite,
PWDATA,
CAPB3LIIl,
CAPB3l);
end generate;
CAPB3LI11:
if (IADDR_OPTIOn = CAPB3I00)
generate
CAPB3l001: CAPB3o
generic map (SYNC_RESET,
apb_dwidth,
maddr_bits)
port map (PCLK,
presetn,
penable,
CAPB3L0Il(12),
paddr,
pwrite,
pwdata,
CAPB3LIIL,
CAPB3L);
end generate;
CAPB3ii11:
if (IADDR_OPTION = CAPB3O10)
generate
CAPB3l001: CAPB3o
generic map (SYNC_RESET,
APB_Dwidth,
maddr_bits)
port map (pclk,
PResetn,
penable,
CAPB3l0il(13),
PADDR,
pwrite,
pwdata,
CAPB3liil,
CAPB3L);
end generate;
CAPB3O011:
if (IADDR_OPTION = CAPB3L10)
generate
CAPB3l001: CAPB3O
generic map (SYNC_RESET,
apb_dwidth,
maddr_bits)
port map (pclk,
PRESETN,
PENABLE,
CAPB3l0il(14),
paddr,
PWRITe,
pwdata,
CAPB3LIIL,
CAPB3l);
end generate;
CAPB3L011:
if (IADDR_OPTION = CAPB3i10)
generate
CAPB3L001: CAPB3O
generic map (sync_reset,
apb_dwidth,
maddr_bits)
port map (pclk,
PRESETN,
PENABLE,
CAPB3L0IL(15),
PADDR,
PWRITE,
PWDATA,
CAPB3liil,
CAPB3l);
end generate;
CAPB3i011:
if (iaddr_option = CAPB3O1I)
generate
CAPB3i1il <= PADDr;
CAPB3l1il <= ( others => '0');
end generate;
CAPB3o111:
if (IADDR_OPtion = CAPB3l1I)
generate
CAPB3I1Il <= iadDR;
CAPB3l1il <= IADDR;
end generate;
CAPB3l111:
if (IADDR_OPTION > CAPB3l1i)
generate
CAPB3i1il <= CAPB3l;
CAPB3l1il <= CAPB3L;
end generate;
CAPB3i111:
if (MADDR_BITS = 12)
generate
process (CAPB3i1IL,CAPB3l1il,PADDR)
begin
case uPR_NIBBLE_POSN is
when 2 =>
padDRS <= CAPB3i1il(31 downto 12)&Paddr(11 downto 0);
when 3 =>
paddrs <= CAPB3I1IL(31 downto 16)&PADDR(11 downto 8)&CAPB3l1il(11 downto 8)&PADDR(7 downto 0);
when 4 =>
paddrs <= CAPB3i1il(31 downto 20)&PAddr(11 downto 8)&CAPB3l1IL(15 downto 8)&paddr(7 downto 0);
when 5 =>
paddRS <= CAPB3I1IL(31 downto 24)&paddR(11 downto 8)&CAPB3l1il(19 downto 8)&PADDR(7 downto 0);
when 6 =>
PADDRS <= CAPB3i1il(31 downto 28)&PADDR(11 downto 8)&CAPB3l1il(23 downto 8)&pADDR(7 downto 0);
when 7 =>
paddRS <= paddr(11 downto 8)&CAPB3l1il(27 downto 8)&paddr(7 downto 0);
when 8 =>
Paddrs <= CAPB3L1IL(31 downto 8)&PADDR(7 downto 0);
when others =>
PADDRS <= paddr;
end case;
end process;
end generate;
CAPB3ooool:
if (maddr_bits = 16)
generate
process (CAPB3I1IL,CAPB3l1il,PADDR)
begin
case UPR_nibble_posn is
when 2 =>
PADDRS <= CAPB3i1il(31 downto 16)&paddr(15 downto 0);
when 3 =>
paddrs <= CAPB3I1IL(31 downto 16)&paddr(15 downto 0);
when 4 =>
paddrs <= CAPB3i1il(31 downto 20)&PADDR(15 downto 12)&CAPB3l1il(15 downto 12)&Paddr(11 downto 0);
when 5 =>
padDRS <= CAPB3I1IL(31 downto 24)&paddr(15 downto 12)&CAPB3L1il(19 downto 12)&paddr(11 downto 0);
when 6 =>
paddrs <= CAPB3i1il(31 downto 28)&paddr(15 downto 12)&CAPB3l1il(23 downto 12)&paddr(11 downto 0);
when 7 =>
Paddrs <= paddr(15 downto 12)&CAPB3l1il(27 downto 12)&PAddr(11 downto 0);
when 8 =>
paddrs <= CAPB3l1il(31 downto 12)&PADDR(11 downto 0);
when others =>
PADDRS <= paddr;
end case;
end process;
end generate;
CAPB3LOOOL:
if (Maddr_bits = 20)
generate
process (CAPB3i1il,CAPB3L1IL,paddr)
begin
case Upr_nibble_posn is
when 2 =>
PADDRS <= CAPB3I1IL(31 downto 20)&PADDR(19 downto 0);
when 3 =>
paddrs <= CAPB3i1il(31 downto 20)&paddr(19 downto 0);
when 4 =>
PADDRS <= CAPB3i1il(31 downto 20)&PADDR(19 downto 0);
when 5 =>
paddrs <= CAPB3i1il(31 downto 24)&paddr(19 downto 16)&CAPB3l1il(19 downto 16)&PADDR(15 downto 0);
when 6 =>
paddrs <= CAPB3I1IL(31 downto 28)&PADdr(19 downto 16)&CAPB3L1IL(23 downto 16)&paddr(15 downto 0);
when 7 =>
paddrs <= PADDR(19 downto 16)&CAPB3L1IL(27 downto 16)&PADDR(15 downto 0);
when 8 =>
paddrs <= CAPB3L1Il(31 downto 16)&paddr(15 downto 0);
when others =>
PAddrs <= PADDr;
end case;
end process;
end generate;
CAPB3IOOOL:
if (Maddr_bits = 24)
generate
process (CAPB3i1il,CAPB3l1il,PADdr)
begin
case upr_nibble_posn is
when 2 =>
PADDRS <= CAPB3i1il(31 downto 24)&PAddr(23 downto 0);
when 3 =>
PADDRS <= CAPB3i1il(31 downto 24)&paddr(23 downto 0);
when 4 =>
paddRS <= CAPB3i1iL(31 downto 24)&PADDR(23 downto 0);
when 5 =>
paddrs <= CAPB3i1il(31 downto 24)&paddr(23 downto 0);
when 6 =>
PAddrs <= CAPB3I1il(31 downto 28)&paddr(23 downto 20)&CAPB3L1il(23 downto 20)&PADDR(19 downto 0);
when 7 =>
PADDRS <= PADDR(23 downto 20)&CAPB3L1IL(27 downto 20)&paddr(19 downto 0);
when 8 =>
PADDRS <= CAPB3l1il(31 downto 20)&paddr(19 downto 0);
when others =>
PADDRS <= PADDR;
end case;
end process;
end generate;
CAPB3OLOOL:
if (maddr_bits = 28)
generate
process (CAPB3i1il,CAPB3L1IL,paddr)
begin
case upr_nibble_posn is
when 2 =>
PADDRS <= CAPB3i1il(31 downto 28)&PADDR(27 downto 0);
when 3 =>
paddrs <= CAPB3I1IL(31 downto 28)&PADDr(27 downto 0);
when 4 =>
PADDRS <= CAPB3i1il(31 downto 28)&paddr(27 downto 0);
when 5 =>
PADDRS <= CAPB3i1il(31 downto 28)&Paddr(27 downto 0);
when 6 =>
paddrs <= CAPB3i1il(31 downto 28)&paddr(27 downto 0);
when 7 =>
PADDRS <= PADDR(27 downto 24)&CAPB3l1il(27 downto 24)&pADDR(23 downto 0);
when 8 =>
paddrs <= CAPB3L1il(31 downto 24)&PADdr(23 downto 0);
when others =>
PADdrs <= PADDR;
end case;
end process;
end generate;
CAPB3llool:
if (MADDR_BITS = 32)
generate
PADDrs <= paddr(31 downto 0);
end generate;
end architecture CAPB3lli;
