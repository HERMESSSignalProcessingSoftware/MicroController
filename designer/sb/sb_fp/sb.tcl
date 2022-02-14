open_project -project {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_fp\sb.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.map} \
    -header {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.hdr} \
    -envm {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.efc} \
    -spm {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.spm} \
    -dca {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.dca}
export_single_ppd \
    -name {M2S010} \
    -file {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.ppd}

save_project
close_project
