	module mb_rtu(
		input             clk,
		input             rst_n,
		
		output reg [15:0] mb_reg;  //读写的寄存器地址和数量
		output reg [15:0] mb_num;   
		
		output reg        wr_en;
		output reg [7:0 ] wr_data;
		
		output reg        rd_en;
		output reg        crc_err;
		input             uart_rx_wire;
	);
	
	wire        [7:0] rx_data;      //uart接收数据
	wire              rx_done;      //串口接收完成
	
	reg         [6:0] curr_state;   //当前状态和下一个状态
	reg         [6:0] next_state;
	
	reg               fifo_clr;     //fifo
	reg               fifo_rd;
	wire        [7:0] q;
	wire        [9:0] fifo_cnt;
	
	reg         [31:0]div_cnt;      //串口接收结束计数定时器
	reg               rx_uart_done; //串口数据超代表接收完成

	reg               fifo_valid;   //判断FIFO里面得数据是否达到MB长度(有效)才进行处理
	reg         [7:0] fifo_data;

	reg         [2:0] cnt_read;	//3个功能计数
	reg         [7:0] cnt_write;
	reg         [1:0] cnt_crc;

	//10写入
	reg         [7:0] write_num;  //记录10功能码写入个数
	reg        [15:0] crc;        //记录接收的CRC
	
	//crc处理
	reg              crc_init;
	reg              crc_en;	
	wire       [15:0]crc_result;

	parameter TIMER_OUT = (2000000/20);
	
	localparam 
	IDLE      = 7'b000_0001,
	RX_HEAD   = 7'b000_0010,
	RX_FUN    = 7'b000_0100,
	RX_READ   = 7'b000_1000,
	RX_WRITE  = 7'b001_0000,
	RX_CRC    = 7'b010_0000,
	RX_ERR    = 7'b100_0000;
	
	//串口接收超时定时器
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			div_cnt <= 32'd0;
		else if(rx_done == 1'b1)
			div_cnt <= 32'd1;
		else if(div_cnt >= 1 && div_cnt < TIMER_OUT)
			div_cnt <= div_cnt + 1'b1;
		else if(div_cnt == div_cnt)
			div_cnt <= 1'b0;
		else 
			div_cnt <= 1'b0;
	end
	
	//超时定时器标志
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rx_uart_done <= 1'b0;
		else if(div_cnt == TIMER_OUT)
			rx_uart_done <= 1'b1;
		else 
			rx_uart_done <= 1'b0;
	end
	
	//启动状态
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			fifo_clr   <= 1'b0;
			fifo_valid <= 1'b0;
		end
		else if(rx_uart_done)begin
			if(fifo_cnt < 8)
				fifo_clr <= 1'b1;
			else begin
				crc_init <= 1'b1;
				fifo_valid <= 1'b1;
			end
		end
		else begin
			fifo_clr   <= 1'b0;
			fifo_valid <= 1'b0;
			crc_init   <= 1'b0;
		end
	end
	
	//cnt_read
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_read <= 3'd0;
		else if(curr_state == RX_READ)
			cnt_read <= cnt_read + 1'b1;
		else 
			cnt_read <= 3'd0;
	end
	
	//cnt_write
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_write <= 8'd0;
		else if(curr_state == RX_WRITE)
			cnt_write <= cnt_write + 8'b1;
		else 
			cnt_write <= 8'd0;
	end
	
	//cnt_crc
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_crc <= 2'b0;
		else if(curr_state == RX_CRC)
			cnt_crc <= cnt_crc + 2'b1;
		else 
			cnt_crc <= 2'b0;
	end
	
	//crc检测
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			crc_err <= 1'b0;
		else if(cnt_crc == 2'd2)begin
			if(crc_result == 16'b0)
				crc_err <= 1'b0;
			else 
				crc_err <= 1'b1;
		end
		else 
			crc_err <= crc_err;
	end
	
	//读取寄存器处理
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			mb_reg <= 16'b0;
			mb_num  <= 16'b0;
		end
		else if(curr_state == RX_READ)begin
			case(cnt_read)
				0,1: mb_reg <= {mb_reg[7:0], fifo_data};
				2,3: mb_num  <= {mb_num[7:0], fifo_data};
			endcase
		end
		else if(curr_state == RX_WRITE)begin
			case(cnt_write)
				0,1: mb_reg <= {mb_reg[7:0], fifo_data};
				2,3: mb_num  <= {mb_num[7:0], fifo_data};
				4:   write_num <= fifo_data;
				default;
			endcase
		end
	end
	
	//wr_en输出
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			wr_en <= 1'b0;
			wr_data <= 8'b0;
		end
		else if(cnt_write >= 5 && curr_state == RX_WRITE)begin
			wr_en <= 1'b1;
			wr_data <= fifo_data;
		end
		else begin
			wr_en <= 1'b0;
			wr_data <= 8'b0;
		end
		
	end
	
	//crc读取
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			crc <= 16'b0;
		end
		else if(curr_state == RX_CRC)
			crc <= {crc[7:0], fifo_data};
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			crc <= 16'b0;
		end
		else if(curr_state == RX_CRC)
			crc <= {crc[7:0], fifo_data};
	end
	
	//数据打拍
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			fifo_data <= 8'b0;
		else 
			fifo_data <= q;
	end
	
	//FSM
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			curr_state <= IDLE;
		else 
			curr_state <= next_state;
	end
	
	always @(*)
	begin
		case(curr_state)
			IDLE:begin
					if(fifo_valid == 1'b1)begin
						fifo_rd <= 1'b1;
						next_state = RX_HEAD;
					end
					else begin 
						fifo_rd <= 1'b0;
						next_state = IDLE;
					end
					crc_en = 1'b0;
				end
				
			RX_HEAD:
				if(fifo_data == 8'h01 || fifo_data == 8'hff) begin
					next_state = RX_FUN;
					crc_en	 <= 1;
				end
				else
					next_state = RX_HEAD;
			
			RX_FUN:
				if(fifo_data == 8'h03)
					next_state = RX_READ;
				else if( fifo_data == 8'h10)
					next_state = RX_WRITE;
				else 
					next_state = RX_ERR;
			
			RX_READ:
				if(cnt_read == 4'd3)
					next_state = RX_CRC;
				else
					next_state = RX_READ;
			
			RX_WRITE:
				if(cnt_write == 7'd4 + write_num)
					next_state = RX_CRC;
				else
					next_state = RX_WRITE;
			
			RX_CRC:
				if(cnt_crc == 2'd1)
					next_state = IDLE;
				else 
					next_state = RX_CRC;
			
		endcase
	end
	
	crc16_d8 crc16_d8(
		.clk(clk),
		.rst_n(rst_n),
		
		.data(fifo_data),
		.crc_init(crc_init),
		.crc_en(crc_en),
		
		.crc_result(crc_result)
	);
	
	uart_rx uart_rx(
    .clk(clk),                 //系统时钟
    .rst_n(rst_n),             //复位
    .uart_rx(uart_rx_wire),    //接收wire
    .baud_set(3'd4),    	    //波特率
    .data_byte(rx_data),
    .rx_done(rx_done)
	);
	
	//接收FIFO用于处理数据啦
	ex_data ex_data(
	.clock(clk),
	.data(rx_data),
	.rdreq(fifo_rd),
	.aclr(fifo_clr),
	.wrreq(rx_done),
	.q(q),
	.usedw(fifo_cnt)
	);
	
	endmodule
	