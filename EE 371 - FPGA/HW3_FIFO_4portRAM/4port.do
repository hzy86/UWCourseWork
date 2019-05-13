onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/clk
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/wr_en
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/reset
add wave -noupdate /RAM32x8_4port_testbench/startCyc
add wave -noupdate -radix decimal /RAM32x8_4port_testbench/i
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/r_d1
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/r_d2
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/r_d3
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/r_s1
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/r_s2
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/r_s3
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/w_d
add wave -noupdate -radix hexadecimal /RAM32x8_4port_testbench/dut/RAM
add wave -noupdate /RAM32x8_4port_testbench/dut/ps
add wave -noupdate /RAM32x8_4port_testbench/dut/ns
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/dut/count
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/dut/rs1
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/dut/rs2
add wave -noupdate -radix unsigned /RAM32x8_4port_testbench/dut/rs3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {850 ps} 0}
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
