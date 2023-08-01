`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 16:05:13
// Design Name: 
// Module Name: gmii_to_rgmii
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ps / 1 ps

module ddio_out_x4 (
	datain_h,
	datain_l,
	outclock,
	dataout);

	input	[3:0]  datain_h;
	input	[3:0]  datain_l;
	input	  outclock;
	output	[3:0]  dataout;

	wire [3:0] sub_wire0;
	wire [3:0] dataout = sub_wire0[3:0];

	altddio_out	ALTDDIO_OUT_component (
				.datain_h (datain_h),
				.datain_l (datain_l),
				.outclock (outclock),
				.dataout (sub_wire0),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component.invert_output = "OFF",
		ALTDDIO_OUT_component.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component.lpm_type = "altddio_out",
		ALTDDIO_OUT_component.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component.power_up_high = "OFF",
		ALTDDIO_OUT_component.width = 4;

endmodule

module ddio_out_x1 (
	datain_h,
	datain_l,
	outclock,
	dataout);

	input	[0:0]  datain_h;
	input	[0:0]  datain_l;
	input	  outclock;
	output	[0:0]  dataout;

	wire [0:0] sub_wire0;
	wire [0:0] dataout = sub_wire0[0:0];

	altddio_out	ALTDDIO_OUT_component (
				.datain_h (datain_h),
				.datain_l (datain_l),
				.outclock (outclock),
				.dataout (sub_wire0),
				.aclr (1'b0),
				.aset (1'b0),
				.oe (1'b1),
				.oe_out (),
				.outclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_OUT_component.extend_oe_disable = "OFF",
		ALTDDIO_OUT_component.invert_output = "OFF",
		ALTDDIO_OUT_component.lpm_hint = "UNUSED",
		ALTDDIO_OUT_component.lpm_type = "altddio_out",
		ALTDDIO_OUT_component.oe_reg = "UNREGISTERED",
		ALTDDIO_OUT_component.power_up_high = "OFF",
		ALTDDIO_OUT_component.width = 1;

endmodule

module gmii_to_rgmii(
    input              gmii_tx_clk , //GMII发送时钟
    input              gmii_tx_en  , //GMII发送数据使能信号
    input       [7:0]  gmii_tx_data, //GMII发送数据
    output             rgmii_tx_clk, //RGMII发送时钟
    output             rgmii_tx_en, //RGMII发送数据控制信号
    output      [3:0]  rgmii_tx_data //RGMII发送数据  
    );
    
	 ddio_out_x4 ddio_out_x4(
		.datain_h(gmii_tx_data[3:0]),
		.datain_l(gmii_tx_data[7:4]),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_tx_data)
	 );
//	 
	wire gmii_tx_err;
	assign gmii_tx_err = 1'b0;//不产生发送错误信号
	
	ddio_out_x1 ddio_out_ctl(
		.datain_h(gmii_tx_en),
		.datain_l(gmii_tx_en ^ gmii_tx_err),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_tx_en)
	);
	
	ddio_out_x1 ddio_out_clk(
		.datain_h(1'b1),
		.datain_l(1'b0),
		.outclock(gmii_tx_clk),
		.dataout(rgmii_tx_clk)
	);
	
endmodule
