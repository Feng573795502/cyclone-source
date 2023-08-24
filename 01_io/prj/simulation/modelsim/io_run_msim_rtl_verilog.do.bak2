transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/01_io/rtl {H:/FPGA/cyclone source/01_io/rtl/io.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/01_io/prj/../testbench {H:/FPGA/cyclone source/01_io/prj/../testbench/io_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  io_tb

add wave *
view structure
view signals
run -all
