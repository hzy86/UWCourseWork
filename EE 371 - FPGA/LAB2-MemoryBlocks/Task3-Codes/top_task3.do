onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/top_testbench/KEY[0]}
add wave -noupdate /top_testbench/SW
add wave -noupdate /top_testbench/HEX0
add wave -noupdate /top_testbench/HEX2
add wave -noupdate /top_testbench/HEX4
add wave -noupdate /top_testbench/HEX5
add wave -noupdate -label data_out -radix decimal /top_testbench/dut/dout
add wave -noupdate -label data_in -radix decimal /top_testbench/dut/din
add wave -noupdate -label addr -radix decimal /top_testbench/dut/addr
add wave -noupdate -label ram /top_testbench/dut/ram/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {126 ps}
