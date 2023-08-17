`timescale 1ns/1ns
`define CLK_PERIOD 20

module ad_data_proc_tb();

reg clk;
reg rst_n;
reg cail_en;
reg [15:0]short_data;
reg [31:0]cail_param;
wire valid;
wire [31:0]result;

data_cail data_cail(
	.clk(clk),
	.rst_n(rst_n),
	
	.cail_en(cail_en),
	.short_data(short_data),
	.data_len(2),
	
	.valid(valid),
	.cail_param(cail_param),
	.result(result)
);
	
	initial clk = 1;
	always #(`CLK_PERIOD/2) clk = ~clk;
	
	initial begin
		rst_n = 0;
		cail_en = 0;
		#200;
		cail_param = 32'h40000000;
		rst_n = 1;
		cail_en = 1;
		short_data = 16'd1;
		#`CLK_PERIOD;
		cail_en = 0;
		short_data = 16'd2;
		#`CLK_PERIOD;
		short_data = 16'd3;
		#`CLK_PERIOD;
		short_data = 16'd4;
		#`CLK_PERIOD;
		short_data = 16'd5;
		#`CLK_PERIOD;
		short_data = 16'd6;
		#`CLK_PERIOD;
		short_data = 16'd7;
		#`CLK_PERIOD;
		short_data = 16'd8;
		#`CLK_PERIOD;
		short_data = 16'd9;
		#10000;
		$stop;
		
	end
	
	endmodule