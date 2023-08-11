transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/lvds_ip_auto_align.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/data_repeat_align.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/data_tranmit_auto_align .v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/lvds_align.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/data_receive.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/decode.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/encode.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/clk_pll.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/iserdes.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test {H:/FPGA/low_trans_test/oserdes.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test/db {H:/FPGA/low_trans_test/db/clk_pll_altpll2.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test/db {H:/FPGA/low_trans_test/db/oserdes_lvds_tx1.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test/db {H:/FPGA/low_trans_test/db/iserdes_lvds_rx1.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test/simulation/modelsim {H:/FPGA/low_trans_test/simulation/modelsim/lvds_ip_test_vlg_tst.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver -L rtl_work -L work -voptargs="+acc"  lvds_ip_test_vlg_tst

add wave *
view structure
view signals
run -all
