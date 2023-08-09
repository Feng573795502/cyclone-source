//altlvds_rx BUFFER_IMPLEMENTATION="RAM" CBX_SINGLE_OUTPUT_FILE="ON" clk_src_is_pll="off" COMMON_RX_TX_PLL="OFF" DATA_RATE=""640.0 Mbps"" DESERIALIZATION_FACTOR=8 ENABLE_DPA_CALIBRATION="ON" ENABLE_DPA_MODE="OFF" ENABLE_SOFT_CDR_MODE="OFF" IMPLEMENT_IN_LES="ON" INCLOCK_BOOST=0 INCLOCK_PERIOD=100000 INCLOCK_PHASE_SHIFT=8334 INPUT_DATA_RATE=640 INTENDED_DEVICE_FAMILY=""Cyclone IV E"" LPM_TYPE="altlvds_rx" NUMBER_OF_CHANNELS=1 PLL_SELF_RESET_ON_LOSS_LOCK="OFF" PORT_RX_CHANNEL_DATA_ALIGN="PORT_UNUSED" PORT_RX_DATA_ALIGN="PORT_USED" REGISTERED_OUTPUT="ON" SIM_DPA_OUTPUT_CLOCK_PHASE_SHIFT=0 USE_CORECLOCK_INPUT="OFF" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" X_ON_BITSLIP="ON" rx_data_align rx_in rx_inclock rx_locked rx_out rx_outclock
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



//synthesis_resources = altlvds_rx 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mggv42
	( 
	rx_data_align,
	rx_in,
	rx_inclock,
	rx_locked,
	rx_out,
	rx_outclock) /* synthesis synthesis_clearbox=1 */;
	input   rx_data_align;
	input   [0:0]  rx_in;
	input   rx_inclock;
	output   rx_locked;
	output   [7:0]  rx_out;
	output   rx_outclock;

	wire  wire_mgl_prim1_rx_locked;
	wire  [7:0]   wire_mgl_prim1_rx_out;
	wire  wire_mgl_prim1_rx_outclock;

	altlvds_rx   mgl_prim1
	( 
	.rx_data_align(rx_data_align),
	.rx_in(rx_in),
	.rx_inclock(rx_inclock),
	.rx_locked(wire_mgl_prim1_rx_locked),
	.rx_out(wire_mgl_prim1_rx_out),
	.rx_outclock(wire_mgl_prim1_rx_outclock));
	defparam
		mgl_prim1.buffer_implementation = "RAM",
		mgl_prim1.clk_src_is_pll = "off",
		mgl_prim1.common_rx_tx_pll = "OFF",
		mgl_prim1.data_rate = ""640.0 Mbps"",
		mgl_prim1.deserialization_factor = 8,
		mgl_prim1.enable_dpa_calibration = "ON",
		mgl_prim1.enable_dpa_mode = "OFF",
		mgl_prim1.enable_soft_cdr_mode = "OFF",
		mgl_prim1.implement_in_les = "ON",
		mgl_prim1.inclock_boost = 0,
		mgl_prim1.inclock_period = 100000,
		mgl_prim1.inclock_phase_shift = 8334,
		mgl_prim1.input_data_rate = 640,
		mgl_prim1.intended_device_family = ""Cyclone IV E"",
		mgl_prim1.lpm_type = "altlvds_rx",
		mgl_prim1.number_of_channels = 1,
		mgl_prim1.pll_self_reset_on_loss_lock = "OFF",
		mgl_prim1.port_rx_channel_data_align = "PORT_UNUSED",
		mgl_prim1.port_rx_data_align = "PORT_USED",
		mgl_prim1.registered_output = "ON",
		mgl_prim1.sim_dpa_output_clock_phase_shift = 0,
		mgl_prim1.use_coreclock_input = "OFF",
		mgl_prim1.use_external_pll = "OFF",
		mgl_prim1.use_no_phase_shift = "ON",
		mgl_prim1.x_on_bitslip = "ON";
	assign
		rx_locked = wire_mgl_prim1_rx_locked,
		rx_out = wire_mgl_prim1_rx_out,
		rx_outclock = wire_mgl_prim1_rx_outclock;
endmodule //mggv42
//VALID FILE
