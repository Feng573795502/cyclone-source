//altlvds_tx CBX_SINGLE_OUTPUT_FILE="ON" clk_src_is_pll="off" COMMON_RX_TX_PLL="OFF" CORECLOCK_DIVIDE_BY=2 DATA_RATE=""800.0 Mbps"" DESERIALIZATION_FACTOR=2 DIFFERENTIAL_DRIVE=0 IMPLEMENT_IN_LES="ON" INCLOCK_BOOST=0 INCLOCK_PERIOD=100000 INCLOCK_PHASE_SHIFT=0 INTENDED_DEVICE_FAMILY=""Cyclone IV E"" LPM_TYPE="altlvds_tx" NUMBER_OF_CHANNELS=1 OUTCLOCK_DIVIDE_BY=1 OUTCLOCK_DUTY_CYCLE=50 OUTCLOCK_MULTIPLY_BY=1 OUTCLOCK_PHASE_SHIFT=0 OUTCLOCK_RESOURCE="AUTO" OUTPUT_DATA_RATE=800 PLL_COMPENSATION_MODE="AUTO" PREEMPHASIS_SETTING=0 REGISTERED_INPUT="OFF" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" VOD_SETTING=0 tx_in tx_inclock tx_out tx_outclock
//VERSION_BEGIN 18.1 cbx_mgl 2018:09:12:13:10:36:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2018  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.



//synthesis_resources = altlvds_tx 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgfds1
	( 
	tx_in,
	tx_inclock,
	tx_out,
	tx_outclock) /* synthesis synthesis_clearbox=1 */;
	input   [1:0]  tx_in;
	input   tx_inclock;
	output   [0:0]  tx_out;
	output   tx_outclock;

	wire  [0:0]   wire_mgl_prim1_tx_out;
	wire  wire_mgl_prim1_tx_outclock;

	altlvds_tx   mgl_prim1
	( 
	.tx_in(tx_in),
	.tx_inclock(tx_inclock),
	.tx_out(wire_mgl_prim1_tx_out),
	.tx_outclock(wire_mgl_prim1_tx_outclock));
	defparam
		mgl_prim1.clk_src_is_pll = "off",
		mgl_prim1.common_rx_tx_pll = "OFF",
		mgl_prim1.coreclock_divide_by = 2,
		mgl_prim1.data_rate = ""800.0 Mbps"",
		mgl_prim1.deserialization_factor = 2,
		mgl_prim1.differential_drive = 0,
		mgl_prim1.implement_in_les = "ON",
		mgl_prim1.inclock_boost = 0,
		mgl_prim1.inclock_period = 100000,
		mgl_prim1.inclock_phase_shift = 0,
		mgl_prim1.intended_device_family = ""Cyclone IV E"",
		mgl_prim1.lpm_type = "altlvds_tx",
		mgl_prim1.number_of_channels = 1,
		mgl_prim1.outclock_divide_by = 1,
		mgl_prim1.outclock_duty_cycle = 50,
		mgl_prim1.outclock_multiply_by = 1,
		mgl_prim1.outclock_phase_shift = 0,
		mgl_prim1.outclock_resource = "AUTO",
		mgl_prim1.output_data_rate = 800,
		mgl_prim1.preemphasis_setting = 0,
		mgl_prim1.registered_input = "OFF",
		mgl_prim1.use_external_pll = "OFF",
		mgl_prim1.use_no_phase_shift = "ON",
		mgl_prim1.vod_setting = 0,
		mgl_prim1.lpm_hint = "PLL_COMPENSATION_MODE=AUTO";
	assign
		tx_out = wire_mgl_prim1_tx_out,
		tx_outclock = wire_mgl_prim1_tx_outclock;
endmodule //mgfds1
//VALID FILE
