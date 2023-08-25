module iic_ctrl(
	clk,
	rst_n,
	
	w_req,
	r_req,
	device_id,
	reg_addr,
	addr_mode,
	wr_done,
	ack,
	r_valid,
	w_valid,
	
	w_num,
	r_num,
	
	wr_data,
	rd_data,
	
	iic_sda,
	iic_clk
	);
	
	input clk;
	input rst_n;
	
	input w_req;
	input r_req;
	
	//读ID
	input [7:0] device_id;
	input [15:0]reg_addr;
	input addr_mode;

	output reg wr_done;
	output reg ack;
	output reg r_valid; //读有效值输出
	output reg w_valid;
	input [7:0]w_num;
	input [7:0]r_num;
	
	//读写数据
	input [7:0]wr_data;
	output reg [7:0]rd_data;
	
	output    iic_clk;
	inout     iic_sda;
	
	//连接部分
	reg  [5:0]cmd;
	reg  [7:0]tx_data;
	wire [7:0]rx_data;
	reg       go;
	wire      trans_done;
	wire      ack_o;
	
	wire [15:0]addr;
	
	reg [5:0]  r_cnt;
	reg [5:0]  w_cnt;
	
	//8bit的时候需要做高低位互换保证输出是低位
	assign addr = addr_mode ? reg_addr : {reg_addr[7:0],reg_addr[15:8]};
	
	localparam
		WR   = 6'b000001,   //写请求
		STA  = 6'b000010,   //起始位请求
		RD   = 6'b000100,   //读请求
		STO  = 6'b001000,   //停止位请求
		ACK  = 6'b010000,   //应答位请求
		NACK = 6'b100000;   //无应答请求
	
	localparam
		IDLE         = 5'b00001,   //空闲状态
		WR_REG       = 5'b00010,   //写寄存器状态
		WAIT_WR_DONE = 5'b00100,   //等待写寄存器完成状态
		RD_REG       = 5'b01000,   //读寄存器状态
		WAIT_RD_DONE = 5'b10000;   //等待读寄存器完成状态
	
	reg [4:0]state;
	reg [7:0]cnt;
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			wr_done <= 1'b0;
			ack     <= 1'b0;
			go      <= 1'b0;
			rd_data <= 8'b0;
			state   <= IDLE;
			r_cnt   <= 6'b0;
			w_cnt   <= 6'b0;
			r_valid <= 1'b0;
			w_valid <= 1'b0;
		end
		else begin
			case(state)
				IDLE:begin
					cnt     <= 8'd0;
					ack     <= 1'b0;
					wr_done <= 1'b0;
					r_valid <= 1'b0;
					
					if(w_req)
						state <= WR_REG;
					else if(r_req)
						state <= RD_REG;
					else 
						state <= IDLE;
				end
				
				WR_REG: begin
					state <= WAIT_WR_DONE;
					w_valid <= 1'b0;
					case(cnt)
						0:write_byte(STA | WR, device_id);
						1:write_byte(WR, addr[15:8]);
						2:begin 
							write_byte(WR, addr[7:0]);
							w_cnt <= 6'b0;
						end
						
						default: begin

							if(w_cnt == w_num - 1)  //最后一个 直接写入
								write_byte(WR | STO, wr_data);
							else 
								write_byte(WR, wr_data);
						end
						
					endcase
				end
				
				WAIT_WR_DONE:begin
					go <= 1'b0;
					if(trans_done == 1'b1)begin
						ack <= ack | ack_o;
						case(cnt)
							0:begin 
								state <= WR_REG;
								cnt <= 1;
							end
							
							1:begin
								state <= WR_REG;
								
								if(addr_mode)
									cnt <= 2;
								else begin
									w_valid <= 1'b1;
									cnt <= 3;
								end
							end
							
							2:begin 
								state <= WR_REG;
								cnt <= 3;
								w_valid <= 1'b1;
							end
							
							default :begin
								
								cnt     <= cnt + 1'b1;
								w_cnt   <= w_cnt + 1'b1;
								
								if(w_cnt == w_num - 1)begin
									state   <= IDLE;
									wr_done <= 1'b1;
								end
								else begin
									w_valid <= 1'b1;
									state  <= WR_REG;
								end
							end
							
						endcase
					end
					else begin
						state   <= WAIT_WR_DONE;
						w_valid <= 1'b0;
					end
				end
				
				RD_REG:begin
					state <= WAIT_RD_DONE;
					case(cnt)
						0:write_byte(STA | WR, device_id);
						1:write_byte(WR, addr[15:8]);
						2:write_byte(WR, addr[7:0]);
						3:begin 
							write_byte(STA | WR, device_id | 8'd1); 
							r_cnt <= 6'b0;
						end
						
						default: begin
							r_valid <= 1'b0;
							if(r_cnt == r_num - 1)
								read_byte(RD | NACK | STO);
							else 
								read_byte(RD | ACK);
						end
					endcase
				end
				
				WAIT_RD_DONE:begin
					go <= 0;
					if(trans_done == 1'b1)begin
						ack <= ack | ack_o;
						case(cnt)
							0:begin
								state <= RD_REG;
								cnt   <= 1;
							end
							
							1:begin 
								state <= RD_REG;
								if(addr_mode)
									cnt <= 2;
								else 
									cnt <= 3;
							end
							
							2:begin
								state <= RD_REG;
								cnt   <= 3;
							end
							
							3:begin 
								state <= RD_REG;
								cnt   <= 4;
							end
							
							default :begin
								rd_data <= rx_data;
								r_valid <= 1'b1;
								
								cnt <= cnt + 1'b1;
								r_cnt <= r_cnt + 1'b1;
								if(r_cnt == r_num - 1)begin
									state <= IDLE;
									wr_done <= 1'b1;
								end
								else
									state <= RD_REG;
								end
						endcase
						
					end
					else begin
						state <= WAIT_RD_DONE;
						r_valid <= 1'b0;
					end
				end
				default: state <= IDLE;
				
			endcase
		
		end
			
	end
	
	task write_byte;
		input [5:0]ctrl_cmd;
		input [7:0]data;
		
		begin
			cmd <= ctrl_cmd;
			tx_data <= data;
			go <= 1'b1;
		end
		
	endtask
			
	task read_byte;
		input [5:0]ctrl_cmd;
		
		begin
			cmd <= ctrl_cmd;
			go <= 1'b1;
		end
		
	endtask
	
iic_bit_shift iic_bit_shift(
		 .clk(clk),
		 .rst_n(rst_n),
		 
		 .cmd(cmd),
		 .go(go),
		 .rx_data(rx_data),
		 .tx_data(tx_data),
		 
		 .trans_done(trans_done),
		 .ack_o(ack_o),
		 .iic_clk(iic_clk),
		 .iic_sda(iic_sda)
    );
	
	endmodule