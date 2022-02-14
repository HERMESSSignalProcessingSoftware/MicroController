set_device \
    -fam SmartFusion2 \
    -die PA4M1000_N \
    -pkg tq144
set_input_cfg \
	-path {B:/HERMESS_SPSoftware/Microcontroller/component/work/sb_sb_MSS/ENVM.cfg}
set_output_efc \
    -path {B:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb.efc}
set_proj_dir \
    -path {B:\HERMESS_SPSoftware\Microcontroller}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
gen_prg -use_init false
