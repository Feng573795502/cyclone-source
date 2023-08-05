module lvds_test(
	input  clk,  //10Mhz
	input  [7:0]tx_in,
	output [7:0]rx_data,
	
	input rx_in
	);
	
	wire tx_out;
	wire rx_outclock;
	wire tx_outclock;
	
	wire rx_inclock = ~tx_outclock;
	
//	lvds_tx lvds_tx(
//		.tx_in(tx_in),
//		.tx_inclock(clk),
//		.tx_out(tx_out),
//		.tx_outclock(tx_outclock)
//		);
//
//	lvds_rx lvds_rx(
//		.rx_in(rx_in),
//		.rx_inclock(rx_inclock),
//		.rx_out(rx_data),
//		.rx_outclock(rx_outclock)
//		);


//	input	[0:0]  rx_in;
//	input	  rx_inclock;
//	output	[7:0]  rx_out;
//	output	  rx_outclock;
endmodule