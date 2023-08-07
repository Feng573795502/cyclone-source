module lvds_test(
	input  clk,  //10Mhz
	input  [7:0]tx_in,
	output [0:0]tx_out,
	output tx_outclock,
	output tx_coreclock,
	output tx_locked,
	
	input rx_data_align,
	input rx_in,
	input rx_inclock,
	output rx_locked,
	output [7:0]rx_data,
	output rx_outclock
	);

lvds_tx lvds_tx(
		.tx_in(tx_in),
		.tx_inclock(clk),
		.tx_out(tx_out),
		.tx_outclock(tx_outclock),
		.tx_coreclock(tx_coreclock),
		.tx_locked(tx_locked)
		);
		
	lvds_rx lvds_rx(
		.rx_data_align(rx_data_align),
		.rx_in(rx_in),
		.rx_inclock(rx_inclock),
		.rx_locked(rx_locked),
		.rx_out(rx_data),
		.rx_outclock(rx_outclock)
		);

endmodule