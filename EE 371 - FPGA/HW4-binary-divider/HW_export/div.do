onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /divider_testbench/clock
add wave -noupdate -radix unsigned /divider_testbench/s
add wave -noupdate -radix unsigned /divider_testbench/resetn
add wave -noupdate -radix unsigned /divider_testbench/DataA
add wave -noupdate -radix unsigned /divider_testbench/DataB
add wave -noupdate -radix unsigned /divider_testbench/Done
add wave -noupdate -radix unsigned /divider_testbench/EB
add wave -noupdate -radix unsigned /divider_testbench/LA
add wave -noupdate -radix unsigned /divider_testbench/Q
add wave -noupdate -radix unsigned /divider_testbench/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1273 ps} 0}
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
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {8 ns}
