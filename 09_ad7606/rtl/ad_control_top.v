module ad_control_top(
	input clk,
	input rst_n,
	
	input [15:0]data_in,
	
	input  busy,
	output clk_adc,
	output conv,
	
	output valid,
	output [31:0]result
);

	localparam DATA_LEN = 4'd8;

	reg        rdreq;
	wire [15:0] ad_data;
	wire [5:0]  rdusedw;

	reg        cail_en;

	reg  [31:0] cail_param; //校准参数
	
	reg  [3:0]       rd_cnt;
	
	reg   read_state;

	//计算信号 启动计算
//	assign cail_en = (rdusedw >= DATA_LEN) ? 1'b1 : 1'b0;
//	assign rdreq   = (rd_cnt != 4'd0) ? 1'b1 : 1'b0;
	
	//8 tick
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rd_cnt <= 4'd0;
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
	
//	always @(posedge clk or negedge rst_n)begin
//		if(!rst_n)
//			rdreq <= 1'b0;
//		else if(rd_cnt != 4'd0)
//			rdreq <= 1;
//		else 
//			rdreq <= 0;
//	end

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
	.data_len(DATA_LEN),
		
	.valid(valid),
		
	.cail_param(32'h40000000),
	.result(result)
);

endmodule
