onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label a -radix binary -childformat {{{/sign_mag_add_testbench/a[3]} -radix decimal} {{/sign_mag_add_testbench/a[2]} -radix decimal} {{/sign_mag_add_testbench/a[1]} -radix decimal} {{/sign_mag_add_testbench/a[0]} -radix decimal}} -expand -subitemconfig {{/sign_mag_add_testbench/a[3]} {-radix decimal} {/sign_mag_add_testbench/a[2]} {-radix decimal} {/sign_mag_add_testbench/a[1]} {-radix decimal} {/sign_mag_add_testbench/a[0]} {-radix decimal}} /sign_mag_add_testbench/a
add wave -noupdate -label b -radix binary -childformat {{{/sign_mag_add_testbench/b[3]} -radix decimal} {{/sign_mag_add_testbench/b[2]} -radix decimal} {{/sign_mag_add_testbench/b[1]} -radix decimal} {{/sign_mag_add_testbench/b[0]} -radix decimal}} -expand -subitemconfig {{/sign_mag_add_testbench/b[3]} {-radix decimal} {/sign_mag_add_testbench/b[2]} {-radix decimal} {/sign_mag_add_testbench/b[1]} {-radix decimal} {/sign_mag_add_testbench/b[0]} {-radix decimal}} /sign_mag_add_testbench/b
add wave -noupdate -label sum -radix binary -childformat {{{/sign_mag_add_testbench/sum[3]} -radix decimal} {{/sign_mag_add_testbench/sum[2]} -radix decimal} {{/sign_mag_add_testbench/sum[1]} -radix decimal} {{/sign_mag_add_testbench/sum[0]} -radix decimal}} -expand -subitemconfig {{/sign_mag_add_testbench/sum[3]} {-radix decimal} {/sign_mag_add_testbench/sum[2]} {-radix decimal} {/sign_mag_add_testbench/sum[1]} {-radix decimal} {/sign_mag_add_testbench/sum[0]} {-radix decimal}} /sign_mag_add_testbench/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {64 ns}
