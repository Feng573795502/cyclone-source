`timescale 1ns / 1ns
`define CLK_PERIOD 20

module ad7606_tb();

reg clk;
reg rst_n;
reg busy;
reg rdreq;
reg [15:0]data_in;

wire conv;
wire ad_clk;
wire [15:0]ad_data;
wire [5:0]rdusedw;

wire [31:0]result;
reg [15:0]dataa;

//ad7606 ad7606(
//	.clk(clk),
//	.rst_n(rst_n),
//	
//	.busy(busy),
//	.rdreq(rdreq),
//	.data_in(data_in),
//	.conv(conv),
//	
//	.clk_adc(ad_clk),
//	
//	.ad_data(ad_data),
//	.rdusedw(rdusedw)
//);

short_to_float short_to_float(
	.clock(clk),
	.dataa(dataa),
	.result(result)
);


initial clk = 1;
always #(`CLK_PERIOD/2) clk = ~ clk;

initial begin

	rst_n = 0;
	rdreq = 0;
	#100;
	rst_n = 1;
	dataa = 16'd125;
	#10;
	dataa = 16'd120;
	#1000;
	#1000;
	$stop;

end 


endmodule