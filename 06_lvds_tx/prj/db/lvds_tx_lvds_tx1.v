//altlvds_tx CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" COMMON_RX_TX_PLL="OFF" CORECLOCK_DIVIDE_BY=2 DATA_RATE="80.0 Mbps" DESERIALIZATION_FACTOR=8 DEVICE_FAMILY="Cyclone IV E" DIFFERENTIAL_DRIVE=0 ENABLE_CLK_LATENCY="OFF" IMPLEMENT_IN_LES="ON" INCLOCK_BOOST=0 INCLOCK_DATA_ALIGNMENT="EDGE_ALIGNED" INCLOCK_PERIOD=100000 INCLOCK_PHASE_SHIFT=0 MULTI_CLOCK="OFF" NUMBER_OF_CHANNELS=1 OUTCLOCK_ALIGNMENT="EDGE_ALIGNED" OUTCLOCK_DIVIDE_BY=4 OUTCLOCK_DUTY_CYCLE=50 OUTCLOCK_MULTIPLY_BY=1 OUTCLOCK_PHASE_SHIFT=0 OUTCLOCK_RESOURCE="AUTO" OUTPUT_DATA_RATE=80 PLL_COMPENSATION_MODE="AUTO" PLL_SELF_RESET_ON_LOSS_LOCK="OFF" PREEMPHASIS_SETTING=0 REGISTERED_INPUT="TX_CORECLK" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" VOD_SETTING=0 tx_coreclock tx_in tx_inclock tx_locked tx_out tx_outclock CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48
//VERSION_BEGIN 18.1 cbx_altaccumulate 2018:09:12:13:04:24:SJ cbx_altclkbuf 2018:09:12:13:04:24:SJ cbx_altddio_in 2018:09:12:13:04:24:SJ cbx_altddio_out 2018:09:12:13:04:24:SJ cbx_altera_syncram_nd_impl 2018:09:12:13:04:24:SJ cbx_altiobuf_bidir 2018:09:12:13:04:24:SJ cbx_altiobuf_in 2018:09:12:13:04:24:SJ cbx_altiobuf_out 2018:09:12:13:04:24:SJ cbx_altlvds_tx 2018:09:12:13:04:24:SJ cbx_altpll 2018:09:12:13:04:24:SJ cbx_altsyncram 2018:09:12:13:04:24:SJ cbx_arriav 2018:09:12:13:04:23:SJ cbx_cyclone 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_counter 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_lpm_mux 2018:09:12:13:04:24:SJ cbx_lpm_shiftreg 2018:09:12:13:04:24:SJ cbx_maxii 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END
//CBXI_INSTANCE_NAME="lvds_test_lvds_tx_lvds_tx_altlvds_tx_ALTLVDS_TX_component"
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




//altddio_out CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" DEVICE_FAMILY="Cyclone IV E" WIDTH=1 datain_h datain_l dataout outclock
//VERSION_BEGIN 18.1 cbx_altddio_out 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_maxii 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END

//synthesis_resources = IO 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"ANALYZE_METASTABILITY=OFF;ADV_NETLIST_OPT_ALLOWED=DEFAULT"} *)
module  lvds_tx_lvds_tx1_lvds_tx_ddio_out
	( 
	datain_h,
	datain_l,
	dataout,
	outclock) /* synthesis synthesis_clearbox=1 */;
	input   [0:0]  datain_h;
	input   [0:0]  datain_l;
	output   [0:0]  dataout;
	input   outclock;

	wire  [0:0]   wire_ddio_outa_dataout;

	cycloneive_ddio_out   ddio_outa_0
	( 
	.clkhi(outclock),
	.clklo(outclock),
	.datainhi(datain_h),
	.datainlo(datain_l),
	.dataout(wire_ddio_outa_dataout[0:0]),
	.muxsel(outclock)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		ddio_outa_0.async_mode = "none",
		ddio_outa_0.power_up = "low",
		ddio_outa_0.sync_mode = "none",
		ddio_outa_0.use_new_clocking_model = "true",
		ddio_outa_0.lpm_type = "cycloneive_ddio_out";
	assign
		dataout = wire_ddio_outa_dataout;
endmodule //lvds_tx_lvds_tx1_lvds_tx_ddio_out


//lpm_compare CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" DEVICE_FAMILY="Cyclone IV E" LPM_WIDTH=2 aeb dataa datab
//VERSION_BEGIN 18.1 cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  lvds_tx_lvds_tx1_lvds_tx_cmpr
	( 
	aeb,
	dataa,
	datab) /* synthesis synthesis_clearbox=1 */;
	output   aeb;
	input   [1:0]  dataa;
	input   [1:0]  datab;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [1:0]  dataa;
	tri0   [1:0]  datab;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [0:0]  aeb_result_wire;
	wire  [0:0]  aneb_result_wire;
	wire  [3:0]  data_wire;
	wire  eq_wire;

	assign
		aeb = eq_wire,
		aeb_result_wire = (~ aneb_result_wire),
		aneb_result_wire = ((data_wire[0] ^ data_wire[1]) | (data_wire[2] ^ data_wire[3])),
		data_wire = {datab[1], dataa[1], datab[0], dataa[0]},
		eq_wire = aeb_result_wire;
endmodule //lvds_tx_lvds_tx1_lvds_tx_cmpr


//lpm_compare CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" DEVICE_FAMILY="Cyclone IV E" LPM_WIDTH=2 dataa datab
//VERSION_BEGIN 18.1 cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ  VERSION_END


//lpm_counter CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" DEVICE_FAMILY="Cyclone IV E" lpm_modulus=4 lpm_width=2 clock q updown
//VERSION_BEGIN 18.1 cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_counter 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ  VERSION_END

//synthesis_resources = lut 2 reg 2 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  lvds_tx_lvds_tx1_lvds_tx_cntr
	( 
	clock,
	q,
	updown) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	output   [1:0]  q;
	input   updown;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1   updown;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [0:0]   wire_counter_comb_bita_0combout;
	wire  [0:0]   wire_counter_comb_bita_1combout;
	wire  [0:0]   wire_counter_comb_bita_0cout;
	wire	[1:0]	wire_counter_reg_bit_d;
	wire	[1:0]	wire_counter_reg_bit_asdata;
	reg	[1:0]	counter_reg_bit;
	wire	[1:0]	wire_counter_reg_bit_ena;
	wire	[1:0]	wire_counter_reg_bit_sload;
	wire  aclr_actual;
	wire clk_en;
	wire cnt_en;
	wire [1:0]  data;
	wire  external_cin;
	wire  [1:0]  s_val;
	wire  [1:0]  safe_q;
	wire sclr;
	wire sload;
	wire sset;
	wire  updown_dir;

	cycloneive_lcell_comb   counter_comb_bita_0
	( 
	.cin(external_cin),
	.combout(wire_counter_comb_bita_0combout[0:0]),
	.cout(wire_counter_comb_bita_0cout[0:0]),
	.dataa(counter_reg_bit[0]),
	.datab(updown_dir),
	.datad(1'b1),
	.datac(1'b0)
	);
	defparam
		counter_comb_bita_0.lut_mask = 16'h5A90,
		counter_comb_bita_0.sum_lutc_input = "cin",
		counter_comb_bita_0.lpm_type = "cycloneive_lcell_comb";
	cycloneive_lcell_comb   counter_comb_bita_1
	( 
	.cin(wire_counter_comb_bita_0cout[0:0]),
	.combout(wire_counter_comb_bita_1combout[0:0]),
	.cout(),
	.dataa(counter_reg_bit[1]),
	.datab(updown_dir),
	.datad(1'b1),
	.datac(1'b0)
	);
	defparam
		counter_comb_bita_1.lut_mask = 16'h5A90,
		counter_comb_bita_1.sum_lutc_input = "cin",
		counter_comb_bita_1.lpm_type = "cycloneive_lcell_comb";
	// synopsys translate_off
	initial
		counter_reg_bit[0:0] = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr_actual)
		if (aclr_actual == 1'b1) counter_reg_bit[0:0] <= 1'b0;
		else if  (wire_counter_reg_bit_ena[0:0] == 1'b1) 
			if (wire_counter_reg_bit_sload[0:0] == 1'b1) counter_reg_bit[0:0] <= wire_counter_reg_bit_asdata[0:0];
			else  counter_reg_bit[0:0] <= wire_counter_reg_bit_d[0:0];
	// synopsys translate_off
	initial
		counter_reg_bit[1:1] = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr_actual)
		if (aclr_actual == 1'b1) counter_reg_bit[1:1] <= 1'b0;
		else if  (wire_counter_reg_bit_ena[1:1] == 1'b1) 
			if (wire_counter_reg_bit_sload[1:1] == 1'b1) counter_reg_bit[1:1] <= wire_counter_reg_bit_asdata[1:1];
			else  counter_reg_bit[1:1] <= wire_counter_reg_bit_d[1:1];
	assign
		wire_counter_reg_bit_asdata = ({2{(~ sclr)}} & (({2{sset}} & s_val) | ({2{(~ sset)}} & data))),
		wire_counter_reg_bit_d = {wire_counter_comb_bita_1combout[0:0], wire_counter_comb_bita_0combout[0:0]};
	assign
		wire_counter_reg_bit_ena = {2{(clk_en & (((sclr | sset) | sload) | cnt_en))}},
		wire_counter_reg_bit_sload = {2{((sclr | sset) | sload)}};
	assign
		aclr_actual = 1'b0,
		clk_en = 1'b1,
		cnt_en = 1'b1,
		data = {2{1'b0}},
		external_cin = 1'b1,
		q = safe_q,
		s_val = {2{1'b1}},
		safe_q = counter_reg_bit,
		sclr = 1'b0,
		sload = 1'b0,
		sset = 1'b0,
		updown_dir = updown;
endmodule //lvds_tx_lvds_tx1_lvds_tx_cntr


//lpm_shiftreg CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" LPM_DIRECTION="RIGHT" LPM_WIDTH=8 clock data load shiftin shiftout
//VERSION_BEGIN 18.1 cbx_lpm_shiftreg 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = reg 8 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  lvds_tx_lvds_tx1_lvds_tx_shift_reg
	( 
	clock,
	data,
	load,
	shiftin,
	shiftout) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	input   [7:0]  data;
	input   load;
	input   shiftin;
	output   shiftout;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [7:0]  data;
	tri0   load;
	tri1   shiftin;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg	[7:0]	shift_reg;
	wire  [7:0]  shift_node;

	// synopsys translate_off
	initial
		shift_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock)
		
			if (load == 1'b1) shift_reg <= data;
			else  shift_reg <= shift_node;
	assign
		shift_node = {shiftin, shift_reg[7:1]},
		shiftout = shift_reg[0];
endmodule //lvds_tx_lvds_tx1_lvds_tx_shift_reg


//lpm_shiftreg CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" LPM_DIRECTION="RIGHT" LPM_WIDTH=4 clock data load shiftin shiftout
//VERSION_BEGIN 18.1 cbx_lpm_shiftreg 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ  VERSION_END

//synthesis_resources = reg 4 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  lvds_tx_lvds_tx1_lvds_tx_shift_reg1
	( 
	clock,
	data,
	load,
	shiftin,
	shiftout) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	input   [3:0]  data;
	input   load;
	input   shiftin;
	output   shiftout;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [3:0]  data;
	tri0   load;
	tri1   shiftin;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg	[3:0]	shift_reg;
	wire  [3:0]  shift_node;

	// synopsys translate_off
	initial
		shift_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock)
		
			if (load == 1'b1) shift_reg <= data;
			else  shift_reg <= shift_node;
	assign
		shift_node = {shiftin, shift_reg[3:1]},
		shiftout = shift_reg[0];
endmodule //lvds_tx_lvds_tx1_lvds_tx_shift_reg1

//synthesis_resources = cycloneive_pll 1 IO 2 lut 4 reg 56 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"{-to lvds_tx_pll} AUTO_MERGE_PLLS=OFF"} *)
module  lvds_tx_lvds_tx1
	( 
	tx_coreclock,
	tx_in,
	tx_inclock,
	tx_locked,
	tx_out,
	tx_outclock) /* synthesis synthesis_clearbox=1 */;
	output   tx_coreclock;
	input   [7:0]  tx_in;
	input   tx_inclock;
	output   tx_locked;
	output   [0:0]  tx_out;
	output   tx_outclock;

	wire  [0:0]   wire_ddio_out_dataout;
	wire  [0:0]   wire_outclock_ddio_dataout;
	reg	dffe11;
	reg	[1:0]	dffe14a;
	reg	[1:0]	dffe15a;
	reg	[1:0]	dffe16a;
	reg	[1:0]	dffe17a;
	reg	[1:0]	dffe18a;
	reg	[1:0]	dffe19a;
	reg	dffe22;
	reg	[1:0]	dffe3a;
	reg	[1:0]	dffe4a;
	reg	[1:0]	dffe5a;
	reg	[1:0]	dffe6a;
	reg	[1:0]	dffe7a;
	reg	[1:0]	dffe8a;
	reg	sync_dffe12a;
	reg	sync_dffe1a;
	reg	[7:0]	tx_reg;
	wire  wire_cmpr10_aeb;
	wire  wire_cmpr20_aeb;
	wire  wire_cmpr9_aeb;
	wire  [1:0]   wire_cntr13_q;
	wire  [1:0]   wire_cntr2_q;
	wire  wire_outclk_shift_shiftout;
	wire  wire_shift_reg23_shiftout;
	wire  wire_shift_reg24_shiftout;
	wire  [4:0]   wire_lvds_tx_pll_clk;
	wire  wire_lvds_tx_pll_fbout;
	wire  wire_lvds_tx_pll_locked;
	wire  fast_clock;
	wire  [0:0]  h_input;
	wire  [0:0]  l_input;
	wire  load_signal;
	wire  out_clock;
	wire  outclk_load_signal;
	wire  slow_clock;
	wire  [7:0]  tx_in_wire;

	lvds_tx_lvds_tx1_lvds_tx_ddio_out   ddio_out
	( 
	.datain_h(l_input),
	.datain_l(h_input),
	.dataout(wire_ddio_out_dataout),
	.outclock(fast_clock));
	lvds_tx_lvds_tx1_lvds_tx_ddio_out   outclock_ddio
	( 
	.datain_h(wire_outclk_shift_shiftout),
	.datain_l(wire_outclk_shift_shiftout),
	.dataout(wire_outclock_ddio_dataout),
	.outclock(out_clock));
	// synopsys translate_off
	initial
		dffe11 = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		  dffe11 <= ((wire_cmpr9_aeb & sync_dffe1a) | (wire_cmpr10_aeb & (~ sync_dffe1a)));
	// synopsys translate_off
	initial
		dffe14a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b1)   dffe14a <= wire_cntr13_q;
	// synopsys translate_off
	initial
		dffe15a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b0)   dffe15a <= wire_cntr13_q;
	// synopsys translate_off
	initial
		dffe16a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b1)   dffe16a <= dffe14a;
	// synopsys translate_off
	initial
		dffe17a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b0)   dffe17a <= dffe15a;
	// synopsys translate_off
	initial
		dffe18a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b0)   dffe18a <= dffe16a;
	// synopsys translate_off
	initial
		dffe19a = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		if (sync_dffe12a == 1'b1)   dffe19a <= dffe17a;
	// synopsys translate_off
	initial
		dffe22 = 0;
	// synopsys translate_on
	always @ ( posedge out_clock)
		  dffe22 <= (wire_cmpr20_aeb & sync_dffe12a);
	// synopsys translate_off
	initial
		dffe3a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b1)   dffe3a <= wire_cntr2_q;
	// synopsys translate_off
	initial
		dffe4a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b0)   dffe4a <= wire_cntr2_q;
	// synopsys translate_off
	initial
		dffe5a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b1)   dffe5a <= dffe3a;
	// synopsys translate_off
	initial
		dffe6a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b0)   dffe6a <= dffe4a;
	// synopsys translate_off
	initial
		dffe7a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b0)   dffe7a <= dffe5a;
	// synopsys translate_off
	initial
		dffe8a = 0;
	// synopsys translate_on
	always @ ( posedge fast_clock)
		if (sync_dffe1a == 1'b1)   dffe8a <= dffe6a;
	// synopsys translate_off
	initial
		sync_dffe12a = 0;
	// synopsys translate_on
	always @ ( posedge slow_clock)
		  sync_dffe12a <= (~ sync_dffe12a);
	// synopsys translate_off
	initial
		sync_dffe1a = 0;
	// synopsys translate_on
	always @ ( posedge slow_clock)
		  sync_dffe1a <= (~ sync_dffe1a);
	// synopsys translate_off
	initial
		tx_reg = 0;
	// synopsys translate_on
	always @ ( posedge slow_clock)
		  tx_reg <= tx_in;
	lvds_tx_lvds_tx1_lvds_tx_cmpr   cmpr10
	( 
	.aeb(wire_cmpr10_aeb),
	.dataa(dffe4a),
	.datab(dffe8a));
	lvds_tx_lvds_tx1_lvds_tx_cmpr   cmpr20
	( 
	.aeb(wire_cmpr20_aeb),
	.dataa(dffe14a),
	.datab(dffe18a));
	lvds_tx_lvds_tx1_lvds_tx_cmpr   cmpr9
	( 
	.aeb(wire_cmpr9_aeb),
	.dataa(dffe3a),
	.datab(dffe7a));
	lvds_tx_lvds_tx1_lvds_tx_cntr   cntr13
	( 
	.clock(out_clock),
	.q(wire_cntr13_q),
	.updown(sync_dffe12a));
	lvds_tx_lvds_tx1_lvds_tx_cntr   cntr2
	( 
	.clock(fast_clock),
	.q(wire_cntr2_q),
	.updown(sync_dffe1a));
	lvds_tx_lvds_tx1_lvds_tx_shift_reg   outclk_shift
	( 
	.clock(out_clock),
	.data(8'b00110011),
	.load(outclk_load_signal),
	.shiftin(1'b0),
	.shiftout(wire_outclk_shift_shiftout));
	lvds_tx_lvds_tx1_lvds_tx_shift_reg1   shift_reg23
	( 
	.clock(fast_clock),
	.data({tx_in_wire[1], tx_in_wire[3], tx_in_wire[5], tx_in_wire[7]}),
	.load(load_signal),
	.shiftin(1'b0),
	.shiftout(wire_shift_reg23_shiftout));
	lvds_tx_lvds_tx1_lvds_tx_shift_reg1   shift_reg24
	( 
	.clock(fast_clock),
	.data({tx_in_wire[0], tx_in_wire[2], tx_in_wire[4], tx_in_wire[6]}),
	.load(load_signal),
	.shiftin(1'b0),
	.shiftout(wire_shift_reg24_shiftout));
	cycloneive_pll   lvds_tx_pll
	( 
	.activeclock(),
	.clk(wire_lvds_tx_pll_clk),
	.clkbad(),
	.fbin(wire_lvds_tx_pll_fbout),
	.fbout(wire_lvds_tx_pll_fbout),
	.inclk({1'b0, tx_inclock}),
	.locked(wire_lvds_tx_pll_locked),
	.phasedone(),
	.scandataout(),
	.scandone(),
	.vcooverrange(),
	.vcounderrange()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkswitch(1'b0),
	.configupdate(1'b0),
	.pfdena(1'b1),
	.phasecounterselect({3{1'b0}}),
	.phasestep(1'b0),
	.phaseupdown(1'b0),
	.scanclk(1'b0),
	.scanclkena(1'b1),
	.scandata(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		lvds_tx_pll.clk0_divide_by = 1,
		lvds_tx_pll.clk0_multiply_by = 4,
		lvds_tx_pll.clk0_phase_shift = "-6250",
		lvds_tx_pll.clk1_divide_by = 8,
		lvds_tx_pll.clk1_multiply_by = 8,
		lvds_tx_pll.clk1_phase_shift = "-6250",
		lvds_tx_pll.inclk0_input_frequency = 100000,
		lvds_tx_pll.operation_mode = "normal",
		lvds_tx_pll.self_reset_on_loss_lock = "off",
		lvds_tx_pll.lpm_type = "cycloneive_pll";
	assign
		fast_clock = wire_lvds_tx_pll_clk[0],
		h_input = {wire_shift_reg24_shiftout},
		l_input = {wire_shift_reg23_shiftout},
		load_signal = dffe11,
		out_clock = wire_lvds_tx_pll_clk[0],
		outclk_load_signal = dffe22,
		slow_clock = wire_lvds_tx_pll_clk[1],
		tx_coreclock = slow_clock,
		tx_in_wire = tx_reg,
		tx_locked = wire_lvds_tx_pll_locked,
		tx_out = wire_ddio_out_dataout,
		tx_outclock = wire_outclock_ddio_dataout;
endmodule //lvds_tx_lvds_tx1
//VALID FILE
