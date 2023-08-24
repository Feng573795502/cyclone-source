`timescale 1ns/1ns

module io_tb();

reg clk;
reg rst_n;

reg in;
wire out;

io io(
	.clk(clk),
	.rst_n(rst_n),
	
	.in(in),
	.out(out)
);

initial clk = 1;
always #10 clk = ~clk;


initial begin
	rst_n = 0;
	#20;
	rst_n = 1;
	in = 1;
	#20;
	in = 0;
	#20;
	in = 1;
	#2000;
	$stop;

end
endmodule