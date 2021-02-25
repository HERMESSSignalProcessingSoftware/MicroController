set_device \
    -family  SmartFusion2 \
    -die     PA4M1000_N \
    -package vf400 \
    -speed   STD \
    -tempr   {COM} \
    -voltr   {COM}
set_def {VOLTAGE} {1.2}
set_def {VCCI_1.2_VOLTR} {COM}
set_def {VCCI_1.5_VOLTR} {COM}
set_def {VCCI_1.8_VOLTR} {COM}
set_def {VCCI_2.5_VOLTR} {COM}
set_def {VCCI_3.3_VOLTR} {COM}
set_def {PLL_SUPPLY} {PLL_SUPPLY_33}
set_def {VPP_SUPPLY_25_33} {VPP_SUPPLY_25}
set_def {PA4_URAM_FF_CONFIG} {SUSPEND}
set_def {PA4_SRAM_FF_CONFIG} {SUSPEND}
set_def {PA4_MSS_FF_CLOCK} {RCOSC_1MHZ}
set_def USE_CONSTRAINTS_FLOW 1
set_netlist -afl {C:\Users\jl\source\repos\hermess\hermess-MicroController\designer\sb\sb.afl} -adl {C:\Users\jl\source\repos\hermess\hermess-MicroController\designer\sb\sb.adl}
set_placement   {C:\Users\jl\source\repos\hermess\hermess-MicroController\designer\sb\sb.loc}
set_routing     {C:\Users\jl\source\repos\hermess\hermess-MicroController\designer\sb\sb.seg}
