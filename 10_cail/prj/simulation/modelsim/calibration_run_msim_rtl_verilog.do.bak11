transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/10_cail/rtl {H:/FPGA/cyclone source/10_cail/rtl/iic_bit_shift.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/10_cail/rtl {H:/FPGA/cyclone source/10_cail/rtl/iic_ctrl.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/10_cail/prj/ip {H:/FPGA/cyclone source/10_cail/prj/ip/cail_param.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/10_cail/rtl {H:/FPGA/cyclone source/10_cail/rtl/cail_param_control.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/10_cail/prj/../testbench {H:/FPGA/cyclone source/10_cail/prj/../testbench/cail_param_control_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  cail_param_control_tb

add wave *
view structure
view signals
run -all
