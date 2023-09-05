

module ad_control_top(
	input clk,
	input rst_n,
	
	//ADC 接口
	input [15:0]data_in, 
	input  busy,
	output clk_adc,
	output conv,
	
	
	output reg ad_reset,
	output ad_rd,
	output [2:0]ad_os
	
	//output [31:0]result,
	//input  read_data
	//output 
);

	localparam DATA_LEN = 15'd8;

	reg        rdreq;
	wire [15:0] ad_data;
	wire [5:0]  rdusedw;

	reg         cail_en;
	reg  [31:0] cail_param; //校准参数
	
	reg  [3:0]       rd_cnt;
	
	reg   read_state;
	
	wire [31:0]cail_data;
	wire       valid;
	
	wire [31:0]result;
	wire [8:0]usedw;
	reg read_data;
	
	//后期合并起来使用
	assign ad_rd = clk_adc;
	assign ad_os = 3'b000;
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			ad_reset <= 1'b1;
		else 
			ad_reset <= 1'b0;
	end
	
	//8 tick
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			read_state <= 1'b0;
		else if(rdusedw >= DATA_LEN)
			read_state <= 1'b1;
		else if(rd_cnt == 7)
			read_state <= 1'b0;
		else
			read_state <= read_state;
	end
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rd_cnt <= 4'd0;
		else if(read_state)
			rd_cnt <= rd_cnt + 1'b1;
		else
			rd_cnt <= 'd0;
	end
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rdreq <= 1'b0;
		else if(read_state)
			rdreq <= 1'b1;
		else
			rdreq <= 1'b0;
	end
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cail_en <= 1'b0;
		else if(read_state)
			cail_en <= 1'b1;
		else
			cail_en <= 1'b0;
	end

//ad例化
ad7606 ad7606(
	.clk(clk),
	.rst_n(rst_n),
	.busy(busy),

	.data_in(data_in),
	
	.clk_adc(clk_adc),
	.conv(conv),
	
	.rdreq(rdreq),
	.ad_data(ad_data),
	.rdusedw(rdusedw)
);

data_cail data_cail(
	.clk(clk),
	.rst_n(rst_n),
		
	.cail_en(cail_en),
	.short_data(ad_data),
	.data_len(16'd8),
		
	.valid(valid),
		
	.cail_param(32'h3c1c4138),
	.result(cail_data)
);

data_fifo data_fifo (
	.clock(clk),
	.data(cail_data),
	.rdreq(read_data),
	.wrreq(valid),
	.q(result),
	.usedw(usedw)
	);


endmodule
