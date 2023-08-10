module lvds_recv(
	input data_rxp,
	input rx_inclock,
	
	output rx_locked,
	input  rx_data_align,
	output rx_outclock,
	output [7:0]rx_out,
	
	input  align_done,
	output [7:0]dedata
	
	);
	
	wire kout;
	wire code_err;
	
	
	//lvds接收
	lvds_rx lvds_rx(
		.rx_data_align(rx_data_align),
		.rx_in(data_rxp),
		.rx_inclock(rx_inclock),
		.rx_locked(rx_locked),
		.rx_out(rx_out),
		.rx_outclock(rx_outclock)
	);
	
	//解码实例
	decode decoder(
		.clk(rx_outclock),
		.rst_n(align_done),
		.datain(rx_out),
		.lock_n(1'b0),
		.dataout(dedata),
		.kout(kout),
		.code_err(code_err)
	); 
	
	endmodule