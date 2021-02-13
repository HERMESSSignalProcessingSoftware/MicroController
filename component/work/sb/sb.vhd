----------------------------------------------------------------------
-- Created by SmartDesign Sat Feb 13 09:53:55 2021
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
-- sb entity declaration
----------------------------------------------------------------------
entity sb is
    -- Port list
    port(
        -- Inputs
        DAPI_RX             : in    std_logic;
        DEVRST_N            : in    std_logic;
        SODS                : in    std_logic;
        SPI_DATASTORAGE_DI  : in    std_logic;
        TM_RX               : in    std_logic;
        ready_dms1          : in    std_logic;
        ready_dms2          : in    std_logic;
        ready_temp          : in    std_logic;
        spi_miso            : in    std_logic;
        -- Outputs
        DAPI_TX             : out   std_logic;
        LED_HEARTBEAT       : out   std_logic;
        LED_RECORDING       : out   std_logic;
        SPI_DATASTORAGE_DO  : out   std_logic;
        TM_TX               : out   std_logic;
        spi_clock           : out   std_logic;
        spi_dms1_cs         : out   std_logic;
        spi_dms2_cs         : out   std_logic;
        spi_mosi            : out   std_logic;
        spi_temp_cs         : out   std_logic;
        -- Inouts
        SPI_DATASTORAGE_CLK : inout std_logic;
        SPI_DATASTORAGE_SS0 : inout std_logic
        );
end sb;
----------------------------------------------------------------------
-- sb architecture body
----------------------------------------------------------------------
architecture RTL of sb is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- sb_sb
component sb_sb
    -- Port list
    port(
        -- Inputs
        DEVRST_N           : in    std_logic;
        FAB_RESET_N        : in    std_logic;
        GPIO_0_F2M         : in    std_logic;
        MMUART_0_RXD       : in    std_logic;
        MMUART_1_RXD       : in    std_logic;
        SPI_0_DI           : in    std_logic;
        STAMP_0_INTR_0_top : in    std_logic;
        STAMP_1_INTR_0_top : in    std_logic;
        STAMP_1_PRDATAS1   : in    std_logic_vector(31 downto 0);
        STAMP_1_PREADYS1   : in    std_logic;
        STAMP_1_PSLVERRS1  : in    std_logic;
        STAMP_2_INTR_0_top : in    std_logic;
        STAMP_2_PRDATAS2   : in    std_logic_vector(31 downto 0);
        STAMP_2_PREADYS2   : in    std_logic;
        STAMP_2_PSLVERRS2  : in    std_logic;
        STAMP_3_INTR_0_top : in    std_logic;
        STAMP_3_PRDATAS3   : in    std_logic_vector(31 downto 0);
        STAMP_3_PREADYS3   : in    std_logic;
        STAMP_3_PSLVERRS3  : in    std_logic;
        STAMP_4_INTR_0_top : in    std_logic;
        STAMP_4_PRDATAS4   : in    std_logic_vector(31 downto 0);
        STAMP_4_PREADYS4   : in    std_logic;
        STAMP_4_PSLVERRS4  : in    std_logic;
        STAMP_5_INTR_0_top : in    std_logic;
        STAMP_5_PRDATAS5   : in    std_logic_vector(31 downto 0);
        STAMP_5_PREADYS5   : in    std_logic;
        STAMP_5_PSLVERRS5  : in    std_logic;
        STAMP_PRDATAS0     : in    std_logic_vector(31 downto 0);
        STAMP_PREADYS0     : in    std_logic;
        STAMP_PSLVERRS0    : in    std_logic;
        -- Outputs
        FIC_0_CLK          : out   std_logic;
        FIC_0_LOCK         : out   std_logic;
        GPIO_2_M2F         : out   std_logic;
        GPIO_3_M2F         : out   std_logic;
        INIT_DONE          : out   std_logic;
        MMUART_0_TXD       : out   std_logic;
        MMUART_1_TXD       : out   std_logic;
        MSS_READY          : out   std_logic;
        POWER_ON_RESET_N   : out   std_logic;
        SPI_0_DO           : out   std_logic;
        STAMP_1_PADDRS     : out   std_logic_vector(31 downto 0);
        STAMP_1_PENABLES   : out   std_logic;
        STAMP_1_PSELS1     : out   std_logic;
        STAMP_1_PWDATAS    : out   std_logic_vector(31 downto 0);
        STAMP_1_PWRITES    : out   std_logic;
        STAMP_2_PADDRS     : out   std_logic_vector(31 downto 0);
        STAMP_2_PENABLES   : out   std_logic;
        STAMP_2_PSELS2     : out   std_logic;
        STAMP_2_PWDATAS    : out   std_logic_vector(31 downto 0);
        STAMP_2_PWRITES    : out   std_logic;
        STAMP_3_PADDRS     : out   std_logic_vector(31 downto 0);
        STAMP_3_PENABLES   : out   std_logic;
        STAMP_3_PSELS3     : out   std_logic;
        STAMP_3_PWDATAS    : out   std_logic_vector(31 downto 0);
        STAMP_3_PWRITES    : out   std_logic;
        STAMP_4_PADDRS     : out   std_logic_vector(31 downto 0);
        STAMP_4_PENABLES   : out   std_logic;
        STAMP_4_PSELS4     : out   std_logic;
        STAMP_4_PWDATAS    : out   std_logic_vector(31 downto 0);
        STAMP_4_PWRITES    : out   std_logic;
        STAMP_5_PADDRS     : out   std_logic_vector(31 downto 0);
        STAMP_5_PENABLES   : out   std_logic;
        STAMP_5_PSELS5     : out   std_logic;
        STAMP_5_PWDATAS    : out   std_logic_vector(31 downto 0);
        STAMP_5_PWRITES    : out   std_logic;
        STAMP_PADDRS       : out   std_logic_vector(31 downto 0);
        STAMP_PENABLES     : out   std_logic;
        STAMP_PSELS0       : out   std_logic;
        STAMP_PWDATAS      : out   std_logic_vector(31 downto 0);
        STAMP_PWRITES      : out   std_logic;
        -- Inouts
        SPI_0_CLK          : inout std_logic;
        SPI_0_SS0          : inout std_logic
        );
end component;
-- STAMP
-- using entity instantiation for component STAMP
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal DAPI_TX_net_0            : std_logic;
signal LED_HEARTBEAT_net_0      : std_logic;
signal LED_RECORDING_net_0      : std_logic;
signal sb_sb_0_FIC_0_CLK        : std_logic;
signal sb_sb_0_STAMP_PENABLE    : std_logic;
signal sb_sb_0_STAMP_PRDATA     : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PREADY     : std_logic;
signal sb_sb_0_STAMP_PSELx      : std_logic;
signal sb_sb_0_STAMP_PSLVERR    : std_logic;
signal sb_sb_0_STAMP_PWDATA     : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PWRITE     : std_logic;
signal spi_clock_net_0          : std_logic;
signal SPI_DATASTORAGE_DO_net_0 : std_logic;
signal spi_dms1_cs_net_0        : std_logic;
signal spi_dms2_cs_net_0        : std_logic;
signal spi_mosi_net_0           : std_logic;
signal spi_temp_cs_net_0        : std_logic;
signal STAMP_0_new_avail        : std_logic;
signal TM_TX_net_0              : std_logic;
signal TM_TX_net_1              : std_logic;
signal DAPI_TX_net_1            : std_logic;
signal LED_RECORDING_net_1      : std_logic;
signal LED_HEARTBEAT_net_1      : std_logic;
signal SPI_DATASTORAGE_DO_net_1 : std_logic;
signal spi_clock_net_1          : std_logic;
signal spi_mosi_net_1           : std_logic;
signal spi_dms1_cs_net_1        : std_logic;
signal spi_temp_cs_net_1        : std_logic;
signal spi_dms2_cs_net_1        : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                  : std_logic;
signal GND_net                  : std_logic;
signal STAMP_1_PRDATAS1_const_net_0: std_logic_vector(31 downto 0);
signal STAMP_2_PRDATAS2_const_net_0: std_logic_vector(31 downto 0);
signal STAMP_3_PRDATAS3_const_net_0: std_logic_vector(31 downto 0);
signal STAMP_4_PRDATAS4_const_net_0: std_logic_vector(31 downto 0);
signal STAMP_5_PRDATAS5_const_net_0: std_logic_vector(31 downto 0);
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal sb_sb_0_STAMP_PADDR      : std_logic_vector(31 downto 0);
signal sb_sb_0_STAMP_PADDR_0_5to0: std_logic_vector(5 downto 0);
signal sb_sb_0_STAMP_PADDR_0    : std_logic_vector(5 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net                      <= '1';
 GND_net                      <= '0';
 STAMP_1_PRDATAS1_const_net_0 <= B"00000000000000000000000000000000";
 STAMP_2_PRDATAS2_const_net_0 <= B"00000000000000000000000000000000";
 STAMP_3_PRDATAS3_const_net_0 <= B"00000000000000000000000000000000";
 STAMP_4_PRDATAS4_const_net_0 <= B"00000000000000000000000000000000";
 STAMP_5_PRDATAS5_const_net_0 <= B"00000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 TM_TX_net_1              <= TM_TX_net_0;
 TM_TX                    <= TM_TX_net_1;
 DAPI_TX_net_1            <= DAPI_TX_net_0;
 DAPI_TX                  <= DAPI_TX_net_1;
 LED_RECORDING_net_1      <= LED_RECORDING_net_0;
 LED_RECORDING            <= LED_RECORDING_net_1;
 LED_HEARTBEAT_net_1      <= LED_HEARTBEAT_net_0;
 LED_HEARTBEAT            <= LED_HEARTBEAT_net_1;
 SPI_DATASTORAGE_DO_net_1 <= SPI_DATASTORAGE_DO_net_0;
 SPI_DATASTORAGE_DO       <= SPI_DATASTORAGE_DO_net_1;
 spi_clock_net_1          <= spi_clock_net_0;
 spi_clock                <= spi_clock_net_1;
 spi_mosi_net_1           <= spi_mosi_net_0;
 spi_mosi                 <= spi_mosi_net_1;
 spi_dms1_cs_net_1        <= spi_dms1_cs_net_0;
 spi_dms1_cs              <= spi_dms1_cs_net_1;
 spi_temp_cs_net_1        <= spi_temp_cs_net_0;
 spi_temp_cs              <= spi_temp_cs_net_1;
 spi_dms2_cs_net_1        <= spi_dms2_cs_net_0;
 spi_dms2_cs              <= spi_dms2_cs_net_1;
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 sb_sb_0_STAMP_PADDR_0_5to0(5 downto 0) <= sb_sb_0_STAMP_PADDR(5 downto 0);
 sb_sb_0_STAMP_PADDR_0(5 downto 0) <= ( sb_sb_0_STAMP_PADDR_0_5to0(5 downto 0) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- sb_sb_0
sb_sb_0 : sb_sb
    port map( 
        -- Inputs
        SPI_0_DI           => SPI_DATASTORAGE_DI,
        MMUART_1_RXD       => TM_RX,
        MMUART_0_RXD       => DAPI_RX,
        FAB_RESET_N        => VCC_net,
        STAMP_5_INTR_0_top => STAMP_0_new_avail,
        STAMP_4_INTR_0_top => GND_net,
        STAMP_3_INTR_0_top => GND_net,
        STAMP_2_INTR_0_top => GND_net,
        STAMP_1_INTR_0_top => GND_net,
        STAMP_0_INTR_0_top => GND_net,
        STAMP_PREADYS0     => sb_sb_0_STAMP_PREADY,
        STAMP_PSLVERRS0    => sb_sb_0_STAMP_PSLVERR,
        STAMP_1_PREADYS1   => VCC_net, -- tied to '1' from definition
        STAMP_1_PSLVERRS1  => GND_net, -- tied to '0' from definition
        STAMP_2_PREADYS2   => VCC_net, -- tied to '1' from definition
        STAMP_2_PSLVERRS2  => GND_net, -- tied to '0' from definition
        STAMP_3_PREADYS3   => VCC_net, -- tied to '1' from definition
        STAMP_3_PSLVERRS3  => GND_net, -- tied to '0' from definition
        STAMP_4_PREADYS4   => VCC_net, -- tied to '1' from definition
        STAMP_4_PSLVERRS4  => GND_net, -- tied to '0' from definition
        STAMP_5_PREADYS5   => VCC_net, -- tied to '1' from definition
        STAMP_5_PSLVERRS5  => GND_net, -- tied to '0' from definition
        DEVRST_N           => DEVRST_N,
        GPIO_0_F2M         => SODS,
        STAMP_PRDATAS0     => sb_sb_0_STAMP_PRDATA,
        STAMP_1_PRDATAS1   => STAMP_1_PRDATAS1_const_net_0, -- tied to X"0" from definition
        STAMP_2_PRDATAS2   => STAMP_2_PRDATAS2_const_net_0, -- tied to X"0" from definition
        STAMP_3_PRDATAS3   => STAMP_3_PRDATAS3_const_net_0, -- tied to X"0" from definition
        STAMP_4_PRDATAS4   => STAMP_4_PRDATAS4_const_net_0, -- tied to X"0" from definition
        STAMP_5_PRDATAS5   => STAMP_5_PRDATAS5_const_net_0, -- tied to X"0" from definition
        -- Outputs
        SPI_0_DO           => SPI_DATASTORAGE_DO_net_0,
        MMUART_1_TXD       => TM_TX_net_0,
        MMUART_0_TXD       => DAPI_TX_net_0,
        POWER_ON_RESET_N   => OPEN,
        INIT_DONE          => OPEN,
        STAMP_PSELS0       => sb_sb_0_STAMP_PSELx,
        STAMP_PENABLES     => sb_sb_0_STAMP_PENABLE,
        STAMP_PWRITES      => sb_sb_0_STAMP_PWRITE,
        STAMP_1_PSELS1     => OPEN,
        STAMP_1_PENABLES   => OPEN,
        STAMP_1_PWRITES    => OPEN,
        STAMP_2_PSELS2     => OPEN,
        STAMP_2_PENABLES   => OPEN,
        STAMP_2_PWRITES    => OPEN,
        STAMP_3_PSELS3     => OPEN,
        STAMP_3_PENABLES   => OPEN,
        STAMP_3_PWRITES    => OPEN,
        STAMP_4_PSELS4     => OPEN,
        STAMP_4_PENABLES   => OPEN,
        STAMP_4_PWRITES    => OPEN,
        STAMP_5_PSELS5     => OPEN,
        STAMP_5_PENABLES   => OPEN,
        STAMP_5_PWRITES    => OPEN,
        FIC_0_CLK          => sb_sb_0_FIC_0_CLK,
        FIC_0_LOCK         => OPEN,
        MSS_READY          => OPEN,
        GPIO_2_M2F         => LED_RECORDING_net_0,
        GPIO_3_M2F         => LED_HEARTBEAT_net_0,
        STAMP_PADDRS       => sb_sb_0_STAMP_PADDR,
        STAMP_PWDATAS      => sb_sb_0_STAMP_PWDATA,
        STAMP_1_PADDRS     => OPEN,
        STAMP_1_PWDATAS    => OPEN,
        STAMP_2_PADDRS     => OPEN,
        STAMP_2_PWDATAS    => OPEN,
        STAMP_3_PADDRS     => OPEN,
        STAMP_3_PWDATAS    => OPEN,
        STAMP_4_PADDRS     => OPEN,
        STAMP_4_PWDATAS    => OPEN,
        STAMP_5_PADDRS     => OPEN,
        STAMP_5_PWDATAS    => OPEN,
        -- Inouts
        SPI_0_CLK          => SPI_DATASTORAGE_CLK,
        SPI_0_SS0          => SPI_DATASTORAGE_SS0 
        );
-- STAMP_0
STAMP_0 : entity work.STAMP
    generic map( 
        async_threshold => ( 5 )
        )
    port map( 
        -- Inputs
        PCLK        => sb_sb_0_FIC_0_CLK,
        PRESETN     => VCC_net,
        PSEL        => sb_sb_0_STAMP_PSELx,
        PENABLE     => sb_sb_0_STAMP_PENABLE,
        PWRITE      => sb_sb_0_STAMP_PWRITE,
        spi_miso    => spi_miso,
        ready_dms1  => ready_dms1,
        ready_dms2  => ready_dms2,
        ready_temp  => ready_temp,
        PADDR       => sb_sb_0_STAMP_PADDR_0,
        PWDATA      => sb_sb_0_STAMP_PWDATA,
        -- Outputs
        new_avail   => STAMP_0_new_avail,
        PREADY      => sb_sb_0_STAMP_PREADY,
        PSLVERR     => sb_sb_0_STAMP_PSLVERR,
        spi_clock   => spi_clock_net_0,
        spi_mosi    => spi_mosi_net_0,
        spi_dms1_cs => spi_dms1_cs_net_0,
        spi_dms2_cs => spi_dms2_cs_net_0,
        spi_temp_cs => spi_temp_cs_net_0,
        PRDATA      => sb_sb_0_STAMP_PRDATA 
        );

end RTL;
