onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /bit_counter_testbench/clk
add wave -noupdate -radix unsigned /bit_counter_testbench/reset
add wave -noupdate -radix unsigned /bit_counter_testbench/s
add wave -noupdate -radix unsigned /bit_counter_testbench/num
add wave -noupdate -radix unsigned /bit_counter_testbench/result
add wave -noupdate -radix unsigned /bit_counter_testbench/dut/A
add wave -noupdate -radix unsigned /bit_counter_testbench/dut/ps
add wave -noupdate -radix unsigned /bit_counter_testbench/dut/ns
add wave -noupdate -radix unsigned /bit_counter_testbench/dut/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29475 ps} 0}
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
WaveRestoreZoom {0 ps} {66910 ps}
