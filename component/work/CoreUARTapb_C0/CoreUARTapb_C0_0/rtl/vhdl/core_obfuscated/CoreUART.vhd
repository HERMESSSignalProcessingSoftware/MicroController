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
use ieeE.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use IEEE.sTD_LOGIC_UNSIGNED.all;
use WORK.CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART_PKG.all;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART is
generic (family: integer := 15;
TX_FIFO: integer := 0;
RX_FIFO: INTEGER := 0;
rx_legacy_mode: integer := 0;
bAUD_VAL_FRCTN_EN: INTEger := 0); port (reset_N: in STD_LOGIC;
CLK: in std_logic;
WEN: in std_logic;
OEn: in std_logiC;
Csn: in std_lOGIC;
DATA_IN: in STD_LOGIC_VECTOR(7 downto 0);
rx: in std_LOGIC;
BAUD_VAL: in STD_LOGIC_VECTOR(12 downto 0);
BIT8: in STD_logic;
parity_en: in std_logic;
ODD_N_EVEN: in std_logic;
baud_val_fractioN: in std_logic_vector(2 downto 0);
parity_ERR: out std_logic;
overflow: out STD_LOGIC;
Txrdy: out std_logic;
RXRDY: out std_logic;
data_out: out std_logic_vecTOR(7 downto 0);
TX: out STd_logic;
FRAMING_ERR: out STD_LOGic);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART;

architecture CUARTLOL of CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART is

constant CUARTiol: STD_LOgic_vector(1 downto 0) := "00";

constant CUARTOLL: STD_LOGIC_VECTOr(1 downto 0) := "01";

constant CUARTlll: STD_LOGIC_VECtor(1 downto 0) := "10";

constant CUARTiLL: std_LOGIC_VECTOR(1 downto 0) := "11";

constant SYNc_reset: integer := SYNC_MODE_SEL(FAMILY);

signal CUARToil: std_logic;

signal CUARTlil: std_logic;

signal CUARTiil: STD_LOgic;

signal CUARTO0L: std_LOGIC;

signal CUARTL: std_logic;

signal CUARTo: std_logic;

signal CUARTl0l: STD_LOGIC;

signal CUARTi0l: STD_logic_vector(7 downto 0);

signal CUARTo1l: std_logic_vector(7 downto 0);

signal CUARTl1l: std_logic_vector(7 downto 0);

signal CUARTi1l: std_logic;

signal CUARTOOI: STD_LOGIC_VECTor(7 downto 0);

signal CUARTLOi: STD_LOGic_vector(7 downto 0);

signal CUARTioi: std_logic_vector(7 downto 0);

signal CUARTOLi: STD_LOGIC;

signal CUARTlli: STD_LOGic;

signal CUARTili: STD_LOGIC;

signal CUARTOII: std_lOGIC;

signal CUARTLII: std_logic;

signal CUARTiii: STD_LOGIC;

signal CUARTo0i: std_logic;

signal CUARTl0i: STD_Logic;

signal CUARTi0i: STD_logic;

signal CUARTo1i: STD_LOGIC;

signal CUARTL1I: STD_LOGIC;

signal CUARTi1i: STD_LOGIC;

signal CUARTOO0: stD_LOGIC;

signal CUARTlo0: STD_LOGIC;

signal CUARTio0: STD_LOGIC;

signal CUARTol0: STD_LOGIC;

signal CUARTll0: STD_LOGIC;

signal CUARTil0: STD_LOGIc;

signal CUARTOI0: sTD_LOGIC;

signal CUARTli0: STD_LOGIc;

signal CUARTII0: std_logic;

signal CUARTo00: STD_LOGIC;

signal CUARTl00: STD_LOGIc;

signal CUARTI00: std_logic;

signal CUARTo10: STD_LOGic;

signal CUARTl10: STD_LOGIC;

signal CUARTi10: STD_LOgic_vector(7 downto 0);

signal CUARToo1: STD_logic;

signal CUARTlo1: STD_LOGIC;

signal CUARTio1: STD_LOGIc;

signal CUARTOL1: std_logic;

signal CUARTll1: STD_LOGic;

signal CUARTil1: STD_LOGIC;

signal CUARTOI1: STD_LOGIC_VECTOR(7 downto 0);

signal CUARTLI1: STD_LOGIC;

signal CUARTII1: std_logic;

signal CUARTo01: std_LOGIC_VECTOR(1 downto 0);

signal CUARTl01: STd_logic_vector(1 downto 0);

signal CUARTII: std_logic;

signal CUARTo0: STD_LOGIC;

component CoreUARTapb_C0_CoreUARTapb_C0_0_Rx_async
generic (RX_FIFO: INTEGER := 0;
SYNC_RESET: INTEGER := 0);
port (clk: in STD_LOGIC;
CUARTo: in STD_LOGIC;
reset_n: in STD_LOGIC;
Bit8: in std_logic;
PARIty_en: in STD_LOGIC;
ODD_N_EVEN: in std_logic;
CUARTi1l: in std_logic;
CUARTL0I: in std_logic;
CUARTlo0: in std_LOGIC;
rx: in STD_LOGIC;
overflow: out STD_LOGIC;
parity_erR: out STD_logic;
CUARTi01: out STD_LOGIC;
CUARTo11: out STD_Logic;
CUARToo0: out STD_LOGIC;
CUARTi0i: out STD_LOGIC;
CUARTIO0: out std_logic;
CUARTLIL: out std_logic;
CUARTloi: out STD_LOGic_vector(7 downto 0);
CUARTO0L: out std_logic);
end component;

component CoreUARTapb_C0_CoreUARTapb_C0_0_Tx_aSYNC
generic (TX_FIFo: INTEGER := 0;
sync_reset: Integer := 0);
port (clk: in STD_LOGIC;
CUARTl: in STD_LOGIC;
reset_n: in std_logic;
CUARTL0L: in STD_LOGic;
CUARTI0L: in STD_LOGIC_VECtor(7 downto 0);
CUARTO1l: in STD_LOGIC_VECTOR(7 downto 0);
CUARTl11: in STD_LOGIC;
CUARTi11: in STD_LOGIC;
BIT8: in std_logic;
parITY_EN: in STD_LOGIC;
Odd_n_even: in std_logic;
txrdy: out std_logic;
tx: out std_logic;
CUARTLII: out std_logic);
end component;

component CoreUARTapb_C0_CoreUARTapb_C0_0_CLOCK_GEN
generic (BAUD_VAL_frctn_en: INTEger := 0;
sync_resET: integer := 0);
port (CLK: in std_logic;
reset_N: in STd_logic;
bauD_VAL: in STD_LOGIC_VECTOR(12 downto 0);
baUD_VAL_FRACTION: in std_logic_vector(2 downto 0);
CUARTo: out STD_LOGIC;
CUARTL: out std_logic);
end component;

component CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_256x8 is
generic (SYNC_RESET: integer := 0);
port (CUARTOOOL: out std_LOGIC_VECTOR(7 downto 0);
CUARTlool: in STD_LOGIC;
CUARTiool: in STD_LOGIC;
CUARTolol: in std_logic_VECTOR(7 downto 0);
Wrb: in std_logic;
rdb: in std_LOGIC;
RESET: in STd_logic;
full: out STD_LOGIC;
EMPTY: out std_logic);
end component;

begin
CUARTii <= '1' when (sync_reseT = 1) else
RESET_N;
CUARTO0 <= RESET_N when (sync_reset = 1) else
'1';
FRAMING_err <= CUARToi0;
parity_err <= CUARTio1;
OVERFLOw <= CUARTol1;
TXRDY <= CUARTll1;
RXRDY <= CUARTil1;
DATa_out <= CUARTOI1;
TX <= CUARTLI1;
CUARTllol:
process (clk,CUARTii)
begin
if (CUARTIi = '0') then
CUARTI0l <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0';
CUARToii <= '1';
elsif (CLK'event and CLK = '1') then
if (CUARTO0 = '0') then
CUARTI0l <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0';
CUARToii <= '1';
else
CUARTOII <= '1';
if (csn = '0' and wen = '0') then
CUARTI0L <= DATA_IN;
CUARTOII <= '0';
end if;
end if;
end if;
end process CUARTllol;
CUARTo00 <= '1' when (Wen = '0' and csn = '0') else
'0';
CUARTL0L <= CUARTO00;
process (CUARTloi,CUARTooi,CUARTIO1)
variable CUARTilol: STD_Logic_vector(7 downto 0);
begin
if (RX_FIFO = 2#0#) then
CUARTILOL := CUARTLOI;
else
if (CUARTIO1 = '1') then
CUARTIlol := CUARTLOI;
else
CUARTILOL := CUARTOOI;
end if;
end if;
CUARToi1 <= CUARTILOL;
end process;
CUARTL00 <= '1' when (CSN = '0' and oen = '0') else
'0';
CUARTi00 <= (CUARTl00) when (rx_fifo = 2#0#) else
not CUARTO0I;
CUARTI1L <= CUARTi00;
CUARTo10 <= '1' when (csn = '0' and OEN = '0') else
'0';
CUARTl10 <= CUARTL1I when rx_fifo /= 0 else
(CUARTo10);
CUARTl0i <= CUARTL10;
CUARTI10 <= CUARTlOI when (CUARTio1 = '0') else
"00000000";
CUARTioi <= CUARTi10;
CUARTLO0 <= CUARTO10 when (rx_fifo = 0) else
'1' when (CUARTo10 = '1') else
CUARTLl0;
CUARTII0 <= '1' when (CSN = '0' and oen = '0') else
'0';
CUARToiol:
if (rx_legacy_mode = 1)
generate
process (CUARTLil,CUARTII1)
variable CUARTLIOL: STD_LOGIC;
begin
if (RX_FIFO = 2#0#) then
CUARTliol := CUARTlil;
else
CUARTLIOL := not CUARTii1;
end if;
CUARTIL1 <= CUARTLIol;
end process;
end generate;
CUARTIIOL:
if (rx_legacy_mode = 0)
generate
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTil1 <= '0';
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTIL1 <= '0';
else
if (rx_fifo = 0) then
if (CUARToo0 = '1' or CUARTLIL = '0') then
CUARTIL1 <= CUARTLIL;
end if;
else
if (CUARTOo0 = '1' or CUARTii1 = '1'
or (CUARTii1 = '0' and (CUARTIL0 = '1' or rx_fifo = 1))) then
CUARTil1 <= not CUARTiI1;
end if;
end if;
end if;
end if;
end process;
end generate;
process (clk,CUARTii)
begin
if (CUARTII = '0') then
CUARTL1I <= '0';
CUARTo1i <= '0';
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTl1i <= '0';
CUARTo1i <= '0';
else
CUARTO1I <= CUARTi0i;
CUARTl1i <= CUARTo1I;
end if;
end if;
end process;
process (clk,CUARTii)
begin
if (CUARTII = '0') then
CUARTll0 <= '0';
CUARTol0 <= '0';
elsif (clk'event and clk = '1') then
if (CUARTO0 = '0') then
CUARTll0 <= '0';
CUARTOL0 <= '0';
else
CUARTOL0 <= CUARTIO0;
CUARTll0 <= CUARTOL0;
end if;
end if;
end process;
process (CLK,CUARTII)
begin
if (CUARTii = '0') then
CUARTO01 <= CUARTIOl;
elsif (clk'event and clk = '1') then
if (CUARTo0 = '0') then
CUARTO01 <= CUARTiol;
else
CUARTo01 <= CUARTl01;
end if;
end if;
end process;
process (CUARTO01,CUARTii1,CUARTLLI)
begin
CUARTl01 <= CUARTo01;
CUARTIli <= '1';
CUARTi1i <= '0';
case CUARTo01 is
when CUARTiol =>
if (CUARTii1 = '1' and CUARTLli = '0') then
CUARTL01 <= CUARToll;
CUARTili <= '0';
end if;
when CUARToll =>
CUARTL01 <= CUARTlll;
when CUARTLll =>
CUARTl01 <= CUARTILL;
when CUARTill =>
CUARTL01 <= CUARTIOL;
CUARTI1I <= '1';
when others =>
CUARTl01 <= CUARTo01;
end case;
end process;
process (CLK,CUARTII)
begin
if (CUARTii = '0') then
CUARTOOI <= "00000000";
elsif (CLK'EVENT and Clk = '1') then
if (CUARTo0 = '0') then
CUARTooi <= "00000000";
else
if (CUARTi1i = '1') then
CUARTooi <= CUARTl1l;
end if;
end if;
end if;
end process;
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTII1 <= '1';
elsif (clk'event and CLK = '1') then
if (CUARTO0 = '0') then
CUARTiI1 <= '1';
else
if (CUARTi1i = '1') then
CUARTII1 <= '0';
else
if (CSN = '0' and OEN = '0') then
if (RX_fifo = 1) then
if (CUARTIO1 = '0') then
CUARTII1 <= '1';
end if;
else
CUARTII1 <= '1';
end if;
end if;
end if;
end if;
end if;
end process;
process (clk,CUARTii)
begin
if (CUARTii = '0') then
CUARTLI0 <= '0';
elsif (clk'EVent and clk = '1') then
if (CUARTo0 = '0') then
CUARTLI0 <= '0';
else
if (CUARTO0L = '0' and CUARTO0I = '1') then
CUARTli0 <= '1';
elsif (CUARTII0 = '1') then
CUARTLI0 <= '0';
else
CUARTli0 <= CUARTli0;
end if;
end if;
end if;
end process;
CUARToo1 <= CUARTLI0 when RX_FIFO /= 0 else
CUARTOIL;
CUARTOL1 <= CUARTOO1;
CUARTLO1 <= '1' when (CUARTio1 = '1' or CUARTO0I = '1') else
CUARTo0l;
CUARTiil <= CUARTlo1;
CUARTO0OL: CoreUARTapb_C0_CoreUARTapb_C0_0_Clock_gEN
generic map (baud_val_frctn_en => BAUD_VAL_FRCTN_en,
SYNC_RESET => sync_reset)
port map (clk => CLK,
RESET_N => reset_n,
BAUD_VAL => BAUD_VAL,
BAUD_VAL_FRaction => baud_val_fraction,
CUARTO => CUARTo,
CUARTl => CUARTl);
CUARTl0ol: CoreUARTapb_C0_CoreUARTapb_C0_0_Tx_async
generic map (tx_fifo => TX_FIFO,
sync_reset => sync_resET)
port map (Clk => clk,
CUARTl => CUARTL,
reset_n => RESET_N,
CUARTL0L => CUARTL0L,
CUARTi0l => CUARTI0L,
CUARTo1l => CUARTO1L,
CUARTl11 => CUARToli,
CUARTI11 => CUARTiii,
bit8 => bit8,
PARITY_EN => parity_en,
ODD_N_EVEn => ODD_N_EVEN,
Txrdy => CUARTll1,
TX => CUARTLI1,
CUARTLII => CUARTlii);
CUARTI0OL: CoreUARTapb_C0_CoreUARTapb_C0_0_RX_ASYNC
generic map (rx_fifo => RX_FIFO,
SYNC_RESET => sync_rESET)
port map (clk => Clk,
CUARTo => CUARTO,
RESET_N => reset_n,
bit8 => BIT8,
PARITy_en => PARITY_EN,
odd_n_eveN => odd_n_even,
CUARTI1L => CUARTI1L,
CUARTl0i => CUARTl0i,
rx => rx,
overflow => CUARTOIL,
parity_ERR => CUARTIO1,
CUARTi0i => CUARTI0I,
CUARTlil => CUARTlil,
CUARTloi => CUARTloi,
CUARTo0l => CUARTo0l,
CUARTLO0 => CUARTlo0,
CUARTIO0 => CUARTIO0,
CUARTi01 => CUARToi0,
CUARTO11 => CUARTil0,
CUARTOO0 => CUARTOO0);
CUARTO1OL:
if (tx_fifo = 2#1#)
generate
CUARTL1OL: CoreUARTapb_C0_CoreUARTapb_C0_0_FIFO_256x8
generic map (sync_reset => SYNC_RESET)
port map (CUARToool => CUARTo1L,
CUARTlool => CLK,
CUARTIOol => clk,
CUARTOLOL => CUARTI0L,
WRB => CUARToii,
RDB => CUARTlii,
reset => RESET_N,
full => CUARTiii,
empty => CUARTOLI);
end generate;
CUARTI1OL:
if (tx_fifo = 2#0#)
generate
CUARTo1l <= "00000000";
CUARTIII <= '0';
CUARTOLI <= '0';
end generate;
CUARTOOLL:
if (RX_FIFO = 2#1#)
generate
CUARTloll: CoreUARTapb_C0_CoreUARTapb_C0_0_fifo_256X8
generic map (sync_reSET => SYNC_RESET)
port map (CUARToool => CUARTL1L,
CUARTlool => Clk,
CUARTiool => CLK,
CUARTolol => CUARTIOI,
WRB => CUARTiil,
RDB => CUARTiLI,
RESET => reset_N,
FULL => CUARTo0i,
EMPTY => CUARTLLI);
end generate;
CUARTioll:
if (RX_fifo = 2#0#)
generate
CUARTl1l <= "00000000";
CUARTo0i <= '0';
CUARTlli <= '0';
end generate;
end architecture CUARTLOL;
