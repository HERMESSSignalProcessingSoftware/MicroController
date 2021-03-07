quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/jl/source/repos/hermess/hermess-MicroController"

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

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/spi_master.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/STAMP.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/components.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/tes.vhd"

vsim -L SmartFusion2 -L presynth -L COREAPB3_LIB -L COREUART_LIB  -t 1fs presynth.tes
add wave /tes/*
run 1000ns
