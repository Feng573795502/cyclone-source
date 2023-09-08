`timescale 1ns/1ns
module cail_param_control_tb();

reg  clk;
reg  rst_n;

reg  wr_req;
reg  rd_req;
reg  [9:0]wr_addr;
reg  [9:0]rd_addr;
reg  [7:0]wr_data;
wire [7:0]rd_data;
reg  update_req;
wire init_done;
wire  iic_clk;
wire  iic_sda;

cail_param_control cail_param_control(
	.clk(clk),
	.rst_n(rst_n),
	
	.wr_req(wr_req),
	.rd_req(rd_req),
	.update_req(update_req),
	.init_done(init_done),
	.wr_addr(wr_addr),
	.rd_addr(rd_addr),
	.wr_data(wr_data),
	.rd_data(rd_data),
	.iic_clk(iic_clk),
	.iic_sda(iic_sda)
);

defparam cail_param_control.RST_TIME = 18'd250000;
pullup PUP(iic_sda);
	
initial clk = 1;
always #10 clk = ~clk;

initial begin
	rst_n = 0;
	wr_req = 0;
	rd_req = 0;
	update_req = 0;
	#200;
	rst_n = 1;
	#200;
	rd_req  <= 1;
	rd_addr <= 0;
	#20;
	rd_addr <= 1;
	#20;
	rd_addr <= 2;
	#20;
	rd_addr <= 3;
	#20;
	rd_addr <= 4;
	#20;
	rd_addr <= 5;
	#20;
	rd_addr <= 6;
	#20;
	rd_req <= 0;
	
	#2000;
	wr_req <= 1;
	wr_addr <= 0;
	wr_data <= 1;
	#20;
	wr_addr <= 1;
	wr_data <= 2;
	#20;
	wr_addr <= 2;
	wr_data <= 3;
	#20;
	wr_addr <= 3;
	wr_data <= 4;
	#20;
	wr_addr <= 4;
	wr_data <= 5;
	#20;
	wr_addr <= 5;
	wr_data <= 6;
	#20;
	wr_addr <= 6;
	wr_data <= 7;
	#20;
	#20;
	#20;
	wr_req <= 0;
	
	
	#2000;
	rd_req  <= 1;
	rd_addr <= 0;
	#20;
	rd_addr <= 1;
	#20;
	rd_addr <= 2;
	#20;
	rd_addr <= 3;
	#20;
	rd_addr <= 4;
	#20;
	rd_addr <= 5;
	#20;
	rd_addr <= 6;
	#20;
	rd_req <= 0;
	
	#2000;
	update_req <= 1;
	#20;
	update_req <= 0;
	#2000;
	
	#5000000;
	$stop;
	
	
end

	M24LC04B M24LC04B(
		.A0(1'b0), 
		.A1(1'b0), 
		.A2(1'b0), 
		.WP(1'b0), 
		.SDA(iic_sda), 
		.SCL(iic_clk), 
		.RESET(~rst_n)
	);

endmodule
