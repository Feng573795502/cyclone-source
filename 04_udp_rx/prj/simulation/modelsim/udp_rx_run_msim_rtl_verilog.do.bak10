transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/04_udp_rx/rtl {H:/FPGA/cyclone source/04_udp_rx/rtl/ip_checksum.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/04_udp_rx/rtl {H:/FPGA/cyclone source/04_udp_rx/rtl/crc32_d8.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/04_udp_rx/rtl {H:/FPGA/cyclone source/04_udp_rx/rtl/eth_udp_rx_gmii.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/04_udp_rx/prj/../testbench {H:/FPGA/cyclone source/04_udp_rx/prj/../testbench/eth_udp_rx_gmii_tb.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/04_udp_rx/prj/../testbench {H:/FPGA/cyclone source/04_udp_rx/prj/../testbench/eth_udp_tx_gmii.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  eth_udp_rx_gmii_tb

add wave *
view structure
view signals
run -all
