`timescale 1ns/1ps
`define CLK_PERIOD 20

module myscfifo_tb;

reg clk;
reg [15:0]data;
reg rdreq;
reg sclr;
reg wrreq;

//线查看
wire almost_empty;
wire almost_full;
wire empty;
wire full;
wire [15:0]q;
wire [7:0]usedw;

myscfifo fifo(
	.clock(clk),
	.data(data),
	.rdreq(rdreq),
	.sclr(sclr),
	.wrreq(wrreq),
	.almost_empty(almost_empty),
	.almost_full(almost_full),
	.empty(empty),
	.full(full),
	.q(q),
	.usedw(usedw)
	);
	initial clk = 1;
	always #(`CLK_PERIOD/2)clk = ~clk;
integer i;

initial begin
		wrreq = 0;
		data = 0;
		rdreq = 0;
		sclr = 0;
		
		#(`CLK_PERIOD*20 + 1);
		for (i=0;i <= 255 ;i = i + 1)begin //=
			wrreq = 1;
			data = i;
			#`CLK_PERIOD;
		end
		wrreq = 0;
		#(`CLK_PERIOD*20);
		for (i=0;i <= 255 ;i = i + 1)begin
			rdreq = 1;
			#`CLK_PERIOD;
		end	
		rdreq = 0;
		$stop;		
	end
		
endmodule