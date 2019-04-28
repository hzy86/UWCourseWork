onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /line_drawer_testbench/clk
add wave -noupdate -radix decimal /line_drawer_testbench/reset
add wave -noupdate -radix decimal /line_drawer_testbench/x0
add wave -noupdate -radix decimal /line_drawer_testbench/y0
add wave -noupdate -radix decimal /line_drawer_testbench/x1
add wave -noupdate -radix decimal /line_drawer_testbench/y1
add wave -noupdate -radix decimal /line_drawer_testbench/xout
add wave -noupdate -radix decimal /line_drawer_testbench/yout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21058 ps} 0}
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
WaveRestoreZoom {0 ps} {16736 ps}
