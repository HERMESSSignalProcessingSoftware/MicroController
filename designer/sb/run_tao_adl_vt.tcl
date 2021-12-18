set_device -family {SmartFusion2} -die {M2S010} -speed {STD}
read_adl {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.adl}
read_afl {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.afl}
map_netlist
check_constraints {D:\HERMESS_SPSoftware\Microcontroller\constraint\timing_sdc_errors.log}
write_sdc -mode smarttime {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\timing_analysis.sdc}
