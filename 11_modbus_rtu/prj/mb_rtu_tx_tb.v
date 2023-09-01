`timescale 1ns/1ns
`define CLK_PERIOD 20

module mb_rtu_tx_tb();

reg clk;
reg rst_n;

reg tx_en_pulse;
reg [15:0]mb_addr;
reg [15:0]mb_num;
reg [7:0]mb_fun;
reg [7:0]reg_data;

wire payload_req_o;

wire tx_done;
wire mb_tx_en;
wire [7:0]mb_txd;

mb_rtu_tx mb_rtu_tx(
	.clk(clk),
	.rst_n(rst_n),
	
	.tx_en_pulse(tx_en_pulse),
	.mb_addr(mb_addr),
	.mb_num(mb_num),
	.mb_fun(mb_fun),
	.reg_data(reg_data),
	.payload_req_o(payload_req_o),
	
	.tx_done(tx_done),
	.mb_tx_en(mb_tx_en),
	.mb_txd(mb_txd)
);

initial clk = 1;
always#10 clk = ~clk;

initial begin
	rst_n = 0;
	#200;
	rst_n = 1;
	
	mb_addr = 16'h0000;
	mb_num  = 16'h000a;
	mb_fun  = 8'h03;
	
	tx_en_pulse = 1;
	#20;
	tx_en_pulse = 0;
	@(posedge payload_req_o);
	reg_data = 8'h11;
	#20;
	reg_data = 8'h12;
	#20;
	reg_data = 8'h13;
	#20;
	reg_data = 8'h14;
	#20;
	reg_data = 8'h15;
	#20;
	reg_data = 8'h16;
	#20;
	reg_data = 8'h20;
	#20;
	reg_data = 8'h21;
	#20;
	reg_data = 8'h22;
	#20;
	reg_data = 8'h23;
	#20;
	reg_data = 8'h24;
	#20;
	
	
	
	#2000;
	$stop;

end

endmodule
