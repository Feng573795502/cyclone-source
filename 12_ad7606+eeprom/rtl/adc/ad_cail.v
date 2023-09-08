	module data_cail(
		input clk,
		input rst_n,

		input  cail_en,
		input  [15:0]short_data,
		input  [15:0]data_len,

		output reg valid,
		input  [31:0]cail_sub_i,
		input  [31:0]cail_mult_i,
		output [31:0]cail_val_o
	);

	reg        cail_state;
	reg   [15:0]cnt_cail;
	wire [31:0]conv_data;
	wire [31:0]cail_zero;
	wire [15:0]max_len;
	
	assign max_len = 16'd16 + data_len;
	
	//工作状态展示
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cail_state <= 1'b0;
		else if(cail_en)
			cail_state <= 1'b1;
		else if(cnt_cail == max_len)
			cail_state <= 1'b0;
		else
			cail_state <= cail_state;
	end
	
	//读取计数
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_cail <= 16'd0;
		else if(cail_state)
			cnt_cail <= cnt_cail + 1'b1;
		else 
			cnt_cail <= 16'd0;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			valid  <= 1'b0;
		else if(cnt_cail > 'd15 && cnt_cail < max_len)
			valid <= 1'b1;
		else 
			valid <= 1'b0;
	end
	
		//十六BIT转换
	short_to_float short_to_float(
		.clock(clk),
		.dataa(short_data),
		.result(conv_data)
	);

	//零点偏移
	float_sub float_sub(
		.clock(clk),
		.dataa(conv_data),
		.datab(cail_sub_i),
		.result(cail_zero)
		);
		
	
	//比例系数乘法
	mult mult (
		.clock(clk),
		.dataa(cail_zero),
		.datab(cail_mult_i),
		.result(cail_val_o)
	);	

endmodule
	