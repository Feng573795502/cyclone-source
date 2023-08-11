module ads_ctrl(
		input clk,
		input rst_n,
		input wr_req,
		input rd_req,
		//input access_start,
		//input cfg_valid,
		//input [7:0]cfg_data,
		output[15:0] ad_voltage,
		output ads_scl,
		inout ads_sda
		//output s_ready
);

  // clk=10M   clk_200k=200k  clk_div=50 ads_scl=100k
  parameter clk_div=50;
   reg clk_200k;
   reg [6:0]counter;
   always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
			counter<=0;
			end
		else if (counter==clk_div/2-1)
		    begin
			counter<=0;
			end
		else	
			begin
			counter<=counter+1'b1;
			end
	end
	  // generate clock=200khz 
	always@(posedge clk or negedge rst_n)
	begin
	    if(!rst_n)
		   begin
		    clk_200k<=1'b0;
		   end
		else if(counter==24) // count value between 0-24
			begin
			    clk_200k<=~clk_200k;
			end
		else
			clk_200k<=clk_200k;
	end
	 // scl=100khz
	reg scl;
	always@(posedge clk_200k or negedge rst_n)
		begin
			if(!rst_n)
			scl<=1'b1;
			else
			scl<=~scl;
		end
	// scl output	
	reg scl_delay;
	always@(negedge clk_200k or negedge rst_n)
		begin
			if(!rst_n) 
			   scl_delay<=1'b1;
			else
				scl_delay<=scl;
		end
			
    reg iicwr_req;
	reg iicrd_req;
	wire iic_wr_en_pos,iic_rd_en_pos;
	reg iic_wr_en_r0,iic_wr_en_r1;
	reg iic_rd_en_r0,iic_rd_en_r1;	
	always@ (posedge clk or negedge rst_n)
		begin
		    if(!rst_n)
			 begin
				iic_rd_en_r0<=1'b0;
				iic_rd_en_r1<=1'b0;
			 end
			else
			  begin
			     iic_rd_en_r0<=rd_req;
				 iic_rd_en_r1<=iic_rd_en_r0;
			  end
		end
	assign iic_rd_en_pos=(~iic_rd_en_r1&&iic_rd_en_r0); //读使能上升沿
    
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
			 begin
				iic_wr_en_r0<=1'b0;
				iic_wr_en_r1<=1'b0;
			 end
			else
			 begin
			     iic_wr_en_r0<=wr_req;
				 iic_wr_en_r1<=iic_wr_en_r0;
			 end
		end
	assign iic_wr_en_pos=(~iic_wr_en_r1&&iic_wr_en_r0);	
	
    wire iic_ack;	
	always@(negedge clk or negedge rst_n)
		begin
			if(!rst_n)
			 begin
			 iicwr_req<=1'b0;
			 end
			else
			begin
				if(iic_wr_en_pos==1'b1)					
				iicwr_req<=1'b1;
				else if(iic_ack==1'b1)
				iicwr_req<=1'b0;
				else 
				iicwr_req<=iicwr_req;
			end
		end
	always@(negedge clk or negedge rst_n)
		begin
			if(!rst_n)
			 begin
			 iicrd_req<=1'b0;
			 end
			else
			begin
				if(iic_rd_en_pos==1'b1)					
				iicrd_req<=1'b1;
				else if(iic_ack==1'b1)
				iicrd_req<=1'b0;
				else 
				iicrd_req<=iicrd_req;
			end
		end	
	
	// scl generate
	
	reg [4:0] state;
	reg[4:0] state_next;
	parameter   IDLE=5'd0,
				STR=5'd1,
				ADDR=5'd2,  // slave write address
				S_ACK0=5'd3, 
				APRADDR=5'd4,// address point register address
				S_ACK1=5'd5,
				//START1=5'd6,
				ADDR1=5'd6, // slave read address
				S_ACK2=5'd7,
				RX_D1=5'd8,
				M_ACK0=5'd9,
				RX_D2=5'd10,
				M_ACK1=5'd11,
				TX_D1=5'd12,
				S_ACK3=5'd13,
				TX_D2=5'd14,
				S_ACK4=5'd15,
				STOP=5'd16,
				ERROR1=5'd17;
		
	// state machine contrvl signal
	
	reg start; 
	reg sda_latch;
//	assign idle_wait=(state==IDLE) ? 1'b1 :1'b0;
  wire state_stop;
  assign state_stop=(state==STOP)?1'b1:1'b0;
	always@ (negedge clk or negedge rst_n)
		begin
			if(!rst_n)
				start<=1'b0;
			else if(iic_wr_en_pos||iic_rd_en_pos)
				start<=1'b1;
			else if(state_stop)
				start<=1'b0;
			else	
			    start<=start;
		end	
		
     // state machine 
	always@(posedge scl or negedge rst_n)
		begin
			if(!rst_n)
			 state<=IDLE;
			else
			 state<=state_next;
		end		
	wire byte_end;
	always@(*)
		begin
			case(state)
				IDLE:
					begin
						if(start)
							state_next=STR; // start信号来之前 数据应该准备好
						else 
							state_next=IDLE;
					end
				STR:
					state_next<=ADDR;
				ADDR:
				    begin
						if(byte_end)
							state_next<=S_ACK0;
						else
						   state_next<=ADDR;
					end
				S_ACK0:
					begin
						if(sda_latch==1)
						  state_next<=ERROR1;
						else 
						   state_next<=APRADDR;
					end
				APRADDR:
				    begin
						if(byte_end)
						   state_next<=S_ACK1;
						else 
						   state_next<=APRADDR;						
					end
				S_ACK1:	
					begin
					    if(sda_latch==1)
						  state_next<=ERROR1;						
						else if(iicwr_req)
							state_next<=TX_D1;
						else if(iicrd_req)
							state_next<=ADDR1;
						else 
						    state_next<=IDLE;	
					end
				TX_D1:
					begin
					    if(byte_end)
						  state_next<=S_ACK2;
						else 
						  state_next<=TX_D1;
					end
				S_ACK2:
					begin
						if(sda_latch==1)
						   state_next<=ERROR1;
						else   
						  state_next<=TX_D2;
					end
				TX_D2:
					begin
					    if(byte_end)
						  state_next<=S_ACK3;
						else 
						  state_next<=TX_D2;
					end
				S_ACK3:
					begin
					     if(sda_latch==1)
							state_next<=ERROR1;
						 else
						    state_next<=STOP;
					end
				ADDR1:
					begin
						if(byte_end)
						  state_next<=S_ACK4;
						else
						  state_next<=ADDR1;
					end
				S_ACK4:
					begin
						if(sda_latch==1)
						   state_next<=ERROR1;
						else 
							state_next<=RX_D1;
					end
				RX_D1:
					begin
						if(byte_end)
						 state_next<=M_ACK0;
						else 
						  state_next<=RX_D1;
					end
				M_ACK0:
					begin
						state_next<=RX_D2;
					end
				RX_D2:
					begin
						if(byte_end)
						  state_next<=M_ACK1;
						else
						  state_next<=RX_D2;
					end
				M_ACK1:
				    state_next<=STOP;
				STOP:
					state_next<=IDLE;
				default:
					state_next<=state;					
			endcase		
		end
	
	assign iic_ack=(state==STOP)?1'b1:1'b0; // 读写使能信号 间隔必须很长，否则一起复位
    // SDA output
		reg sda;
		reg highz_en;
		reg [2:0] cnt8;
		always@(posedge scl or negedge rst_n)
			begin
				if(!rst_n)
					cnt8<=3'b0;
				else if(cnt8==3'b111)
					cnt8<=3'b0;
				else if((state==ADDR)|| state==APRADDR || state==ADDR1 || state==RX_D1 || state==RX_D2 ||
				state==TX_D1 || state==TX_D2)
					cnt8<=cnt8+1;
				else 
                   cnt8<=3'b0;				
			end
	assign byte_end=(cnt8==3'b111)? 1'b1:1'b0;
	
	wire tx_d1,tx_d2;
	wire addr_wr_sda,addr_rd_sda,apraddr_sda;
    always@(posedge scl or negedge rst_n)
		begin
			if(!rst_n)
				begin
					sda<=1'b1;
					highz_en<=1'b1;
				end
			else
				begin
				highz_en<=1'b0;
					case(state_next)
						IDLE:
							begin
							sda<=1'b1;
							highz_en<=1'b1;
							end
						STR:
							begin
								sda<=1'b0;
							end
						ADDR:
							begin
								sda<=addr_wr_sda;
							end
						ADDR1:
							begin
								sda<=addr_rd_sda;							
							end
						APRADDR:
							begin
								sda<=apraddr_sda;
							end
						S_ACK0:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						S_ACK1:	
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						S_ACK2:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						S_ACK3:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						S_ACK4:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						M_ACK0:
							begin
								sda<=1'b0;
							end
						M_ACK1:
							begin
								sda<=1'b0;
							end
						TX_D1:
							begin
							   sda<=tx_d1;
							end
						TX_D2:
							begin
								sda<=tx_d2;
							end
						RX_D1:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						RX_D2:
							begin
								sda<=1'b1;
								highz_en<=1'b1;
							end
						STOP:
							begin
							    sda<=1'b0;
							end
						default:
							begin
								sda<=1'b0;
								highz_en<=1'b1;
							end
					endcase		
				end
		end
		
	// configuration register 
				
    //读写数据
		parameter S_WR_ADDR=8'b1001_0000,
			  S_APR_CFG=8'b0000_0010,
			  DATA_HIGH=8'b1100_1001,
			  DATA_LOW=8'b1000_0011,
			  S_APR_COV=8'b0000_0000,
			  S_RD_ADDR=8'b1001_0001;		
			  
	reg[7:0] reg_addr_wr; // slave write address 
	reg [7:0]point_reg; // address pointer address
	reg [7:0]reg_addr_rd; // slave read address
	
	reg [7:0] data_h;// high byte  for ads writing 
	reg [7:0] data_l;// low byte for ads writing
	
	reg[7:0] reg_addr_wr_buf; // 
	reg [7:0]point_reg_buf; // 
	reg [7:0]reg_addr_rd_buf; // 
	reg [7:0] data_h_buf;// 
	reg [7:0] data_l_buf;// 
	always@(negedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
				reg_addr_wr_buf<=0;
				point_reg_buf<=0;
				reg_addr_rd_buf<=0;
				data_h_buf<=0;
				data_l_buf<=0;
				end
			else if(iic_wr_en_pos)
				begin
					reg_addr_wr_buf<=S_WR_ADDR;
					point_reg_buf<=S_APR_CFG;	
					data_h_buf<=DATA_HIGH;
					data_l_buf<=DATA_LOW;
				end
			else if(iic_rd_en_pos)
				begin
					reg_addr_wr_buf<=S_WR_ADDR;
					point_reg_buf<=S_APR_COV;
					reg_addr_rd_buf<=S_RD_ADDR;
				end
			else
				begin
				
				reg_addr_wr_buf<=reg_addr_wr_buf;
				point_reg_buf<=point_reg_buf;
				reg_addr_rd_buf<=reg_addr_rd_buf;
				data_h_buf<=data_h_buf;
				data_l_buf<=data_l_buf;
				end				
		end
 
	// ADDR register 
    wire addr_sda;

	//reg [7:0]apraddr_data;
	reg[7:0]tx_data1;
	reg[7:0]tx_data2;
	reg [7:0]addr_wr_data;
	reg [7:0]addr_rd_data;
	reg [7:0]apraddr_data;

			  
	always@(posedge scl or negedge rst_n)
		begin
			if(!rst_n)
			    begin
				 addr_wr_data<=8'b0;
				 apraddr_data<=8'b0;
				 tx_data1<=8'b0;
				 tx_data2<=8'b0;
				end
			else if(state_next==STR&&iicwr_req)
			    begin
				  addr_wr_data<=reg_addr_wr_buf;
				  apraddr_data<=point_reg_buf;
				   tx_data1<=data_h_buf;	
				   tx_data2<=data_l_buf;
				end
			else if(state_next==STR&&iicrd_req)	
					begin
					    addr_wr_data<=reg_addr_wr_buf;
				        apraddr_data<=point_reg_buf; 
                        addr_rd_data<=reg_addr_rd_buf;					
					end	
			else if(state_next==ADDR1)
					 begin
						addr_rd_data[7:1]<=addr_rd_data[6:0];
					 end		
			else if(state_next==ADDR)
				begin
					addr_wr_data[7:1]<=addr_wr_data[6:0];
				end
			else if(state_next==APRADDR)
				begin
					apraddr_data[7:1]<=apraddr_data[6:0];
				end
			else if(state_next==TX_D1)
				begin
					tx_data1[7:1]<=tx_data1[6:0];
					
				end
			else if(state_next==TX_D2)
				begin
				    tx_data2[7:1]<=tx_data2[6:0];
				end
			else 
				begin
					addr_wr_data<=addr_wr_data;
					apraddr_data<=apraddr_data;
					tx_data1<=tx_data1;
					tx_data2<=tx_data2;
				end
				
		end
		assign addr_wr_sda=addr_wr_data[7];
		assign addr_rd_sda=addr_rd_data[7];
		assign apraddr_sda=apraddr_data[7];
		assign tx_d1=tx_data1[7];
		assign tx_d2=tx_data2[7];
	// master receive data,series to paralle
	   reg[7:0] rx_data1;
	   reg [7:0]rx_data2;
	   always@(posedge scl or negedge rst_n)
			begin
				if(!rst_n)
				     begin
						rx_data1<=0;
						rx_data2<=0;
					 end
				else if(state==RX_D1)
					begin
					   rx_data1[0]<=sda_latch;
					   rx_data1[7:1]<=rx_data1[6:0];
					   rx_data2<=rx_data2;
					end
				else if(state==RX_D2)
					begin
						rx_data2[0]<=sda_latch;
						rx_data2[7:1]<=rx_data2[6:0];
						rx_data1<=rx_data1;
					end
				else if(state==IDLE)
					begin
						rx_data1<=0;
						rx_data2<=0;
					end
				else 
					begin
						rx_data1<=rx_data1;
						rx_data2<=rx_data2;
					end					
			end
	//reg sda_latch;
	always@(negedge scl or negedge rst_n) //注意 下降沿采样 
		begin
			if(!rst_n)
				begin
					sda_latch<=1'b0;
				end
			else if(highz_en)
				sda_latch<=ads_sda;
			else 
			    sda_latch<=sda_latch;
    			
		end
	// scl gate	
	reg scl_gate;
	always@(negedge scl or negedge rst_n)
		begin
		   if(!rst_n)
				begin
					scl_gate<=1'b0;
				end
		   else if(state==STR)
				begin
				   scl_gate<=1'b1;
				end
			else if(state==STOP || state== ERROR1)
				begin
				 scl_gate<=1'b0;
				end
			else 
				scl_gate<=scl_gate;
		end
	assign ads_scl=~scl_gate||scl_delay;
	assign ads_sda=highz_en?1'bz:sda;
	
	assign ad_voltage={rx_data1,rx_data2};
	//assign s_ready=(iicwr_req||iicrd_req)?1'b1:1'b0;	//检测到输出上升沿 输出ready信号
endmodule