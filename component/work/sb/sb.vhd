----------------------------------------------------------------------
-- Created by SmartDesign Mon Feb 14 21:50:49 2022
-- Version: v2021.2 2021.2.0.11
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library HERMESS_TELEMETRY;
use HERMESS_TELEMETRY.all;
----------------------------------------------------------------------
-- sb entity declaration
----------------------------------------------------------------------
entity sb is
    -- Port list
    port(
        -- Inputs
        DAPI_RXD         : in  std_logic;
        DEVRST_N         : in  std_logic;
        F_MISO           : in  std_logic;
        IN_RXSM_LO       : in  std_logic;
        IN_RXSM_SODS     : in  std_logic;
        IN_RXSM_SOE      : in  std_logic;
        STAMP1_DRDY_SGR1 : in  std_logic;
        STAMP1_DRDY_SGR2 : in  std_logic;
        STAMP1_DRDY_TEMP : in  std_logic;
        STAMP1_MISO      : in  std_logic;
        STAMP2_DRDY_SGR1 : in  std_logic;
        STAMP2_DRDY_SGR2 : in  std_logic;
        STAMP2_DRDY_TEMP : in  std_logic;
        STAMP2_MISO      : in  std_logic;
        STAMP3_DRDY_SGR1 : in  std_logic;
        STAMP3_DRDY_SGR2 : in  std_logic;
        STAMP3_DRDY_TEMP : in  std_logic;
        STAMP3_MISO      : in  std_logic;
        STAMP4_DRDY_SGR1 : in  std_logic;
        STAMP4_DRDY_SGR2 : in  std_logic;
        STAMP4_DRDY_TEMP : in  std_logic;
        STAMP4_MISO      : in  std_logic;
        STAMP5_DRDY_SGR1 : in  std_logic;
        STAMP5_DRDY_SGR2 : in  std_logic;
        STAMP5_DRDY_TEMP : in  std_logic;
        STAMP5_MISO      : in  std_logic;
        STAMP6_DRDY_SGR1 : in  std_logic;
        STAMP6_DRDY_SGR2 : in  std_logic;
        STAMP6_DRDY_TEMP : in  std_logic;
        STAMP6_MISO      : in  std_logic;
        TM_RXD           : in  std_logic;
        WP               : in  std_logic;
        -- Outputs
        DAPI_TXD         : out std_logic;
        F_CLK            : out std_logic;
        F_CS1            : out std_logic;
        F_CS2            : out std_logic;
        F_MOSI           : out std_logic;
        LED_FPGA_LOADED  : out std_logic;
        LED_HB_MEMSYNC   : out std_logic;
        LED_HB_MSS       : out std_logic;
        LED_RECORDING    : out std_logic;
        OUT_ADC_START    : out std_logic;
        STAMP1_CS_SGR1   : out std_logic;
        STAMP1_CS_SGR2   : out std_logic;
        STAMP1_CS_TEMP   : out std_logic;
        STAMP1_MOSI      : out std_logic;
        STAMP1_SCLK      : out std_logic;
        STAMP2_CS_SGR1   : out std_logic;
        STAMP2_CS_SGR2   : out std_logic;
        STAMP2_CS_TEMP   : out std_logic;
        STAMP2_MOSI      : out std_logic;
        STAMP2_SCLK      : out std_logic;
        STAMP3_CS_SGR1   : out std_logic;
        STAMP3_CS_SGR2   : out std_logic;
        STAMP3_CS_TEMP   : out std_logic;
        STAMP3_MOSI      : out std_logic;
        STAMP3_SCLK      : out std_logic;
        STAMP4_CS_SGR1   : out std_logic;
        STAMP4_CS_SGR2   : out std_logic;
        STAMP4_CS_TEMP   : out std_logic;
        STAMP4_MOSI      : out std_logic;
        STAMP4_SCLK      : out std_logic;
        STAMP5_CS_SGR1   : out std_logic;
        STAMP5_CS_SGR2   : out std_logic;
        STAMP5_CS_TEMP   : out std_logic;
        STAMP5_MOSI      : out std_logic;
        STAMP5_SCLK      : out std_logic;
        STAMP6_CS_SGR1   : out std_logic;
        STAMP6_CS_SGR2   : out std_logic;
        STAMP6_CS_TEMP   : out std_logic;
        STAMP6_MOSI      : out std_logic;
        STAMP6_SCLK      : out std_logic;
        TM_TXD           : out std_logic
        );
end sb;
----------------------------------------------------------------------
-- sb architecture body
----------------------------------------------------------------------
architecture RTL of sb is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- AND2
component AND2
    -- Port list
    port(
        -- Inputs
        A : in  std_logic;
        B : in  std_logic;
        -- Outputs
        Y : out std_logic
        );
end component;
-- MemorySynchronizer
-- using entity instantiation for component MemorySynchronizer
-- sb_sb
component sb_sb
    -- Port list
    port(
        -- Inputs
        DEVRST_N               : in  std_logic;
        FAB_RESET_N            : in  std_logic;
        GPIO_0_F2M             : in  std_logic;
        GPIO_1_F2M             : in  std_logic;
        GPIO_2_F2M             : in  std_logic;
        GPIO_5_F2M             : in  std_logic;
        MMUART_0_RXD_F2M       : in  std_logic;
        MemSync_0_INTR_0_top   : in  std_logic;
        MemSync_PRDATAS0       : in  std_logic_vector(31 downto 0);
        MemSync_PREADYS0       : in  std_logic;
        MemSync_PSLVERRS0      : in  std_logic;
        SPI_0_CLK_F2M          : in  std_logic;
        SPI_0_DI_F2M           : in  std_logic;
        SPI_0_SS0_F2M          : in  std_logic;
        STAMP_0_INTR_0_top     : in  std_logic;
        STAMP_1_INTR_0_top     : in  std_logic;
        STAMP_1_PRDATAS2       : in  std_logic_vector(31 downto 0);
        STAMP_1_PREADYS2       : in  std_logic;
        STAMP_1_PSLVERRS2      : in  std_logic;
        STAMP_2_INTR_0_top     : in  std_logic;
        STAMP_2_PRDATAS3       : in  std_logic_vector(31 downto 0);
        STAMP_2_PREADYS3       : in  std_logic;
        STAMP_2_PSLVERRS3      : in  std_logic;
        STAMP_3_INTR_0_top     : in  std_logic;
        STAMP_3_PRDATAS4       : in  std_logic_vector(31 downto 0);
        STAMP_3_PREADYS4       : in  std_logic;
        STAMP_3_PSLVERRS4      : in  std_logic;
        STAMP_4_INTR_0_top     : in  std_logic;
        STAMP_4_PRDATAS5       : in  std_logic_vector(31 downto 0);
        STAMP_4_PREADYS5       : in  std_logic;
        STAMP_4_PSLVERRS5      : in  std_logic;
        STAMP_5_INTR_0_top     : in  std_logic;
        STAMP_5_PRDATAS6       : in  std_logic_vector(31 downto 0);
        STAMP_5_PREADYS6       : in  std_logic;
        STAMP_5_PSLVERRS6      : in  std_logic;
        STAMP_PRDATAS1         : in  std_logic_vector(31 downto 0);
        STAMP_PREADYS1         : in  std_logic;
        STAMP_PSLVERRS1        : in  std_logic;
        Telemetry_0_INTR_0_top : in  std_logic;
        Telemetry_PRDATAS7     : in  std_logic_vector(31 downto 0);
        Telemetry_PREADYS7     : in  std_logic;
        Telemetry_PSLVERRS7    : in  std_logic;
        -- Outputs
        FIC_0_CLK              : out std_logic;
        FIC_0_LOCK             : out std_logic;
        GPIO_12_M2F            : out std_logic;
        GPIO_25_M2F            : out std_logic;
        GPIO_26_M2F            : out std_logic;
        GPIO_28_M2F            : out std_logic;
        GPIO_29_M2F            : out std_logic;
        GPIO_30_M2F            : out std_logic;
        GPIO_31_M2F            : out std_logic;
        GPIO_3_M2F             : out std_logic;
        GPIO_4_M2F             : out std_logic;
        INIT_DONE              : out std_logic;
        MMUART_0_TXD_M2F       : out std_logic;
        MSS_READY              : out std_logic;
        MemSync_PADDRS         : out std_logic_vector(31 downto 0);
        MemSync_PENABLES       : out std_logic;
        MemSync_PSELS0         : out std_logic;
        MemSync_PWDATAS        : out std_logic_vector(31 downto 0);
        MemSync_PWRITES        : out std_logic;
        POWER_ON_RESET_N       : out std_logic;
        SPI_0_CLK_M2F          : out std_logic;
        SPI_0_DO_M2F           : out std_logic;
        SPI_0_SS0_M2F          : out std_logic;
        SPI_0_SS0_M2F_OE       : out std_logic;
        STAMP_1_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_1_PENABLES       : out std_logic;
        STAMP_1_PSELS2         : out std_logic;
        STAMP_1_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_1_PWRITES        : out std_logic;
        STAMP_2_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_2_PENABLES       : out std_logic;
        STAMP_2_PSELS3         : out std_logic;
        STAMP_2_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_2_PWRITES        : out std_logic;
        STAMP_3_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_3_PENABLES       : out std_logic;
        STAMP_3_PSELS4         : out std_logic;
        STAMP_3_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_3_PWRITES        : out std_logic;
        STAMP_4_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_4_PENABLES       : out std_logic;
        STAMP_4_PSELS5         : out std_logic;
        STAMP_4_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_4_PWRITES        : out std_logic;
        STAMP_5_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_5_PENABLES       : out std_logic;
        STAMP_5_PSELS6         : out std_logic;
        STAMP_5_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_5_PWRITES        : out std_logic;
        STAMP_PADDRS           : out std_logic_vector(31 downto 0);
        STAMP_PENABLES         : out std_logic;
        STAMP_PSELS1           : out std_logic;
        STAMP_PWDATAS          : out std_logic_vector(31 downto 0);
        STAMP_PWRITES          : out std_logic;
        Telemetry_PADDRS       : out std_logic_vector(31 downto 0);
        Telemetry_PENABLES     : out std_logic;
        Telemetry_PSELS7       : out std_logic;
        Telemetry_PWDATAS      : out std_logic_vector(31 downto 0);
        Telemetry_PWRITES      : out std_logic
        );
end component;
-- STAMP
-- using entity instantiation for component STAMP
-- telemetry
-- using entity instantiation for component telemetry
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal AND2_0_Y                            : std_logic;
signal DAPI_TXD_net_0                      : std_logic;
signal F_CLK_net_0                         : std_logic;
signal F_CS1_0                             : std_logic;
signal F_CS2_0                             : std_logic;
signal F_MOSI_net_0                        : std_logic;
signal LED_FPGA_LOADED_net_0               : std_logic;
signal LED_HB_MEMSYNC_net_0                : std_logic;
signal LED_HB_MSS_net_0                    : std_logic;
signal LED_RECORDING_net_0                 : std_logic;
signal MemorySynchronizer_0_dataReadyReset : std_logic;
signal MemorySynchronizer_0_ReadInterrupt  : std_logic;
signal OUT_ADC_START_net_0                 : std_logic;
signal sb_sb_0_FIC_0_CLK                   : std_logic;
signal sb_sb_0_GPIO_4_M2F                  : std_logic;
signal sb_sb_0_GPIO_12_M2F                 : std_logic;
signal sb_sb_0_MemSync_PENABLE             : std_logic;
signal sb_sb_0_MemSync_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_MemSync_PREADY              : std_logic;
signal sb_sb_0_MemSync_PSELx               : std_logic;
signal sb_sb_0_MemSync_PSLVERR             : std_logic;
signal sb_sb_0_MemSync_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_MemSync_PWRITE              : std_logic;
signal sb_sb_0_POWER_ON_RESET_N            : std_logic;
signal sb_sb_0_STAMP_PENABLE               : std_logic;
signal sb_sb_0_STAMP_PRDATA                : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PREADY                : std_logic;
signal sb_sb_0_STAMP_PSELx                 : std_logic;
signal sb_sb_0_STAMP_PSLVERR               : std_logic;
signal sb_sb_0_STAMP_PWDATA                : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PWRITE                : std_logic;
signal sb_sb_0_STAMP_1_PENABLE             : std_logic;
signal sb_sb_0_STAMP_1_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_1_PREADY              : std_logic;
signal sb_sb_0_STAMP_1_PSELx               : std_logic;
signal sb_sb_0_STAMP_1_PSLVERR             : std_logic;
signal sb_sb_0_STAMP_1_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_1_PWRITE              : std_logic;
signal sb_sb_0_STAMP_2_PENABLE             : std_logic;
signal sb_sb_0_STAMP_2_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_2_PREADY              : std_logic;
signal sb_sb_0_STAMP_2_PSELx               : std_logic;
signal sb_sb_0_STAMP_2_PSLVERR             : std_logic;
signal sb_sb_0_STAMP_2_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_2_PWRITE              : std_logic;
signal sb_sb_0_STAMP_3_PENABLE             : std_logic;
signal sb_sb_0_STAMP_3_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_3_PREADY              : std_logic;
signal sb_sb_0_STAMP_3_PSELx               : std_logic;
signal sb_sb_0_STAMP_3_PSLVERR             : std_logic;
signal sb_sb_0_STAMP_3_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_3_PWRITE              : std_logic;
signal sb_sb_0_STAMP_4_PENABLE             : std_logic;
signal sb_sb_0_STAMP_4_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_4_PREADY              : std_logic;
signal sb_sb_0_STAMP_4_PSELx               : std_logic;
signal sb_sb_0_STAMP_4_PSLVERR             : std_logic;
signal sb_sb_0_STAMP_4_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_4_PWRITE              : std_logic;
signal sb_sb_0_STAMP_5_PENABLE             : std_logic;
signal sb_sb_0_STAMP_5_PRDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_5_PREADY              : std_logic;
signal sb_sb_0_STAMP_5_PSELx               : std_logic;
signal sb_sb_0_STAMP_5_PSLVERR             : std_logic;
signal sb_sb_0_STAMP_5_PWDATA              : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_5_PWRITE              : std_logic;
signal sb_sb_0_Telemetry_PENABLE           : std_logic;
signal sb_sb_0_Telemetry_PRDATA            : std_logic_vector(31 downto 0);
signal sb_sb_0_Telemetry_PREADY            : std_logic;
signal sb_sb_0_Telemetry_PSELx             : std_logic;
signal sb_sb_0_Telemetry_PSLVERR           : std_logic;
signal sb_sb_0_Telemetry_PWDATA            : std_logic_vector(31 downto 0);
signal sb_sb_0_Telemetry_PWRITE            : std_logic;
signal STAMP1_CS_SGR1_net_0                : std_logic;
signal STAMP1_CS_SGR2_net_0                : std_logic;
signal STAMP1_CS_TEMP_net_0                : std_logic;
signal STAMP1_MOSI_net_0                   : std_logic;
signal STAMP1_SCLK_net_0                   : std_logic;
signal STAMP2_CS_SGR1_net_0                : std_logic;
signal STAMP2_CS_SGR2_net_0                : std_logic;
signal STAMP2_CS_TEMP_net_0                : std_logic;
signal STAMP2_MOSI_net_0                   : std_logic;
signal STAMP2_SCLK_net_0                   : std_logic;
signal STAMP3_CS_SGR1_net_0                : std_logic;
signal STAMP3_CS_SGR2_net_0                : std_logic;
signal STAMP3_CS_TEMP_net_0                : std_logic;
signal STAMP3_MOSI_net_0                   : std_logic;
signal STAMP3_SCLK_net_0                   : std_logic;
signal STAMP4_CS_SGR1_net_0                : std_logic;
signal STAMP4_CS_SGR2_net_0                : std_logic;
signal STAMP4_CS_TEMP_net_0                : std_logic;
signal STAMP4_MOSI_net_0                   : std_logic;
signal STAMP4_SCLK_net_0                   : std_logic;
signal STAMP5_CS_SGR1_net_0                : std_logic;
signal STAMP5_CS_SGR2_net_0                : std_logic;
signal STAMP5_CS_TEMP_net_0                : std_logic;
signal STAMP5_MOSI_net_0                   : std_logic;
signal STAMP5_SCLK_net_0                   : std_logic;
signal STAMP6_CS_SGR1_net_0                : std_logic;
signal STAMP6_CS_SGR2_net_0                : std_logic;
signal STAMP6_CS_TEMP_net_0                : std_logic;
signal STAMP6_MOSI_net_0                   : std_logic;
signal STAMP6_SCLK_net_0                   : std_logic;
signal STAMP_1_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_1_new_avail                   : std_logic;
signal STAMP_1_request_resync              : std_logic;
signal STAMP_2_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_2_new_avail                   : std_logic;
signal STAMP_2_request_resync              : std_logic;
signal STAMP_3_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_3_new_avail                   : std_logic;
signal STAMP_3_request_resync              : std_logic;
signal STAMP_4_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_4_new_avail                   : std_logic;
signal STAMP_4_request_resync              : std_logic;
signal STAMP_5_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_5_new_avail                   : std_logic;
signal STAMP_5_request_resync              : std_logic;
signal STAMP_6_data_frame                  : std_logic_vector(63 downto 0);
signal STAMP_6_new_avail                   : std_logic;
signal STAMP_6_request_resync              : std_logic;
signal telemetry_0_INTERRUPT               : std_logic;
signal TM_TXD_0                            : std_logic;
signal LED_HB_MSS_net_1                    : std_logic;
signal LED_RECORDING_net_1                 : std_logic;
signal OUT_ADC_START_net_1                 : std_logic;
signal LED_HB_MEMSYNC_net_1                : std_logic;
signal DAPI_TXD_net_1                      : std_logic;
signal TM_TXD_0_net_0                      : std_logic;
signal F_CS2_0_net_0                       : std_logic;
signal F_CLK_net_1                         : std_logic;
signal F_MOSI_net_1                        : std_logic;
signal F_CS1_0_net_0                       : std_logic;
signal STAMP1_CS_TEMP_net_1                : std_logic;
signal STAMP1_MOSI_net_1                   : std_logic;
signal STAMP1_CS_SGR2_net_1                : std_logic;
signal STAMP1_CS_SGR1_net_1                : std_logic;
signal STAMP1_SCLK_net_1                   : std_logic;
signal STAMP6_CS_TEMP_net_1                : std_logic;
signal STAMP6_CS_SGR2_net_1                : std_logic;
signal STAMP6_CS_SGR1_net_1                : std_logic;
signal STAMP6_SCLK_net_1                   : std_logic;
signal STAMP6_MOSI_net_1                   : std_logic;
signal STAMP4_CS_TEMP_net_1                : std_logic;
signal STAMP4_CS_SGR2_net_1                : std_logic;
signal STAMP4_CS_SGR1_net_1                : std_logic;
signal STAMP4_SCLK_net_1                   : std_logic;
signal STAMP4_MOSI_net_1                   : std_logic;
signal STAMP5_CS_TEMP_net_1                : std_logic;
signal STAMP5_CS_SGR2_net_1                : std_logic;
signal STAMP5_CS_SGR1_net_1                : std_logic;
signal STAMP5_SCLK_net_1                   : std_logic;
signal STAMP5_MOSI_net_1                   : std_logic;
signal STAMP3_CS_TEMP_net_1                : std_logic;
signal STAMP3_CS_SGR2_net_1                : std_logic;
signal STAMP3_CS_SGR1_net_1                : std_logic;
signal STAMP3_SCLK_net_1                   : std_logic;
signal STAMP3_MOSI_net_1                   : std_logic;
signal STAMP2_CS_TEMP_net_1                : std_logic;
signal STAMP2_CS_SGR2_net_1                : std_logic;
signal STAMP2_CS_SGR1_net_1                : std_logic;
signal STAMP2_SCLK_net_1                   : std_logic;
signal STAMP2_MOSI_net_1                   : std_logic;
signal LED_FPGA_LOADED_net_1               : std_logic;
signal IN_databus_net_0                    : std_logic_vector(383 downto 0);
signal IN_newAvails_net_0                  : std_logic_vector(5 downto 0);
signal IN_requestSync_net_0                : std_logic_vector(5 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                             : std_logic;
signal GND_net                             : std_logic;
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal sb_sb_0_MemSync_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_MemSync_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_MemSync_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_PADDR                 : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PADDR_0               : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_PADDR_0_11to0         : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_1_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_1_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_1_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_2_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_2_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_2_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_3_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_3_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_3_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_4_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_4_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_4_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_STAMP_5_PADDR               : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_5_PADDR_0             : std_logic_vector(11 downto 0);
signal sb_sb_0_STAMP_5_PADDR_0_11to0       : std_logic_vector(11 downto 0);

signal sb_sb_0_Telemetry_PADDR             : std_logic_vector(31 downto 0);
signal sb_sb_0_Telemetry_PADDR_0           : std_logic_vector(11 downto 0);
signal sb_sb_0_Telemetry_PADDR_0_11to0     : std_logic_vector(11 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net <= '1';
 GND_net <= '0';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 LED_HB_MSS_net_1      <= LED_HB_MSS_net_0;
 LED_HB_MSS            <= LED_HB_MSS_net_1;
 LED_RECORDING_net_1   <= LED_RECORDING_net_0;
 LED_RECORDING         <= LED_RECORDING_net_1;
 OUT_ADC_START_net_1   <= OUT_ADC_START_net_0;
 OUT_ADC_START         <= OUT_ADC_START_net_1;
 LED_HB_MEMSYNC_net_1  <= LED_HB_MEMSYNC_net_0;
 LED_HB_MEMSYNC        <= LED_HB_MEMSYNC_net_1;
 DAPI_TXD_net_1        <= DAPI_TXD_net_0;
 DAPI_TXD              <= DAPI_TXD_net_1;
 TM_TXD_0_net_0        <= TM_TXD_0;
 TM_TXD                <= TM_TXD_0_net_0;
 F_CS2_0_net_0         <= F_CS2_0;
 F_CS2                 <= F_CS2_0_net_0;
 F_CLK_net_1           <= F_CLK_net_0;
 F_CLK                 <= F_CLK_net_1;
 F_MOSI_net_1          <= F_MOSI_net_0;
 F_MOSI                <= F_MOSI_net_1;
 F_CS1_0_net_0         <= F_CS1_0;
 F_CS1                 <= F_CS1_0_net_0;
 STAMP1_CS_TEMP_net_1  <= STAMP1_CS_TEMP_net_0;
 STAMP1_CS_TEMP        <= STAMP1_CS_TEMP_net_1;
 STAMP1_MOSI_net_1     <= STAMP1_MOSI_net_0;
 STAMP1_MOSI           <= STAMP1_MOSI_net_1;
 STAMP1_CS_SGR2_net_1  <= STAMP1_CS_SGR2_net_0;
 STAMP1_CS_SGR2        <= STAMP1_CS_SGR2_net_1;
 STAMP1_CS_SGR1_net_1  <= STAMP1_CS_SGR1_net_0;
 STAMP1_CS_SGR1        <= STAMP1_CS_SGR1_net_1;
 STAMP1_SCLK_net_1     <= STAMP1_SCLK_net_0;
 STAMP1_SCLK           <= STAMP1_SCLK_net_1;
 STAMP6_CS_TEMP_net_1  <= STAMP6_CS_TEMP_net_0;
 STAMP6_CS_TEMP        <= STAMP6_CS_TEMP_net_1;
 STAMP6_CS_SGR2_net_1  <= STAMP6_CS_SGR2_net_0;
 STAMP6_CS_SGR2        <= STAMP6_CS_SGR2_net_1;
 STAMP6_CS_SGR1_net_1  <= STAMP6_CS_SGR1_net_0;
 STAMP6_CS_SGR1        <= STAMP6_CS_SGR1_net_1;
 STAMP6_SCLK_net_1     <= STAMP6_SCLK_net_0;
 STAMP6_SCLK           <= STAMP6_SCLK_net_1;
 STAMP6_MOSI_net_1     <= STAMP6_MOSI_net_0;
 STAMP6_MOSI           <= STAMP6_MOSI_net_1;
 STAMP4_CS_TEMP_net_1  <= STAMP4_CS_TEMP_net_0;
 STAMP4_CS_TEMP        <= STAMP4_CS_TEMP_net_1;
 STAMP4_CS_SGR2_net_1  <= STAMP4_CS_SGR2_net_0;
 STAMP4_CS_SGR2        <= STAMP4_CS_SGR2_net_1;
 STAMP4_CS_SGR1_net_1  <= STAMP4_CS_SGR1_net_0;
 STAMP4_CS_SGR1        <= STAMP4_CS_SGR1_net_1;
 STAMP4_SCLK_net_1     <= STAMP4_SCLK_net_0;
 STAMP4_SCLK           <= STAMP4_SCLK_net_1;
 STAMP4_MOSI_net_1     <= STAMP4_MOSI_net_0;
 STAMP4_MOSI           <= STAMP4_MOSI_net_1;
 STAMP5_CS_TEMP_net_1  <= STAMP5_CS_TEMP_net_0;
 STAMP5_CS_TEMP        <= STAMP5_CS_TEMP_net_1;
 STAMP5_CS_SGR2_net_1  <= STAMP5_CS_SGR2_net_0;
 STAMP5_CS_SGR2        <= STAMP5_CS_SGR2_net_1;
 STAMP5_CS_SGR1_net_1  <= STAMP5_CS_SGR1_net_0;
 STAMP5_CS_SGR1        <= STAMP5_CS_SGR1_net_1;
 STAMP5_SCLK_net_1     <= STAMP5_SCLK_net_0;
 STAMP5_SCLK           <= STAMP5_SCLK_net_1;
 STAMP5_MOSI_net_1     <= STAMP5_MOSI_net_0;
 STAMP5_MOSI           <= STAMP5_MOSI_net_1;
 STAMP3_CS_TEMP_net_1  <= STAMP3_CS_TEMP_net_0;
 STAMP3_CS_TEMP        <= STAMP3_CS_TEMP_net_1;
 STAMP3_CS_SGR2_net_1  <= STAMP3_CS_SGR2_net_0;
 STAMP3_CS_SGR2        <= STAMP3_CS_SGR2_net_1;
 STAMP3_CS_SGR1_net_1  <= STAMP3_CS_SGR1_net_0;
 STAMP3_CS_SGR1        <= STAMP3_CS_SGR1_net_1;
 STAMP3_SCLK_net_1     <= STAMP3_SCLK_net_0;
 STAMP3_SCLK           <= STAMP3_SCLK_net_1;
 STAMP3_MOSI_net_1     <= STAMP3_MOSI_net_0;
 STAMP3_MOSI           <= STAMP3_MOSI_net_1;
 STAMP2_CS_TEMP_net_1  <= STAMP2_CS_TEMP_net_0;
 STAMP2_CS_TEMP        <= STAMP2_CS_TEMP_net_1;
 STAMP2_CS_SGR2_net_1  <= STAMP2_CS_SGR2_net_0;
 STAMP2_CS_SGR2        <= STAMP2_CS_SGR2_net_1;
 STAMP2_CS_SGR1_net_1  <= STAMP2_CS_SGR1_net_0;
 STAMP2_CS_SGR1        <= STAMP2_CS_SGR1_net_1;
 STAMP2_SCLK_net_1     <= STAMP2_SCLK_net_0;
 STAMP2_SCLK           <= STAMP2_SCLK_net_1;
 STAMP2_MOSI_net_1     <= STAMP2_MOSI_net_0;
 STAMP2_MOSI           <= STAMP2_MOSI_net_1;
 LED_FPGA_LOADED_net_1 <= LED_FPGA_LOADED_net_0;
 LED_FPGA_LOADED       <= LED_FPGA_LOADED_net_1;
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
 IN_databus_net_0     <= ( STAMP_6_data_frame & STAMP_5_data_frame & STAMP_4_data_frame & STAMP_3_data_frame & STAMP_2_data_frame & STAMP_1_data_frame );
 IN_newAvails_net_0   <= ( STAMP_6_new_avail & STAMP_5_new_avail & STAMP_4_new_avail & STAMP_3_new_avail & STAMP_2_new_avail & STAMP_1_new_avail );
 IN_requestSync_net_0 <= ( STAMP_6_request_resync & STAMP_5_request_resync & STAMP_4_request_resync & STAMP_3_request_resync & STAMP_2_request_resync & STAMP_1_request_resync );
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 sb_sb_0_MemSync_PADDR_0(11 downto 0) <= ( sb_sb_0_MemSync_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_MemSync_PADDR_0_11to0(11 downto 0) <= sb_sb_0_MemSync_PADDR(11 downto 0);

 sb_sb_0_STAMP_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_PADDR(11 downto 0);

 sb_sb_0_STAMP_1_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_1_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_1_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_1_PADDR(11 downto 0);

 sb_sb_0_STAMP_2_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_2_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_2_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_2_PADDR(11 downto 0);

 sb_sb_0_STAMP_3_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_3_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_3_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_3_PADDR(11 downto 0);

 sb_sb_0_STAMP_4_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_4_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_4_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_4_PADDR(11 downto 0);

 sb_sb_0_STAMP_5_PADDR_0(11 downto 0) <= ( sb_sb_0_STAMP_5_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_STAMP_5_PADDR_0_11to0(11 downto 0) <= sb_sb_0_STAMP_5_PADDR(11 downto 0);

 sb_sb_0_Telemetry_PADDR_0(11 downto 0) <= ( sb_sb_0_Telemetry_PADDR_0_11to0(11 downto 0) );
 sb_sb_0_Telemetry_PADDR_0_11to0(11 downto 0) <= sb_sb_0_Telemetry_PADDR(11 downto 0);

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- AND2_0
AND2_0 : AND2
    port map( 
        -- Inputs
        A => sb_sb_0_POWER_ON_RESET_N,
        B => sb_sb_0_GPIO_4_M2F,
        -- Outputs
        Y => AND2_0_Y 
        );
-- MemorySynchronizer_0
MemorySynchronizer_0 : entity work.MemorySynchronizer
    port map( 
        -- Inputs
        clk                   => sb_sb_0_FIC_0_CLK,
        nReset                => AND2_0_Y,
        IN_enable             => sb_sb_0_GPIO_12_M2F,
        PSEL                  => sb_sb_0_MemSync_PSELx,
        PENABLE               => sb_sb_0_MemSync_PENABLE,
        PWRITE                => sb_sb_0_MemSync_PWRITE,
        IN_databus            => IN_databus_net_0,
        IN_newAvails          => IN_newAvails_net_0,
        IN_requestSync        => IN_requestSync_net_0,
        PADDR                 => sb_sb_0_MemSync_PADDR_0,
        PWDATA                => sb_sb_0_MemSync_PWDATA,
        -- Outputs
        dataReadyReset        => MemorySynchronizer_0_dataReadyReset,
        SynchronizerInterrupt => OPEN,
        ReadInterrupt         => MemorySynchronizer_0_ReadInterrupt,
        ADCResync             => OPEN,
        PREADY                => sb_sb_0_MemSync_PREADY,
        PSLVERR               => sb_sb_0_MemSync_PSLVERR,
        PRDATA                => sb_sb_0_MemSync_PRDATA 
        );
-- sb_sb_0
sb_sb_0 : sb_sb
    port map( 
        -- Inputs
        FAB_RESET_N            => VCC_net,
        MemSync_0_INTR_0_top   => MemorySynchronizer_0_ReadInterrupt,
        STAMP_5_INTR_0_top     => STAMP_6_new_avail,
        STAMP_4_INTR_0_top     => STAMP_5_new_avail,
        STAMP_3_INTR_0_top     => STAMP_4_new_avail,
        STAMP_2_INTR_0_top     => STAMP_3_new_avail,
        STAMP_1_INTR_0_top     => STAMP_2_new_avail,
        STAMP_0_INTR_0_top     => STAMP_1_new_avail,
        Telemetry_0_INTR_0_top => telemetry_0_INTERRUPT,
        MemSync_PRDATAS0       => sb_sb_0_MemSync_PRDATA,
        MemSync_PREADYS0       => sb_sb_0_MemSync_PREADY,
        MemSync_PSLVERRS0      => sb_sb_0_MemSync_PSLVERR,
        STAMP_PRDATAS1         => sb_sb_0_STAMP_PRDATA,
        STAMP_PREADYS1         => sb_sb_0_STAMP_PREADY,
        STAMP_PSLVERRS1        => sb_sb_0_STAMP_PSLVERR,
        STAMP_1_PRDATAS2       => sb_sb_0_STAMP_1_PRDATA,
        STAMP_1_PREADYS2       => sb_sb_0_STAMP_1_PREADY,
        STAMP_1_PSLVERRS2      => sb_sb_0_STAMP_1_PSLVERR,
        STAMP_2_PRDATAS3       => sb_sb_0_STAMP_2_PRDATA,
        STAMP_2_PREADYS3       => sb_sb_0_STAMP_2_PREADY,
        STAMP_2_PSLVERRS3      => sb_sb_0_STAMP_2_PSLVERR,
        STAMP_3_PRDATAS4       => sb_sb_0_STAMP_3_PRDATA,
        STAMP_3_PREADYS4       => sb_sb_0_STAMP_3_PREADY,
        STAMP_3_PSLVERRS4      => sb_sb_0_STAMP_3_PSLVERR,
        STAMP_4_PRDATAS5       => sb_sb_0_STAMP_4_PRDATA,
        STAMP_4_PREADYS5       => sb_sb_0_STAMP_4_PREADY,
        STAMP_4_PSLVERRS5      => sb_sb_0_STAMP_4_PSLVERR,
        STAMP_5_PRDATAS6       => sb_sb_0_STAMP_5_PRDATA,
        STAMP_5_PREADYS6       => sb_sb_0_STAMP_5_PREADY,
        STAMP_5_PSLVERRS6      => sb_sb_0_STAMP_5_PSLVERR,
        Telemetry_PRDATAS7     => sb_sb_0_Telemetry_PRDATA,
        Telemetry_PREADYS7     => sb_sb_0_Telemetry_PREADY,
        Telemetry_PSLVERRS7    => sb_sb_0_Telemetry_PSLVERR,
        DEVRST_N               => DEVRST_N,
        MMUART_0_RXD_F2M       => DAPI_RXD,
        GPIO_0_F2M             => IN_RXSM_LO,
        GPIO_1_F2M             => IN_RXSM_SOE,
        GPIO_2_F2M             => IN_RXSM_SODS,
        GPIO_5_F2M             => WP,
        SPI_0_DI_F2M           => F_MISO,
        SPI_0_CLK_F2M          => GND_net,
        SPI_0_SS0_F2M          => GND_net,
        -- Outputs
        POWER_ON_RESET_N       => sb_sb_0_POWER_ON_RESET_N,
        INIT_DONE              => OPEN,
        MemSync_PADDRS         => sb_sb_0_MemSync_PADDR,
        MemSync_PSELS0         => sb_sb_0_MemSync_PSELx,
        MemSync_PENABLES       => sb_sb_0_MemSync_PENABLE,
        MemSync_PWRITES        => sb_sb_0_MemSync_PWRITE,
        MemSync_PWDATAS        => sb_sb_0_MemSync_PWDATA,
        STAMP_PADDRS           => sb_sb_0_STAMP_PADDR,
        STAMP_PSELS1           => sb_sb_0_STAMP_PSELx,
        STAMP_PENABLES         => sb_sb_0_STAMP_PENABLE,
        STAMP_PWRITES          => sb_sb_0_STAMP_PWRITE,
        STAMP_PWDATAS          => sb_sb_0_STAMP_PWDATA,
        STAMP_1_PADDRS         => sb_sb_0_STAMP_1_PADDR,
        STAMP_1_PSELS2         => sb_sb_0_STAMP_1_PSELx,
        STAMP_1_PENABLES       => sb_sb_0_STAMP_1_PENABLE,
        STAMP_1_PWRITES        => sb_sb_0_STAMP_1_PWRITE,
        STAMP_1_PWDATAS        => sb_sb_0_STAMP_1_PWDATA,
        STAMP_2_PADDRS         => sb_sb_0_STAMP_2_PADDR,
        STAMP_2_PSELS3         => sb_sb_0_STAMP_2_PSELx,
        STAMP_2_PENABLES       => sb_sb_0_STAMP_2_PENABLE,
        STAMP_2_PWRITES        => sb_sb_0_STAMP_2_PWRITE,
        STAMP_2_PWDATAS        => sb_sb_0_STAMP_2_PWDATA,
        STAMP_3_PADDRS         => sb_sb_0_STAMP_3_PADDR,
        STAMP_3_PSELS4         => sb_sb_0_STAMP_3_PSELx,
        STAMP_3_PENABLES       => sb_sb_0_STAMP_3_PENABLE,
        STAMP_3_PWRITES        => sb_sb_0_STAMP_3_PWRITE,
        STAMP_3_PWDATAS        => sb_sb_0_STAMP_3_PWDATA,
        STAMP_4_PADDRS         => sb_sb_0_STAMP_4_PADDR,
        STAMP_4_PSELS5         => sb_sb_0_STAMP_4_PSELx,
        STAMP_4_PENABLES       => sb_sb_0_STAMP_4_PENABLE,
        STAMP_4_PWRITES        => sb_sb_0_STAMP_4_PWRITE,
        STAMP_4_PWDATAS        => sb_sb_0_STAMP_4_PWDATA,
        STAMP_5_PADDRS         => sb_sb_0_STAMP_5_PADDR,
        STAMP_5_PSELS6         => sb_sb_0_STAMP_5_PSELx,
        STAMP_5_PENABLES       => sb_sb_0_STAMP_5_PENABLE,
        STAMP_5_PWRITES        => sb_sb_0_STAMP_5_PWRITE,
        STAMP_5_PWDATAS        => sb_sb_0_STAMP_5_PWDATA,
        Telemetry_PADDRS       => sb_sb_0_Telemetry_PADDR,
        Telemetry_PSELS7       => sb_sb_0_Telemetry_PSELx,
        Telemetry_PENABLES     => sb_sb_0_Telemetry_PENABLE,
        Telemetry_PWRITES      => sb_sb_0_Telemetry_PWRITE,
        Telemetry_PWDATAS      => sb_sb_0_Telemetry_PWDATA,
        FIC_0_CLK              => sb_sb_0_FIC_0_CLK,
        FIC_0_LOCK             => OPEN,
        MSS_READY              => OPEN,
        MMUART_0_TXD_M2F       => DAPI_TXD_net_0,
        GPIO_3_M2F             => OUT_ADC_START_net_0,
        GPIO_4_M2F             => sb_sb_0_GPIO_4_M2F,
        GPIO_12_M2F            => sb_sb_0_GPIO_12_M2F,
        GPIO_25_M2F            => LED_HB_MEMSYNC_net_0,
        GPIO_26_M2F            => LED_FPGA_LOADED_net_0,
        GPIO_28_M2F            => F_CS1_0,
        GPIO_29_M2F            => F_CS2_0,
        GPIO_30_M2F            => LED_RECORDING_net_0,
        GPIO_31_M2F            => LED_HB_MSS_net_0,
        SPI_0_DO_M2F           => F_MOSI_net_0,
        SPI_0_CLK_M2F          => F_CLK_net_0,
        SPI_0_SS0_M2F          => OPEN,
        SPI_0_SS0_M2F_OE       => OPEN 
        );
-- STAMP_1
STAMP_1 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_PSELx,
        PENABLE        => sb_sb_0_STAMP_PENABLE,
        PWRITE         => sb_sb_0_STAMP_PWRITE,
        spi_miso       => STAMP1_MISO,
        ready_dms1     => STAMP1_DRDY_SGR1,
        ready_dms2     => STAMP1_DRDY_SGR2,
        ready_temp     => STAMP1_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_PWDATA,
        -- Outputs
        new_avail      => STAMP_1_new_avail,
        request_resync => STAMP_1_request_resync,
        PREADY         => sb_sb_0_STAMP_PREADY,
        PSLVERR        => sb_sb_0_STAMP_PSLVERR,
        spi_clock      => STAMP1_SCLK_net_0,
        spi_mosi       => STAMP1_MOSI_net_0,
        spi_dms1_cs    => STAMP1_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP1_CS_SGR2_net_0,
        spi_temp_cs    => STAMP1_CS_TEMP_net_0,
        data_frame     => STAMP_1_data_frame,
        PRDATA         => sb_sb_0_STAMP_PRDATA 
        );
-- STAMP_2
STAMP_2 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_1_PSELx,
        PENABLE        => sb_sb_0_STAMP_1_PENABLE,
        PWRITE         => sb_sb_0_STAMP_1_PWRITE,
        spi_miso       => STAMP2_MISO,
        ready_dms1     => STAMP2_DRDY_SGR1,
        ready_dms2     => STAMP2_DRDY_SGR2,
        ready_temp     => STAMP2_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_1_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_1_PWDATA,
        -- Outputs
        new_avail      => STAMP_2_new_avail,
        request_resync => STAMP_2_request_resync,
        PREADY         => sb_sb_0_STAMP_1_PREADY,
        PSLVERR        => sb_sb_0_STAMP_1_PSLVERR,
        spi_clock      => STAMP2_SCLK_net_0,
        spi_mosi       => STAMP2_MOSI_net_0,
        spi_dms1_cs    => STAMP2_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP2_CS_SGR2_net_0,
        spi_temp_cs    => STAMP2_CS_TEMP_net_0,
        data_frame     => STAMP_2_data_frame,
        PRDATA         => sb_sb_0_STAMP_1_PRDATA 
        );
-- STAMP_3
STAMP_3 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_2_PSELx,
        PENABLE        => sb_sb_0_STAMP_2_PENABLE,
        PWRITE         => sb_sb_0_STAMP_2_PWRITE,
        spi_miso       => STAMP3_MISO,
        ready_dms1     => STAMP3_DRDY_SGR1,
        ready_dms2     => STAMP3_DRDY_SGR2,
        ready_temp     => STAMP3_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_2_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_2_PWDATA,
        -- Outputs
        new_avail      => STAMP_3_new_avail,
        request_resync => STAMP_3_request_resync,
        PREADY         => sb_sb_0_STAMP_2_PREADY,
        PSLVERR        => sb_sb_0_STAMP_2_PSLVERR,
        spi_clock      => STAMP3_SCLK_net_0,
        spi_mosi       => STAMP3_MOSI_net_0,
        spi_dms1_cs    => STAMP3_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP3_CS_SGR2_net_0,
        spi_temp_cs    => STAMP3_CS_TEMP_net_0,
        data_frame     => STAMP_3_data_frame,
        PRDATA         => sb_sb_0_STAMP_2_PRDATA 
        );
-- STAMP_4
STAMP_4 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_3_PSELx,
        PENABLE        => sb_sb_0_STAMP_3_PENABLE,
        PWRITE         => sb_sb_0_STAMP_3_PWRITE,
        spi_miso       => STAMP4_MISO,
        ready_dms1     => STAMP4_DRDY_SGR1,
        ready_dms2     => STAMP4_DRDY_SGR2,
        ready_temp     => STAMP4_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_3_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_3_PWDATA,
        -- Outputs
        new_avail      => STAMP_4_new_avail,
        request_resync => STAMP_4_request_resync,
        PREADY         => sb_sb_0_STAMP_3_PREADY,
        PSLVERR        => sb_sb_0_STAMP_3_PSLVERR,
        spi_clock      => STAMP4_SCLK_net_0,
        spi_mosi       => STAMP4_MOSI_net_0,
        spi_dms1_cs    => STAMP4_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP4_CS_SGR2_net_0,
        spi_temp_cs    => STAMP4_CS_TEMP_net_0,
        data_frame     => STAMP_4_data_frame,
        PRDATA         => sb_sb_0_STAMP_3_PRDATA 
        );
-- STAMP_5
STAMP_5 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_4_PSELx,
        PENABLE        => sb_sb_0_STAMP_4_PENABLE,
        PWRITE         => sb_sb_0_STAMP_4_PWRITE,
        spi_miso       => STAMP5_MISO,
        ready_dms1     => STAMP5_DRDY_SGR1,
        ready_dms2     => STAMP5_DRDY_SGR2,
        ready_temp     => STAMP5_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_4_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_4_PWDATA,
        -- Outputs
        new_avail      => STAMP_5_new_avail,
        request_resync => STAMP_5_request_resync,
        PREADY         => sb_sb_0_STAMP_4_PREADY,
        PSLVERR        => sb_sb_0_STAMP_4_PSLVERR,
        spi_clock      => STAMP5_SCLK_net_0,
        spi_mosi       => STAMP5_MOSI_net_0,
        spi_dms1_cs    => STAMP5_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP5_CS_SGR2_net_0,
        spi_temp_cs    => STAMP5_CS_TEMP_net_0,
        data_frame     => STAMP_5_data_frame,
        PRDATA         => sb_sb_0_STAMP_4_PRDATA 
        );
-- STAMP_6
STAMP_6 : entity work.STAMP
    generic map( 
        async_prescaler => ( 2500 )
        )
    port map( 
        -- Inputs
        reset_status   => MemorySynchronizer_0_dataReadyReset,
        PCLK           => sb_sb_0_FIC_0_CLK,
        PRESETN        => AND2_0_Y,
        PSEL           => sb_sb_0_STAMP_5_PSELx,
        PENABLE        => sb_sb_0_STAMP_5_PENABLE,
        PWRITE         => sb_sb_0_STAMP_5_PWRITE,
        spi_miso       => STAMP6_MISO,
        ready_dms1     => STAMP6_DRDY_SGR1,
        ready_dms2     => STAMP6_DRDY_SGR2,
        ready_temp     => STAMP6_DRDY_TEMP,
        PADDR          => sb_sb_0_STAMP_5_PADDR_0,
        PWDATA         => sb_sb_0_STAMP_5_PWDATA,
        -- Outputs
        new_avail      => STAMP_6_new_avail,
        request_resync => STAMP_6_request_resync,
        PREADY         => sb_sb_0_STAMP_5_PREADY,
        PSLVERR        => sb_sb_0_STAMP_5_PSLVERR,
        spi_clock      => STAMP6_SCLK_net_0,
        spi_mosi       => STAMP6_MOSI_net_0,
        spi_dms1_cs    => STAMP6_CS_SGR1_net_0,
        spi_dms2_cs    => STAMP6_CS_SGR2_net_0,
        spi_temp_cs    => STAMP6_CS_TEMP_net_0,
        data_frame     => STAMP_6_data_frame,
        PRDATA         => sb_sb_0_STAMP_5_PRDATA 
        );
-- telemetry_0
telemetry_0 : entity HERMESS_TELEMETRY.telemetry
    port map( 
        -- Inputs
        PCLK      => sb_sb_0_FIC_0_CLK,
        PRESETN   => AND2_0_Y,
        PADDR     => sb_sb_0_Telemetry_PADDR_0,
        PSEL      => sb_sb_0_Telemetry_PSELx,
        PENABLE   => sb_sb_0_Telemetry_PENABLE,
        PWRITE    => sb_sb_0_Telemetry_PWRITE,
        PWDATA    => sb_sb_0_Telemetry_PWDATA,
        RX        => TM_RXD,
        -- Outputs
        PRDATA    => sb_sb_0_Telemetry_PRDATA,
        PREADY    => sb_sb_0_Telemetry_PREADY,
        PSLVERR   => sb_sb_0_Telemetry_PSLVERR,
        TX        => TM_TXD_0,
        INTERRUPT => telemetry_0_INTERRUPT 
        );

end RTL;
