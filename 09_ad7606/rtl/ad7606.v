module ad7606(
	input clk,
	input rst_n,
	
	input busy,
	
	input [15:0]data_in,
	
	output conv,
	output reg [0:0]ad_clk,
	
	output reg[15:0]ad_data,
	
	
);

//50Mhz  => 200K

parameter PULSE = 8'd250;

reg [7:0]cnt;
reg [2:0] mode;

reg busy_dly1;
reg busy_dly2;

reg read_siganl;

reg [5:0]read_cnt;

reg rd_en;

ad_fifo ad_fifo(
	.aclr(rst_n),
	.data(data_in),
	.rdclk(),
	.rdreq(rd_en),
	.wrclk,
	.wrreq,
	.q,
	.rdusedw);

//捕获下拉信号
always @(posedge clk or negedge rst_n)begin
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

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt <= 8'd0;
	else if(cnt < (PULSE - 1'b1))
		cnt <= cnt + 1'b1;
	else 
		cnt <= 8'd0;
end

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		read_siganl <= 1'b0;
	else if(cnt == 1)
		read_siganl <= 1'b1;
	else 
		read_siganl <= 1'b0;
end


assign conv = (cnt < 5 ? 1'b0 : 1'b1);

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		read_cnt <= 6'd0;
	else if(mode == 1)
		read_cnt <= read_cnt + 1'b1;
	else 
		read_cnt <= 6'd0;
end

//主状态机
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
			mode <= 3'd0;
			ad_clk <= 1;
		end
	else begin
		case(mode)
			0: begin
				if(read_siganl) 
					mode = 1;
				else 
					mode = 0;
			end
			
			1:begin
				case(read_cnt)
					0,1:  ad_clk <= 0;
					2,3:  ad_clk <= 1;
					
					4,5:  ad_clk <= 0;
					6,7:  ad_clk <= 1;
					
					8,9:  ad_clk <= 0;
					10,11:ad_clk <= 1;
					
					12,13:ad_clk <= 0;
					14,15:ad_clk <= 1;
					
					16,17:ad_clk <= 0;
					18,19:ad_clk <= 1;
					
					20,21:ad_clk <= 0;
					22,23:ad_clk <= 1;
					
					24,25:ad_clk <= 0;
					26,27:ad_clk <= 1;
					
					28,29:ad_clk <= 0;
					30,31:ad_clk <= 1;
				endcase
				
				if(read_cnt[1:0] == 2'b10)
					rd_en <= 1;
				else 
					rd_en <= 0;
					
					if(read_cnt == 31)
						mode <= 0;
			end
		endcase
	end
end

endmodule


