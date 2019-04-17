onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK_50 /top_testbench/CLOCK_50
add wave -noupdate -label nreset {/top_testbench/KEY[0]}
add wave -noupdate -label HEX0 /top_testbench/HEX0
add wave -noupdate -label HEX1 /top_testbench/HEX1
add wave -noupdate -label HEX2 /top_testbench/HEX2
add wave -noupdate -label HEX3 /top_testbench/HEX3
add wave -noupdate -label HEX4 /top_testbench/HEX4
add wave -noupdate -label HEX5 /top_testbench/HEX5
add wave -noupdate -label SW /top_testbench/SW
add wave -noupdate -label r_d -radix hexadecimal /top_testbench/dut/r_d
add wave -noupdate -label r_s -radix unsigned /top_testbench/dut/r_s
add wave -noupdate -label we /top_testbench/dut/we
add wave -noupdate -label w_s -radix unsigned /top_testbench/dut/w_s
add wave -noupdate -label w_d -radix hexadecimal /top_testbench/dut/w_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26743 ps} 0}
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
WaveRestoreZoom {23491 ps} {31491 ps}
