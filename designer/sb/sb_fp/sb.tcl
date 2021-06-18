open_project -project {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_fp\sb.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
save_project
close_project
