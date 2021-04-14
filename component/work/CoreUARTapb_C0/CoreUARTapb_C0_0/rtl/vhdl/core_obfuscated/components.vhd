library Ieee;
use ieee.std_logic_1164.all;
package CoreUARTapb_C0_CoreUARTapb_C0_0_COMPONents is

component CoreUARTapb_C0_CoreUARTapb_C0_0_COREUARTapb
generic (RX_LEGACY_MOde: INTEGER := 0;
FAMILY: INTEGER := 15;
TX_Fifo: INTEGER := 0;
rx_fifo: INTEGEr := 0;
baud_valuE: integer := 0;
FIXedmode: INTEGER := 0;
PRG_BIT8: inTEGER := 0;
prg_parity: integer := 0;
baud_val_frctn: integer := 0;
BAUD_VAL_FRCTN_EN: INTeger := 0);
port (PClk: in STD_logic;
PRESETN: in STD_LOGIC;
PADDR: in STD_LOGIC_vector(4 downto 0);
psel: in STD_LOGIC;
penable: in STD_LOGIC;
pwrite: in STD_LOGIC;
pwdata: in STD_LOGIC_VECTOR(7 downto 0);
prdata: out std_logIC_VECTOR(7 downto 0);
pready: out STD_logic;
pslverr: out std_LOGIC;
TXRDY: out std_logic;
rxrdy: out STD_LOGIC;
FRAMING_ERR: out std_logic;
PARITY_ERR: out std_logic;
overflow: out std_logIC;
rx: in STD_LOGIC;
TX: out std_logic);
end component;
end CoreUARTapb_C0_CoreUARTapb_C0_0_COMPONENts;
