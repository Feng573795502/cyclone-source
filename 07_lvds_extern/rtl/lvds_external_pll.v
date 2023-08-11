module lvds_external_pll(
	input clk,
	output lvds_txp,
	input  lvds_rxp,
	
	output tx_inclock,
	output tx_outclk,
	
	
	input  rx_data_align,
	input  rx_inclock,
	output rx_locked,
	output rx_outclock,
	output clk_locked,
	input [7:0]data_in,
	output [7:0]rx_out
	
);

wire tx_syncclock;

assign tx_outclk = tx_syncclock;

lvds_pll lvds_pll(
	.inclk0(clk),          // 50M 
	.c0(tx_inclock),       // 40M 
	.c1(tx_syncclock),     // 10M
	.locked(clk_locked)
);

lvds_tx lvds_tx(
	.tx_in(data_in),
	.tx_inclock(tx_inclock),      //串行时钟   快速时钟
	.tx_syncclock(tx_syncclock),  //并行时钟线 慢速时钟
	.tx_out(lvds_txp)
	);

lvds_rx lvds_rx(
	.rx_data_align(rx_data_align),
	.rx_in(lvds_rxp),
	.rx_inclock(rx_inclock),
	//.rx_locked(rx_locked),
	.rx_out(rx_out),
	.rx_outclock(rx_outclock)
	);
	
endmodule
