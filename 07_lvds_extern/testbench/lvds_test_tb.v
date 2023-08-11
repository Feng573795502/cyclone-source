`timescale 1ns / 1ns
`define CLK_PERIOD 20
`define CLK_50PERIOD 20
module lvds_test_tb();

reg  clk;
wire lvds_data;
wire tx_inclock;
wire tx_outclk;
reg  rx_data_align;
reg  rx_inclock;
wire rx_locked;
wire rx_outclock;
wire clk_locked;

reg [7:0]data_in;
wire [7:0]rx_out;

lvds_external_pll lvds_external_pll(
	.clk(clk),
	.lvds_txp(lvds_data),
	.lvds_rxp(lvds_data),
	.tx_inclock(tx_inclock),
	.tx_outclk(tx_outclk),
	.rx_data_align(rx_data_align),
	.rx_inclock(rx_inclock),
	.rx_locked(rx_locked),
	.rx_outclock(rx_outclock),
	.clk_locked(clk_locked),
	.data_in(data_in),
	.rx_out(rx_out)
);

initial clk = 1;
always #(`CLK_50PERIOD/2)clk = ~clk;
always @(*)rx_inclock = tx_outclk;

initial begin

	data_in = 8'b0;
	rx_data_align = 0;

	@(posedge clk_locked)
	rx_data_align = 1;
	#205;

	data_in = 8'h01;
	#100;
	data_in = 8'h11;

	#100;
	data_in = 8'h22;

	#100;
	data_in = 8'h44;

	#100;
	data_in = 8'h55;
	#100;
	data_in = 8'h66;
	#100;
	data_in = 8'h77;
	#2000;

	$stop;

end

endmodule