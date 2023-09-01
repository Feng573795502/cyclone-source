transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/11_modbus_rtu/rtl {H:/FPGA/cyclone source/11_modbus_rtu/rtl/crc16_d8.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/11_modbus_rtu/rtl {H:/FPGA/cyclone source/11_modbus_rtu/rtl/mb_rtu_tx.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/11_modbus_rtu/prj {H:/FPGA/cyclone source/11_modbus_rtu/prj/mb_rtu_tx_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  mb_rtu_tx_tb

add wave *
view structure
view signals
run -all
