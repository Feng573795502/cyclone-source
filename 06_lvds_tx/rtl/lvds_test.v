module lvds_test(
	input  clk,  //10Mhz
	input  [7:0]tx_in,
	output [7:0]rx_data
//	output tx_outclock,
//	output rx_outclock
	);
	
	wire tx_out;
	wire rx_outclock;
	wire tx_outclock;
	lvds_tx lvds_tx(
		.tx_in(tx_in),
		.tx_inclock(clk),
		.tx_out(tx_out),
		.tx_outclock(tx_outclock)
		);

	lvds_rx lvds_rx(
		.rx_in(tx_out)
//		.rx_inclock(tx_outclock),
//		.rx_out(rx_data),
//		.rx_outclock(rx_outclock)
		);
//			rx_in,
//	rx_inclock,
//	rx_out,
//	rx_outclock);

	input	[0:0]  rx_in;
	input	  rx_inclock;
	output	[7:0]  rx_out;
	output	  rx_outclock;
endmodule