transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/06_lvds_tx/prj/ip {H:/FPGA/cyclone source/06_lvds_tx/prj/ip/lvds_tx.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/06_lvds_tx/prj/db {H:/FPGA/cyclone source/06_lvds_tx/prj/db/lvds_tx_lvds_tx.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/06_lvds_tx/prj/../testbench {H:/FPGA/cyclone source/06_lvds_tx/prj/../testbench/lvds_tx_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lvds_tx_tb

add wave *
view structure
view signals
run -all
