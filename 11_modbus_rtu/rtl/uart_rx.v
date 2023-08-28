module uart_rx(
    input clk,               //系统时钟
    input rst_n,             //复位
    input uart_rx,           //接收wire
    input [2:0]baud_set,     //波特率
    output reg[7:0]data_byte,
    output reg rx_done
);

wire uart_rx_nedge;

//寄存器定义
reg uart_rx_sync1;   //同步寄存器
reg uart_rx_sync2;

reg [15:0]bps_dr;    //波特率计数最大值
reg [15:0]div_cnt;   //计数累加值
reg bps_clk;         //波特率时钟
reg [7:0]clk_cnt;    //波特率时钟累积

reg uart_state;      //串口工作状态

reg [2:0]START_BIT;
reg [2:0]STOP_BIT;
reg [2:0]data_byte_pre [7:0];

//时钟同步 用于消除亚稳态
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        uart_rx_sync1 <= 1'b0;
        uart_rx_sync2 <= 1'b0;
    end 
    else begin 
        uart_rx_sync1 <= uart_rx;
        uart_rx_sync2 <= uart_rx_sync1;
    end      
end

//获取消除亚稳态的数据
//always @(posedge clk or negedge rst_n)begin
//    if(reset)begin
//        uart_rx_reg1 <= 1'b0;
//        uart_rx_reg1 <= 1'b0;
//    end
//    else
//        uart_rx_reg1 <= uart_rx_sync2;
//        uart_rx_reg2 <= uart_rx_reg1;
//end

//下降沿沿计算  起始标志
assign uart_rx_nedge = !uart_rx_sync1 & uart_rx_sync2;

//波特率值计算  16bit过采样
always @(posedge clk  or negedge rst_n)begin
    if(!rst_n)
        bps_dr = 16'd324;
    else begin
        case(baud_set)
            0:bps_dr <= 16'd324;
            1:bps_dr <= 16'd162;
            2:bps_dr <= 16'd80;
            3:bps_dr <= 16'd53;
            4:bps_dr <= 16'd26;
        default: bps_dr <= 16'd324;
        endcase
    end
end

//串口状态
always @(posedge clk  or negedge rst_n)begin
    if(!rst_n)
        uart_state <= 1'b0;
    else if(uart_rx_nedge)
        uart_state <= 1'b1;
    else if(rx_done || (clk_cnt == 8'd12 && (START_BIT > 2)) || (clk_cnt == 8'd155 && (STOP_BIT < 3)))  //起始位/结束位计数不够 跳出
			uart_state <= 1'b0;
	else
		uart_state <= uart_state;	
end

//计数器
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        div_cnt <= 16'b0;
    else if(uart_state) begin  //状态包括了异常检测所以其他地方均不需要使用状态
        if(div_cnt == bps_dr)
            div_cnt <= 16'b0;
        else 
            div_cnt <= div_cnt + 16'b1;
    end 
    else 
        div_cnt <= 16'b0;
end

//波特率时钟生成
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bps_clk <= 1'b0;
    else if(div_cnt == 16'b1)
        bps_clk <= 1'b1;
    else 
         bps_clk <= 1'b0;
end

//采集统计
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        clk_cnt <= 8'd0;
    else if(clk_cnt == 8'd159 | (clk_cnt == 8'd12 && START_BIT > 2))
        clk_cnt <= 8'b0;
    else if(bps_clk)
        clk_cnt <= clk_cnt + 8'b1;
    else 
        clk_cnt <= clk_cnt;
end

//数据采集
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
		START_BIT <= 3'd0;
		data_byte_pre[0] <= 3'd0;
		data_byte_pre[1] <= 3'd0;
		data_byte_pre[2] <= 3'd0;
		data_byte_pre[3] <= 3'd0;
		data_byte_pre[4] <= 3'd0;
		data_byte_pre[5] <= 3'd0;
		data_byte_pre[6] <= 3'd0;
		data_byte_pre[7] <= 3'd0;
		STOP_BIT <= 3'd0;
    end
    else if(bps_clk)begin  //达到bps_clk采集一次 
        case(clk_cnt)
            0:begin
        START_BIT <= 3'd0;
        data_byte_pre[0] <= 3'd0;
        data_byte_pre[1] <= 3'd0;
        data_byte_pre[2] <= 3'd0;
        data_byte_pre[3] <= 3'd0;
        data_byte_pre[4] <= 3'd0;
        data_byte_pre[5] <= 3'd0;
        data_byte_pre[6] <= 3'd0;
        data_byte_pre[7] <= 3'd0;
        STOP_BIT <= 3'd0;
    end
			6 ,7 ,8 ,9 ,10,11:START_BIT <= START_BIT + uart_rx_sync2;
			22,23,24,25,26,27:data_byte_pre[0] <= data_byte_pre[0] + uart_rx_sync2;
			38,39,40,41,42,43:data_byte_pre[1] <= data_byte_pre[1] + uart_rx_sync2;
			54,55,56,57,58,59:data_byte_pre[2] <= data_byte_pre[2] + uart_rx_sync2;
			70,71,72,73,74,75:data_byte_pre[3] <= data_byte_pre[3] + uart_rx_sync2;
			86,87,88,89,90,91:data_byte_pre[4] <= data_byte_pre[4] + uart_rx_sync2;
			102,103,104,105,106,107:data_byte_pre[5] <= data_byte_pre[5] + uart_rx_sync2;
			118,119,120,121,122,123:data_byte_pre[6] <= data_byte_pre[6] + uart_rx_sync2;
			134,135,136,137,138,139:data_byte_pre[7] <= data_byte_pre[7] + uart_rx_sync2;
			150,151,152,153,154,155:STOP_BIT <= STOP_BIT + uart_rx_sync2;
			default:
      begin
        START_BIT <= START_BIT;
        data_byte_pre[0] <= data_byte_pre[0];
        data_byte_pre[1] <= data_byte_pre[1];
        data_byte_pre[2] <= data_byte_pre[2];
        data_byte_pre[3] <= data_byte_pre[3];
        data_byte_pre[4] <= data_byte_pre[4];
        data_byte_pre[5] <= data_byte_pre[5];
        data_byte_pre[6] <= data_byte_pre[6];
        data_byte_pre[7] <= data_byte_pre[7];
        STOP_BIT <= STOP_BIT;
      end
    endcase
    end

end

//取值
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		data_byte <= 8'd0;
	else if(clk_cnt == 8'd159)begin
		data_byte[0] <= data_byte_pre[0][2];
		data_byte[1] <= data_byte_pre[1][2];
		data_byte[2] <= data_byte_pre[2][2];
		data_byte[3] <= data_byte_pre[3][2];
		data_byte[4] <= data_byte_pre[4][2];
		data_byte[5] <= data_byte_pre[5][2];
		data_byte[6] <= data_byte_pre[6][2];
		data_byte[7] <= data_byte_pre[7][2];
	end
end

//采集完成输出
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rx_done <= 1'b0;
    else if(clk_cnt == 8'd159)
        rx_done <= 1'b1;
    else 
        rx_done <= 1'b0;
end

endmodule
