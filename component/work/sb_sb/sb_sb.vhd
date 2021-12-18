----------------------------------------------------------------------
-- Created by SmartDesign Mon Dec 13 15:59:22 2021
-- Version: v12.6 12.900.20.24
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library COREAPB3_LIB;
use COREAPB3_LIB.all;
use COREAPB3_LIB.components.all;
----------------------------------------------------------------------
-- sb_sb entity declaration
----------------------------------------------------------------------
entity sb_sb is
    -- Port list
    port(
        -- Inputs
        DEVRST_N             : in  std_logic;
        FAB_RESET_N          : in  std_logic;
        GPIO_0_F2M           : in  std_logic;
        GPIO_1_F2M           : in  std_logic;
        GPIO_2_F2M           : in  std_logic;
        GPIO_5_F2M           : in  std_logic;
        MMUART_0_RXD_F2M     : in  std_logic;
        MMUART_1_RXD_F2M     : in  std_logic;
        MemSync_0_INTR_0_top : in  std_logic;
        MemSync_PRDATAS0     : in  std_logic_vector(31 downto 0);
        MemSync_PREADYS0     : in  std_logic;
        MemSync_PSLVERRS0    : in  std_logic;
        SPI_0_CLK_F2M        : in  std_logic;
        SPI_0_DI_F2M         : in  std_logic;
        SPI_0_SS0_F2M        : in  std_logic;
        STAMP_0_INTR_0_top   : in  std_logic;
        STAMP_1_INTR_0_top   : in  std_logic;
        STAMP_1_PRDATAS2     : in  std_logic_vector(31 downto 0);
        STAMP_1_PREADYS2     : in  std_logic;
        STAMP_1_PSLVERRS2    : in  std_logic;
        STAMP_2_INTR_0_top   : in  std_logic;
        STAMP_2_PRDATAS3     : in  std_logic_vector(31 downto 0);
        STAMP_2_PREADYS3     : in  std_logic;
        STAMP_2_PSLVERRS3    : in  std_logic;
        STAMP_3_INTR_0_top   : in  std_logic;
        STAMP_3_PRDATAS4     : in  std_logic_vector(31 downto 0);
        STAMP_3_PREADYS4     : in  std_logic;
        STAMP_3_PSLVERRS4    : in  std_logic;
        STAMP_4_INTR_0_top   : in  std_logic;
        STAMP_4_PRDATAS5     : in  std_logic_vector(31 downto 0);
        STAMP_4_PREADYS5     : in  std_logic;
        STAMP_4_PSLVERRS5    : in  std_logic;
        STAMP_5_INTR_0_top   : in  std_logic;
        STAMP_5_PRDATAS6     : in  std_logic_vector(31 downto 0);
        STAMP_5_PREADYS6     : in  std_logic;
        STAMP_5_PSLVERRS6    : in  std_logic;
        STAMP_PRDATAS1       : in  std_logic_vector(31 downto 0);
        STAMP_PREADYS1       : in  std_logic;
        STAMP_PSLVERRS1      : in  std_logic;
        -- Outputs
        FIC_0_CLK            : out std_logic;
        FIC_0_LOCK           : out std_logic;
        GPIO_12_M2F          : out std_logic;
        GPIO_28_M2F          : out std_logic;
        GPIO_29_M2F          : out std_logic;
        GPIO_30_M2F          : out std_logic;
        GPIO_31_M2F          : out std_logic;
        GPIO_3_M2F           : out std_logic;
        GPIO_4_M2F           : out std_logic;
        INIT_DONE            : out std_logic;
        MMUART_0_TXD_M2F     : out std_logic;
        MMUART_1_TXD_M2F     : out std_logic;
        MSS_READY            : out std_logic;
        MemSync_PADDRS       : out std_logic_vector(31 downto 0);
        MemSync_PENABLES     : out std_logic;
        MemSync_PSELS0       : out std_logic;
        MemSync_PWDATAS      : out std_logic_vector(31 downto 0);
        MemSync_PWRITES      : out std_logic;
        POWER_ON_RESET_N     : out std_logic;
        SPI_0_CLK_M2F        : out std_logic;
        SPI_0_DO_M2F         : out std_logic;
        SPI_0_SS0_M2F        : out std_logic;
        SPI_0_SS0_M2F_OE     : out std_logic;
        STAMP_1_PADDRS       : out std_logic_vector(31 downto 0);
        STAMP_1_PENABLES     : out std_logic;
        STAMP_1_PSELS2       : out std_logic;
        STAMP_1_PWDATAS      : out std_logic_vector(31 downto 0);
        STAMP_1_PWRITES      : out std_logic;
        STAMP_2_PADDRS       : out std_logic_vector(31 downto 0);
        STAMP_2_PENABLES     : out std_logic;
        STAMP_2_PSELS3       : out std_logic;
        STAMP_2_PWDATAS      : out std_logic_vector(31 downto 0);
        STAMP_2_PWRITES      : out std_logic;
        STAMP_3_PADDRS       : out std_logic_vector(31 downto 0);
        STAMP_3_PENABLES     : out std_logic;
        STAMP_3_PSELS4       : out std_logic;
        STAMP_3_PWDATAS      : out std_logic_vector(31 downto 0);
        STAMP_3_PWRITES      : out std_logic;
        STAMP_4_PADDRS       : out std_logic_vector(31 downto 0);
        STAMP_4_PENABLES     : out std_logic;
        STAMP_4_PSELS5       : out std_logic;
        STAMP_4_PWDATAS      : out std_logic_vector(31 downto 0);
        STAMP_4_PWRITES      : out std_logic;
        STAMP_5_PADDRS       : out std_logic_vector(31 downto 0);
        STAMP_5_PENABLES     : out std_logic;
        STAMP_5_PSELS6       : out std_logic;
        STAMP_5_PWDATAS      : out std_logic_vector(31 downto 0);
        STAMP_5_PWRITES      : out std_logic;
        STAMP_PADDRS         : out std_logic_vector(31 downto 0);
        STAMP_PENABLES       : out std_logic;
        STAMP_PSELS1         : out std_logic;
        STAMP_PWDATAS        : out std_logic_vector(31 downto 0);
        STAMP_PWRITES        : out std_logic
        );
end sb_sb;
----------------------------------------------------------------------
-- sb_sb architecture body
----------------------------------------------------------------------
architecture RTL of sb_sb is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- sb_sb_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
component sb_sb_CCC_0_FCCC
    -- Port list
    port(
        -- Inputs
        RCOSC_25_50MHZ : in  std_logic;
        -- Outputs
        GL0            : out std_logic;
        LOCK           : out std_logic
        );
end component;
-- CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
-- using entity instantiation for component CoreAPB3
-- CoreResetP   -   Actel:DirectCore:CoreResetP:7.1.100
component CoreResetP
    generic( 
        DDR_WAIT            : integer := 200 ;
        DEVICE_090          : integer := 0 ;
        DEVICE_VOLTAGE      : integer := 2 ;
        ENABLE_SOFT_RESETS  : integer := 0 ;
        EXT_RESET_CFG       : integer := 0 ;
        FDDR_IN_USE         : integer := 0 ;
        MDDR_IN_USE         : integer := 0 ;
        SDIF0_IN_USE        : integer := 0 ;
        SDIF0_PCIE          : integer := 0 ;
        SDIF0_PCIE_HOTRESET : integer := 1 ;
        SDIF0_PCIE_L2P2     : integer := 1 ;
        SDIF1_IN_USE        : integer := 0 ;
        SDIF1_PCIE          : integer := 0 ;
        SDIF1_PCIE_HOTRESET : integer := 1 ;
        SDIF1_PCIE_L2P2     : integer := 1 ;
        SDIF2_IN_USE        : integer := 0 ;
        SDIF2_PCIE          : integer := 0 ;
        SDIF2_PCIE_HOTRESET : integer := 1 ;
        SDIF2_PCIE_L2P2     : integer := 1 ;
        SDIF3_IN_USE        : integer := 0 ;
        SDIF3_PCIE          : integer := 0 ;
        SDIF3_PCIE_HOTRESET : integer := 1 ;
        SDIF3_PCIE_L2P2     : integer := 1 
        );
    -- Port list
    port(
        -- Inputs
        CLK_BASE                       : in  std_logic;
        CLK_LTSSM                      : in  std_logic;
        CONFIG1_DONE                   : in  std_logic;
        CONFIG2_DONE                   : in  std_logic;
        FAB_RESET_N                    : in  std_logic;
        FIC_2_APB_M_PRESET_N           : in  std_logic;
        FPLL_LOCK                      : in  std_logic;
        POWER_ON_RESET_N               : in  std_logic;
        RCOSC_25_50MHZ                 : in  std_logic;
        RESET_N_M2F                    : in  std_logic;
        SDIF0_PERST_N                  : in  std_logic;
        SDIF0_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF0_PSEL                     : in  std_logic;
        SDIF0_PWRITE                   : in  std_logic;
        SDIF0_SPLL_LOCK                : in  std_logic;
        SDIF1_PERST_N                  : in  std_logic;
        SDIF1_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF1_PSEL                     : in  std_logic;
        SDIF1_PWRITE                   : in  std_logic;
        SDIF1_SPLL_LOCK                : in  std_logic;
        SDIF2_PERST_N                  : in  std_logic;
        SDIF2_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF2_PSEL                     : in  std_logic;
        SDIF2_PWRITE                   : in  std_logic;
        SDIF2_SPLL_LOCK                : in  std_logic;
        SDIF3_PERST_N                  : in  std_logic;
        SDIF3_PRDATA                   : in  std_logic_vector(31 downto 0);
        SDIF3_PSEL                     : in  std_logic;
        SDIF3_PWRITE                   : in  std_logic;
        SDIF3_SPLL_LOCK                : in  std_logic;
        SOFT_EXT_RESET_OUT             : in  std_logic;
        SOFT_FDDR_CORE_RESET           : in  std_logic;
        SOFT_M3_RESET                  : in  std_logic;
        SOFT_MDDR_DDR_AXI_S_CORE_RESET : in  std_logic;
        SOFT_RESET_F2M                 : in  std_logic;
        SOFT_SDIF0_0_CORE_RESET        : in  std_logic;
        SOFT_SDIF0_1_CORE_RESET        : in  std_logic;
        SOFT_SDIF0_CORE_RESET          : in  std_logic;
        SOFT_SDIF0_PHY_RESET           : in  std_logic;
        SOFT_SDIF1_CORE_RESET          : in  std_logic;
        SOFT_SDIF1_PHY_RESET           : in  std_logic;
        SOFT_SDIF2_CORE_RESET          : in  std_logic;
        SOFT_SDIF2_PHY_RESET           : in  std_logic;
        SOFT_SDIF3_CORE_RESET          : in  std_logic;
        SOFT_SDIF3_PHY_RESET           : in  std_logic;
        -- Outputs
        DDR_READY                      : out std_logic;
        EXT_RESET_OUT                  : out std_logic;
        FDDR_CORE_RESET_N              : out std_logic;
        INIT_DONE                      : out std_logic;
        M3_RESET_N                     : out std_logic;
        MDDR_DDR_AXI_S_CORE_RESET_N    : out std_logic;
        MSS_HPMS_READY                 : out std_logic;
        RESET_N_F2M                    : out std_logic;
        SDIF0_0_CORE_RESET_N           : out std_logic;
        SDIF0_1_CORE_RESET_N           : out std_logic;
        SDIF0_CORE_RESET_N             : out std_logic;
        SDIF0_PHY_RESET_N              : out std_logic;
        SDIF1_CORE_RESET_N             : out std_logic;
        SDIF1_PHY_RESET_N              : out std_logic;
        SDIF2_CORE_RESET_N             : out std_logic;
        SDIF2_PHY_RESET_N              : out std_logic;
        SDIF3_CORE_RESET_N             : out std_logic;
        SDIF3_PHY_RESET_N              : out std_logic;
        SDIF_READY                     : out std_logic;
        SDIF_RELEASED                  : out std_logic
        );
end component;
-- sb_sb_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
component sb_sb_FABOSC_0_OSC
    -- Port list
    port(
        -- Inputs
        XTL                : in  std_logic;
        -- Outputs
        RCOSC_1MHZ_CCC     : out std_logic;
        RCOSC_1MHZ_O2F     : out std_logic;
        RCOSC_25_50MHZ_CCC : out std_logic;
        RCOSC_25_50MHZ_O2F : out std_logic;
        XTLOSC_CCC         : out std_logic;
        XTLOSC_O2F         : out std_logic
        );
end component;
-- sb_sb_MSS
component sb_sb_MSS
    -- Port list
    port(
        -- Inputs
        FIC_0_APB_M_PRDATA     : in  std_logic_vector(31 downto 0);
        FIC_0_APB_M_PREADY     : in  std_logic;
        FIC_0_APB_M_PSLVERR    : in  std_logic;
        FIC_2_APB_M_PRDATA     : in  std_logic_vector(31 downto 0);
        FIC_2_APB_M_PREADY     : in  std_logic;
        FIC_2_APB_M_PSLVERR    : in  std_logic;
        GPIO_0_F2M             : in  std_logic;
        GPIO_1_F2M             : in  std_logic;
        GPIO_2_F2M             : in  std_logic;
        GPIO_5_F2M             : in  std_logic;
        MCCC_CLK_BASE          : in  std_logic;
        MCCC_CLK_BASE_PLL_LOCK : in  std_logic;
        MMUART_0_RXD_F2M       : in  std_logic;
        MMUART_1_RXD_F2M       : in  std_logic;
        MSS_INT_F2M            : in  std_logic_vector(15 downto 0);
        MSS_RESET_N_F2M        : in  std_logic;
        SPI_0_CLK_F2M          : in  std_logic;
        SPI_0_DI_F2M           : in  std_logic;
        SPI_0_SS0_F2M          : in  std_logic;
        -- Outputs
        FIC_0_APB_M_PADDR      : out std_logic_vector(31 downto 0);
        FIC_0_APB_M_PENABLE    : out std_logic;
        FIC_0_APB_M_PSEL       : out std_logic;
        FIC_0_APB_M_PWDATA     : out std_logic_vector(31 downto 0);
        FIC_0_APB_M_PWRITE     : out std_logic;
        FIC_2_APB_M_PADDR      : out std_logic_vector(15 downto 2);
        FIC_2_APB_M_PCLK       : out std_logic;
        FIC_2_APB_M_PENABLE    : out std_logic;
        FIC_2_APB_M_PRESET_N   : out std_logic;
        FIC_2_APB_M_PSEL       : out std_logic;
        FIC_2_APB_M_PWDATA     : out std_logic_vector(31 downto 0);
        FIC_2_APB_M_PWRITE     : out std_logic;
        GPIO_12_M2F            : out std_logic;
        GPIO_28_M2F            : out std_logic;
        GPIO_29_M2F            : out std_logic;
        GPIO_30_M2F            : out std_logic;
        GPIO_31_M2F            : out std_logic;
        GPIO_3_M2F             : out std_logic;
        GPIO_4_M2F             : out std_logic;
        MMUART_0_TXD_M2F       : out std_logic;
        MMUART_1_TXD_M2F       : out std_logic;
        MSS_RESET_N_M2F        : out std_logic;
        SPI_0_CLK_M2F          : out std_logic;
        SPI_0_DO_M2F           : out std_logic;
        SPI_0_SS0_M2F          : out std_logic;
        SPI_0_SS0_M2F_OE       : out std_logic
        );
end component;
-- SYSRESET
component SYSRESET
    -- Port list
    port(
        -- Inputs
        DEVRST_N         : in  std_logic;
        -- Outputs
        POWER_ON_RESET_N : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APBmslave0_7_PADDR                                 : std_logic_vector(31 downto 0);
signal APBmslave0_7_PENABLE                               : std_logic;
signal APBmslave0_7_PSELx                                 : std_logic;
signal APBmslave0_7_PWDATA                                : std_logic_vector(31 downto 0);
signal APBmslave0_7_PWRITE                                : std_logic;
signal APBmslave1_0_PSELx                                 : std_logic;
signal APBmslave2_0_PSELx                                 : std_logic;
signal APBmslave3_0_PSELx                                 : std_logic;
signal APBmslave4_0_PSELx                                 : std_logic;
signal APBmslave5_0_PSELx                                 : std_logic;
signal APBmslave6_0_PSELx                                 : std_logic;
signal CORERESETP_0_RESET_N_F2M                           : std_logic;
signal FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal FABOSC_0_RCOSC_25_50MHZ_O2F                        : std_logic;
signal FIC_0_CLK_net_0                                    : std_logic;
signal FIC_0_LOCK_net_0                                   : std_logic;
signal GPIO_3_M2F_net_0                                   : std_logic;
signal GPIO_4_M2F_net_0                                   : std_logic;
signal GPIO_12_M2F_net_0                                  : std_logic;
signal GPIO_28_M2F_net_0                                  : std_logic;
signal GPIO_29_M2F_net_0                                  : std_logic;
signal GPIO_30_M2F_net_0                                  : std_logic;
signal GPIO_31_M2F_net_0                                  : std_logic;
signal INIT_DONE_net_0                                    : std_logic;
signal MMUART_0_TXD_M2F_net_0                             : std_logic;
signal MMUART_1_TXD_M2F_net_0                             : std_logic;
signal MSS_READY_net_0                                    : std_logic;
signal POWER_ON_RESET_N_net_0                             : std_logic;
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PADDR             : std_logic_vector(31 downto 0);
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE           : std_logic;
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA            : std_logic_vector(31 downto 0);
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PREADY            : std_logic;
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSELx             : std_logic;
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR           : std_logic;
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA            : std_logic_vector(31 downto 0);
signal sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE            : std_logic;
signal sb_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N               : std_logic;
signal sb_sb_MSS_TMP_0_MSS_RESET_N_M2F                    : std_logic;
signal SPI_0_CLK_M2F_net_0                                : std_logic;
signal SPI_0_DO_M2F_net_0                                 : std_logic;
signal SPI_0_SS0_M2F_net_0                                : std_logic;
signal SPI_0_SS0_M2F_OE_net_0                             : std_logic;
signal POWER_ON_RESET_N_net_1                             : std_logic;
signal INIT_DONE_net_1                                    : std_logic;
signal APBmslave0_7_PADDR_net_0                           : std_logic_vector(31 downto 0);
signal APBmslave0_7_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_0                         : std_logic;
signal APBmslave0_7_PWRITE_net_0                          : std_logic;
signal APBmslave0_7_PWDATA_net_0                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_1                           : std_logic_vector(31 downto 0);
signal APBmslave1_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_1                         : std_logic;
signal APBmslave0_7_PWRITE_net_1                          : std_logic;
signal APBmslave0_7_PWDATA_net_1                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_2                           : std_logic_vector(31 downto 0);
signal APBmslave2_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_2                         : std_logic;
signal APBmslave0_7_PWRITE_net_2                          : std_logic;
signal APBmslave0_7_PWDATA_net_2                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_3                           : std_logic_vector(31 downto 0);
signal APBmslave3_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_3                         : std_logic;
signal APBmslave0_7_PWRITE_net_3                          : std_logic;
signal APBmslave0_7_PWDATA_net_3                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_4                           : std_logic_vector(31 downto 0);
signal APBmslave4_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_4                         : std_logic;
signal APBmslave0_7_PWRITE_net_4                          : std_logic;
signal APBmslave0_7_PWDATA_net_4                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_5                           : std_logic_vector(31 downto 0);
signal APBmslave5_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_5                         : std_logic;
signal APBmslave0_7_PWRITE_net_5                          : std_logic;
signal APBmslave0_7_PWDATA_net_5                          : std_logic_vector(31 downto 0);
signal APBmslave0_7_PADDR_net_6                           : std_logic_vector(31 downto 0);
signal APBmslave6_0_PSELx_net_0                           : std_logic;
signal APBmslave0_7_PENABLE_net_6                         : std_logic;
signal APBmslave0_7_PWRITE_net_6                          : std_logic;
signal APBmslave0_7_PWDATA_net_6                          : std_logic_vector(31 downto 0);
signal FIC_0_CLK_net_1                                    : std_logic;
signal FIC_0_LOCK_net_1                                   : std_logic;
signal MSS_READY_net_1                                    : std_logic;
signal MMUART_0_TXD_M2F_net_1                             : std_logic;
signal MMUART_1_TXD_M2F_net_1                             : std_logic;
signal GPIO_3_M2F_net_1                                   : std_logic;
signal GPIO_4_M2F_net_1                                   : std_logic;
signal GPIO_12_M2F_net_1                                  : std_logic;
signal GPIO_28_M2F_net_1                                  : std_logic;
signal GPIO_29_M2F_net_1                                  : std_logic;
signal GPIO_30_M2F_net_1                                  : std_logic;
signal GPIO_31_M2F_net_1                                  : std_logic;
signal SPI_0_DO_M2F_net_1                                 : std_logic;
signal SPI_0_CLK_M2F_net_1                                : std_logic;
signal SPI_0_SS0_M2F_net_1                                : std_logic;
signal SPI_0_SS0_M2F_OE_net_1                             : std_logic;
signal MSS_INT_F2M_net_0                                  : std_logic_vector(15 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                                            : std_logic;
signal GND_net                                            : std_logic;
signal PADDR_const_net_0                                  : std_logic_vector(7 downto 2);
signal PWDATA_const_net_0                                 : std_logic_vector(7 downto 0);
signal IADDR_const_net_0                                  : std_logic_vector(31 downto 0);
signal SDIF0_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF1_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF2_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal SDIF3_PRDATA_const_net_0                           : std_logic_vector(31 downto 0);
signal PRDATAS7_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS8_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS9_const_net_0                               : std_logic_vector(31 downto 0);
signal PRDATAS10_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS11_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS12_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS13_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS14_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS15_const_net_0                              : std_logic_vector(31 downto 0);
signal PRDATAS16_const_net_0                              : std_logic_vector(31 downto 0);
signal FIC_2_APB_M_PRDATA_const_net_0                     : std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net                        <= '1';
 GND_net                        <= '0';
 PADDR_const_net_0              <= B"000000";
 PWDATA_const_net_0             <= B"00000000";
 IADDR_const_net_0              <= B"00000000000000000000000000000000";
 SDIF0_PRDATA_const_net_0       <= B"00000000000000000000000000000000";
 SDIF1_PRDATA_const_net_0       <= B"00000000000000000000000000000000";
 SDIF2_PRDATA_const_net_0       <= B"00000000000000000000000000000000";
 SDIF3_PRDATA_const_net_0       <= B"00000000000000000000000000000000";
 PRDATAS7_const_net_0           <= B"00000000000000000000000000000000";
 PRDATAS8_const_net_0           <= B"00000000000000000000000000000000";
 PRDATAS9_const_net_0           <= B"00000000000000000000000000000000";
 PRDATAS10_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS11_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS12_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS13_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS14_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS15_const_net_0          <= B"00000000000000000000000000000000";
 PRDATAS16_const_net_0          <= B"00000000000000000000000000000000";
 FIC_2_APB_M_PRDATA_const_net_0 <= B"00000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 POWER_ON_RESET_N_net_1       <= POWER_ON_RESET_N_net_0;
 POWER_ON_RESET_N             <= POWER_ON_RESET_N_net_1;
 INIT_DONE_net_1              <= INIT_DONE_net_0;
 INIT_DONE                    <= INIT_DONE_net_1;
 APBmslave0_7_PADDR_net_0     <= APBmslave0_7_PADDR;
 MemSync_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_0;
 APBmslave0_7_PSELx_net_0     <= APBmslave0_7_PSELx;
 MemSync_PSELS0               <= APBmslave0_7_PSELx_net_0;
 APBmslave0_7_PENABLE_net_0   <= APBmslave0_7_PENABLE;
 MemSync_PENABLES             <= APBmslave0_7_PENABLE_net_0;
 APBmslave0_7_PWRITE_net_0    <= APBmslave0_7_PWRITE;
 MemSync_PWRITES              <= APBmslave0_7_PWRITE_net_0;
 APBmslave0_7_PWDATA_net_0    <= APBmslave0_7_PWDATA;
 MemSync_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_0;
 APBmslave0_7_PADDR_net_1     <= APBmslave0_7_PADDR;
 STAMP_PADDRS(31 downto 0)    <= APBmslave0_7_PADDR_net_1;
 APBmslave1_0_PSELx_net_0     <= APBmslave1_0_PSELx;
 STAMP_PSELS1                 <= APBmslave1_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_1   <= APBmslave0_7_PENABLE;
 STAMP_PENABLES               <= APBmslave0_7_PENABLE_net_1;
 APBmslave0_7_PWRITE_net_1    <= APBmslave0_7_PWRITE;
 STAMP_PWRITES                <= APBmslave0_7_PWRITE_net_1;
 APBmslave0_7_PWDATA_net_1    <= APBmslave0_7_PWDATA;
 STAMP_PWDATAS(31 downto 0)   <= APBmslave0_7_PWDATA_net_1;
 APBmslave0_7_PADDR_net_2     <= APBmslave0_7_PADDR;
 STAMP_1_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_2;
 APBmslave2_0_PSELx_net_0     <= APBmslave2_0_PSELx;
 STAMP_1_PSELS2               <= APBmslave2_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_2   <= APBmslave0_7_PENABLE;
 STAMP_1_PENABLES             <= APBmslave0_7_PENABLE_net_2;
 APBmslave0_7_PWRITE_net_2    <= APBmslave0_7_PWRITE;
 STAMP_1_PWRITES              <= APBmslave0_7_PWRITE_net_2;
 APBmslave0_7_PWDATA_net_2    <= APBmslave0_7_PWDATA;
 STAMP_1_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_2;
 APBmslave0_7_PADDR_net_3     <= APBmslave0_7_PADDR;
 STAMP_2_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_3;
 APBmslave3_0_PSELx_net_0     <= APBmslave3_0_PSELx;
 STAMP_2_PSELS3               <= APBmslave3_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_3   <= APBmslave0_7_PENABLE;
 STAMP_2_PENABLES             <= APBmslave0_7_PENABLE_net_3;
 APBmslave0_7_PWRITE_net_3    <= APBmslave0_7_PWRITE;
 STAMP_2_PWRITES              <= APBmslave0_7_PWRITE_net_3;
 APBmslave0_7_PWDATA_net_3    <= APBmslave0_7_PWDATA;
 STAMP_2_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_3;
 APBmslave0_7_PADDR_net_4     <= APBmslave0_7_PADDR;
 STAMP_3_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_4;
 APBmslave4_0_PSELx_net_0     <= APBmslave4_0_PSELx;
 STAMP_3_PSELS4               <= APBmslave4_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_4   <= APBmslave0_7_PENABLE;
 STAMP_3_PENABLES             <= APBmslave0_7_PENABLE_net_4;
 APBmslave0_7_PWRITE_net_4    <= APBmslave0_7_PWRITE;
 STAMP_3_PWRITES              <= APBmslave0_7_PWRITE_net_4;
 APBmslave0_7_PWDATA_net_4    <= APBmslave0_7_PWDATA;
 STAMP_3_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_4;
 APBmslave0_7_PADDR_net_5     <= APBmslave0_7_PADDR;
 STAMP_4_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_5;
 APBmslave5_0_PSELx_net_0     <= APBmslave5_0_PSELx;
 STAMP_4_PSELS5               <= APBmslave5_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_5   <= APBmslave0_7_PENABLE;
 STAMP_4_PENABLES             <= APBmslave0_7_PENABLE_net_5;
 APBmslave0_7_PWRITE_net_5    <= APBmslave0_7_PWRITE;
 STAMP_4_PWRITES              <= APBmslave0_7_PWRITE_net_5;
 APBmslave0_7_PWDATA_net_5    <= APBmslave0_7_PWDATA;
 STAMP_4_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_5;
 APBmslave0_7_PADDR_net_6     <= APBmslave0_7_PADDR;
 STAMP_5_PADDRS(31 downto 0)  <= APBmslave0_7_PADDR_net_6;
 APBmslave6_0_PSELx_net_0     <= APBmslave6_0_PSELx;
 STAMP_5_PSELS6               <= APBmslave6_0_PSELx_net_0;
 APBmslave0_7_PENABLE_net_6   <= APBmslave0_7_PENABLE;
 STAMP_5_PENABLES             <= APBmslave0_7_PENABLE_net_6;
 APBmslave0_7_PWRITE_net_6    <= APBmslave0_7_PWRITE;
 STAMP_5_PWRITES              <= APBmslave0_7_PWRITE_net_6;
 APBmslave0_7_PWDATA_net_6    <= APBmslave0_7_PWDATA;
 STAMP_5_PWDATAS(31 downto 0) <= APBmslave0_7_PWDATA_net_6;
 FIC_0_CLK_net_1              <= FIC_0_CLK_net_0;
 FIC_0_CLK                    <= FIC_0_CLK_net_1;
 FIC_0_LOCK_net_1             <= FIC_0_LOCK_net_0;
 FIC_0_LOCK                   <= FIC_0_LOCK_net_1;
 MSS_READY_net_1              <= MSS_READY_net_0;
 MSS_READY                    <= MSS_READY_net_1;
 MMUART_0_TXD_M2F_net_1       <= MMUART_0_TXD_M2F_net_0;
 MMUART_0_TXD_M2F             <= MMUART_0_TXD_M2F_net_1;
 MMUART_1_TXD_M2F_net_1       <= MMUART_1_TXD_M2F_net_0;
 MMUART_1_TXD_M2F             <= MMUART_1_TXD_M2F_net_1;
 GPIO_3_M2F_net_1             <= GPIO_3_M2F_net_0;
 GPIO_3_M2F                   <= GPIO_3_M2F_net_1;
 GPIO_4_M2F_net_1             <= GPIO_4_M2F_net_0;
 GPIO_4_M2F                   <= GPIO_4_M2F_net_1;
 GPIO_12_M2F_net_1            <= GPIO_12_M2F_net_0;
 GPIO_12_M2F                  <= GPIO_12_M2F_net_1;
 GPIO_28_M2F_net_1            <= GPIO_28_M2F_net_0;
 GPIO_28_M2F                  <= GPIO_28_M2F_net_1;
 GPIO_29_M2F_net_1            <= GPIO_29_M2F_net_0;
 GPIO_29_M2F                  <= GPIO_29_M2F_net_1;
 GPIO_30_M2F_net_1            <= GPIO_30_M2F_net_0;
 GPIO_30_M2F                  <= GPIO_30_M2F_net_1;
 GPIO_31_M2F_net_1            <= GPIO_31_M2F_net_0;
 GPIO_31_M2F                  <= GPIO_31_M2F_net_1;
 SPI_0_DO_M2F_net_1           <= SPI_0_DO_M2F_net_0;
 SPI_0_DO_M2F                 <= SPI_0_DO_M2F_net_1;
 SPI_0_CLK_M2F_net_1          <= SPI_0_CLK_M2F_net_0;
 SPI_0_CLK_M2F                <= SPI_0_CLK_M2F_net_1;
 SPI_0_SS0_M2F_net_1          <= SPI_0_SS0_M2F_net_0;
 SPI_0_SS0_M2F                <= SPI_0_SS0_M2F_net_1;
 SPI_0_SS0_M2F_OE_net_1       <= SPI_0_SS0_M2F_OE_net_0;
 SPI_0_SS0_M2F_OE             <= SPI_0_SS0_M2F_OE_net_1;
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
 MSS_INT_F2M_net_0 <= ( '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & STAMP_5_INTR_0_top & STAMP_4_INTR_0_top & STAMP_3_INTR_0_top & STAMP_2_INTR_0_top & STAMP_1_INTR_0_top & STAMP_0_INTR_0_top & MemSync_0_INTR_0_top );
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CCC_0   -   Actel:SgCore:FCCC:2.0.201
CCC_0 : sb_sb_CCC_0_FCCC
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FIC_0_CLK_net_0,
        LOCK           => FIC_0_LOCK_net_0 
        );
-- CoreAPB3_0   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3_0 : entity COREAPB3_LIB.CoreAPB3
    generic map( 
        APB_DWIDTH      => ( 32 ),
        APBSLOT0ENABLE  => ( 1 ),
        APBSLOT1ENABLE  => ( 1 ),
        APBSLOT2ENABLE  => ( 1 ),
        APBSLOT3ENABLE  => ( 1 ),
        APBSLOT4ENABLE  => ( 1 ),
        APBSLOT5ENABLE  => ( 1 ),
        APBSLOT6ENABLE  => ( 1 ),
        APBSLOT7ENABLE  => ( 0 ),
        APBSLOT8ENABLE  => ( 0 ),
        APBSLOT9ENABLE  => ( 0 ),
        APBSLOT10ENABLE => ( 0 ),
        APBSLOT11ENABLE => ( 0 ),
        APBSLOT12ENABLE => ( 0 ),
        APBSLOT13ENABLE => ( 0 ),
        APBSLOT14ENABLE => ( 0 ),
        APBSLOT15ENABLE => ( 0 ),
        FAMILY          => ( 19 ),
        IADDR_OPTION    => ( 0 ),
        MADDR_BITS      => ( 16 ),
        SC_0            => ( 0 ),
        SC_1            => ( 0 ),
        SC_2            => ( 0 ),
        SC_3            => ( 0 ),
        SC_4            => ( 0 ),
        SC_5            => ( 0 ),
        SC_6            => ( 0 ),
        SC_7            => ( 0 ),
        SC_8            => ( 0 ),
        SC_9            => ( 0 ),
        SC_10           => ( 0 ),
        SC_11           => ( 0 ),
        SC_12           => ( 0 ),
        SC_13           => ( 0 ),
        SC_14           => ( 0 ),
        SC_15           => ( 0 ),
        UPR_NIBBLE_POSN => ( 3 )
        )
    port map( 
        -- Inputs
        PRESETN    => GND_net, -- tied to '0' from definition
        PCLK       => GND_net, -- tied to '0' from definition
        PADDR      => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PADDR,
        PWRITE     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE,
        PENABLE    => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE,
        PWDATA     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA,
        PSEL       => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSELx,
        PRDATAS0   => MemSync_PRDATAS0,
        PREADYS0   => MemSync_PREADYS0,
        PSLVERRS0  => MemSync_PSLVERRS0,
        PRDATAS1   => STAMP_PRDATAS1,
        PREADYS1   => STAMP_PREADYS1,
        PSLVERRS1  => STAMP_PSLVERRS1,
        PRDATAS2   => STAMP_1_PRDATAS2,
        PREADYS2   => STAMP_1_PREADYS2,
        PSLVERRS2  => STAMP_1_PSLVERRS2,
        PRDATAS3   => STAMP_2_PRDATAS3,
        PREADYS3   => STAMP_2_PREADYS3,
        PSLVERRS3  => STAMP_2_PSLVERRS3,
        PRDATAS4   => STAMP_3_PRDATAS4,
        PREADYS4   => STAMP_3_PREADYS4,
        PSLVERRS4  => STAMP_3_PSLVERRS4,
        PRDATAS5   => STAMP_4_PRDATAS5,
        PREADYS5   => STAMP_4_PREADYS5,
        PSLVERRS5  => STAMP_4_PSLVERRS5,
        PRDATAS6   => STAMP_5_PRDATAS6,
        PREADYS6   => STAMP_5_PREADYS6,
        PSLVERRS6  => STAMP_5_PSLVERRS6,
        PRDATAS7   => PRDATAS7_const_net_0, -- tied to X"0" from definition
        PREADYS7   => VCC_net, -- tied to '1' from definition
        PSLVERRS7  => GND_net, -- tied to '0' from definition
        PRDATAS8   => PRDATAS8_const_net_0, -- tied to X"0" from definition
        PREADYS8   => VCC_net, -- tied to '1' from definition
        PSLVERRS8  => GND_net, -- tied to '0' from definition
        PRDATAS9   => PRDATAS9_const_net_0, -- tied to X"0" from definition
        PREADYS9   => VCC_net, -- tied to '1' from definition
        PSLVERRS9  => GND_net, -- tied to '0' from definition
        PRDATAS10  => PRDATAS10_const_net_0, -- tied to X"0" from definition
        PREADYS10  => VCC_net, -- tied to '1' from definition
        PSLVERRS10 => GND_net, -- tied to '0' from definition
        PRDATAS11  => PRDATAS11_const_net_0, -- tied to X"0" from definition
        PREADYS11  => VCC_net, -- tied to '1' from definition
        PSLVERRS11 => GND_net, -- tied to '0' from definition
        PRDATAS12  => PRDATAS12_const_net_0, -- tied to X"0" from definition
        PREADYS12  => VCC_net, -- tied to '1' from definition
        PSLVERRS12 => GND_net, -- tied to '0' from definition
        PRDATAS13  => PRDATAS13_const_net_0, -- tied to X"0" from definition
        PREADYS13  => VCC_net, -- tied to '1' from definition
        PSLVERRS13 => GND_net, -- tied to '0' from definition
        PRDATAS14  => PRDATAS14_const_net_0, -- tied to X"0" from definition
        PREADYS14  => VCC_net, -- tied to '1' from definition
        PSLVERRS14 => GND_net, -- tied to '0' from definition
        PRDATAS15  => PRDATAS15_const_net_0, -- tied to X"0" from definition
        PREADYS15  => VCC_net, -- tied to '1' from definition
        PSLVERRS15 => GND_net, -- tied to '0' from definition
        PRDATAS16  => PRDATAS16_const_net_0, -- tied to X"0" from definition
        PREADYS16  => VCC_net, -- tied to '1' from definition
        PSLVERRS16 => GND_net, -- tied to '0' from definition
        IADDR      => IADDR_const_net_0, -- tied to X"0" from definition
        -- Outputs
        PRDATA     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA,
        PREADY     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PREADY,
        PSLVERR    => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR,
        PADDRS     => APBmslave0_7_PADDR,
        PWRITES    => APBmslave0_7_PWRITE,
        PENABLES   => APBmslave0_7_PENABLE,
        PWDATAS    => APBmslave0_7_PWDATA,
        PSELS0     => APBmslave0_7_PSELx,
        PSELS1     => APBmslave1_0_PSELx,
        PSELS2     => APBmslave2_0_PSELx,
        PSELS3     => APBmslave3_0_PSELx,
        PSELS4     => APBmslave4_0_PSELx,
        PSELS5     => APBmslave5_0_PSELx,
        PSELS6     => APBmslave6_0_PSELx,
        PSELS7     => OPEN,
        PSELS8     => OPEN,
        PSELS9     => OPEN,
        PSELS10    => OPEN,
        PSELS11    => OPEN,
        PSELS12    => OPEN,
        PSELS13    => OPEN,
        PSELS14    => OPEN,
        PSELS15    => OPEN,
        PSELS16    => OPEN 
        );
-- CORERESETP_0   -   Actel:DirectCore:CoreResetP:7.1.100
CORERESETP_0 : CoreResetP
    generic map( 
        DDR_WAIT            => ( 200 ),
        DEVICE_090          => ( 0 ),
        DEVICE_VOLTAGE      => ( 2 ),
        ENABLE_SOFT_RESETS  => ( 0 ),
        EXT_RESET_CFG       => ( 0 ),
        FDDR_IN_USE         => ( 0 ),
        MDDR_IN_USE         => ( 0 ),
        SDIF0_IN_USE        => ( 0 ),
        SDIF0_PCIE          => ( 0 ),
        SDIF0_PCIE_HOTRESET => ( 1 ),
        SDIF0_PCIE_L2P2     => ( 1 ),
        SDIF1_IN_USE        => ( 0 ),
        SDIF1_PCIE          => ( 0 ),
        SDIF1_PCIE_HOTRESET => ( 1 ),
        SDIF1_PCIE_L2P2     => ( 1 ),
        SDIF2_IN_USE        => ( 0 ),
        SDIF2_PCIE          => ( 0 ),
        SDIF2_PCIE_HOTRESET => ( 1 ),
        SDIF2_PCIE_L2P2     => ( 1 ),
        SDIF3_IN_USE        => ( 0 ),
        SDIF3_PCIE          => ( 0 ),
        SDIF3_PCIE_HOTRESET => ( 1 ),
        SDIF3_PCIE_L2P2     => ( 1 )
        )
    port map( 
        -- Inputs
        RESET_N_M2F                    => sb_sb_MSS_TMP_0_MSS_RESET_N_M2F,
        FIC_2_APB_M_PRESET_N           => sb_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N,
        POWER_ON_RESET_N               => POWER_ON_RESET_N_net_0,
        FAB_RESET_N                    => FAB_RESET_N,
        RCOSC_25_50MHZ                 => FABOSC_0_RCOSC_25_50MHZ_O2F,
        CLK_BASE                       => FIC_0_CLK_net_0,
        CLK_LTSSM                      => GND_net, -- tied to '0' from definition
        FPLL_LOCK                      => VCC_net, -- tied to '1' from definition
        SDIF0_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF1_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF2_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        SDIF3_SPLL_LOCK                => VCC_net, -- tied to '1' from definition
        CONFIG1_DONE                   => VCC_net,
        CONFIG2_DONE                   => VCC_net,
        SDIF0_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF1_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF2_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF3_PERST_N                  => VCC_net, -- tied to '1' from definition
        SDIF0_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF0_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF0_PRDATA                   => SDIF0_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF1_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF1_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF1_PRDATA                   => SDIF1_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF2_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF2_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF2_PRDATA                   => SDIF2_PRDATA_const_net_0, -- tied to X"0" from definition
        SDIF3_PSEL                     => GND_net, -- tied to '0' from definition
        SDIF3_PWRITE                   => VCC_net, -- tied to '1' from definition
        SDIF3_PRDATA                   => SDIF3_PRDATA_const_net_0, -- tied to X"0" from definition
        SOFT_EXT_RESET_OUT             => GND_net, -- tied to '0' from definition
        SOFT_RESET_F2M                 => GND_net, -- tied to '0' from definition
        SOFT_M3_RESET                  => GND_net, -- tied to '0' from definition
        SOFT_MDDR_DDR_AXI_S_CORE_RESET => GND_net, -- tied to '0' from definition
        SOFT_FDDR_CORE_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_0_CORE_RESET        => GND_net, -- tied to '0' from definition
        SOFT_SDIF0_1_CORE_RESET        => GND_net, -- tied to '0' from definition
        SOFT_SDIF1_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF1_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF2_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF2_CORE_RESET          => GND_net, -- tied to '0' from definition
        SOFT_SDIF3_PHY_RESET           => GND_net, -- tied to '0' from definition
        SOFT_SDIF3_CORE_RESET          => GND_net, -- tied to '0' from definition
        -- Outputs
        MSS_HPMS_READY                 => MSS_READY_net_0,
        DDR_READY                      => OPEN,
        SDIF_READY                     => OPEN,
        RESET_N_F2M                    => CORERESETP_0_RESET_N_F2M,
        M3_RESET_N                     => OPEN,
        EXT_RESET_OUT                  => OPEN,
        MDDR_DDR_AXI_S_CORE_RESET_N    => OPEN,
        FDDR_CORE_RESET_N              => OPEN,
        SDIF0_CORE_RESET_N             => OPEN,
        SDIF0_0_CORE_RESET_N           => OPEN,
        SDIF0_1_CORE_RESET_N           => OPEN,
        SDIF0_PHY_RESET_N              => OPEN,
        SDIF1_CORE_RESET_N             => OPEN,
        SDIF1_PHY_RESET_N              => OPEN,
        SDIF2_CORE_RESET_N             => OPEN,
        SDIF2_PHY_RESET_N              => OPEN,
        SDIF3_CORE_RESET_N             => OPEN,
        SDIF3_PHY_RESET_N              => OPEN,
        SDIF_RELEASED                  => OPEN,
        INIT_DONE                      => INIT_DONE_net_0 
        );
-- FABOSC_0   -   Actel:SgCore:OSC:2.0.101
FABOSC_0 : sb_sb_FABOSC_0_OSC
    port map( 
        -- Inputs
        XTL                => GND_net, -- tied to '0' from definition
        -- Outputs
        RCOSC_25_50MHZ_CCC => FABOSC_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        RCOSC_25_50MHZ_O2F => FABOSC_0_RCOSC_25_50MHZ_O2F,
        RCOSC_1MHZ_CCC     => OPEN,
        RCOSC_1MHZ_O2F     => OPEN,
        XTLOSC_CCC         => OPEN,
        XTLOSC_O2F         => OPEN 
        );
-- sb_sb_MSS_0
sb_sb_MSS_0 : sb_sb_MSS
    port map( 
        -- Inputs
        MCCC_CLK_BASE          => FIC_0_CLK_net_0,
        MMUART_0_RXD_F2M       => MMUART_0_RXD_F2M,
        MMUART_1_RXD_F2M       => MMUART_1_RXD_F2M,
        MCCC_CLK_BASE_PLL_LOCK => FIC_0_LOCK_net_0,
        MSS_RESET_N_F2M        => CORERESETP_0_RESET_N_F2M,
        GPIO_0_F2M             => GPIO_0_F2M,
        GPIO_1_F2M             => GPIO_1_F2M,
        GPIO_2_F2M             => GPIO_2_F2M,
        GPIO_5_F2M             => GPIO_5_F2M,
        SPI_0_DI_F2M           => SPI_0_DI_F2M,
        SPI_0_CLK_F2M          => SPI_0_CLK_F2M,
        SPI_0_SS0_F2M          => SPI_0_SS0_F2M,
        FIC_0_APB_M_PREADY     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PREADY,
        FIC_0_APB_M_PSLVERR    => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSLVERR,
        FIC_2_APB_M_PREADY     => VCC_net, -- tied to '1' from definition
        FIC_2_APB_M_PSLVERR    => GND_net, -- tied to '0' from definition
        MSS_INT_F2M            => MSS_INT_F2M_net_0,
        FIC_0_APB_M_PRDATA     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PRDATA,
        FIC_2_APB_M_PRDATA     => FIC_2_APB_M_PRDATA_const_net_0, -- tied to X"0" from definition
        -- Outputs
        MMUART_0_TXD_M2F       => MMUART_0_TXD_M2F_net_0,
        MMUART_1_TXD_M2F       => MMUART_1_TXD_M2F_net_0,
        MSS_RESET_N_M2F        => sb_sb_MSS_TMP_0_MSS_RESET_N_M2F,
        GPIO_3_M2F             => GPIO_3_M2F_net_0,
        GPIO_4_M2F             => GPIO_4_M2F_net_0,
        GPIO_12_M2F            => GPIO_12_M2F_net_0,
        GPIO_28_M2F            => GPIO_28_M2F_net_0,
        GPIO_29_M2F            => GPIO_29_M2F_net_0,
        GPIO_30_M2F            => GPIO_30_M2F_net_0,
        GPIO_31_M2F            => GPIO_31_M2F_net_0,
        SPI_0_DO_M2F           => SPI_0_DO_M2F_net_0,
        SPI_0_CLK_M2F          => SPI_0_CLK_M2F_net_0,
        SPI_0_SS0_M2F          => SPI_0_SS0_M2F_net_0,
        SPI_0_SS0_M2F_OE       => SPI_0_SS0_M2F_OE_net_0,
        FIC_0_APB_M_PSEL       => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PSELx,
        FIC_0_APB_M_PWRITE     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWRITE,
        FIC_0_APB_M_PENABLE    => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PENABLE,
        FIC_2_APB_M_PRESET_N   => sb_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N,
        FIC_2_APB_M_PCLK       => OPEN,
        FIC_2_APB_M_PWRITE     => OPEN,
        FIC_2_APB_M_PENABLE    => OPEN,
        FIC_2_APB_M_PSEL       => OPEN,
        FIC_0_APB_M_PADDR      => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PADDR,
        FIC_0_APB_M_PWDATA     => sb_sb_MSS_TMP_0_FIC_0_APB_MASTER_PWDATA,
        FIC_2_APB_M_PADDR      => OPEN,
        FIC_2_APB_M_PWDATA     => OPEN 
        );
-- SYSRESET_POR
SYSRESET_POR : SYSRESET
    port map( 
        -- Inputs
        DEVRST_N         => DEVRST_N,
        -- Outputs
        POWER_ON_RESET_N => POWER_ON_RESET_N_net_0 
        );

end RTL;
