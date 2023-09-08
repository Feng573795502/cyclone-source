module ad7606(
	input clk,
	input rst_n,

	output ad_clk_o,
	output ad_conv_o,
	input [15:0]data_i,

	input ad_rd,
	output [15:0]ad_data,
	output [4:0]data_cnt
);

	//50Mhz  => 200K
	parameter PULSE = 8'd125;

	//计数器
	reg [7:0]cnt;
	reg [2:0] mode;
	reg read_siganl;
	reg [5:0]read_cnt;

	//写请求
	reg ad_fifo_wr;
	reg clk_25m;
	wire clk_25  = clk_25m;
	wire reset = ~rst_n;

	ad_fifo ad_fifo(
		.aclr(reset),
		.data(data_i),
		
		.rdclk(clk),  //供外部读取,选择外部时钟z
		.rdreq(ad_rd),
		.wrclk(clk_25m),
		.wrreq(ad_fifo_wr),
		.q(ad_data),
		.rdusedw(data_cnt)
	);

	//转换信号
	assign ad_conv_o = (cnt < 2 ? 1'b0 : 1'b1);
	assign ad_clk_o  = (mode) ? clk_25m : 1'b1;

	//转换计数 用于输出conv
	always @(posedge clk_25 or negedge rst_n)begin
		if(!rst_n)
			cnt <= 8'd0;
		else if(cnt < (PULSE - 1'b1))
			cnt <= cnt + 1'b1;
		else 
			cnt <= 8'd0;
	end

	//ad clk输出
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			clk_25m <= 1'b1;
		else 
			clk_25m <= ~clk_25m;
	end

	//模拟读数据
	always @(posedge clk_25 or negedge rst_n)begin
		if(!rst_n)
			read_siganl <= 1'b0;
		else if(cnt == 8'd10)
			read_siganl <= 1'b1;
		else 
			read_siganl <= 1'b0;
	end

	//模式设置
	always@(posedge clk_25 or negedge rst_n)begin
		if(!rst_n)
			read_cnt <= 6'd0;
		else if(mode == 1)
			read_cnt <= read_cnt + 1'b1;
		else 
			read_cnt <= 6'd0;
	end

	//主状态机
	always @(posedge clk_25 or negedge rst_n)begin
		if(!rst_n)begin
				mode       <= 3'd0;
				ad_fifo_wr <= 1'b0;
			end
		else begin
			case(mode)
				0: begin
					if(read_siganl) begin
						ad_fifo_wr <= 1'b1;
						mode       <= 1;
					end
					else begin 
						ad_fifo_wr <= 1'b0;
						mode       <= 0;
					end
				end
				
				1:begin
						if(read_cnt == 7)begin
							ad_fifo_wr <= 1'b0;
							mode       <= 1'b0;
						end
				end
			endcase
		end
	end

endmodule


