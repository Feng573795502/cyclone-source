module lvds_align(
	input       rx_clk,          //接输出时钟,因为输入模块接的也是输出时钟
	input       [9:0]rx_data,    //rx接收数据
	input       rst_n,           //rx初始化完成标志 用于rst_n
	input       data_cnt_done,   //数据cnt完成
	output reg  clk_align_done,      //数据对齐完成输出
	output reg  rx_data_align    //接收数据对其输出
);

//同步码
	parameter comma1 = 10'b01_0111_1100,
				 comma2 = 10'b10_1000_0011;

	reg [4:0]  cnt;
	wire       realign;
	reg [2:0]  judge_done;

	//对其未完成 累加
	always @(posedge rx_clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 5'b0;
			else if(clk_align_done)         //校准完成不在操作
			cnt <= 5'b0;
		else 
			cnt <= cnt + 1'b1;           
	end
 
	//发出同步信号
	always @(posedge rx_clk or negedge rst_n)begin
		if(!rst_n)
			rx_data_align <= 1'b0;
		else if(cnt == 10)
			rx_data_align <= 1'b1;
		else
			rx_data_align <= 1'b0;     
	end

	always @(posedge rx_clk or negedge rst_n)begin
	if(!rst_n)
		judge_done <= 3'b0;
	else if((cnt == 16)&&(rx_data == comma1 || rx_data == comma2)) //数据准确
		judge_done[0] <= 1'b1;
	else if((cnt == 17)&&(rx_data == comma1 || rx_data == comma2)) 
		judge_done[1] <= 1'b1;
	else if((cnt == 18)&&(rx_data == comma1 || rx_data == comma2)) 
		judge_done[2]<=1'b1;
	else if(cnt == 10) //重新开始了校准
		judge_done <= 3'b0;
	end
	
	//校准查看
	always @(posedge rx_clk or negedge rst_n)  begin
		if(!rst_n)
			clk_align_done <= 1'b0;
		else if(!data_cnt_done) 
			clk_align_done <= 1'b0;
		else if(cnt == 19) begin
			if(judge_done == 3'b111)  //校准完成
				clk_align_done <= 1'b1;
			else 
				clk_align_done <= 1'b0;   
		end
		else 
			clk_align_done <= clk_align_done; 
	end
endmodule 