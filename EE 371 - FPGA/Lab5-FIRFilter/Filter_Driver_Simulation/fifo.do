onerror {resume}
quietly virtual function -install /fifo_testbench -env /fifo_testbench/#INITIAL#47 { &{/fifo_testbench/wr, /fifo_testbench/rd }} wr_rd
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /fifo_testbench/clk
add wave -noupdate -radix hexadecimal /fifo_testbench/reset
add wave -noupdate -radix hexadecimal /fifo_testbench/empty
add wave -noupdate -radix hexadecimal /fifo_testbench/full
add wave -noupdate /fifo_testbench/wr_rd
add wave -noupdate /fifo_testbench/dut/f_unit/r_addr
add wave -noupdate -radix hexadecimal /fifo_testbench/r_data
add wave -noupdate /fifo_testbench/dut/f_unit/w_addr
add wave -noupdate -radix hexadecimal /fifo_testbench/w_data
add wave -noupdate /fifo_testbench/dut/f_unit/array_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {15496 ps}
