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
library Ieee;
use ieee.STD_LOGic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.Std_logic_unsigned.all;
use WORK.CoreUARTapb_C0_CoreUARTapb_C0_0_COreuart_pkg.all;
entity CoreUARTapb_C0_CoreUARTapb_C0_0_COREUARTapb is
generic (rx_legacy_mode: integer := 0;
FAMILY: integer := 15;
tx_fifo: INTEGER := 0;
RX_FIFO: integer := 0;
baud_value: INteger := 0;
FIXEDMODE: INTEGER := 0;
prg_bit8: integer := 0;
prg_parity: integer := 0;
BAUD_VAL_FRCTN: INTEGER := 0;
BAUD_VAL_FRCTN_en: INTeger := 0); port (PCLK: in STD_logic;
PRESEtn: in STD_LOGIC;
PADDR: in STD_LOGIC_VECTor(4 downto 0);
PSEL: in STD_LOGIC;
PENABLE: in STd_logic;
pwrite: in STD_LOGIC;
pwdata: in STD_logic_vector(7 downto 0);
prdata: out std_logiC_VECTOR(7 downto 0);
prEADY: out std_logic;
PSLVERR: out std_logic;
TXRDY: out std_logic;
RXRDY: out STD_LOGIC;
FRAMing_err: out std_logiC;
PARity_err: out std_LOGIC;
Overflow: out std_logic;
rx: in STD_LOGIC;
tx: out std_logic);
end entity CoreUARTapb_C0_CoreUARTapb_C0_0_COREUARTapb;

architecture CUARTlol of CoreUARTapb_C0_CoreUARTapb_C0_0_COREUARTAPB is

component CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART
generic (rx_legacy_mode: integer;
TX_FIFO: integer;
RX_FIFO: INTEGER;
baud_val_frctn_en: integer;
family: INteger);
port (RESET_N: in STD_LOGIC;
clk: in STD_LOGIC;
wen: in STD_logic;
oen: in std_logiC;
csn: in STD_logic;
data_IN: in std_logic_vector(7 downto 0);
RX: in std_logic;
baud_val: in STD_LOGIC_Vector(12 downto 0);
bit8: in STD_LOGIC;
PARIty_en: in STD_LOGIC;
odd_n_even: in STD_LOGIC;
baud_VAL_FRACTION: in std_logic_veCTOR(2 downto 0);
PARITY_ERR: out std_loGIC;
overflow: out STD_LOGIC;
txrdy: out STD_LOGIC;
rxrdy: out STD_LOGIC;
data_OUT: out std_logic_vector(7 downto 0);
tx: out std_logic;
FRAMING_ERR: out std_logic);
end component;

constant SYNC_RESET: Integer := sync_mode_sel(FAMILY);

signal CUARTolll: Std_logic_vector(7 downto 0);

signal CUARTllll: STD_LOGic_vector(7 downto 0);

signal CUARTILLL: STD_LOGIC_VECTOR(2 downto 0);

signal CUARToill: STD_LOGIC_VEctor(7 downto 0);

signal CUARTLILL: sTD_LOGIC_VECTOR(7 downto 0);

signal CUARTiill: STD_Logic;

signal DATA_IN: STD_LOGIC_VECTOR(7 downto 0);

signal data_out: STD_LOGIC_VECtor(7 downto 0);

signal baud_VAL: STD_LOgic_vector(12 downto 0);

signal bit8: STD_LOGIc;

signal parity_en: STD_LOGIC;

signal ODd_n_even: sTD_LOGIC;

signal wen: STD_LOGIC;

signal oen: STD_LOGIC;

signal Csn: std_LOGIC;

signal CUARTo0ll: STD_LOGIC_Vector(1 downto 0);

signal CUARTL0LL: STD_LOGIC;

signal CUARTi0ll: STD_LOGIC;

signal CUARTL00: std_logic_vector(12 downto 0);

signal CUARTi00: std_logic;

signal CUARTo10: Std_logic;

signal CUARTl10: STD_LOgic;

signal CUARTo1LL: std_logic_vector(7 downto 0);

signal CUARTl1ll: std_logic;

signal CUARTI1LL: std_logic;

signal CUARTooil: STD_LOGIC;

signal CUARTLOIL: STD_LOGIC;

signal CUARTIOIL: std_logic;

signal CUARTOI0: std_loGIC;

signal CUARTolil: STD_LOGIC_VECTOR(2 downto 0);

signal CUARTllil: STD_LOGIC_VECTOR(2 downto 0);

signal CUARTII: std_LOGIC;

signal CUARTO0: std_logic;

function CUARTilIL(VAL: in Integer)
return std_logic is
begin
if (VAL = 1) then
return ('1');
else
return ('0');
end if;
end CUARTiLIL;

begin
CUARTii <= '1' when (SYNC_reset = 1) else
presetn;
CUARTo0 <= presetn when (sync_RESET = 1) else
'1';
PSlverr <= '0';
PREADY <= '1';
PRDATA <= CUARTO1Ll;
TXRDY <= CUARTl1LL;
rxrdy <= CUARTI1ll;
tx <= CUARTOOIL;
PARIty_err <= CUARTLOil;
FRAMING_err <= CUARToi0;
OVERFLOW <= CUARTIOIl;
WEN <= '0' when (PENAble = '1' and PWRITE = '1'
and paDDR(4 downto 2) = "000") else
'1';
OEN <= '0' when (PENABLE = '1' and pwrite = '0'
and Paddr(4 downto 2) = "001") else
'1';
csn <= not PSEL;
data_in <= PWDATA;
CUARTiill <= (psel and not PWRITE) and (not penable or CUARTLOIL);
CUARToiil:
process (paddr,CUARTiilL,CUARTLILL,DATA_out,CUARTolll,CUARTLLLL,CUARTILLL,CUARTioil,CUARTLOIL,CUARTi1ll,CUARTl1ll,CUARTOI0)
variable CUARTliil: std_logic_vectoR(7 downto 0);
begin
if (CUARTIILL = '1') then
case PADDR(4 downto 2) is
when "000" =>
CUARTLIIL := "00000000";
when "001" =>
CUARTliil := DATA_OUT;
when "010" =>
CUARTliil := CUARTOLLL;
when "011" =>
CUARTLIIL := CUARTllll;
when "100" =>
CUARTliil := "000"&CUARTOI0&CUARTIOIL&CUARTLOIL&CUARTi1ll&CUARTl1ll;
when "101" =>
CUARTliil := "00000"&CUARTILLL;
when others =>
CUARTliil := CUARTlill;
end case;
else
CUARTLIIL := CUARTlill;
end if;
CUARTOILL <= CUARTliil;
end process CUARToiil;
CUARTO0LL <= conv_std_logic_vectOR(prg_parity,
2);
CUARTl0ll <= '1' when (CUARTO0LL = "01" or CUARTo0ll = "10") else
'0';
CUARTi0ll <= '1' when (CUARTO0LL = "01") else
'0';
CUARTiiil:
process (pclk,CUARTii)
begin
if (not CUARTii = '1') then
CUARTLILL <= "00000000";
elsif (PCLK'event and pclk = '1') then
if (not CUARTO0 = '1') then
CUARTlill <= "00000000";
else
CUARTlill <= CUARTOILL;
end if;
end if;
end process CUARTIIIL;
CUARTO1LL <= data_out when ((RX_FIFO = 1) and (CUARTloil = '1')) else
CUARTLILL;
CUARTo0il:
process (PCLK,CUARTII)
begin
if (not CUARTII = '1') then
CUARToLLL <= "00000000";
elsif (pclk'event and PCLK = '1') then
if (not CUARTo0 = '1') then
CUARTolll <= "00000000";
else
if (PSEL = '1' and penable = '1'
and pwrite = '1'
and PADdr(4 downto 2) = "010") then
CUARTOLLL <= PWDATA;
else
CUARTolll <= CUARTolll;
end if;
end if;
end if;
end process CUARTo0il;
CUARTL00 <= conv_std_logic_vector(BAUD_VALUE,
13) when fixedmode /= 0 else
CUARTLLLL(7 downto 3)&CUARTolll;
BAUD_VAL <= CUARTl00;
CUARTL0IL:
process (PCLK,CUARTII)
begin
if (not CUARTII = '1') then
CUARTLLLL <= "00000000";
elsif (PCLK'EVENT and PCLK = '1') then
if (not CUARTo0 = '1') then
CUARTLLLL <= "00000000";
else
if (psel = '1' and PENABLE = '1'
and pwrite = '1'
and PADDR(4 downto 2) = "011") then
CUARTLlll <= PWDATa(7 downto 0);
else
CUARTllll <= CUARTllll;
end if;
end if;
end if;
end process CUARTl0il;
CUARTi0il:
if (baud_vAL_FRCTN_EN = 1)
generate
CUARTO1IL:
process (pCLK,CUARTiI)
begin
if (not CUARTII = '1') then
CUARTilll <= "000";
elsif (PCLK'EVENT and PCLK = '1') then
if (not CUARTo0 = '1') then
CUARTILLL <= "000";
else
if (psel = '1' and PENABLE = '1'
and pwriTE = '1'
and PADDR(4 downto 2) = "101") then
CUARTILLL <= pwdaTA(2 downto 0);
else
CUARTILLL <= CUARTilll;
end if;
end if;
end if;
end process CUARTo1il;
end generate;
CUARTOLIL <= "000" when baud_VAL_FRCTN = 0 else
"001" when baud_val_frctn = 1 else
"010" when Baud_val_frctn = 2 else
"011" when Baud_val_frctn = 3 else
"100" when baud_val_frCTN = 4 else
"101" when baud_val_frctn = 5 else
"110" when BAUD_Val_frctn = 6 else
"111" when baud_vAL_FRCTN = 7 else
"000";
CUARTI00 <= CUARTilil(PRG_BIT8) when FIXEDmode /= 0 else
CUARTllll(0);
BIt8 <= CUARTI00;
CUARTo10 <= CUARTl0ll when fixedMODE /= 0 else
CUARTllll(1);
PARITy_en <= CUARTo10;
CUARTL10 <= CUARTi0ll when fixedmode /= 0 else
CUARTLLll(2);
ODD_N_EVEN <= CUARTL10;
CUARTllil <= CUARTolil when fixedmode /= 0 else
CUARTIlll when baUD_VAL_FRCTN_EN /= 0 else
"000";
CUARTl1il: CoreUARTapb_C0_CoreUARTapb_C0_0_COREUART
generic map (RX_LEgacy_mode => RX_legacy_mode,
rx_fifo => rx_fifo,
TX_FIFO => tx_fifo,
BAUD_VAL_FRCTN_EN => Baud_val_frctn_en,
FAMILY => family)
port map (reset_n => PResetn,
clk => pclk,
WEN => WEN,
oen => oen,
CSN => CSN,
data_in => data_IN,
RX => RX,
baud_val => BAUD_VAL,
BIT8 => BIT8,
parity_en => PARITY_en,
odd_n_eVEN => odd_n_even,
PARITY_ERR => CUARTLOIL,
OVerflow => CUARTioil,
TXRdy => CUARTL1LL,
RXRDY => CUARTi1ll,
data_OUT => data_out,
TX => CUARTooil,
FRAMING_ERR => CUARTOI0,
BAUD_VAL_FRACTION => CUARTllil);
end architecture CUARTlol;
