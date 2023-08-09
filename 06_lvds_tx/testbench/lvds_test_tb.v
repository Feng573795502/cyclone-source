`timescale 1ns / 1ns
`define CLK_PERIOD 100

module lvds_test_tb();

reg clk;
reg [7:0]tx_in;
wire tx_outclock;
wire tx_done;
wire lvds_data;
wire tx_coreclock;
wire tx_locked;
wire rx_inclock = tx_outclock;

reg rx_data_align;

wire [7:0]rx_data;
wire rx_locked;


lvds_test lvds_test(
	.clk(clk),  //10Mhz
	.tx_in(tx_in),
	.tx_out(lvds_data),
	.tx_outclock(tx_outclock),
	.tx_coreclock(tx_coreclock),
	.tx_locked(tx_locked),
	.tx_done(tx_done),
	
	.rx_data_align(rx_data_align),
	.rx_in(lvds_data),
	.rx_inclock(rx_inclock),
	.rx_locked(rx_locked),
	.rx_data(rx_data),
	.rx_outclock(rx_outclock)
	);

	initial clk = 1;
	always #(`CLK_PERIOD/2) clk = ~clk;
	
	initial begin
	rx_data_align = 0;
	#2000;
	rx_data_align = 1;
	tx_in = 8'hf1;
	#200;
	tx_in = 8'h22;
	#200;
	tx_in = 8'hf1;
	#200;
	tx_in = 8'h22;
	#200;
	tx_in = 8'hf1;
	#200;
	tx_in = 8'h22;
	#200;
	tx_in = 8'hf1;
	#200;
	tx_in = 8'h22;
	#2000;
	
	$stop;
	
	end
	

endmodule
