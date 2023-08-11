transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {low_trans_test.vo}

vlog -vlog01compat -work work +incdir+H:/FPGA/low_trans_test/simulation/modelsim {H:/FPGA/low_trans_test/simulation/modelsim/lvds_ip_test_vlg_tst.v}

vsim -t 1ps -L altera_ver -L cyclone10lp_ver -L gate_work -L work -voptargs="+acc"  lvds_ip_test_vlg_tst

add wave *
view structure
view signals
run -all
