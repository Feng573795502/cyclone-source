`timescale 1ns / 1ns
`define CLK_PERIOD 20

module ad7606_tb();

reg clk;
reg rst_n;
reg busy;


wire conv;
wire ad_clk;
wire rd_en;

ad7606 ad7606(
	.clk(clk),
	.rst_n(rst_n),
	
	.busy(busy),
	.conv(conv),
	
	.ad_clk(ad_clk),
	
	.rd_en(rd_en),
	.ad_data()
);

initial clk = 1;
always #(`CLK_PERIOD/2) clk = ~ clk;

initial begin

	rst_n = 0;
	#100;
	rst_n = 1;
	
	#1000;
	
	$stop;

end 


endmodule