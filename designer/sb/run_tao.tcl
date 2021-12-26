set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\hdl\Timestamp.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\hdl\MemorySynchronizer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\hdl\spi_master.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\hdl\STAMP.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3_muxptob3.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3_iaddr_reg.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\coreapb3.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vhdl\core\coreresetp_pcie_hotreset.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vhdl\core\coreresetp.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\work\sb_sb\CCC_0\sb_sb_CCC_0_FCCC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\work\sb_sb\FABOSC_0\sb_sb_FABOSC_0_OSC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\work\sb_sb_MSS\sb_sb_MSS.vhd}
read_vhdl -mode vhdl_2008 -lib COREAPB3_LIB {C:\Users\RG\Documents\MicroController\component\Actel\DirectCore\CoreAPB3\4.1.100\rtl\vhdl\core\components.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\work\sb_sb\sb_sb.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\RG\Documents\MicroController\component\work\sb\sb.vhd}
set_top_level {sb}
map_netlist
check_constraints {C:\Users\RG\Documents\MicroController\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\RG\Documents\MicroController\designer\sb\synthesis.fdc}
