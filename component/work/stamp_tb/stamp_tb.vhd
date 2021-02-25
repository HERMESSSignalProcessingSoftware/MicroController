----------------------------------------------------------------------
-- Created by SmartDesign Fri Feb 26 21:04:40 2021
-- Version: v12.6 12.900.20.24
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- stamp_tb entity declaration
----------------------------------------------------------------------
entity stamp_tb is
    -- Port list
    port(
        -- Inputs
        DAPI_RX             : in    std_logic;
        DEVRST_N            : in    std_logic;
        RXSM_LO             : in    std_logic;
        RXSM_SODS           : in    std_logic;
        RXSM_SOE            : in    std_logic;
        SPI_DATASTORAGE_DI  : in    std_logic;
        TM_RX               : in    std_logic;
        stamp0_ready_dms1   : in    std_logic;
        stamp0_ready_dms2   : in    std_logic;
        stamp0_ready_temp   : in    std_logic;
        stamp0_spi_miso     : in    std_logic;
        -- Outputs
        DAPI_TX             : out   std_logic;
        LED_HEARTBEAT       : out   std_logic;
        LED_RECORDING       : out   std_logic;
        SPI_DATASTORAGE_DO  : out   std_logic;
        TM_TX               : out   std_logic;
        adc_resetn          : out   std_logic;
        adc_start           : out   std_logic;
        stamp0_spi_clock    : out   std_logic;
        stamp0_spi_dms1_cs  : out   std_logic;
        stamp0_spi_dms2_cs  : out   std_logic;
        stamp0_spi_mosi     : out   std_logic;
        stamp0_spi_temp_cs  : out   std_logic;
        -- Inouts
        SPI_DATASTORAGE_CLK : inout std_logic;
        SPI_DATASTORAGE_SS0 : inout std_logic
        );
end stamp_tb;
----------------------------------------------------------------------
-- stamp_tb architecture body
----------------------------------------------------------------------
architecture RTL of stamp_tb is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- sb
component sb
    -- Port list
    port(
        -- Inputs
        DAPI_RX             : in    std_logic;
        DEVRST_N            : in    std_logic;
        RXSM_LO             : in    std_logic;
        RXSM_SODS           : in    std_logic;
        RXSM_SOE            : in    std_logic;
        SPI_DATASTORAGE_DI  : in    std_logic;
        TM_RX               : in    std_logic;
        stamp0_ready_dms1   : in    std_logic;
        stamp0_ready_dms2   : in    std_logic;
        stamp0_ready_temp   : in    std_logic;
        stamp0_spi_miso     : in    std_logic;
        -- Outputs
        DAPI_TX             : out   std_logic;
        LED_HEARTBEAT       : out   std_logic;
        LED_RECORDING       : out   std_logic;
        SPI_DATASTORAGE_DO  : out   std_logic;
        TM_TX               : out   std_logic;
        adc_resetn          : out   std_logic;
        adc_start           : out   std_logic;
        stamp0_spi_clock    : out   std_logic;
        stamp0_spi_dms1_cs  : out   std_logic;
        stamp0_spi_dms2_cs  : out   std_logic;
        stamp0_spi_mosi     : out   std_logic;
        stamp0_spi_temp_cs  : out   std_logic;
        -- Inouts
        SPI_DATASTORAGE_CLK : inout std_logic;
        SPI_DATASTORAGE_SS0 : inout std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal adc_resetn_net_0         : std_logic;
signal adc_start_net_0          : std_logic;
signal DAPI_TX_net_0            : std_logic;
signal LED_HEARTBEAT_net_0      : std_logic;
signal LED_RECORDING_net_0      : std_logic;
signal SPI_DATASTORAGE_DO_net_0 : std_logic;
signal stamp0_spi_clock_net_0   : std_logic;
signal stamp0_spi_dms1_cs_net_0 : std_logic;
signal stamp0_spi_dms2_cs_net_0 : std_logic;
signal stamp0_spi_mosi_net_0    : std_logic;
signal stamp0_spi_temp_cs_net_0 : std_logic;
signal TM_TX_net_0              : std_logic;
signal stamp0_spi_clock_net_1   : std_logic;
signal stamp0_spi_mosi_net_1    : std_logic;
signal stamp0_spi_dms1_cs_net_1 : std_logic;
signal stamp0_spi_temp_cs_net_1 : std_logic;
signal stamp0_spi_dms2_cs_net_1 : std_logic;
signal adc_start_net_1          : std_logic;
signal adc_resetn_net_1         : std_logic;
signal TM_TX_net_1              : std_logic;
signal DAPI_TX_net_1            : std_logic;
signal LED_HEARTBEAT_net_1      : std_logic;
signal LED_RECORDING_net_1      : std_logic;
signal SPI_DATASTORAGE_DO_net_1 : std_logic;

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 stamp0_spi_clock_net_1   <= stamp0_spi_clock_net_0;
 stamp0_spi_clock         <= stamp0_spi_clock_net_1;
 stamp0_spi_mosi_net_1    <= stamp0_spi_mosi_net_0;
 stamp0_spi_mosi          <= stamp0_spi_mosi_net_1;
 stamp0_spi_dms1_cs_net_1 <= stamp0_spi_dms1_cs_net_0;
 stamp0_spi_dms1_cs       <= stamp0_spi_dms1_cs_net_1;
 stamp0_spi_temp_cs_net_1 <= stamp0_spi_temp_cs_net_0;
 stamp0_spi_temp_cs       <= stamp0_spi_temp_cs_net_1;
 stamp0_spi_dms2_cs_net_1 <= stamp0_spi_dms2_cs_net_0;
 stamp0_spi_dms2_cs       <= stamp0_spi_dms2_cs_net_1;
 adc_start_net_1          <= adc_start_net_0;
 adc_start                <= adc_start_net_1;
 adc_resetn_net_1         <= adc_resetn_net_0;
 adc_resetn               <= adc_resetn_net_1;
 TM_TX_net_1              <= TM_TX_net_0;
 TM_TX                    <= TM_TX_net_1;
 DAPI_TX_net_1            <= DAPI_TX_net_0;
 DAPI_TX                  <= DAPI_TX_net_1;
 LED_HEARTBEAT_net_1      <= LED_HEARTBEAT_net_0;
 LED_HEARTBEAT            <= LED_HEARTBEAT_net_1;
 LED_RECORDING_net_1      <= LED_RECORDING_net_0;
 LED_RECORDING            <= LED_RECORDING_net_1;
 SPI_DATASTORAGE_DO_net_1 <= SPI_DATASTORAGE_DO_net_0;
 SPI_DATASTORAGE_DO       <= SPI_DATASTORAGE_DO_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- sb_0
sb_0 : sb
    port map( 
        -- Inputs
        TM_RX               => TM_RX,
        DAPI_RX             => DAPI_RX,
        DEVRST_N            => DEVRST_N,
        RXSM_LO             => RXSM_LO,
        SPI_DATASTORAGE_DI  => SPI_DATASTORAGE_DI,
        stamp0_spi_miso     => stamp0_spi_miso,
        stamp0_ready_dms1   => stamp0_ready_dms1,
        stamp0_ready_dms2   => stamp0_ready_dms2,
        stamp0_ready_temp   => stamp0_ready_temp,
        RXSM_SODS           => RXSM_SODS,
        RXSM_SOE            => RXSM_SOE,
        -- Outputs
        TM_TX               => TM_TX_net_0,
        DAPI_TX             => DAPI_TX_net_0,
        LED_RECORDING       => LED_RECORDING_net_0,
        LED_HEARTBEAT       => LED_HEARTBEAT_net_0,
        SPI_DATASTORAGE_DO  => SPI_DATASTORAGE_DO_net_0,
        stamp0_spi_clock    => stamp0_spi_clock_net_0,
        stamp0_spi_mosi     => stamp0_spi_mosi_net_0,
        stamp0_spi_dms1_cs  => stamp0_spi_dms1_cs_net_0,
        stamp0_spi_temp_cs  => stamp0_spi_temp_cs_net_0,
        stamp0_spi_dms2_cs  => stamp0_spi_dms2_cs_net_0,
        adc_start           => adc_start_net_0,
        adc_resetn          => adc_resetn_net_0,
        -- Inouts
        SPI_DATASTORAGE_CLK => SPI_DATASTORAGE_CLK,
        SPI_DATASTORAGE_SS0 => SPI_DATASTORAGE_SS0 
        );

end RTL;
