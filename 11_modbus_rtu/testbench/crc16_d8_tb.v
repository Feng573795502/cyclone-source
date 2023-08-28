`timescale 1ns/1ns
`define CLK_PERIOD 20

module crc16_d8_tb();

reg clk;
reg rst_n;

reg [7:0]data;
reg crc_init;
reg crc_en;
wire [15:0]crc_result;

crc16_d8 crc16_d8(
		.clk(clk),
		.rst_n(rst_n),
		
		.data(data),
		.crc_init(crc_init),
		.crc_en(crc_en),
		
		.crc_result(crc_result)
	);
	
	initial clk = 1;
	always#(`CLK_PERIOD/2)clk = ~clk;
	
	initial begin
	rst_n = 0;
	data = 8'd0;
	crc_init = 0;
	crc_en = 0;
	
	#(`CLK_PERIOD * 20 + 1);
	rst_n = 1'b1;
	#(`CLK_PERIOD*10);
	
	crc_init = 1'b1;
	#(`CLK_PERIOD);
	crc_init = 1'b0;
	
	crc_en = 1'b1;
	
	repeat(5)begin
		data = data + 1;
		#(`CLK_PERIOD);
	end
	
	crc_en = 0;
	#200;
	
	$stop;
	
	end
	
endmodule