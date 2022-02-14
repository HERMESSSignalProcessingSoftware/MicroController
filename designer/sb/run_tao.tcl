set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\Timestamp.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\MemorySynchronizer.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\spi_master.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\STAMP.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3_muxptob3.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3_iaddr_reg.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vhdl\core\coreresetp_pcie_hotreset.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vhdl\core\coreresetp.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\work\sb_sb\CCC_0\sb_sb_CCC_0_FCCC.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\work\sb_sb\FABOSC_0\sb_sb_FABOSC_0_OSC.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\work\sb_sb_MSS\sb_sb_MSS.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {B:\HERMESS_SPSoftware\Microcontroller\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\components.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\work\sb_sb\sb_sb.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\UART_RX.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\hdl\UART_TX.vhd}
read_vhdl -mode vhdl_2008 -lib HERMESS_TELEMETRY {B:\HERMESS_SPSoftware\Microcontroller\hdl\telemetry.vhd}
read_vhdl -mode vhdl_2008 {B:\HERMESS_SPSoftware\Microcontroller\component\work\sb\sb.vhd}
set_top_level {sb}
map_netlist
check_constraints {B:\HERMESS_SPSoftware\Microcontroller\constraint\synthesis_sdc_errors.log}
write_fdc {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\synthesis.fdc}
