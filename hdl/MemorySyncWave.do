onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Basic Signals}
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/clk
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/nReset
add wave -noupdate -divider INPUTS
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_enable
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/IN_databus
add wave -noupdate -radix binary -childformat {{/memorysynchronizer_tb/DUT/IN_newAvails(5) -radix hexadecimal} {/memorysynchronizer_tb/DUT/IN_newAvails(4) -radix hexadecimal} {/memorysynchronizer_tb/DUT/IN_newAvails(3) -radix hexadecimal} {/memorysynchronizer_tb/DUT/IN_newAvails(2) -radix hexadecimal} {/memorysynchronizer_tb/DUT/IN_newAvails(1) -radix hexadecimal} {/memorysynchronizer_tb/DUT/IN_newAvails(0) -radix hexadecimal}} -subitemconfig {/memorysynchronizer_tb/DUT/IN_newAvails(5) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/IN_newAvails(4) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/IN_newAvails(3) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/IN_newAvails(2) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/IN_newAvails(1) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/IN_newAvails(0) {-height 15 -radix hexadecimal}} /memorysynchronizer_tb/DUT/IN_newAvails
add wave -noupdate -radix binary /memorysynchronizer_tb/DUT/IN_requestSync
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
add wave -noupdate -radix hexadecimal -childformat {{/memorysynchronizer_tb/DUT/SynchStatusReg(31) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(30) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(29) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(28) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(27) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(26) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(25) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(24) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(23) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(22) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(21) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(20) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(19) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(18) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(17) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(16) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(15) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(14) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(13) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(12) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(11) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(10) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(9) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(8) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(7) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(6) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(5) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(4) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(3) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(2) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(1) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg(0) -radix hexadecimal}} -subitemconfig {/memorysynchronizer_tb/DUT/SynchStatusReg(31) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(30) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(29) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(28) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(27) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(26) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(25) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(24) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(23) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(22) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(21) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(20) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(19) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(18) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(17) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(16) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(15) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(14) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(13) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(12) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(11) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(10) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(9) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(8) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(7) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(6) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(5) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(4) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(3) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(2) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(1) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg(0) {-height 15 -radix hexadecimal}} /memorysynchronizer_tb/DUT/SynchStatusReg
add wave -noupdate -radix hexadecimal -childformat {{/memorysynchronizer_tb/DUT/SynchStatusReg2(31) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(30) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(29) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(28) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(27) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(26) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(25) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(24) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(23) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(22) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(21) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(20) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(19) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(18) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(17) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(16) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(15) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(14) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(13) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(12) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(11) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(10) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(9) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(8) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(7) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(6) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(5) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(4) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(3) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(2) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(1) -radix hexadecimal} {/memorysynchronizer_tb/DUT/SynchStatusReg2(0) -radix hexadecimal}} -subitemconfig {/memorysynchronizer_tb/DUT/SynchStatusReg2(31) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(30) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(29) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(28) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(27) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(26) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(25) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(24) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(23) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(22) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(21) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(20) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(19) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(18) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(17) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(16) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(15) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(14) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(13) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(12) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(11) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(10) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(9) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(8) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(7) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(6) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(5) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(4) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(3) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(2) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(1) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/SynchStatusReg2(0) {-height 15 -radix hexadecimal}} /memorysynchronizer_tb/DUT/SynchStatusReg2
add wave -noupdate -radix hexadecimal -childformat {{/memorysynchronizer_tb/DUT/ResetTimerValueReg(31) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(30) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(29) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(28) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(27) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(26) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(25) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(24) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(23) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(22) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(21) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(20) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(19) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(18) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(17) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(16) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(15) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(14) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(13) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(12) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(11) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(10) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(9) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(8) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(7) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(6) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(5) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(4) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(3) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(2) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(1) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ResetTimerValueReg(0) -radix hexadecimal}} -subitemconfig {/memorysynchronizer_tb/DUT/ResetTimerValueReg(31) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(30) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(29) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(28) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(27) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(26) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(25) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(24) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(23) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(22) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(21) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(20) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(19) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(18) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(17) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(16) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(15) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(14) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(13) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(12) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(11) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(10) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(9) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(8) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(7) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(6) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(5) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(4) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(3) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(2) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(1) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ResetTimerValueReg(0) {-height 15 -radix hexadecimal}} /memorysynchronizer_tb/DUT/ResetTimerValueReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/WaitingTimerValueReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/ResyncTimerValueReg
add wave -noupdate -radix hexadecimal -childformat {{/memorysynchronizer_tb/DUT/ConfigReg(31) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(30) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(29) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(28) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(27) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(26) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(25) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(24) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(23) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(22) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(21) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(20) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(19) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(18) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(17) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(16) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(15) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(14) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(13) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(12) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(11) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(10) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(9) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(8) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(7) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(6) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(5) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(4) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(3) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(2) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(1) -radix hexadecimal} {/memorysynchronizer_tb/DUT/ConfigReg(0) -radix hexadecimal}} -subitemconfig {/memorysynchronizer_tb/DUT/ConfigReg(31) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(30) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(29) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(28) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(27) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(26) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(25) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(24) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(23) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(22) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(21) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(20) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(19) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(18) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(17) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(16) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(15) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(14) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(13) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(12) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(11) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(10) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(9) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(8) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(7) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(6) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(5) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(4) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(3) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(2) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(1) {-height 15 -radix hexadecimal} /memorysynchronizer_tb/DUT/ConfigReg(0) {-height 15 -radix hexadecimal}} /memorysynchronizer_tb/DUT/ConfigReg
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/TimeStampReg
add wave -noupdate -divider {Timestamp Signals}
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/TimeStampValue
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/getTime
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/enableTimestampGen
add wave -noupdate -divider Statemachines
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/MemorySyncState
add wave -noupdate -radix hexadecimal /memorysynchronizer_tb/DUT/APBState
add wave -noupdate -divider Locals
add wave -noupdate /memorysynchronizer_tb/DUT/line__160/ResetTimerCounter
add wave -noupdate /memorysynchronizer_tb/DUT/line__160/ResyncTimerCounter
add wave -noupdate /memorysynchronizer_tb/DUT/line__160/WaitingTimerCounter
add wave -noupdate /memorysynchronizer_tb/DUT/line__160/NumberOfPendingResyncRequest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12660000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 72
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
configure wave -timelineunits us
update
WaveRestoreZoom {19755101 ps} {20012890 ps}