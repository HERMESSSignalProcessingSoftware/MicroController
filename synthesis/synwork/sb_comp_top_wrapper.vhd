--
-- Synopsys
-- Vhdl wrapper for top level design, written on Fri Jun 25 12:11:45 2021
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_sb is
   port (
      DEVRST_N : in std_logic;
      MISO : in std_logic;
      MMUART_0_RXD_F2M : in std_logic;
      RXSM_LO : in std_logic;
      RXSM_SODS : in std_logic;
      RXSM_SOE : in std_logic;
      stamp0_ready_dms1 : in std_logic;
      stamp0_ready_dms2 : in std_logic;
      stamp0_ready_temp : in std_logic;
      stamp0_spi_miso : in std_logic;
      ENABLE_MEMORY_LED : out std_logic;
      LED_HEARTBEAT : out std_logic;
      LED_RECORDING : out std_logic;
      MMUART_0_TXD_M2F : out std_logic;
      MOSI : out std_logic;
      SCLK : out std_logic;
      adc_clk : out std_logic;
      adc_start : out std_logic;
      debug_led : out std_logic;
      nCS1 : out std_logic;
      nCS2 : out std_logic;
      resetn : out std_logic;
      stamp0_spi_clock : out std_logic;
      stamp0_spi_dms1_cs : out std_logic;
      stamp0_spi_dms2_cs : out std_logic;
      stamp0_spi_mosi : out std_logic;
      stamp0_spi_temp_cs : out std_logic
   );
end wrapper_for_sb;

architecture rtl of wrapper_for_sb is

component sb
 port (
   DEVRST_N : in std_logic;
   MISO : in std_logic;
   MMUART_0_RXD_F2M : in std_logic;
   RXSM_LO : in std_logic;
   RXSM_SODS : in std_logic;
   RXSM_SOE : in std_logic;
   stamp0_ready_dms1 : in std_logic;
   stamp0_ready_dms2 : in std_logic;
   stamp0_ready_temp : in std_logic;
   stamp0_spi_miso : in std_logic;
   ENABLE_MEMORY_LED : out std_logic;
   LED_HEARTBEAT : out std_logic;
   LED_RECORDING : out std_logic;
   MMUART_0_TXD_M2F : out std_logic;
   MOSI : out std_logic;
   SCLK : out std_logic;
   adc_clk : out std_logic;
   adc_start : out std_logic;
   debug_led : out std_logic;
   nCS1 : out std_logic;
   nCS2 : out std_logic;
   resetn : out std_logic;
   stamp0_spi_clock : out std_logic;
   stamp0_spi_dms1_cs : out std_logic;
   stamp0_spi_dms2_cs : out std_logic;
   stamp0_spi_mosi : out std_logic;
   stamp0_spi_temp_cs : out std_logic
 );
end component;

signal tmp_DEVRST_N : std_logic;
signal tmp_MISO : std_logic;
signal tmp_MMUART_0_RXD_F2M : std_logic;
signal tmp_RXSM_LO : std_logic;
signal tmp_RXSM_SODS : std_logic;
signal tmp_RXSM_SOE : std_logic;
signal tmp_stamp0_ready_dms1 : std_logic;
signal tmp_stamp0_ready_dms2 : std_logic;
signal tmp_stamp0_ready_temp : std_logic;
signal tmp_stamp0_spi_miso : std_logic;
signal tmp_ENABLE_MEMORY_LED : std_logic;
signal tmp_LED_HEARTBEAT : std_logic;
signal tmp_LED_RECORDING : std_logic;
signal tmp_MMUART_0_TXD_M2F : std_logic;
signal tmp_MOSI : std_logic;
signal tmp_SCLK : std_logic;
signal tmp_adc_clk : std_logic;
signal tmp_adc_start : std_logic;
signal tmp_debug_led : std_logic;
signal tmp_nCS1 : std_logic;
signal tmp_nCS2 : std_logic;
signal tmp_resetn : std_logic;
signal tmp_stamp0_spi_clock : std_logic;
signal tmp_stamp0_spi_dms1_cs : std_logic;
signal tmp_stamp0_spi_dms2_cs : std_logic;
signal tmp_stamp0_spi_mosi : std_logic;
signal tmp_stamp0_spi_temp_cs : std_logic;

begin

tmp_DEVRST_N <= DEVRST_N;

tmp_MISO <= MISO;

tmp_MMUART_0_RXD_F2M <= MMUART_0_RXD_F2M;

tmp_RXSM_LO <= RXSM_LO;

tmp_RXSM_SODS <= RXSM_SODS;

tmp_RXSM_SOE <= RXSM_SOE;

tmp_stamp0_ready_dms1 <= stamp0_ready_dms1;

tmp_stamp0_ready_dms2 <= stamp0_ready_dms2;

tmp_stamp0_ready_temp <= stamp0_ready_temp;

tmp_stamp0_spi_miso <= stamp0_spi_miso;

ENABLE_MEMORY_LED <= tmp_ENABLE_MEMORY_LED;

LED_HEARTBEAT <= tmp_LED_HEARTBEAT;

LED_RECORDING <= tmp_LED_RECORDING;

MMUART_0_TXD_M2F <= tmp_MMUART_0_TXD_M2F;

MOSI <= tmp_MOSI;

SCLK <= tmp_SCLK;

adc_clk <= tmp_adc_clk;

adc_start <= tmp_adc_start;

debug_led <= tmp_debug_led;

nCS1 <= tmp_nCS1;

nCS2 <= tmp_nCS2;

resetn <= tmp_resetn;

stamp0_spi_clock <= tmp_stamp0_spi_clock;

stamp0_spi_dms1_cs <= tmp_stamp0_spi_dms1_cs;

stamp0_spi_dms2_cs <= tmp_stamp0_spi_dms2_cs;

stamp0_spi_mosi <= tmp_stamp0_spi_mosi;

stamp0_spi_temp_cs <= tmp_stamp0_spi_temp_cs;



u1:   sb port map (
		DEVRST_N => tmp_DEVRST_N,
		MISO => tmp_MISO,
		MMUART_0_RXD_F2M => tmp_MMUART_0_RXD_F2M,
		RXSM_LO => tmp_RXSM_LO,
		RXSM_SODS => tmp_RXSM_SODS,
		RXSM_SOE => tmp_RXSM_SOE,
		stamp0_ready_dms1 => tmp_stamp0_ready_dms1,
		stamp0_ready_dms2 => tmp_stamp0_ready_dms2,
		stamp0_ready_temp => tmp_stamp0_ready_temp,
		stamp0_spi_miso => tmp_stamp0_spi_miso,
		ENABLE_MEMORY_LED => tmp_ENABLE_MEMORY_LED,
		LED_HEARTBEAT => tmp_LED_HEARTBEAT,
		LED_RECORDING => tmp_LED_RECORDING,
		MMUART_0_TXD_M2F => tmp_MMUART_0_TXD_M2F,
		MOSI => tmp_MOSI,
		SCLK => tmp_SCLK,
		adc_clk => tmp_adc_clk,
		adc_start => tmp_adc_start,
		debug_led => tmp_debug_led,
		nCS1 => tmp_nCS1,
		nCS2 => tmp_nCS2,
		resetn => tmp_resetn,
		stamp0_spi_clock => tmp_stamp0_spi_clock,
		stamp0_spi_dms1_cs => tmp_stamp0_spi_dms1_cs,
		stamp0_spi_dms2_cs => tmp_stamp0_spi_dms2_cs,
		stamp0_spi_mosi => tmp_stamp0_spi_mosi,
		stamp0_spi_temp_cs => tmp_stamp0_spi_temp_cs
       );
end rtl;
