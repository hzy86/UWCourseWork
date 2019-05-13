onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /binary_search_testbench/clk
add wave -noupdate -radix hexadecimal /binary_search_testbench/reset
add wave -noupdate -radix hexadecimal /binary_search_testbench/found
add wave -noupdate -radix hexadecimal /binary_search_testbench/start
add wave -noupdate -radix hexadecimal /binary_search_testbench/dut/A
add wave -noupdate -radix unsigned /binary_search_testbench/dut/result_addr
add wave -noupdate /binary_search_testbench/dut/found
add wave -noupdate -radix unsigned /binary_search_testbench/dut/high
add wave -noupdate -radix unsigned /binary_search_testbench/dut/low
add wave -noupdate -radix unsigned /binary_search_testbench/dut/mid
add wave -noupdate -radix hexadecimal /binary_search_testbench/dut/mid_val
add wave -noupdate /binary_search_testbench/dut/ns
add wave -noupdate /binary_search_testbench/dut/ps
add wave -noupdate -radix hexadecimal /binary_search_testbench/dut/ram/RAM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {415 ps} 0}
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
WaveRestoreZoom {1350 ps} {9350 ps}
