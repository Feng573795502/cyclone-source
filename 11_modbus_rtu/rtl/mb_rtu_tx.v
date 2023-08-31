module mb_rtu_tx(
	input clk,
	input rst_n,
	
	input       tx_en_pulse,
	input [15:0]mb_addr,
	input [15:0]mb_num,
	input [7:0] fun,
	
	output     reg tx_done,
	output     reg tx_en,
	output reg[7:0]tx_data
);

reg  [5:0]curr_state;
reg  [5:0]next_state;

reg  [7:0]data_len;

reg  tx_en_renewcrc;
reg  [7:0]tx_data_renewcrc;

localparam 
IDLE    = 6'b00_0001,
TX_HEAD = 6'b00_0010,
TX_DATA = 6'b00_0100,
TX_CRC  = 6'b00_1000;

reg [1:0]cnt_head;
reg [7:0]cnt_data;
reg [1:0]cnt_crc;

//数据长度存储
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
	endcase
end


reg   [7:0]crc_in;
reg        crc_init;
reg        crc_en;
reg        crc_en_temp;
wire [15:0]crc_result;

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
		crc_en_tmep <= 1'b0;
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
		crc_in <= crc_inl
end

assign crc_state = curr_state == TX_CRC;
	
	
//数据输出然后转到crc输出
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		txd_crc <= 16'h0000;
	else if(crc_state_dly2)begin
		case (cnt_crc_dly2)
			 2'd0:txd_crc <= crc_result[15:8];
			 2'd0:txd_crc <= crc_result[7:0];
		 endcase
	end
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
		tx_en   <= 1'b0;
		tx_data <= 8'h00;
	end
	else begin
		tx_en   <= tx_en_renewcrc;
		tx_data <= tx_data_renewcrc;
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
