onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/CLOCK_50
add wave -noupdate -label hw_reset -radix decimal {/DE1_SoC_testbench/dut/SW[9]}
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/reset
add wave -noupdate /DE1_SoC_testbench/dut/color
add wave -noupdate -label pixel_write_en -radix decimal {/DE1_SoC_testbench/dut/SW[0]}
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/x0
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/x1
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/y0
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/y1
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/x
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/y
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/ani/clk
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/ani/reset
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/ani/ps
add wave -noupdate -radix decimal /DE1_SoC_testbench/dut/ani/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1420 ps} 0}
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
WaveRestoreZoom {0 ps} {6374 ps}
