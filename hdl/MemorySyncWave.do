onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Basic Signals}
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/clk
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/nReset
add wave -noupdate -divider INPUTS
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_enable
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_databus
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_newAvails
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_requestSync
add wave -noupdate -divider OUTPUTS
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/dataReadyReset
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/SynchronizerInterrupt
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ReadInterrupt
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ADCResync
add wave -noupdate -divider APB
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PADDR
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PSEL
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PENABLE
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PWRITE
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PWDATA
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PREADY
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/PRDATA
add wave -noupdate -divider Register
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp1ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp1ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp2ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp2ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp3ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp3ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp4ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp4ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp5ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp5ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp6ShadowReg1
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/Stamp6ShadowReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/SynchStatusReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/SynchStatusReg2
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ResetTimerValueReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/WaitingTimerValueReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ResyncTimerValueReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ConfigReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/TimeStampReg
add wave -noupdate -divider {Timestamp Signals}
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/TimeStampValue
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/getTime
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/enableTimestampGen
add wave -noupdate -divider Statemachines
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/MemorySyncState
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/APBState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {122 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
