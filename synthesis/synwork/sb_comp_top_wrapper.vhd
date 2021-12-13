--
-- Synopsys
-- Vhdl wrapper for top level design, written on Mon Dec 13 03:45:06 2021
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_sb is
   port (
      DAPI_RXD : in std_logic;
      DEVRST_N : in std_logic;
      F_MISO : in std_logic;
      IN_RXSM_LO : in std_logic;
      IN_RXSM_SODS : in std_logic;
      IN_RXSM_SOE : in std_logic;
      STAMP1_DRDY_SGR1 : in std_logic;
      STAMP1_DRDY_SGR2 : in std_logic;
      STAMP1_DRDY_TEMP : in std_logic;
      STAMP1_MISO : in std_logic;
      STAMP2_DRDY_SGR1 : in std_logic;
      STAMP2_DRDY_SGR2 : in std_logic;
      STAMP2_DRDY_TEMP : in std_logic;
      STAMP2_MISO : in std_logic;
      STAMP3_DRDY_SGR1 : in std_logic;
      STAMP3_DRDY_SGR2 : in std_logic;
      STAMP3_DRDY_TEMP : in std_logic;
      STAMP3_MISO : in std_logic;
      STAMP4_DRDY_SGR1 : in std_logic;
      STAMP4_DRDY_SGR2 : in std_logic;
      STAMP4_DRDY_TEMP : in std_logic;
      STAMP4_MISO : in std_logic;
      STAMP5_DRDY_SGR1 : in std_logic;
      STAMP5_DRDY_SGR2 : in std_logic;
      STAMP5_DRDY_TEMP : in std_logic;
      STAMP5_MISO : in std_logic;
      STAMP6_DRDY_SGR1 : in std_logic;
      STAMP6_DRDY_SGR2 : in std_logic;
      STAMP6_DRDY_TEMP : in std_logic;
      STAMP6_MISO : in std_logic;
      TM_RXD : in std_logic;
      WP : in std_logic;
      DAPI_TXD : out std_logic;
      F_CLK : out std_logic;
      F_CS1 : out std_logic;
      F_CS2 : out std_logic;
      F_MOSI : out std_logic;
      LED_FPGA_LOADED : out std_logic;
      LED_HB_MEMSYNC : out std_logic;
      LED_HB_MSS : out std_logic;
      LED_RECORDING : out std_logic;
      OUT_ADC_START : out std_logic;
      STAMP1_CS_SGR1 : out std_logic;
      STAMP1_CS_SGR2 : out std_logic;
      STAMP1_CS_TEMP : out std_logic;
      STAMP1_MOSI : out std_logic;
      STAMP1_SCLK : out std_logic;
      STAMP2_CS_SGR1 : out std_logic;
      STAMP2_CS_SGR2 : out std_logic;
      STAMP2_CS_TEMP : out std_logic;
      STAMP2_MOSI : out std_logic;
      STAMP2_SCLK : out std_logic;
      STAMP3_CS_SGR1 : out std_logic;
      STAMP3_CS_SGR2 : out std_logic;
      STAMP3_CS_TEMP : out std_logic;
      STAMP3_MOSI : out std_logic;
      STAMP3_SCLK : out std_logic;
      STAMP4_CS_SGR1 : out std_logic;
      STAMP4_CS_SGR2 : out std_logic;
      STAMP4_CS_TEMP : out std_logic;
      STAMP4_MOSI : out std_logic;
      STAMP4_SCLK : out std_logic;
      STAMP5_CS_SGR1 : out std_logic;
      STAMP5_CS_SGR2 : out std_logic;
      STAMP5_CS_TEMP : out std_logic;
      STAMP5_MOSI : out std_logic;
      STAMP5_SCLK : out std_logic;
      STAMP6_CS_SGR1 : out std_logic;
      STAMP6_CS_SGR2 : out std_logic;
      STAMP6_CS_TEMP : out std_logic;
      STAMP6_MOSI : out std_logic;
      STAMP6_SCLK : out std_logic;
      TM_TXD : out std_logic
   );
end wrapper_for_sb;

architecture rtl of wrapper_for_sb is

component sb
 port (
   DAPI_RXD : in std_logic;
   DEVRST_N : in std_logic;
   F_MISO : in std_logic;
   IN_RXSM_LO : in std_logic;
   IN_RXSM_SODS : in std_logic;
   IN_RXSM_SOE : in std_logic;
   STAMP1_DRDY_SGR1 : in std_logic;
   STAMP1_DRDY_SGR2 : in std_logic;
   STAMP1_DRDY_TEMP : in std_logic;
   STAMP1_MISO : in std_logic;
   STAMP2_DRDY_SGR1 : in std_logic;
   STAMP2_DRDY_SGR2 : in std_logic;
   STAMP2_DRDY_TEMP : in std_logic;
   STAMP2_MISO : in std_logic;
   STAMP3_DRDY_SGR1 : in std_logic;
   STAMP3_DRDY_SGR2 : in std_logic;
   STAMP3_DRDY_TEMP : in std_logic;
   STAMP3_MISO : in std_logic;
   STAMP4_DRDY_SGR1 : in std_logic;
   STAMP4_DRDY_SGR2 : in std_logic;
   STAMP4_DRDY_TEMP : in std_logic;
   STAMP4_MISO : in std_logic;
   STAMP5_DRDY_SGR1 : in std_logic;
   STAMP5_DRDY_SGR2 : in std_logic;
   STAMP5_DRDY_TEMP : in std_logic;
   STAMP5_MISO : in std_logic;
   STAMP6_DRDY_SGR1 : in std_logic;
   STAMP6_DRDY_SGR2 : in std_logic;
   STAMP6_DRDY_TEMP : in std_logic;
   STAMP6_MISO : in std_logic;
   TM_RXD : in std_logic;
   WP : in std_logic;
   DAPI_TXD : out std_logic;
   F_CLK : out std_logic;
   F_CS1 : out std_logic;
   F_CS2 : out std_logic;
   F_MOSI : out std_logic;
   LED_FPGA_LOADED : out std_logic;
   LED_HB_MEMSYNC : out std_logic;
   LED_HB_MSS : out std_logic;
   LED_RECORDING : out std_logic;
   OUT_ADC_START : out std_logic;
   STAMP1_CS_SGR1 : out std_logic;
   STAMP1_CS_SGR2 : out std_logic;
   STAMP1_CS_TEMP : out std_logic;
   STAMP1_MOSI : out std_logic;
   STAMP1_SCLK : out std_logic;
   STAMP2_CS_SGR1 : out std_logic;
   STAMP2_CS_SGR2 : out std_logic;
   STAMP2_CS_TEMP : out std_logic;
   STAMP2_MOSI : out std_logic;
   STAMP2_SCLK : out std_logic;
   STAMP3_CS_SGR1 : out std_logic;
   STAMP3_CS_SGR2 : out std_logic;
   STAMP3_CS_TEMP : out std_logic;
   STAMP3_MOSI : out std_logic;
   STAMP3_SCLK : out std_logic;
   STAMP4_CS_SGR1 : out std_logic;
   STAMP4_CS_SGR2 : out std_logic;
   STAMP4_CS_TEMP : out std_logic;
   STAMP4_MOSI : out std_logic;
   STAMP4_SCLK : out std_logic;
   STAMP5_CS_SGR1 : out std_logic;
   STAMP5_CS_SGR2 : out std_logic;
   STAMP5_CS_TEMP : out std_logic;
   STAMP5_MOSI : out std_logic;
   STAMP5_SCLK : out std_logic;
   STAMP6_CS_SGR1 : out std_logic;
   STAMP6_CS_SGR2 : out std_logic;
   STAMP6_CS_TEMP : out std_logic;
   STAMP6_MOSI : out std_logic;
   STAMP6_SCLK : out std_logic;
   TM_TXD : out std_logic
 );
end component;

signal tmp_DAPI_RXD : std_logic;
signal tmp_DEVRST_N : std_logic;
signal tmp_F_MISO : std_logic;
signal tmp_IN_RXSM_LO : std_logic;
signal tmp_IN_RXSM_SODS : std_logic;
signal tmp_IN_RXSM_SOE : std_logic;
signal tmp_STAMP1_DRDY_SGR1 : std_logic;
signal tmp_STAMP1_DRDY_SGR2 : std_logic;
signal tmp_STAMP1_DRDY_TEMP : std_logic;
signal tmp_STAMP1_MISO : std_logic;
signal tmp_STAMP2_DRDY_SGR1 : std_logic;
signal tmp_STAMP2_DRDY_SGR2 : std_logic;
signal tmp_STAMP2_DRDY_TEMP : std_logic;
signal tmp_STAMP2_MISO : std_logic;
signal tmp_STAMP3_DRDY_SGR1 : std_logic;
signal tmp_STAMP3_DRDY_SGR2 : std_logic;
signal tmp_STAMP3_DRDY_TEMP : std_logic;
signal tmp_STAMP3_MISO : std_logic;
signal tmp_STAMP4_DRDY_SGR1 : std_logic;
signal tmp_STAMP4_DRDY_SGR2 : std_logic;
signal tmp_STAMP4_DRDY_TEMP : std_logic;
signal tmp_STAMP4_MISO : std_logic;
signal tmp_STAMP5_DRDY_SGR1 : std_logic;
signal tmp_STAMP5_DRDY_SGR2 : std_logic;
signal tmp_STAMP5_DRDY_TEMP : std_logic;
signal tmp_STAMP5_MISO : std_logic;
signal tmp_STAMP6_DRDY_SGR1 : std_logic;
signal tmp_STAMP6_DRDY_SGR2 : std_logic;
signal tmp_STAMP6_DRDY_TEMP : std_logic;
signal tmp_STAMP6_MISO : std_logic;
signal tmp_TM_RXD : std_logic;
signal tmp_WP : std_logic;
signal tmp_DAPI_TXD : std_logic;
signal tmp_F_CLK : std_logic;
signal tmp_F_CS1 : std_logic;
signal tmp_F_CS2 : std_logic;
signal tmp_F_MOSI : std_logic;
signal tmp_LED_FPGA_LOADED : std_logic;
signal tmp_LED_HB_MEMSYNC : std_logic;
signal tmp_LED_HB_MSS : std_logic;
signal tmp_LED_RECORDING : std_logic;
signal tmp_OUT_ADC_START : std_logic;
signal tmp_STAMP1_CS_SGR1 : std_logic;
signal tmp_STAMP1_CS_SGR2 : std_logic;
signal tmp_STAMP1_CS_TEMP : std_logic;
signal tmp_STAMP1_MOSI : std_logic;
signal tmp_STAMP1_SCLK : std_logic;
signal tmp_STAMP2_CS_SGR1 : std_logic;
signal tmp_STAMP2_CS_SGR2 : std_logic;
signal tmp_STAMP2_CS_TEMP : std_logic;
signal tmp_STAMP2_MOSI : std_logic;
signal tmp_STAMP2_SCLK : std_logic;
signal tmp_STAMP3_CS_SGR1 : std_logic;
signal tmp_STAMP3_CS_SGR2 : std_logic;
signal tmp_STAMP3_CS_TEMP : std_logic;
signal tmp_STAMP3_MOSI : std_logic;
signal tmp_STAMP3_SCLK : std_logic;
signal tmp_STAMP4_CS_SGR1 : std_logic;
signal tmp_STAMP4_CS_SGR2 : std_logic;
signal tmp_STAMP4_CS_TEMP : std_logic;
signal tmp_STAMP4_MOSI : std_logic;
signal tmp_STAMP4_SCLK : std_logic;
signal tmp_STAMP5_CS_SGR1 : std_logic;
signal tmp_STAMP5_CS_SGR2 : std_logic;
signal tmp_STAMP5_CS_TEMP : std_logic;
signal tmp_STAMP5_MOSI : std_logic;
signal tmp_STAMP5_SCLK : std_logic;
signal tmp_STAMP6_CS_SGR1 : std_logic;
signal tmp_STAMP6_CS_SGR2 : std_logic;
signal tmp_STAMP6_CS_TEMP : std_logic;
signal tmp_STAMP6_MOSI : std_logic;
signal tmp_STAMP6_SCLK : std_logic;
signal tmp_TM_TXD : std_logic;

begin

tmp_DAPI_RXD <= DAPI_RXD;

tmp_DEVRST_N <= DEVRST_N;

tmp_F_MISO <= F_MISO;

tmp_IN_RXSM_LO <= IN_RXSM_LO;

tmp_IN_RXSM_SODS <= IN_RXSM_SODS;

tmp_IN_RXSM_SOE <= IN_RXSM_SOE;

tmp_STAMP1_DRDY_SGR1 <= STAMP1_DRDY_SGR1;

tmp_STAMP1_DRDY_SGR2 <= STAMP1_DRDY_SGR2;

tmp_STAMP1_DRDY_TEMP <= STAMP1_DRDY_TEMP;

tmp_STAMP1_MISO <= STAMP1_MISO;

tmp_STAMP2_DRDY_SGR1 <= STAMP2_DRDY_SGR1;

tmp_STAMP2_DRDY_SGR2 <= STAMP2_DRDY_SGR2;

tmp_STAMP2_DRDY_TEMP <= STAMP2_DRDY_TEMP;

tmp_STAMP2_MISO <= STAMP2_MISO;

tmp_STAMP3_DRDY_SGR1 <= STAMP3_DRDY_SGR1;

tmp_STAMP3_DRDY_SGR2 <= STAMP3_DRDY_SGR2;

tmp_STAMP3_DRDY_TEMP <= STAMP3_DRDY_TEMP;

tmp_STAMP3_MISO <= STAMP3_MISO;

tmp_STAMP4_DRDY_SGR1 <= STAMP4_DRDY_SGR1;

tmp_STAMP4_DRDY_SGR2 <= STAMP4_DRDY_SGR2;

tmp_STAMP4_DRDY_TEMP <= STAMP4_DRDY_TEMP;

tmp_STAMP4_MISO <= STAMP4_MISO;

tmp_STAMP5_DRDY_SGR1 <= STAMP5_DRDY_SGR1;

tmp_STAMP5_DRDY_SGR2 <= STAMP5_DRDY_SGR2;

tmp_STAMP5_DRDY_TEMP <= STAMP5_DRDY_TEMP;

tmp_STAMP5_MISO <= STAMP5_MISO;

tmp_STAMP6_DRDY_SGR1 <= STAMP6_DRDY_SGR1;

tmp_STAMP6_DRDY_SGR2 <= STAMP6_DRDY_SGR2;

tmp_STAMP6_DRDY_TEMP <= STAMP6_DRDY_TEMP;

tmp_STAMP6_MISO <= STAMP6_MISO;

tmp_TM_RXD <= TM_RXD;

tmp_WP <= WP;

DAPI_TXD <= tmp_DAPI_TXD;

F_CLK <= tmp_F_CLK;

F_CS1 <= tmp_F_CS1;

F_CS2 <= tmp_F_CS2;

F_MOSI <= tmp_F_MOSI;

LED_FPGA_LOADED <= tmp_LED_FPGA_LOADED;

LED_HB_MEMSYNC <= tmp_LED_HB_MEMSYNC;

LED_HB_MSS <= tmp_LED_HB_MSS;

LED_RECORDING <= tmp_LED_RECORDING;

OUT_ADC_START <= tmp_OUT_ADC_START;

STAMP1_CS_SGR1 <= tmp_STAMP1_CS_SGR1;

STAMP1_CS_SGR2 <= tmp_STAMP1_CS_SGR2;

STAMP1_CS_TEMP <= tmp_STAMP1_CS_TEMP;

STAMP1_MOSI <= tmp_STAMP1_MOSI;

STAMP1_SCLK <= tmp_STAMP1_SCLK;

STAMP2_CS_SGR1 <= tmp_STAMP2_CS_SGR1;

STAMP2_CS_SGR2 <= tmp_STAMP2_CS_SGR2;

STAMP2_CS_TEMP <= tmp_STAMP2_CS_TEMP;

STAMP2_MOSI <= tmp_STAMP2_MOSI;

STAMP2_SCLK <= tmp_STAMP2_SCLK;

STAMP3_CS_SGR1 <= tmp_STAMP3_CS_SGR1;

STAMP3_CS_SGR2 <= tmp_STAMP3_CS_SGR2;

STAMP3_CS_TEMP <= tmp_STAMP3_CS_TEMP;

STAMP3_MOSI <= tmp_STAMP3_MOSI;

STAMP3_SCLK <= tmp_STAMP3_SCLK;

STAMP4_CS_SGR1 <= tmp_STAMP4_CS_SGR1;

STAMP4_CS_SGR2 <= tmp_STAMP4_CS_SGR2;

STAMP4_CS_TEMP <= tmp_STAMP4_CS_TEMP;

STAMP4_MOSI <= tmp_STAMP4_MOSI;

STAMP4_SCLK <= tmp_STAMP4_SCLK;

STAMP5_CS_SGR1 <= tmp_STAMP5_CS_SGR1;

STAMP5_CS_SGR2 <= tmp_STAMP5_CS_SGR2;

STAMP5_CS_TEMP <= tmp_STAMP5_CS_TEMP;

STAMP5_MOSI <= tmp_STAMP5_MOSI;

STAMP5_SCLK <= tmp_STAMP5_SCLK;

STAMP6_CS_SGR1 <= tmp_STAMP6_CS_SGR1;

STAMP6_CS_SGR2 <= tmp_STAMP6_CS_SGR2;

STAMP6_CS_TEMP <= tmp_STAMP6_CS_TEMP;

STAMP6_MOSI <= tmp_STAMP6_MOSI;

STAMP6_SCLK <= tmp_STAMP6_SCLK;

TM_TXD <= tmp_TM_TXD;



u1:   sb port map (
		DAPI_RXD => tmp_DAPI_RXD,
		DEVRST_N => tmp_DEVRST_N,
		F_MISO => tmp_F_MISO,
		IN_RXSM_LO => tmp_IN_RXSM_LO,
		IN_RXSM_SODS => tmp_IN_RXSM_SODS,
		IN_RXSM_SOE => tmp_IN_RXSM_SOE,
		STAMP1_DRDY_SGR1 => tmp_STAMP1_DRDY_SGR1,
		STAMP1_DRDY_SGR2 => tmp_STAMP1_DRDY_SGR2,
		STAMP1_DRDY_TEMP => tmp_STAMP1_DRDY_TEMP,
		STAMP1_MISO => tmp_STAMP1_MISO,
		STAMP2_DRDY_SGR1 => tmp_STAMP2_DRDY_SGR1,
		STAMP2_DRDY_SGR2 => tmp_STAMP2_DRDY_SGR2,
		STAMP2_DRDY_TEMP => tmp_STAMP2_DRDY_TEMP,
		STAMP2_MISO => tmp_STAMP2_MISO,
		STAMP3_DRDY_SGR1 => tmp_STAMP3_DRDY_SGR1,
		STAMP3_DRDY_SGR2 => tmp_STAMP3_DRDY_SGR2,
		STAMP3_DRDY_TEMP => tmp_STAMP3_DRDY_TEMP,
		STAMP3_MISO => tmp_STAMP3_MISO,
		STAMP4_DRDY_SGR1 => tmp_STAMP4_DRDY_SGR1,
		STAMP4_DRDY_SGR2 => tmp_STAMP4_DRDY_SGR2,
		STAMP4_DRDY_TEMP => tmp_STAMP4_DRDY_TEMP,
		STAMP4_MISO => tmp_STAMP4_MISO,
		STAMP5_DRDY_SGR1 => tmp_STAMP5_DRDY_SGR1,
		STAMP5_DRDY_SGR2 => tmp_STAMP5_DRDY_SGR2,
		STAMP5_DRDY_TEMP => tmp_STAMP5_DRDY_TEMP,
		STAMP5_MISO => tmp_STAMP5_MISO,
		STAMP6_DRDY_SGR1 => tmp_STAMP6_DRDY_SGR1,
		STAMP6_DRDY_SGR2 => tmp_STAMP6_DRDY_SGR2,
		STAMP6_DRDY_TEMP => tmp_STAMP6_DRDY_TEMP,
		STAMP6_MISO => tmp_STAMP6_MISO,
		TM_RXD => tmp_TM_RXD,
		WP => tmp_WP,
		DAPI_TXD => tmp_DAPI_TXD,
		F_CLK => tmp_F_CLK,
		F_CS1 => tmp_F_CS1,
		F_CS2 => tmp_F_CS2,
		F_MOSI => tmp_F_MOSI,
		LED_FPGA_LOADED => tmp_LED_FPGA_LOADED,
		LED_HB_MEMSYNC => tmp_LED_HB_MEMSYNC,
		LED_HB_MSS => tmp_LED_HB_MSS,
		LED_RECORDING => tmp_LED_RECORDING,
		OUT_ADC_START => tmp_OUT_ADC_START,
		STAMP1_CS_SGR1 => tmp_STAMP1_CS_SGR1,
		STAMP1_CS_SGR2 => tmp_STAMP1_CS_SGR2,
		STAMP1_CS_TEMP => tmp_STAMP1_CS_TEMP,
		STAMP1_MOSI => tmp_STAMP1_MOSI,
		STAMP1_SCLK => tmp_STAMP1_SCLK,
		STAMP2_CS_SGR1 => tmp_STAMP2_CS_SGR1,
		STAMP2_CS_SGR2 => tmp_STAMP2_CS_SGR2,
		STAMP2_CS_TEMP => tmp_STAMP2_CS_TEMP,
		STAMP2_MOSI => tmp_STAMP2_MOSI,
		STAMP2_SCLK => tmp_STAMP2_SCLK,
		STAMP3_CS_SGR1 => tmp_STAMP3_CS_SGR1,
		STAMP3_CS_SGR2 => tmp_STAMP3_CS_SGR2,
		STAMP3_CS_TEMP => tmp_STAMP3_CS_TEMP,
		STAMP3_MOSI => tmp_STAMP3_MOSI,
		STAMP3_SCLK => tmp_STAMP3_SCLK,
		STAMP4_CS_SGR1 => tmp_STAMP4_CS_SGR1,
		STAMP4_CS_SGR2 => tmp_STAMP4_CS_SGR2,
		STAMP4_CS_TEMP => tmp_STAMP4_CS_TEMP,
		STAMP4_MOSI => tmp_STAMP4_MOSI,
		STAMP4_SCLK => tmp_STAMP4_SCLK,
		STAMP5_CS_SGR1 => tmp_STAMP5_CS_SGR1,
		STAMP5_CS_SGR2 => tmp_STAMP5_CS_SGR2,
		STAMP5_CS_TEMP => tmp_STAMP5_CS_TEMP,
		STAMP5_MOSI => tmp_STAMP5_MOSI,
		STAMP5_SCLK => tmp_STAMP5_SCLK,
		STAMP6_CS_SGR1 => tmp_STAMP6_CS_SGR1,
		STAMP6_CS_SGR2 => tmp_STAMP6_CS_SGR2,
		STAMP6_CS_TEMP => tmp_STAMP6_CS_TEMP,
		STAMP6_MOSI => tmp_STAMP6_MOSI,
		STAMP6_SCLK => tmp_STAMP6_SCLK,
		TM_TXD => tmp_TM_TXD
       );
end rtl;
