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
	
	.wr_req(),
	.rd_req(),
	
	.wr_addr(),
	.rd_addr(),
		
	.iic_clk(iic_clk),
	.iic_sda(iic_sda)
);
defparam cail_param_control.RST_TIME = 29;
pullup PUP(iic_sda);
	
initial clk = 1;
always #10 clk = ~clk;

initial begin
	rst_n = 0;
	wr_req = 0;
	rd_req = 0;

	#200;
	rst_n = 1;
	#5000000;
	#5000000;
	$stop;
	
	
end


endmodule
