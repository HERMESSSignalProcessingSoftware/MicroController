--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Apr 14 23:03:54 2021
--
library ieee;
use ieee.std_logic_1164.all;

entity wrapper_for_sb is
   port (
      DAPI_RX : in std_logic;
      DEVRST_N : in std_logic;
      RXSM_LO : in std_logic;
      RXSM_SODS : in std_logic;
      RXSM_SOE : in std_logic;
      SPI_DATASTORAGE_DI : in std_logic;
      TM_RX : in std_logic;
      stamp0_ready_dms1 : in std_logic;
      stamp0_ready_dms2 : in std_logic;
      stamp0_ready_temp : in std_logic;
      stamp0_spi_miso : in std_logic;
      DAPI_TX : out std_logic;
      LED_HEARTBEAT : out std_logic;
      LED_RECORDING : out std_logic;
      SPI_DATASTORAGE_DO : out std_logic;
      TM_TX : out std_logic;
      adc_clk : out std_logic;
      adc_start : out std_logic;
      debug_led : out std_logic;
      resetn : out std_logic;
      stamp0_spi_clock : out std_logic;
      stamp0_spi_dms1_cs : out std_logic;
      stamp0_spi_dms2_cs : out std_logic;
      stamp0_spi_mosi : out std_logic;
      stamp0_spi_temp_cs : out std_logic;
      SPI_DATASTORAGE_CLK : in std_logic;
      SPI_DATASTORAGE_SS0 : in std_logic
   );
end wrapper_for_sb;

architecture rtl of wrapper_for_sb is

component sb
 port (
   DAPI_RX : in std_logic;
   DEVRST_N : in std_logic;
   RXSM_LO : in std_logic;
   RXSM_SODS : in std_logic;
   RXSM_SOE : in std_logic;
   SPI_DATASTORAGE_DI : in std_logic;
   TM_RX : in std_logic;
   stamp0_ready_dms1 : in std_logic;
   stamp0_ready_dms2 : in std_logic;
   stamp0_ready_temp : in std_logic;
   stamp0_spi_miso : in std_logic;
   DAPI_TX : out std_logic;
   LED_HEARTBEAT : out std_logic;
   LED_RECORDING : out std_logic;
   SPI_DATASTORAGE_DO : out std_logic;
   TM_TX : out std_logic;
   adc_clk : out std_logic;
   adc_start : out std_logic;
   debug_led : out std_logic;
   resetn : out std_logic;
   stamp0_spi_clock : out std_logic;
   stamp0_spi_dms1_cs : out std_logic;
   stamp0_spi_dms2_cs : out std_logic;
   stamp0_spi_mosi : out std_logic;
   stamp0_spi_temp_cs : out std_logic;
   SPI_DATASTORAGE_CLK : inout std_logic;
   SPI_DATASTORAGE_SS0 : inout std_logic
 );
end component;

signal tmp_DAPI_RX : std_logic;
signal tmp_DEVRST_N : std_logic;
signal tmp_RXSM_LO : std_logic;
signal tmp_RXSM_SODS : std_logic;
signal tmp_RXSM_SOE : std_logic;
signal tmp_SPI_DATASTORAGE_DI : std_logic;
signal tmp_TM_RX : std_logic;
signal tmp_stamp0_ready_dms1 : std_logic;
signal tmp_stamp0_ready_dms2 : std_logic;
signal tmp_stamp0_ready_temp : std_logic;
signal tmp_stamp0_spi_miso : std_logic;
signal tmp_DAPI_TX : std_logic;
signal tmp_LED_HEARTBEAT : std_logic;
signal tmp_LED_RECORDING : std_logic;
signal tmp_SPI_DATASTORAGE_DO : std_logic;
signal tmp_TM_TX : std_logic;
signal tmp_adc_clk : std_logic;
signal tmp_adc_start : std_logic;
signal tmp_debug_led : std_logic;
signal tmp_resetn : std_logic;
signal tmp_stamp0_spi_clock : std_logic;
signal tmp_stamp0_spi_dms1_cs : std_logic;
signal tmp_stamp0_spi_dms2_cs : std_logic;
signal tmp_stamp0_spi_mosi : std_logic;
signal tmp_stamp0_spi_temp_cs : std_logic;
signal tmp_SPI_DATASTORAGE_CLK : std_logic;
signal tmp_SPI_DATASTORAGE_SS0 : std_logic;

begin

tmp_DAPI_RX <= DAPI_RX;

tmp_DEVRST_N <= DEVRST_N;

tmp_RXSM_LO <= RXSM_LO;

tmp_RXSM_SODS <= RXSM_SODS;

tmp_RXSM_SOE <= RXSM_SOE;

tmp_SPI_DATASTORAGE_DI <= SPI_DATASTORAGE_DI;

tmp_TM_RX <= TM_RX;

tmp_stamp0_ready_dms1 <= stamp0_ready_dms1;

tmp_stamp0_ready_dms2 <= stamp0_ready_dms2;

tmp_stamp0_ready_temp <= stamp0_ready_temp;

tmp_stamp0_spi_miso <= stamp0_spi_miso;

DAPI_TX <= tmp_DAPI_TX;

LED_HEARTBEAT <= tmp_LED_HEARTBEAT;

LED_RECORDING <= tmp_LED_RECORDING;

SPI_DATASTORAGE_DO <= tmp_SPI_DATASTORAGE_DO;

TM_TX <= tmp_TM_TX;

adc_clk <= tmp_adc_clk;

adc_start <= tmp_adc_start;

debug_led <= tmp_debug_led;

resetn <= tmp_resetn;

stamp0_spi_clock <= tmp_stamp0_spi_clock;

stamp0_spi_dms1_cs <= tmp_stamp0_spi_dms1_cs;

stamp0_spi_dms2_cs <= tmp_stamp0_spi_dms2_cs;

stamp0_spi_mosi <= tmp_stamp0_spi_mosi;

stamp0_spi_temp_cs <= tmp_stamp0_spi_temp_cs;

tmp_SPI_DATASTORAGE_CLK <= SPI_DATASTORAGE_CLK;

tmp_SPI_DATASTORAGE_SS0 <= SPI_DATASTORAGE_SS0;



u1:   sb port map (
		DAPI_RX => tmp_DAPI_RX,
		DEVRST_N => tmp_DEVRST_N,
		RXSM_LO => tmp_RXSM_LO,
		RXSM_SODS => tmp_RXSM_SODS,
		RXSM_SOE => tmp_RXSM_SOE,
		SPI_DATASTORAGE_DI => tmp_SPI_DATASTORAGE_DI,
		TM_RX => tmp_TM_RX,
		stamp0_ready_dms1 => tmp_stamp0_ready_dms1,
		stamp0_ready_dms2 => tmp_stamp0_ready_dms2,
		stamp0_ready_temp => tmp_stamp0_ready_temp,
		stamp0_spi_miso => tmp_stamp0_spi_miso,
		DAPI_TX => tmp_DAPI_TX,
		LED_HEARTBEAT => tmp_LED_HEARTBEAT,
		LED_RECORDING => tmp_LED_RECORDING,
		SPI_DATASTORAGE_DO => tmp_SPI_DATASTORAGE_DO,
		TM_TX => tmp_TM_TX,
		adc_clk => tmp_adc_clk,
		adc_start => tmp_adc_start,
		debug_led => tmp_debug_led,
		resetn => tmp_resetn,
		stamp0_spi_clock => tmp_stamp0_spi_clock,
		stamp0_spi_dms1_cs => tmp_stamp0_spi_dms1_cs,
		stamp0_spi_dms2_cs => tmp_stamp0_spi_dms2_cs,
		stamp0_spi_mosi => tmp_stamp0_spi_mosi,
		stamp0_spi_temp_cs => tmp_stamp0_spi_temp_cs,
		SPI_DATASTORAGE_CLK => tmp_SPI_DATASTORAGE_CLK,
		SPI_DATASTORAGE_SS0 => tmp_SPI_DATASTORAGE_SS0
       );
end rtl;
