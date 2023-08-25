onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cail_param_control_tb/clk
add wave -noupdate /cail_param_control_tb/rst_n
add wave -noupdate /cail_param_control_tb/wr_req
add wave -noupdate /cail_param_control_tb/rd_req
add wave -noupdate /cail_param_control_tb/wr_addr
add wave -noupdate /cail_param_control_tb/rd_addr
add wave -noupdate /cail_param_control_tb/wr_data
add wave -noupdate /cail_param_control_tb/rd_data
add wave -noupdate /cail_param_control_tb/update_req
add wave -noupdate /cail_param_control_tb/init_done
add wave -noupdate /cail_param_control_tb/iic_clk
add wave -noupdate /cail_param_control_tb/iic_sda
add wave -noupdate /cail_param_control_tb/cail_param_control/ee_wvalid
add wave -noupdate -radix unsigned /cail_param_control_tb/cail_param_control/iic_ctrl/wr_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1052040000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 405
configure wave -valuecolwidth 216
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
configure wave -timelineunits ns
update
WaveRestoreZoom {933129180 ps} {1446721178 ps}
