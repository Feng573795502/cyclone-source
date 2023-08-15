module ad7606(
	input clk,
	input rst_n,
	
	input busy,
	input rdreq,
	input [15:0]data_in,
	
	//adc时钟
	output clk_adc,
	output conv,
	
	
	output [15:0]ad_data,
	output [5:0]rdusedw
);

//50Mhz  => 200K
parameter PULSE = 8'd125;

//计数器
reg [7:0]cnt;

//状态
reg [2:0] mode;

//引脚打拍 用于捕获busy
reg busy_dly1;
reg busy_dly2;

//读取信号
reg read_siganl;

//读取计数
reg [5:0]read_cnt;

//写请求
reg wrreq;

reg clk_25m;

wire clk_25  = clk_25m;

wire reset = ~rst_n;

ad_fifo ad_fifo(
	.aclr(reset),
	.data(data_in),
	.rdclk(clk_25m),
	.rdreq(rdreq),
	
	.wrclk(clk_25m),
	.wrreq(wrreq),
	.q(ad_data),
	.rdusedw(rdusedw)
	);

//输出读取信号
assign conv = (cnt < 2 ? 1'b0 : 1'b1);

assign clk_adc = (mode) ? clk_25m : 1'b1;
//捕获下拉信号
always @(posedge clk_25 or negedge rst_n)begin
	if(!rst_n)begin
		busy_dly1 <= 1'b0;
		busy_dly1 <= 1'b0;
	end
	else begin
		busy_dly1 <= busy;
		busy_dly2 <= busy_dly1;
	end
end

//assign read_siganl = (!busy_dly1 & busy_dly2);  //下降沿

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
			mode  <= 3'd0;
			wrreq <= 1'b0;
		end
	else begin
		case(mode)
			0: begin
				if(read_siganl) begin
					wrreq <= 1'b1;
					mode <= 1;
				end
				else begin 
					wrreq <= 1'b0;
					mode <= 0;
				end
			end
			
			1:begin
//				ex_clk <= ad_clk;
//				case(read_cnt)
//					0,1:  ad_clk <= 0;
//					2,3:  ad_clk <= 1;
//
//					4,5:  ad_clk <= 0;
//					6,7:  ad_clk <= 1;
//
//					8,9:  ad_clk <= 0;
//					10,11:ad_clk <= 1;
//
//					12,13:ad_clk <= 0;
//					14,15:ad_clk <= 1;
//
//					16,17:ad_clk <= 0;
//					18,19:ad_clk <= 1;
//
//					20,21:ad_clk <= 0;
//					22,23:ad_clk <= 1;
//
//					24,25:ad_clk <= 0;
//					26,27:ad_clk <= 1;
//
//					28,29:ad_clk <= 0;
//					30,31:ad_clk <= 1;
//				endcase
//				if(read_cnt[1:0] == 2'b10)
//					wrreq <= 1;
					
					if(read_cnt == 7)begin
						wrreq <= 1'b0;
						mode  <= 1'b0;
					end
			end
		endcase
	end
end

endmodule


