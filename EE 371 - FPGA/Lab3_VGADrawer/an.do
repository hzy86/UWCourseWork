onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /animation_testbench/clk
add wave -noupdate -label reset /animation_testbench/reset
add wave -noupdate -label x0 -radix decimal -radixshowbase 0 /animation_testbench/x0
add wave -noupdate -label y0 -radix decimal -radixshowbase 0 /animation_testbench/y0
add wave -noupdate -label x1 -radix decimal -radixshowbase 0 /animation_testbench/x1
add wave -noupdate -label y1 -radix decimal -radixshowbase 0 /animation_testbench/y1
add wave -noupdate -label ps /animation_testbench/dut/ps
add wave -noupdate -label ns /animation_testbench/dut/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {32 ns}
