onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lvds_test_tb/clk
add wave -noupdate -radix hexadecimal /lvds_test_tb/tx_in
add wave -noupdate /lvds_test_tb/tx_locked
add wave -noupdate /lvds_test_tb/rx_data_align
add wave -noupdate -radix hexadecimal /lvds_test_tb/rx_data
add wave -noupdate /lvds_test_tb/rx_locked
add wave -noupdate /lvds_test_tb/lvds_data
add wave -noupdate /lvds_test_tb/tx_coreclock
add wave -noupdate /lvds_test_tb/tx_outclock
add wave -noupdate /lvds_test_tb/rx_inclock
add wave -noupdate /lvds_test_tb/rx_outclock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {803360 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3374112 ps}
