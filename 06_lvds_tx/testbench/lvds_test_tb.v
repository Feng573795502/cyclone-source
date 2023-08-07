`timescale 1ns / 1ns
`define CLK_PERIOD 100

module lvds_test_tb();

reg clk;
reg [7:0]tx_in;
wire tx_outclock;

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
	
	.rx_data_align(1),
	.rx_in(lvds_data),
	.rx_inclock(rx_inclock),
	.rx_locked(rx_locked),
	.rx_data(rx_data),
	.rx_outclock(rx_outclock)
	);

	initial clk = 1;
	always #(`CLK_PERIOD/2) clk = ~clk;
	
	initial begin
	
	tx_in = 8'hf1;
	#`CLK_PERIOD;
	tx_in = 8'h22;
	
	#2000;
	
	$stop;
	
	end
	

endmodule
