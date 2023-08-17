	module data_cail(
		input clk,
		input rst_n,
		
		input  cail_en,
		input  [15:0]short_data,
		input  [16:0]data_len,
		
		output reg valid,
		
		input  [31:0]cail_param,
		output [31:0]result
	);

	reg            cail_state;
	reg [4:0]      cnt_cail;
	wire [31:0]    float_data;
	
	wire [15:0]     max_len;
	
	
	assign max_len = 16'd9 + data_len;
	
	//工作状态展示
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cail_state <= 1'b0;
		else if(cail_en)
			cail_state <= 1'b1;
		else if(cnt_cail == 'd17)
			cail_state <= 1'b0;
		else
			cail_state <= cail_state;
	end
	
	//读取计数
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_cail <= 5'd0;
		else if(cail_state)
			cnt_cail <= cnt_cail + 1'b1;
		else 
			cnt_cail <= 5'd0;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			valid  <= 1'b0;
		else if(cnt_cail > 8 && cnt_cail < max_len)
			valid <= 1'b1;
		else 
			valid <= 1'b0;
	end
	
		//十六BIT转换
	short_to_float short_to_float(
		.clock(clk),
		.dataa(short_data),
		.result(float_data)
	);
	
	//乘法
	mult mult (
		.clock(clk),
		.dataa(float_data),
		.datab(cail_param),
		.result(result)
	);	

endmodule
	