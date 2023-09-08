transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/eeprom {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/eeprom/iic_ctrl.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/eeprom {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/eeprom/iic_bit_shift.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/eeprom {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/eeprom/cail_param_control.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/adc {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/adc/ad_control_top.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/adc {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/adc/ad_cail.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl/adc {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/adc/ad7606.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/ip {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/ip/ad_fifo.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/ip {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/ip/short_to_float.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/ip {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/ip/mult.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/ip {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/ip/data_fifo.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/ip {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/ip/float_sub.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/cail_param.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/rtl {H:/FPGA/cyclone source/12_ad7606+eeprom/rtl/analyzer.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/12_ad7606+eeprom/prj/../testbench {H:/FPGA/cyclone source/12_ad7606+eeprom/prj/../testbench/analyzer_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  analyzer_tb

add wave *
view structure
view signals
run -all
