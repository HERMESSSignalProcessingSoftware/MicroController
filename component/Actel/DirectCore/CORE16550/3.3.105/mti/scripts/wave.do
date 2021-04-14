onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /Core16550_usertb/INTR
add wave -noupdate -format Literal /Core16550_usertb/PADDR
add wave -noupdate -format Logic /Core16550_usertb/PCLK
add wave -noupdate -format Logic /Core16550_usertb/PENABLE
add wave -noupdate -format Literal /Core16550_usertb/PRDATA
add wave -noupdate -format Logic /Core16550_usertb/PRESETN
add wave -noupdate -format Logic /Core16550_usertb/PSEL
add wave -noupdate -format Literal /Core16550_usertb/PWDATA
add wave -noupdate -format Logic /Core16550_usertb/PWRITE
add wave -noupdate -format Logic /Core16550_usertb/RXFIFO_EMPTY
add wave -noupdate -format Logic /Core16550_usertb/RXFIFO_FULL
add wave -noupdate -format Logic /Core16550_usertb/RXRDYN
add wave -noupdate -format Logic /Core16550_usertb/TXRDYN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81250000 ps} 0}
configure wave -namecolwidth 354
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {1823688288 ps} {1824753248 ps}
