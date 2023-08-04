`timescale 1ns / 1ns
`define    CLK_PERILOD 100
module lvds_tx_tb();
	
	reg clk;
	reg [7:0]tx_in;
	wire [0:0]tx_out;
	wire [0:0]tx_outclock;
	wire [0:0]rx_outclock;
	
	wire [7:0]rx_data;
	
	lvds_tx lvds_tx(
		.tx_in(tx_in),
		.tx_inclock(clk),
		.tx_out(tx_out),
		.tx_outclock(tx_outclock)
		);

	lvds_rx lvds_rx(
		.rx_in(tx_out),
		.rx_inclock(tx_outclock),
		.rx_out(rx_data),
		.rx_outclock(rx_outclock)
		);

	initial clk = 1;
	always #(`CLK_PERILOD / 2) clk = ~clk;
	
	
	initial begin
	tx_in = 8'h11;
	#2000;
	tx_in = 16'hff;
	
	$stop;
	end
	
	endmodule
	