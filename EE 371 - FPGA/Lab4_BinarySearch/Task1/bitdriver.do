onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /driver_testbench/CLOCK_50
add wave -noupdate {/driver_testbench/KEY[0]}
add wave -noupdate {/driver_testbench/SW[9]}
add wave -noupdate -radix unsigned /driver_testbench/dut/bc/result
add wave -noupdate -radix unsigned /driver_testbench/i
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[7]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[6]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[5]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[4]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[3]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[2]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[1]}
add wave -noupdate -expand -group {SW[7:0]} {/driver_testbench/SW[0]}
add wave -noupdate {/driver_testbench/LEDR[9]}
add wave -noupdate /driver_testbench/HEX0
add wave -noupdate /driver_testbench/HEX1
add wave -noupdate /driver_testbench/HEX2
add wave -noupdate /driver_testbench/HEX3
add wave -noupdate /driver_testbench/HEX4
add wave -noupdate /driver_testbench/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15736 ps} 0}
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
WaveRestoreZoom {0 ps} {16 ns}
