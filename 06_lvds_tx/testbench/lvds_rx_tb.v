`timescale 1ns / 1ns
`define    CLK_PERILOD 100
module lvds_rx_tb();
	
	reg clk;
	reg rx_in;
	wire [0:0]rx_outclock;
	
	wire [7:0]rx_data;

	lvds_rx lvds_rx(
		.rx_in(rx_in),
		.rx_inclock(clk),
		.rx_out(rx_data),
		.rx_outclock(rx_outclock)
		);

	initial clk = 1;
	always #(`CLK_PERILOD / 2) clk = ~clk;
	
	
	initial begin
	#2000;
	
	$stop;
	end
	
	endmodule