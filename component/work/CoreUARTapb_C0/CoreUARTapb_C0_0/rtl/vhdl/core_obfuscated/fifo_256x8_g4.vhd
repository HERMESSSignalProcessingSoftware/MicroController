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
library IEEE;
use ieee.std_LOGIC_1164.all;
library smartfusION2;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_256X8 is
generic (sync_RESET: integer := 0); port (CUARToool: out STD_LOGIC_VECTOR(7 downto 0);
CUARTLOOL: in STD_LOGIC;
CUARTIOOL: in STD_LOGIC;
CUARTolol: in STD_LOGIC_VECTOR(7 downto 0);
WRB: in std_logic;
RDB: in std_logic;
RESET: in STD_LOGic;
full: out std_logic;
empty: out STD_LOGIC);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_256X8;

architecture CUARTLOL of CoreUARTapb_C0_CoreUARTapb_C0_0_fiFO_256X8 is

component CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_CTRL_128
generic (sync_RESET: integer := 0;
CUARToo0L: INTEGER := 7;
CUARTLO0L: INTEGer := 8;
CUARTi1il: integer := 128);
port (CUARTio0l: in stD_LOGIC;
RESET_N: in std_logic;
DATA_IN: in std_LOGIC_VECTOR(CUARTlo0l-1 downto 0);
CUARTOL0L: in std_logic;
CUARTll0l: in STD_LOGIC;
CUARTIL0L: in std_logic_VECTOR(CUARTOO0L-1 downto 0);
dATA_OUT: out std_logic_VECTOR(CUARTlo0l-1 downto 0);
full: out STD_LOGIC;
empty: out std_logic;
CUARToi0l: out STD_LOGIC);
end component;

constant CUARTIL0L: std_logIC_VECTOR(6 downto 0) := "0100000";

signal aempty: Std_logic;

signal afull: STD_LOGIC;

signal CUARTli0l: STD_LOGIC_VECTOR(7 downto 0);

signal CUARTii0l: STD_LOGIC;

signal CUARTo00l: STD_LOGic;

signal geqth: STD_LOGIC;

begin
CUARToool <= CUARTli0l;
FULL <= CUARTII0L;
EMPTY <= CUARTo00L;
CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_128X8_PA4: CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_ctrl_128
generic map (Sync_reset => SYNC_RESET)
port map (data_in => CUARTolol,
data_out => CUARTli0l,
CUARTll0L => Wrb,
CUARTol0L => RDB,
CUARTio0l => CUARTiool,
full => CUARTii0l,
empty => CUARTo00l,
CUARToi0l => geqth,
RESET_N => resET,
CUARTIL0L => CUARTIl0l);
end architecture CUARTlol;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.STD_logic_unsigned.all;
use IEEE.std_logic_arith.all;
library SMARTFUSION2;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_CTRL_128 is
generic (SYNC_RESET: INTEGER := 0;
CUARTI1IL: INTEGER := 128;
CUARTOO0L: inTEGER := 7;
CUARTLO0L: intEGER := 8); port (CUARTIO0L: in STD_LOGIC;
RESET_N: in std_logic;
DATA_IN: in std_lOGIC_VECTOR(CUARTLO0L-1 downto 0);
CUARTOL0l: in std_logiC;
CUARTLl0l: in STD_LOGIC;
CUARTIL0L: in STd_logic_vector(CUARToo0l-1 downto 0);
DATA_OUT: out std_logic_vECTOR(CUARTlo0l-1 downto 0);
full: out STD_LOgic;
empty: out std_logic;
CUARToi0l: out std_logic);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_CTRL_128;

architecture CUARTlol of CoreUARTapb_C0_CoreUARTapb_C0_0_Fifo_ctrl_128 is

component CoreUARTapb_C0_CoreUARTapb_C0_0_RAM128X8_Pa4
port (CUARTo1oi: in STd_logic_vector(7 downto 0);
CUARTl1oI: out STD_LOGIC_Vector(7 downto 0);
CUARTi1oi: in STD_LOGIC_VECTOR(6 downto 0);
CUARTOOLI: in std_logic_vector(6 downto 0);
CUARTloli: in STd_logic;
CUARTIOOL: in STd_logic;
RESET_N: in STD_Logic;
CUARTlool: in STD_LOGIC);
end component;

signal CUARTOL1L: std_LOGIC_VECTOR(CUARTlo0l-1 downto 0);

signal CUARTll1l: STD_Logic;

signal CUARTIL1L: sTD_LOGIC_VECTOR(CUARToo0l-1 downto 0);

signal CUARTOi1l: STD_LOGIC_VECTOR(CUARTOO0L-1 downto 0);

signal CUARTLi1l: STD_LOGIC_VECTOR(CUARToo0l-1 downto 0);

signal CUARTII1L: std_logic;

signal CUARTo01L: STD_logic;

signal CUARTo00: STD_logic;

signal CUARTL01L: std_logic_vectoR(CUARTlo0L-1 downto 0);

signal CUARTII0L: std_logic;

signal CUARTo00l: STD_LOGIC;

signal CUARTi01l: STD_LOGIC;

signal CUARTII: std_lOGIC;

signal CUARTO0: std_logic;

begin
CUARTii <= '1' when (SYNC_reset = 1) else
reset_n;
CUARTo0 <= RESET_N when (sync_resET = 1) else
'1';
DATA_OUT <= CUARTL01L;
full <= CUARTII0L;
EMPTY <= CUARTO00L;
CUARTOI0L <= CUARTi01l;
CUARTII1L <= '1' when (CUARTil1l = conv_std_logic_vecTOR(CUARTi1il-1,
7)) else
'0';
CUARTII0L <= CUARTII1L;
CUARTo01l <= '1' when (CUARTIL1L = "0000000") else
'0';
CUARTO00L <= CUARTo01l;
CUARTo00 <= '1' when (CUARTil1l >= CUARTIL0L) else
'0';
CUARTI01L <= CUARTo00;
process (CUARTIO0L,CUARTii)
begin
if (not CUARTii = '1') then
CUARToi1l <= ( others => '0');
CUARTLI1L <= ( others => '0');
CUARTIL1L <= ( others => '0');
elsif (CUARTio0l'evenT and CUARTio0l = '1') then
if (not CUARTo0 = '1') then
CUARToi1l <= ( others => '0');
CUARTli1l <= ( others => '0');
CUARTIl1l <= ( others => '0');
else
if (not CUARTol0l = '1') then
if (CUARTll0l = '1') then
CUARTil1l <= CUARTIL1L-"0000001";
end if;
if (CUARTOI1L = conv_std_lOGIC_VECTOR(CUARTi1il-1,
7)) then
CUARTOi1l <= ( others => '0');
else
CUARToi1L <= CUARTOI1L+"0000001";
end if;
end if;
if (not CUARTLL0L = '1') then
if (CUARTol0l = '1') then
CUARTIl1l <= CUARTIL1L+"0000001";
end if;
if (CUARTLI1L = CONV_STD_LOGIC_VECTor(CUARTI1Il-1,
7)) then
CUARTLI1l <= ( others => '0');
else
CUARTli1l <= CUARTli1l+"0000001";
end if;
end if;
end if;
end if;
end process;
process (CUARTIO0L,CUARTii)
begin
if (not CUARTii = '1') then
CUARTll1l <= '0';
elsif (CUARTIO0L'event and CUARTIO0L = '1') then
if (not CUARTo0 = '1') then
CUARTLL1l <= '0';
else
CUARTLL1L <= CUARTol0l;
if (CUARTll1l = '0') then
CUARTL01L <= CUARTOl1l;
else
CUARTl01l <= CUARTL01L;
end if;
end if;
end if;
end process;
CUARTLLII: CoreUARTapb_C0_CoreUARTapb_C0_0_ram128x8_pa4
port map (CUARTo1oi => data_in,
CUARTl1oi => CUARTOL1L,
CUARTi1oi => CUARTLI1l,
CUARTOOLI => CUARToi1l,
CUARTloli => CUARTLL0L,
Reset_n => RESET_n,
CUARTioOL => CUARTio0l,
CUARTlool => CUARTIO0L);
end architecture CUARTLOL;

library ieee;
use ieee.STD_LOGIC_1164.all;
library SMARTFusion2;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_ram128x8_pa4 is
port (CUARTo1oi: in std_logic_vector(7 downto 0);
CUARTL1OI: out std_logIC_VECTOR(7 downto 0);
CUARTi1oi: in STD_LOGIC_Vector(6 downto 0);
CUARTOOLI: in std_logic_vector(6 downto 0);
CUARTloli: in STD_LOGIC;
reseT_N: in STD_LOGIC;
CUARTiool: in STD_LOGIC;
CUARTlool: in std_logic);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_RAM128X8_PA4;

architecture CUARTlol of CoreUARTapb_C0_CoreUARTapb_C0_0_RAM128X8_PA4 is

component inv
port (A: in STD_logic := 'U';
y: out std_logic);
end component;

component RAM64X18
port (a_dout: out STD_LOGIC_VECTOR(17 downto 0);
b_dout: out std_logic_vectoR(17 downto 0);
BUSY: out std_LOGIC;
A_ADdr_clk: in STD_logic;
a_dout_clk: in std_logic;
a_addr_srst_n: in std_logic;
a_dout_srst_n: in std_logic;
A_ADDR_ARST_N: in STD_LOGIC;
A_DOUt_arst_n: in STD_LOGIC;
A_ADDR_EN: in std_logic;
a_dout_eN: in std_logic;
a_blk: in Std_logic_vector(1 downto 0);
A_ADDR: in STD_LOGIC_vector(9 downto 0);
b_addr_clk: in STD_logic;
B_dout_clk: in STD_LOGIC;
B_ADDR_SRST_N: in std_LOGIC;
b_doUT_SRST_N: in std_logic;
b_addr_arst_n: in STD_LOGIc;
b_dout_arst_n: in STD_LOGIC;
B_ADDr_en: in STD_LOGIC;
B_DOUT_EN: in std_logic;
b_blk: in STD_LOGic_vector(1 downto 0);
b_addr: in std_logic_vectOR(9 downto 0);
c_clk: in STD_LOGIC;
C_ADDR: in std_logic_VECTOR(9 downto 0);
c_din: in std_logic_vector(17 downto 0);
C_WEn: in STD_LOGIC;
c_blk: in Std_logic_vector(1 downto 0);
A_EN: in std_logIC;
a_addr_LAT: in std_logic;
a_dout_lat: in STD_LOGIC;
a_width: in STD_LOGIC_VECTOR(2 downto 0);
B_EN: in std_logic;
B_ADDr_lat: in STD_LOGIC;
B_DOUT_LAT: in std_logIC;
b_width: in STD_LOGIC_VECTOR(2 downto 0);
C_en: in std_logiC;
c_wIDTH: in STD_LOGIC_vector(2 downto 0);
sii_lock: in STD_LOGIC);
end component;

component VCC
port (Y: out STD_LOGIC);
end component;

component gnd
port (Y: out STD_LOGIC);
end component;

signal CUARTOLLI: std_logic;

signal CUARTllli: STD_LOGIC;

signal CUARTILLI: std_loGIC;

signal CUARToili: STD_LOGic;

signal CUARTILII: STD_LOGIC_VECtor(17 downto 0);

signal CUARToiii: std_logic_vector(9 downto 0);

signal CUARTliii: STD_LOGIC_VEctor(9 downto 0);

signal CUARTiiii: STD_Logic_vector(17 downto 0);

begin
CUARTiili: VCC
port map (y => CUARTILLI);
CUARTo0li: gnd
port map (Y => CUARToili);
CUARTl0li: inv
port map (A => CUARTLOLI,
Y => CUARTLLLI);
CUARTL1OI <= CUARTILII(7 downto 0);
CUARToiii <= CUARTOOLI&"000";
CUARTliii <= CUARTI1OI&"000";
CUARTiiii <= "0000000000"&CUARTo1oi;
CUARTo0ii: RAM64X18
port map (a_dout => CUARTILII,
b_dout => open ,
BUSY => open ,
a_addr_clk => CUARTlool,
A_Dout_clk => CUARTILli,
a_addr_srst_N => CUARTILLI,
a_dout_srst_n => CUARTilli,
a_addr_ARST_N => CUARTilli,
a_dout_arst_n => CUARTilli,
a_addr_EN => CUARTILLI,
a_dout_en => CUARTilli,
a_blk => "11",
A_ADDR => CUARToiii,
B_ADDR_CLK => CUARTilli,
b_douT_CLK => CUARTilli,
b_addr_srst_N => CUARTilli,
B_DOUt_srst_n => CUARTilli,
B_ADDR_ARST_N => CUARTilli,
B_DOut_arst_n => CUARTilli,
b_addr_en => CUARTilli,
B_DOUt_en => CUARTILLI,
b_blk => "00",
B_ADDR => "0000000000",
c_CLK => CUARTiool,
c_addr => CUARTliii,
c_din => CUARTiiii,
C_WEN => CUARTLLLI,
c_blk => "11",
A_EN => CUARTilli,
A_ADDR_LAT => CUARTOILI,
A_DOUT_LAT => CUARTilli,
b_en => CUARTOIli,
b_addr_lat => CUARTOILI,
b_douT_LAT => CUARTilli,
c_en => CUARTILLI,
A_WIDTH => "011",
B_WIDTH => "011",
C_WIDTH => "011",
SII_LOCK => CUARTOILI);
end architecture CUARTLOL;
