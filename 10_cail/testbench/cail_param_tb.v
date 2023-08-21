`timescale 1ns/1ns


module cail_param_tb();


	reg	clock;
	reg	[7:0]  data;
	reg	[4:0]  rdaddress;
	reg	[4:0]  wraddress;
	reg	wren;
	wire	[7:0]  q;
	
cail_param cail_param(
	.clock(clock),
	.data(data),
	.rdaddress(rdaddress),
	.wraddress(wraddress),
	.wren(wren),
	.q(q));

	initial clock = 1;
	always #10 clock = ~clock;
	
	initial begin
	
		wren = 0;
		#200;
		rdaddress = 4'd0;
		wraddress = 4'd0;
		data = 8'h11;
		wren = 1;
		#20;
		data = 8'h22;
		wraddress = 4'd1;
		rdaddress = 4'd1;
		#20;
		data = 8'h33;
		wraddress = 4'd2;
		rdaddress = 4'd2;
		#20
		data = 8'h44;
		wraddress = 4'd3;
		rdaddress = 4'd3;
		#20
		wren = 0;
		#2000;
		rdaddress = 4'd0;
		#20;
		rdaddress = 4'd1;
		#20;
		rdaddress = 4'd2;
		#20
		rdaddress = 4'd3;
		#20
		#2000;
		$stop;
	end
	
	endmodule