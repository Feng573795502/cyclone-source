`timescale 1ns / 1ns
`define CLK_PERIOD 13.3
`define CLK_50PERIOD 20
module lvds_test_tb();

reg  clk;
wire lvds_txp;
wire slow_clk;
wire fast_clk;
wire clk_locked;

reg [7:0]data_in;
wire [7:0]rx_out;

lvds_external_pll lvds_external_pll(
	.clk(clk),
	.lvds_txp(lvds_txp),
	.lvds_rxp(lvds_txp),
	.lvds_slow_clk(slow_clk),
	.lvds_fast_clk(fast_clk),
	.clk_locked(clk_locked),
	.data_in(data_in),
	.rx_out(rx_out)
);
	
initial clk = 1;
always #(`CLK_50PERIOD/2)clk = ~clk;

initial begin

	data_in = 8'b0;

	@(posedge clk_locked)
	#200;
	data_in = 8'h01;
	#`CLK_PERIOD;
	data_in = 8'h11;

	#`CLK_PERIOD;
	data_in = 8'h22;

	#`CLK_PERIOD;
	data_in = 8'h44;

	#`CLK_PERIOD;
	data_in = 8'h55;
	#`CLK_PERIOD;
	data_in = 8'h66;
	#`CLK_PERIOD;
	data_in = 8'h77;
	#200;

	$stop;

end

endmodule