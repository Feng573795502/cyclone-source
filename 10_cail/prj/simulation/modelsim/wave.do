onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cail_param_control_tb/clk
add wave -noupdate /cail_param_control_tb/rst_n
add wave -noupdate /cail_param_control_tb/wr_req
add wave -noupdate /cail_param_control_tb/rd_req
add wave -noupdate -radix unsigned /cail_param_control_tb/wr_addr
add wave -noupdate -radix unsigned /cail_param_control_tb/rd_addr
add wave -noupdate -radix unsigned /cail_param_control_tb/wr_data
add wave -noupdate -radix unsigned /cail_param_control_tb/rd_data
add wave -noupdate /cail_param_control_tb/iic_clk
add wave -noupdate /cail_param_control_tb/iic_sda
add wave -noupdate -radix unsigned /cail_param_control_tb/cail_param_control/rd_req_dly
add wave -noupdate -radix unsigned /cail_param_control_tb/cail_param_control/rd_addr_dly
add wave -noupdate -radix unsigned /cail_param_control_tb/cail_param_control/ram_r_addr
add wave -noupdate -radix unsigned /cail_param_control_tb/cail_param_control/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000497989 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 362
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1000384004 ps} {1000747670 ps}
