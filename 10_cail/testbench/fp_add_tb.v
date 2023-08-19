`timescale 1ns/1ns
`define CLK_PERIOD 20

module fp_add_tb();

reg clk;
reg rst_n;

reg [32:0]data;
reg       valid;

reg go;

calibration_top calibration_top
(
	.clk(clk),
	.rst_n(rst_n),
	
	.data(data),
	.valid(valid),
	
	.go(go)
);
	
	initial clk = 1;
	always #(`CLK_PERIOD/2) clk = ~clk;
	
	
	initial begin
	rst_n = 0;
	data  = 32'h40000000;
	valid = 0;
	go    = 0;
	
	#200;
	rst_n = 1;
	valid = 1;
	
	#320;
	valid = 0;
	#2000;
	$stop;
	end
	
endmodule