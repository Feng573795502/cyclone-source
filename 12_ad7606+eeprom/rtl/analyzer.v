module analyzer(
	input clk,
	input rst_n,
	
	//ADC 接口
	input  busy_i,
	output ad_clk_o,
	output ad_conv_o,
	input [15:0]data_i,
	
	//后续不需要
	output reg ad_reset_o,
	output ad_rd_o,
	output [2:0]ad_os_o,
	
	output [31:0]result,
	
	output iic_clk,
	inout  iic_sda
	
);
	localparam 
	IDLE         = 6'b000001,
	WR           = 6'b000010,
	RD           = 6'b000100,
	UPDATE_REG   = 6'b001000,
	UPDATE_EE    = 6'b010000;
	
	localparam REG_NUM = 8'd255;
	parameter  wordsize = 8, memsize = 32;
	//校准参数寄存器
	reg [wordsize - 1 : 0]ch1_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch2_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch3_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch4_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch5_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch6_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch7_cail[memsize - 1 : 0];
	reg [wordsize - 1 : 0]ch8_cail[memsize - 1 : 0];

	//加法和乘法
	reg [31:0]cur_sub;
	reg [31:0]cur_mult;
	wire cail_en;

	reg [4:0]ch_cnt;
	
	//eeprom连接
	reg  ee_wr_req;
	reg  ee_rd_req;
	reg  ee_update;
	wire ee_init_done;
	
	reg [9:0]ee_wr_addr;
	reg [9:0]ee_rd_addr;
	
	reg [7:0]ee_wr_data;
	wire [7:0]ee_rd_data;
	
	reg [5:0]main_state;
	
	reg [7:0]cnt_wr;
	reg [7:0]cnt_rd;
	reg [7:0]cnt_update;
	
	reg [7:0]wr_num;
	reg [7:0]rd_num;
	
	reg wr_req;
	reg rd_req;
	reg up_ee_req;
	
	//写操作计数
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_wr <= 8'b0;
		else if(main_state == WR)
			cnt_wr <= cnt_wr + 1'b1;
		else 
			cnt_wr <= 8'b0;
	end
	
	//读操作计数
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_rd <= 8'b0;
		else if(main_state == RD)
			cnt_rd <= cnt_rd + 1'b1;
		else 
			cnt_rd <= 8'b0;
	end
	
	//更新寄存器计数
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_update <= 8'b0;
		else if(main_state == UPDATE_REG)
			cnt_update <= cnt_update + 1'b1;
		else 
			cnt_update <= 8'b0;
	end
	
	//FSM
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			main_state <= IDLE;
			wr_req     <= 1'b0;
			rd_req     <= 1'b0;
			up_ee_req  <= 1'b0;
		end
		else begin
			case(main_state)
				IDLE:begin
					if(ee_init_done)begin   //初始化完成 更新REG
						ee_rd_addr <= 9'd0;
						ee_rd_req  <= 1'b1;
						main_state <= UPDATE_REG;
					end
					else if(wr_req)begin         //写入RAM 用于10功能码触发
						main_state <= WR;
					end
					else if(rd_req)begin         //读取RAM 用于03功能码触发
						main_state <= RD;
					end
					else if(up_ee_req)begin      //读取rAM 用于更新REG 作为计算
						main_state <= UPDATE_EE;
					end
					else 
						main_state <= IDLE;
				end
				
				WR: begin
					if(cnt_wr == wr_num)begin
						ee_wr_req  <= 1'b0;
						main_state <= IDLE;
					end
				end
				
				RD: begin
					if(cnt_rd == rd_num)begin
						ee_rd_req  <= 1'b0;
						main_state <= IDLE;
					end
				
				end
				
				UPDATE_REG:begin
					if(cnt_update == REG_NUM)begin
						ee_rd_req  <= 1'b0;
						main_state <= IDLE;
					end
				end
			endcase
		
		end
	
	end
	
	
	integer i = 0;
	//读取更新值
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
//			while(i < 100)begin
//				ch1_cail[i] <= 8'h01;
//				ch2_cail[i] <= 8'h01;
//				ch3_cail[i] <= 8'h01;
//				ch4_cail[i] <= 8'h01;
//				ch5_cail[i] <= 8'h01;
//				ch6_cail[i] <= 8'h01;
//				ch7_cail[i] <= 8'h01;
//				ch7_cail[i] <= 8'h01;
//				i = i + 1;
			end
			
		else if(main_state == UPDATE_REG)
			case(cnt_update[7:5])
				0:ch1_cail[cnt_update[4:0]] <= ee_rd_data;
				1:ch2_cail[cnt_update[4:0]] <= ee_rd_data;
				2:ch3_cail[cnt_update[4:0]] <= ee_rd_data;
				3:ch4_cail[cnt_update[4:0]] <= ee_rd_data;
				4:ch5_cail[cnt_update[4:0]] <= ee_rd_data;
				5:ch6_cail[cnt_update[4:0]] <= ee_rd_data;
				6:ch7_cail[cnt_update[4:0]] <= ee_rd_data;
				7:ch8_cail[cnt_update[4:0]] <= ee_rd_data;
			endcase
	end
	
	//计算通道值选择
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			ch_cnt <= 5'd0;
		else if(cail_en && ch_cnt == 5'd0)
			ch_cnt <= 5'd1;
		else if(ch_cnt >= 1 && ch_cnt < 5'd19)
			ch_cnt <= ch_cnt + 1'b1;
		else 
			ch_cnt <= 5'd0;
	end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			cur_sub  <= 32'h00000000;
			cur_mult <= 32'h00000000;
		end
		else begin
			case(ch_cnt) 
				5:begin
				cur_sub  <= 32'h3f800000; //1 conv 6个时钟
				end
				6:begin
				cur_sub  <= 32'h40000000; //2
				end
				7:begin
				cur_sub  <= 32'h40400000; //3
				end
				8:begin
				cur_sub  <= 32'h40800000; //4
				end
				9:begin
				cur_sub  <= 32'h40a00000; //5
				end
				10:begin
				cur_sub  <= 32'h40C00000; //6
				end
				11:begin
				cur_sub  <= 32'h40E00000; //7
				end
				12:begin
				cur_sub  <= 32'h41000000; //8 //转换ZZ
				cur_mult <= 32'h3f800000; //1
				end
				13:begin
				cur_mult <= 32'h40000000; //2
				end
				14:begin
				cur_mult <= 32'h40400000; //3
				end
				15:begin
				cur_mult <= 32'h40800000; //4
				end
				16:begin
				cur_mult <= 32'h40a00000; //5
				end
				17:begin
				cur_mult <= 32'h40C00000; //6
				end
				18:begin
				cur_mult <= 32'h40E00000; //7
				end
				19:begin
				cur_mult <= 32'h41000000; //8
				end
				default: begin
					cur_mult <= 32'h0000000; //1
					cur_sub  <= 32'h0000000; //1
				end
			endcase
		end
	end
	
	//通道采集
	ad_control_top ad_control_top(
	.clk(clk),
	.rst_n(rst_n),
	
	//ADC 接口
	.busy_i(busy_i),
	.ad_clk_o(ad_clk_o),
	.ad_conv_o(ad_conv_o),
	.data_i(data_i),
	
	//后续不需要
	.ad_reset_o(ad_rst_o),
	.ad_rd_o(ad_rd_o),
	.ad_os_o(ad_os_o),
	
	.cail_sub_i(cur_sub),
	.cail_mult_i(cur_mult),
	
	.result(result),
	.cail_en(cail_en)
	);
	
	//eeprom控制器
	eeprom_ctrl eeprom_ctrl(
	.clk(clk),
	.rst_n(rst_n),
	
	.wr_req(ee_wr_req),      //写入、读取、更新请求
	.rd_req(ee_rd_req),
	.update_req(ee_update_req),
	
	.init_done(ee_init_done),
	
	//eeprom 地址
	.wr_addr(ee_wr_addr),
	.rd_addr(ee_rd_addr),
	
	.wr_data(ee_wr_data),  //只留给MB RTU写入
	.rd_data(ee_rd_data),  //MB RTU / 校准读取
	
	.iic_clk(iic_clk),
	.iic_sda(iic_sda)
);

endmodule
