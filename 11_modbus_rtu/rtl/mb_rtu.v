	module mb_rtu(
		clk,
		rst_n,
		uart_rx_wire
	);

	input clk;
	input rst_n;
	
	input uart_rx_wire; //数据线
	
	wire  [7:0]rx_data;
	
	reg [3:0]curr_state;
	reg [3:0]next_state;
	
	reg fifo_clr;
	reg fifo_rd;
	wire [7:0]q;
	wire [9:0]fifo_cnt;
	
	wire rx_done;
	reg  rx_uart_done;
	
	
	
	reg [31:0]div_cnt;
	
	parameter TIMER_OUT = (2000000/20);
	
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
	
	//检测数据长度
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			fifo_clr <= 1'b0;
		else if(rx_uart_done)begin
			if(fifo_cnt < 8)
				fifo_clr <= 1'b1;
		end
		else 
			fifo_clr <= 1'b0;
	end
	
	crc16_d8 crc16_d8(
		.clk(clk),
		.rst_n(rst_n),
		
		.data(),
		.crc_init(),
		.crc_en(),
		
		.crc_result()
	);
	
	uart_rx uart_rx(
    .clk(clk),               //系统时钟
    .rst_n(rst_n),             //复位
    .uart_rx(uart_rx_wire),           //接收wire
    .baud_set(3'd4),     //波特率
    .data_byte(rx_data),
    .rx_done(rx_done)
	);
	
	//接收FIFO用于处理数据啦
	ex_data ex_data(
	.clock(clk),
	.data(rx_data),
	.rdreq(0),
	.aclr(fifo_clr),
	.wrreq(rx_done),
	.q(q),
	.usedw(fifo_cnt)
	);
	
	endmodule
	