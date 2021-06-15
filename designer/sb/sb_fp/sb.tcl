open_project -project {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_fp\sb.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.map} \
    -header {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.hdr} \
    -envm {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.efc} \
    -spm {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.spm} \
    -dca {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.dca}
export_single_ppd \
    -name {M2S010} \
    -file {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.ppd}

save_project
close_project
