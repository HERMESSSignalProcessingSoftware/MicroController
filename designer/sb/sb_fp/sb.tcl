open_project -project {C:\Users\RG\Documents\MicroController\designer\sb\sb_fp\sb.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {C:\Users\RG\Documents\MicroController\designer\sb\sb.map} \
    -header {C:\Users\RG\Documents\MicroController\designer\sb\sb.hdr} \
    -envm {C:\Users\RG\Documents\MicroController\designer\sb\sb.efc} \
    -spm {C:\Users\RG\Documents\MicroController\designer\sb\sb.spm} \
    -dca {C:\Users\RG\Documents\MicroController\designer\sb\sb.dca}
export_single_ppd \
    -name {M2S010} \
    -file {C:\Users\RG\Documents\MicroController\designer\sb\sb.ppd}

save_project
close_project
