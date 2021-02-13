open_project -project {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb_fp\sb.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.map} \
    -header {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.hdr} \
    -envm {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.efc} \
    -spm {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.spm} \
    -dca {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.dca}
export_single_ppd \
    -name {M2S010} \
    -file {C:\Users\jl\source\repos\Smartfusion2 Tinker\hermess\designer\sb\sb.ppd}

save_project
close_project
