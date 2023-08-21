`timescale 1ns/1ns
module cail_param_control_tb();

reg clk;
reg rst_n;

reg wr_req;
reg rd_req;
reg [3:0]ch;
reg [1:0]type;

reg [31:0]in_data;
wire [31:0]result;


cail_param_control cail_param_control(
	.clk(clk),
	.rst_n(rst_n),
	
	.wr_req(wr_req),
	.rd_req(rd_req),
	
	.ch(ch),
	.type(type),
	
	.in_data(in_data),
	.result(result)
);

initial clk = 1;
always #10 clk = ~clk;

initial begin
	rst_n = 0;
	wr_req = 0;
	rd_req = 0;
	
	ch = 0;
	type = 0;
	
	#200;
	
	in_data = 32'h11223344;
	#100;
	wr_req = 1;
	#5000;
	
	$stop;
	
	
end


endmodule
