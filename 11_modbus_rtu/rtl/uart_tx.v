module uart_tx(
    input clk,            //系统时钟和复位时钟
    input rst_n, 
    
    input send_en,           //启动发送标志
    input [7:0]data_byte,    //数据线
    input [2:0] baud_set,    //波特率设置线
    
    output reg tx_done,     //发送完成标志
    output reg uart_state,  //空闲状态
    output reg uart_tx      //发送线
    );
    
//参数定义
localparam START_BIT = 1'b0;
localparam STOP_BIT  = 1'b1;

//参数定义
reg[15:0] div_cnt;   //波特率计数
reg[15:0] bps_dr;    //波特率的值
reg[3:0]  bps_cnt;   //发送计数
reg[7:0]  data_byte_reg; //发送数据寄存器
reg bps_clk;             //发送时钟 

//uart_状态
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        uart_state <= 1'b0;
    else if(send_en)
        uart_state <= 1'b1;
    else if(bps_cnt == 4'd11)
        uart_state <= 1'b0;
    else 
        uart_state <= uart_state;
end

//数据获取 发送状态的时候更新寄存器值
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_byte_reg = 8'd0;
    else if(send_en)
		data_byte_reg <= data_byte;
	else
		data_byte_reg <= data_byte_reg;
end

//波特率计算
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bps_dr <= 16'd5207;
    else begin
		case(baud_set)
			0:bps_dr <= 16'd5207;
			1:bps_dr <= 16'd2603;
			2:bps_dr <= 16'd1301;
			3:bps_dr <= 16'd867;
			4:bps_dr <= 16'd433;
			default:bps_dr <= 16'd5207;			
		endcase
    end
end

//div时钟 波特率时钟啦
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        div_cnt <= 16'b0;
    else if(uart_state)begin
        if(div_cnt == bps_dr)
            div_cnt <= 16'd0;
        else 
            div_cnt <= div_cnt + 16'b1;
    end
    else 
        div_cnt <= 16'b0;
end

//发送标志 类似10ms 状态机
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bps_clk <= 1'b0;
    else if(div_cnt == 16'd1) //延迟一个时钟周期发送数据
        bps_clk = 1'b1;
    else
        bps_clk = 1'b0;
end

//发送计数 1+8+1 最后一位预留
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bps_cnt <= 4'd0;
    else if(bps_cnt == 4'd11)
        bps_cnt <= 4'd0;
    else if(bps_clk)
        bps_cnt <= bps_cnt + 1'b1;
    else 
        bps_cnt <= bps_cnt;
end

//发送完成输出  最后以为多出来的用来延长停止位 done
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        tx_done <= 1'b0;
    else if(bps_cnt == 4'd11)
        tx_done <= 1'b1;
    else 
        tx_done <= 1'b0;
end

//发送数据     并转串
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        uart_tx <= 1'b1;
    else begin
		case(bps_cnt)
			0:uart_tx <= 1'b1;
			1:uart_tx <= START_BIT;
			2:uart_tx <= data_byte_reg[0];
			3:uart_tx <= data_byte_reg[1];
			4:uart_tx <= data_byte_reg[2];
			5:uart_tx <= data_byte_reg[3];
			6:uart_tx <= data_byte_reg[4];
			7:uart_tx <= data_byte_reg[5];
			8:uart_tx <= data_byte_reg[6];
			9:uart_tx <= data_byte_reg[7];
			10:uart_tx <= STOP_BIT;
			default:uart_tx <= 1'b1;
    endcase
    end
end

endmodule
