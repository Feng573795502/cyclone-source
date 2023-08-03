transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/02_pll/prj/ip {H:/FPGA/cyclone source/02_pll/prj/ip/pll.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/02_pll/prj/db {H:/FPGA/cyclone source/02_pll/prj/db/pll_altpll.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/02_pll/prj/../testbench {H:/FPGA/cyclone source/02_pll/prj/../testbench/pll_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  pll_tb

add wave *
view structure
view signals
run -all
