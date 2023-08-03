`timescale 1ns/1ps
`define clk_period 20

module pll_tb;

reg areset;
reg clk;

wire c0;
wire c1;
wire c2;
wire c3;
wire locked;



pll pll(
	.areset(areset),
	.inclk0(clk),
	.c0(c0),
	.c1(c1),
	.c2(c2),
	.c3(c3),
	.locked(locked));

	initial clk = 1;
	always#(`clk_period/2) clk = ~clk;
	
	initial begin
		areset = 1'b1;
		#(`clk_period * 100 + 1);
		areset = 1'b0;
		#(`clk_period * 200 + 1);
		$stop;
	end

endmodule