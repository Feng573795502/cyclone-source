transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/09_ad7606/prj/ip {H:/FPGA/cyclone source/09_ad7606/prj/ip/short_to_float.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/09_ad7606/prj/../testbench {H:/FPGA/cyclone source/09_ad7606/prj/../testbench/ad7606_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  ad7606_tb

add wave *
view structure
view signals
run -all
