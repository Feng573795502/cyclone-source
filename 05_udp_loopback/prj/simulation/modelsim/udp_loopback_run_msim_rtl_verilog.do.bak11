transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/rgmii_to_gmii {H:/FPGA/cyclone source/05_udp_loopback/rtl/rgmii_to_gmii/rgmii_to_gmii.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/gmii_to_rgmii {H:/FPGA/cyclone source/05_udp_loopback/rtl/gmii_to_rgmii/gmii_to_rgmii.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/check {H:/FPGA/cyclone source/05_udp_loopback/rtl/check/ip_checksum.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/check {H:/FPGA/cyclone source/05_udp_loopback/rtl/check/crc32_d8.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl {H:/FPGA/cyclone source/05_udp_loopback/rtl/eth_udp_tx_gmii.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl {H:/FPGA/cyclone source/05_udp_loopback/rtl/eth_udp_rx_gmii.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl {H:/FPGA/cyclone source/05_udp_loopback/rtl/udp_loopback.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/prj/ip {H:/FPGA/cyclone source/05_udp_loopback/prj/ip/eth_dcfifo.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/prj/ip {H:/FPGA/cyclone source/05_udp_loopback/prj/ip/pll_rx.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/mdio {H:/FPGA/cyclone source/05_udp_loopback/rtl/mdio/mdio_bit_shift.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/rtl/mdio {H:/FPGA/cyclone source/05_udp_loopback/rtl/mdio/phy_config.v}
vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/prj/db {H:/FPGA/cyclone source/05_udp_loopback/prj/db/pll_rx_altpll.v}

vlog -vlog01compat -work work +incdir+H:/FPGA/cyclone\ source/05_udp_loopback/prj/../testbench {H:/FPGA/cyclone source/05_udp_loopback/prj/../testbench/phy_config_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  phy_config_tb

add wave *
view structure
view signals
run -all
