read_sdc -scenario "timing_analysis" -netlist "optimized" -pin_separator "/" -ignore_errors {D:/HERMESS_SPSoftware/Microcontroller/designer/sb/timing_analysis.sdc}
set_options -analysis_scenario "timing_analysis" 
save
set max_slow_lv_ht      "not_run"
set min_fast_hv_lt      "not_run"
set max_fast_hv_lt      "not_run"
set min_slow_lv_ht      "not_run"
set max_viol_slow_lv_ht "not_run"
set min_viol_fast_hv_lt "not_run"
set max_viol_fast_hv_lt "not_run"
set min_viol_slow_lv_ht "not_run"
set coverage            "not_run"
set_options -max_opcond worst
set_options -min_opcond best
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_timing_constraints_coverage.xml} ]
report \
    -type     combinational_loops \
    -format   xml \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_timing_combinational_loops.xml}
set_options -max_opcond best
set_options -min_opcond worst
set has_violations {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_has_violations}
set fp [open $has_violations w]
puts $fp "_max_timing_slow_1.14V_85C $max_slow_lv_ht"
puts $fp "_min_timing_fast_1.26V_0C $min_fast_hv_lt"
puts $fp "_max_timing_fast_1.26V_0C $max_fast_hv_lt"
puts $fp "_min_timing_slow_1.14V_85C $min_slow_lv_ht"
puts $fp "_max_timing_violations_slow_1.14V_85C $max_viol_slow_lv_ht"
puts $fp "_min_timing_violations_fast_1.26V_0C $min_viol_fast_hv_lt"
puts $fp "_max_timing_violations_fast_1.26V_0C $max_viol_fast_hv_lt"
puts $fp "_min_timing_violations_slow_1.14V_85C $min_viol_slow_lv_ht"
puts $fp "_timing_constraints_coverage $coverage"
report_timing \
    -delay_type     max \
    -max_paths  1000 \
    -file      \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\max_report.json}
report_timing \
    -delay_type     min \
    -max_paths  1000 \
    -file      \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\min_report.json}
set max_timing_violations_multi_corner [report \
    -type     timing_violations \
    -analysis max \
    -format   xml \
    -multi_corner yes \
    -use_slack_threshold  yes \
    -slack_threshold  0.0 \
    -max_paths  20 \
    -max_expanded_paths  0 \
    -max_parallel_paths  1 \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_max_timing_violations_multi_corner.xml} ]
puts $fp "_max_timing_violations_multi_corner $max_timing_violations_multi_corner"
set max_timing_multi_corner [report \
    -type     timing \
    -analysis max \
    -format   xml \
    -multi_corner yes \
    -use_slack_threshold no \
    -slack_threshold  0.0 \
    -max_paths  5 \
    -max_expanded_paths  1 \
    -max_parallel_paths  1 \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_max_timing_multi_corner.xml} ]
puts $fp "_max_timing_multi_corner $max_timing_multi_corner"
set min_timing_violations_multi_corner [report \
    -type     timing_violations \
    -analysis min \
    -format   xml \
    -multi_corner yes \
    -use_slack_threshold  yes \
    -slack_threshold  0.0 \
    -max_paths  20 \
    -max_expanded_paths  0 \
    -max_parallel_paths  1 \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_min_timing_violations_multi_corner.xml} ]
puts $fp "_min_timing_violations_multi_corner $min_timing_violations_multi_corner"
set min_timing_multi_corner [report \
    -type     timing \
    -analysis min \
    -format   xml \
    -multi_corner yes \
    -use_slack_threshold no \
    -slack_threshold  0.0 \
    -max_paths  5 \
    -max_expanded_paths  1 \
    -max_parallel_paths  1 \
    {D:\HERMESS_SPSoftware\Microcontroller\designer\sb\sb_min_timing_multi_corner.xml} ]
puts $fp "_min_timing_multi_corner $min_timing_multi_corner"
close $fp
