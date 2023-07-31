`timescale 1ns/1ps
`define wrclk_period 20
`define rdclk_period 10

module mydcfifo_tb;

reg wrclk;
reg rdclk;
reg [15:0]data;
reg rdreq;
reg wrreq;

wire [7:0]q;
wire rdempuy;
wire [8:0]rdusedw;
wire wrfull;
wire [7:0]wrusedw;

mydcfifo fifo(
	.data(data),
	.rdclk(rdclk),
	.rdreq(rdreq),
	.wrclk(wrclk),
	.wrreq(wrreq),
	.q(q),
	.rdempty(rdempuy),
	.rdusedw(rdusedw),
	.wrfull(wrfull),
	.wrusedw(wrusedw)
	);

initial wrclk = 1;
always #(`wrclk_period/2)wrclk = ~wrclk;

initial rdclk = 1;
always #(`rdclk_period/2)rdclk = ~rdclk;

integer i;

initial begin
	data = 0;
	rdreq = 0;
	wrreq = 0;
	#(`wrclk_period*20 + 1);
	for (i=0;i <= 255 ;i = i + 1)begin
		wrreq = 1;
		data = i + 1024;
		#`wrclk_period;
	end
	wrreq = 0;
	#(`rdclk_period*20);
	for (i=0;i <= 511 ;i = i + 1)begin
		rdreq = 1;
		#`rdclk_period;
	end
	rdreq = 0;
	#(`rdclk_period*20);
	$stop;
end


endmodule