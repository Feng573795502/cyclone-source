`timescale 1ns / 1ns
`define CLK_PERIOD 20

	module ad_control_top_tb();
	
	reg clk;
	reg rst_n;
	
	reg [15:0]data_in;
	
	wire clk_adc;
	wire conv;
	wire valid;
	
	wire [31:0]result;
	
	ad_control_top ad_control_top(
	.clk(clk),
	.rst_n(rst_n),
	
	.data_in(data_in),
	
	.busy(),
	.clk_adc(clk_adc),
	.conv(conv),
	
	.valid(valid),
	.result(result)
);

initial clk = 0;
always #(`CLK_PERIOD/2) clk = ~clk;

initial begin
	rst_n = 0;
	data_in = 16'd1;
	#100;
	rst_n = 1;
	data_in = 16'd2;
	
	#2000;
	

	$stop;
end

endmodule
