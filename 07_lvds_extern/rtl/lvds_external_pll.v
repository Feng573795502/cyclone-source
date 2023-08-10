module lvds_external_pll(
	input clk,
	output lvds_txp,
	input  lvds_rxp,
	output lvds_slow_clk,
	output lvds_fast_clk,
	output clk_locked,
	input [7:0]data_in,
	output [7:0]rx_out
	
);

wire tx_inclock;
wire tx_syncclock;

lvds_pll lvds_pll(
	.inclk0(clk),         // 50M 
	.c0(lvds_fast_clk),   // 300M 
	.c1(lvds_slow_clk),   // 75M
	.locked(clk_locked)
);

lvds_tx lvds_tx(
	.tx_in(data_in),
	.tx_inclock(lvds_fast_clk),
	.tx_syncclock(lvds_slow_clk),
	.tx_out(lvds_txp)
	);

lvds_rx lvds_rx(
	.rx_data_align(1),
	.rx_in(lvds_rxp),
	.rx_inclock(lvds_fast_clk),
	.rx_out(rx_out)
	);
	
endmodule
