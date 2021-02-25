quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/jl/source/repos/hermess/hermess-MicroController"
source "${PROJECT_DIR}/simulation/bfmtovec_compile.tcl";
source "${PROJECT_DIR}/simulation/CM3_compile_bfm.tcl";


if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "J:/LiberoSoC/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"
if {[file exists COREAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAPB3_LIB already exists"
} else {
   file delete -force COREAPB3_LIB 
   vlib COREAPB3_LIB
}
vmap COREAPB3_LIB "COREAPB3_LIB"
if {[file exists COREUART_LIB/_info]} {
   echo "INFO: Simulation library COREUART_LIB already exists"
} else {
   file delete -force COREUART_LIB 
   vlib COREUART_LIB
}
vmap COREUART_LIB "COREUART_LIB"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Synchronizer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/spi_master.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/STAMP.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_muxptob3.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_iaddr_reg.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vhdl/core/coreresetp_pcie_hotreset.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Actel/DirectCore/CoreResetP/7.1.100/rtl/vhdl/core/coreresetp.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/sb_sb/CCC_0/sb_sb_CCC_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/sb_sb/FABOSC_0/sb_sb_FABOSC_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/sb_sb_MSS/sb_sb_MSS.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/components.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/sb_sb/sb_sb.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/sb/sb.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/stamp_tb/stamp_tb.vhd"

vsim -L SmartFusion2 -L presynth -L COREAPB3_LIB -L COREUART_LIB  -t 1fs presynth.stamp_tb
add wave /stamp_tb/*
run 1000ns
