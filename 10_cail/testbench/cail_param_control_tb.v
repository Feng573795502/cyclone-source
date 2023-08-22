`timescale 1ns/1ns
module cail_param_control_tb();

reg clk;
reg rst_n;

reg wr_req;
reg rd_req;
reg [3:0]ch;
reg [1:0]type;
reg mult;
reg [31:0]in_data;
wire [31:0]result;
wire  iic_clk;
wire  iic_sda;

cail_param_control cail_param_control(
	.clk(clk),
	.rst_n(rst_n),
	
	.wr_req(wr_req),
	.rd_req(rd_req),
	
	.ch(ch),
	.type(type),
	.mult(mult),
	
	.in_data(in_data),
	.result(result),
		
	.iic_clk(iic_clk),
	.iic_sda(iic_sda)
);
	
	



pullup PUP(iic_sda);
	
initial clk = 1;
always #10 clk = ~clk;

initial begin
	rst_n = 0;
	wr_req = 0;
	rd_req = 0;
	
	ch = 0;
	type = 0;
	mult = 1;
	#200;
	rst_n = 1;
	
	in_data = 32'h11223344;
	#100;
	wr_req = 1;
	#20;
	wr_req = 0;
	
	
	rd_req = 1;
	#20;
	rd_req = 0;
	#20;
	in_data = 32'h55667788;
	wr_req = 1;
	#20;
	rd_req = 1;
	#20;
	wr_req = 0;
	#20;
	rd_req = 0;
	#5000000;
	#5000000;
	$stop;
	
	
end


endmodule
