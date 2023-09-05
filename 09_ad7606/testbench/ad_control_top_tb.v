`timescale 1ns / 1ns
`define CLK_PERIOD 20

	module ad_control_top_tb();
	
	reg clk;
	reg rst_n;
	
	reg [15:0]data_in;
	
	wire clk_adc;
	wire conv;
	
	wire [31:0]result;
	wire [8:0]usedw;
	reg read_data;
	
	wire ad_reset;
	wire ad_rd;
	wire [2:0]ad_os;
	
	ad_control_top ad_control_top(
	.clk(clk),
	.rst_n(rst_n),
	
	.data_in(data_in),
	
	.busy(),
	.clk_adc(clk_adc),
	.conv(conv),
	
	.ad_reset(ad_reset),
	.ad_rd(ad_rd),
	.ad_os(ad_os)
);

initial clk = 0;
always #(`CLK_PERIOD/2) clk = ~clk;


initial begin
	rst_n = 0;
	read_data = 0;
	data_in = 16'd1;
	#100;
	rst_n = 1;
	#500;
	data_in = 16'd2;#40;
	data_in = 16'd3;#40;
	data_in = 16'd4;#40;
	data_in = 16'd5;#40;
	data_in = 16'd6;#40;
	data_in = 16'd7;#40;
	data_in = 16'd8;#40;
	data_in = 16'd9;#40;
	#40;
	#2010;
	read_data = 1;
	#160;
	read_data = 0;
	#200;
	$stop;
end

endmodule
