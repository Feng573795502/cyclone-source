transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/ip {H:/FPGA/cyclone source/07_lvds_extern/prj/ip/lvds_tx.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj {H:/FPGA/cyclone source/07_lvds_extern/prj/lvds_pll.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/rtl {H:/FPGA/cyclone source/07_lvds_extern/rtl/lvds_external_pll.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/ip {H:/FPGA/cyclone source/07_lvds_extern/prj/ip/lvds_rx.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/db {H:/FPGA/cyclone source/07_lvds_extern/prj/db/lvds_pll_altpll.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/db {H:/FPGA/cyclone source/07_lvds_extern/prj/db/lvds_tx_lvds_tx.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/db {H:/FPGA/cyclone source/07_lvds_extern/prj/db/lvds_rx_lvds_rx.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/07_lvds_extern/prj/../testbench {H:/FPGA/cyclone source/07_lvds_extern/prj/../testbench/lvds_test_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lvds_test_tb

add wave *
view structure
view signals
run -all
