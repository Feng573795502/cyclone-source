module mb_rtu_tx(
	input clk,
	input rst_n,
	
	input       tx_en_pulse,
	input [15:0]mb_addr,
	input [15:0]mb_num,
	input [7:0] mb_fun,
	
	output         payload_req_o,
	input [7:0]reg_data,
	output     reg tx_done,
	output     reg mb_tx_en,
	output reg[7:0]mb_txd
);


localparam 
	IDLE    = 6'b00_0001,
	TX_HEAD = 6'b00_0010,
	TX_DATA = 6'b00_0100,
	TX_CRC  = 6'b00_1000;

	//状态位置
	reg  [5:0]curr_state;
	reg  [5:0]next_state;

	//输出缓存用于切换数据和crc
	reg  tx_en_renewcrc;
	reg  [7:0]tx_data_renewcrc;
		
	reg [1:0]cnt_head;
	reg [7:0]cnt_data;
	reg [1:0]cnt_crc;
	reg [1:0]cnt_crc_dly1;
	reg [1:0]cnt_crc_dly2;
	

	reg [15:0]mb_addr_reg;
	reg [15:0]mb_num_reg;
	reg [7:0] mb_fun_reg;
	reg [7:0] data_len_reg;

	reg   [7:0]crc_in;
	reg        crc_init;
	reg        crc_en;
	reg        crc_en_temp;
	wire [15:0]crc_result;
	
	reg tx_en;
	reg tx_en_dly1;
	reg [7:0]tx_data;
	reg [7:0]tx_data_dly1;
	
	//crc状态
	wire crc_state;
	reg crc_state_dly1;
	reg crc_state_dly2;

//获取配置信息
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		mb_addr_reg <= 16'd0;
		mb_num_reg  <= 16'd0;
		mb_fun_reg  <= 8'd0;
	end
	else if(tx_en_pulse)begin
		mb_addr_reg <= mb_addr;
		mb_num_reg  <= mb_num;
		mb_fun_reg  <= mb_fun;
	end
	else begin
		mb_addr_reg <= mb_addr_reg;
		mb_num_reg  <= mb_num_reg;
		mb_fun_reg  <= mb_fun_reg;
	end
end

//长度设置
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		data_len_reg <= 8'd0;
	else if(tx_en_pulse)begin
		if(mb_fun == 8'h10)
			data_len_reg <= 8'd4 - 1;
		else 
			data_len_reg <= {mb_num[6:0],1'b0};
	end
	else 
		data_len_reg <= data_len_reg;
end

//FSM
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		curr_state <= IDLE;
	else 
		curr_state <= next_state;
end

//主状态机
always @(*)begin
	case(curr_state)
		IDLE: 
			if(tx_en_pulse)
				next_state <= TX_HEAD;
			else 
				next_state <= IDLE;
				
		TX_HEAD:
			if(cnt_head == 2'd1)
				next_state <= TX_DATA;
			else 
				next_state <= TX_HEAD;
	
		TX_DATA:
			if(cnt_data == data_len_reg)
				next_state <= TX_CRC;
			else 
				next_state <= TX_DATA;
		TX_CRC:
			if(cnt_crc == 2'd1)
				next_state <= IDLE;
			else 
				next_state <= TX_CRC;
		
		default: next_state <= IDLE;
	endcase
end

//cnt_head
always @(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt_head <= 2'd0;
	else if(curr_state == TX_HEAD)
		cnt_head <= cnt_head + 1'b1;
	else 
		cnt_head <= 2'd0;

//cnt_data
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_data <= 8'd0;
	else if(curr_state == TX_DATA)
		cnt_data <= cnt_data + 1'b1;
	else 
		cnt_data <= 8'd0;
end
		
		//tx_cnc
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_crc <= 2'd0;
	else if(curr_state == TX_CRC)
		cnt_crc <= cnt_crc + 1'b1;
	else 
		cnt_crc <= 2'd0;
end

//数据发送处理
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		tx_en   <= 1'b0;
		tx_data <= 8'h00;
	end
	else begin
		case(curr_state)
			IDLE:begin
				tx_en   <= 1'b0;
				tx_data <= 8'b0;
			end
			
			TX_HEAD:begin
				tx_en <= 1'b1;
				if(cnt_head == 2'd0) //addr
					tx_data <= 7'b1;
				else                 //fun
					tx_data <= mb_fun_reg; 
			end
			
			TX_DATA:begin
				tx_en <= 1'b1;
				
				if(mb_fun_reg == 8'h10)begin
					case(cnt_data)
						0: tx_data <= mb_addr_reg[15:8];
						1: tx_data <= mb_addr_reg[7:0];
						2: tx_data <= mb_num_reg[15:8];
						3: tx_data <= mb_num_reg[7:0];
					endcase
				end
				else begin
					if(cnt_data == 0)
						tx_data <= data_len_reg;
					else 
						tx_data <= reg_data;
				end
			end
			
			TX_CRC:begin
				tx_en <= 1'b1;
				tx_data <= 8'h00;
			end
			
		endcase
	end
end

assign payload_req_o = (curr_state == TX_DATA && cnt_data != 0) ? 1'b1 : 1'b0;

crc16_d8 crc_inst(
	.clk(clk),
	.rst_n(rst_n),
	
	.data(crc_in),
	.crc_init(crc_init),
	.crc_en(crc_en),
	.crc_result(crc_result)
);

//初始化crc
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		crc_init <= 1'b0;
	else if(tx_en_pulse && (curr_state == IDLE))
		crc_init <= 1'b1;
	else 
		crc_init <= 1'b0;
end

//crc使能判断
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		crc_en_temp <= 1'b0;
	else if(curr_state == TX_HEAD || curr_state == TX_DATA)
		crc_en_temp <= 1'b1;
	else 
		crc_en_temp <= 1'b0;
end

//crc使能 delya一个时钟周期
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		crc_en <= 1'b0;
	else if(crc_en_temp)
		crc_en <= 1'b1;
	else 
		crc_en <= 1'b0;
end

//crc数据
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		crc_in <= 8'h00;
	else if(crc_en_temp)
		crc_in <= tx_data;
	else 
		crc_in <= crc_in;
end

assign crc_state = curr_state == TX_CRC;

//状态延时和数据延时
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		tx_en_dly1   <= 1'b0;
		tx_data_dly1 <= 8'h00;
	end
	else begin
		tx_en_dly1   <= tx_en;
		tx_data_dly1 <= tx_data;
	end
end

//延时两个时钟周期，状态和ctc cnt_crc
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		crc_state_dly1 <= 1'b0;
		crc_state_dly2 <= 1'b0;
		cnt_crc_dly1   <= 2'd0;
		cnt_crc_dly2   <= 2'd0;
	end
	else begin
		crc_state_dly1 <= crc_state;
		crc_state_dly2 <= crc_state_dly1;
		cnt_crc_dly1   <= cnt_crc;
		cnt_crc_dly2   <= cnt_crc_dly1;
	end
end

//数据输出然后转到crc输出
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		tx_data_renewcrc <= 8'h00;
	else if(crc_state_dly2)begin
		case (cnt_crc_dly2)
			 2'd0:tx_data_renewcrc <= crc_result[7:0];
			 2'd1:tx_data_renewcrc <= crc_result[15:8];
		 endcase
	end
	else 
		tx_data_renewcrc <= tx_data_dly1;
end

//打两拍
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		tx_en_renewcrc <= 1'b0;
	else if(tx_en_dly1)
		tx_en_renewcrc <= 1'b1;
	else 
		tx_en_renewcrc <= 1'b0;
end

//发送数据
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		mb_tx_en <= 1'b0;
		mb_txd   <= 8'h00;
	end
	else begin
		mb_tx_en <= tx_en_renewcrc;
		mb_txd   <= tx_data_renewcrc;
	end
end

//发送完成
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		tx_done <= 1'b0;
	else if(curr_state == TX_CRC && cnt_crc == 2'd1) //发送完成
		tx_done <= 1'b1;
	else 
		tx_done <= 1'b0;
end

endmodule
