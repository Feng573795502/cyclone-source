module eeprom_ctrl(
	input clk,
	input rst_n,
	
	input  wr_req,      //写入、读取、更新请求
	input  rd_req,
	input  update_req,
	
	output reg init_done,
	
	input [9:0]wr_addr,
	input [9:0]rd_addr,
	
	input [7:0]wr_data,
	output reg [7:0]rd_data,
	
	output iic_clk,
	inout  iic_sda
);

	//与IIC控制器连接
	reg  ee_w_req;
	reg  ee_r_req;
	wire ee_wr_done;
	wire ee_rvalid;
	wire ee_wvalid;
	reg [7:0]ee_w_num;
	reg [7:0]ee_r_num;
	reg [7:0]ee_w_data;
	wire [7:0]ee_r_data;
	
	reg ee_rvalid_dly;
	reg ee_wvalid_dly;
	reg ee_wr_done_dly;
	reg [7:0]ee_r_data_dly;
	
	//ram
	reg  [7:0]ram_w_data;
	wire [7:0]ram_r_data;
	reg  [9:0]ram_w_addr_dly;
	reg  [9:0]ram_w_addr;
	reg  [9:0]ram_r_addr;
	reg  [9:0]ram_r_addr_dly;
	reg  ram_wr;
	
	reg [9:0]wr_addr_dly;
	reg [9:0]rd_addr_dly;
	reg wr_req_dly;
	reg rd_req_dly;
	
	reg [7:0]wr_data_dly;
	reg [4:0]state;
	
	localparam EEPROM_ID = 8'hA0;
				  
	localparam 
		IDLE   = 5'b00001,
		INIT   = 5'b00010,
		WR_RAM = 5'b00100,
		RD_RAM = 5'b01000,
		SAVE   = 5'b10000;
		
	parameter RST_TIME = 18'd2;
	reg [18:0]rst_cnt;
	
	
	//上电初始化
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rst_cnt <= 19'b0;
		else if(rst_cnt < RST_TIME)
			rst_cnt <= rst_cnt + 1'b1;
		else 
			rst_cnt <= RST_TIME + 1'b1;
	end
	
	//eeprom输出打拍
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			ee_rvalid_dly  <= 1'b0;
			ee_wvalid_dly  <= 1'b0;
			ee_wr_done_dly <= 1'b0;
			ee_r_data_dly  <= 8'b0;
		end
		else begin
			ee_rvalid_dly  <= ee_rvalid;
			ee_wvalid_dly  <= ee_wvalid;
			ee_wr_done_dly <= ee_wr_done;
			ee_r_data_dly  <= ee_r_data;
		end
	end
	
	//打拍
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			wr_req_dly <= 1'b0;
			rd_req_dly <= 1'b0;
			wr_addr_dly <= 10'b0;
			rd_addr_dly <= 10'b0;
			wr_data_dly <= 8'b0;
		end
		else begin
			wr_req_dly <= wr_req;
			rd_req_dly <= rd_req;
			wr_addr_dly <= wr_addr;
			rd_addr_dly <= rd_addr;
			wr_data_dly <= wr_data;
			
		end
	end
	
	//对外输出数据
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			rd_data    <= 8'b0;
		end
		else 
			rd_data    <= ram_r_data;
	end
	
	//主状态机
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			state <= IDLE;
			ee_w_req <= 1'b0;
			ee_r_req <= 1'b0;
			ram_r_addr <= 'b0;
			ram_w_data <= 'b0;
			ee_w_num   <= 'b0;
			ee_w_data  <= 'b0;
			ee_r_num   <= 'b0;
		end
		else begin
			case(state)
				IDLE:begin
					ram_wr         <= 1'b0;
					init_done      <= 1'b0;
					if(rst_cnt == RST_TIME)begin
						state <= INIT;
						ee_r_num       <= 'd6;						//读取192个数据
						ee_r_req       <= 1'b1;
						ram_w_addr_dly <= 10'b0;
						ram_w_addr     <= 10'b0;
					end
					else if(rd_req_dly)begin                  //读数据
						state <= RD_RAM;
						ram_r_addr <= rd_addr_dly;
					end
					else if(wr_req_dly)begin                  //写请求
						state      <= WR_RAM;
						ram_wr     <= 1'b1;
						ram_w_addr <= wr_addr_dly;
						ram_w_data <= wr_data_dly;
					end
					else if(update_req)begin                 //写入请求
						state <= SAVE;
						ee_w_num       <= 'd6;
						ee_w_req       <= 1'b1;
						ram_r_addr     <= 10'b0;
					end
				end
				
				INIT:begin  //从ee写入ram
					ee_r_req          <= 1'b0;
					if(ee_rvalid_dly)begin
						ram_wr         <= 1'b1;
						//ram_w_data     <= ee_r_data_dly;
						ram_w_data     <= ram_w_addr_dly + 'd10;  //测试 后续改回上面的
						ram_w_addr_dly <= ram_w_addr_dly + 1'b1;
						ram_w_addr     <= ram_w_addr_dly;
					end
					else 
						ram_wr         <= 1'b0;
					if(ee_wr_done_dly)begin
						state          <= IDLE;
						init_done      <= 1'b1;
					end
				end
				
				RD_RAM:begin
					if(rd_req_dly == 1'b0)
						state <= IDLE;
					else 
						ram_r_addr <= rd_addr_dly;
				end
				
				WR_RAM:begin
					ram_w_addr <= wr_addr_dly;
					ram_w_data <= wr_data_dly;
					if(wr_req_dly == 1'b0)begin
						ram_wr <= 1'b0;
						state  <= IDLE;
					end
				end
				
				SAVE:begin
					ee_w_req <= 1'b0;
					ee_w_data <= ram_r_data;
					
					if(ee_wvalid_dly)begin
						ram_r_addr <= ram_r_addr + 1'b1;
					end
					if(ee_wr_done_dly)begin
						state          <= IDLE;
					end
				end
			
			endcase
			
		end
	
	end

	
	always@(posedge clk or negedge rst_n)begin
		
	end
	
	//连接eeporm
	iic_ctrl iic_ctrl(
		.clk(clk),
		.rst_n(rst_n),
		
		.w_req(ee_w_req),
		.r_req(ee_r_req),
		.device_id(EEPROM_ID),
		.reg_addr(16'h00),
		.addr_mode(1'b0),
		.wr_done(ee_wr_done),
		.ack(),
		.r_valid(ee_rvalid),
		.w_valid(ee_wvalid),
		
		.w_num(ee_w_num),
		.r_num(ee_r_num),
		
		.wr_data(ee_w_data),
		.rd_data(ee_r_data),
		
		.iic_sda(iic_sda),
		.iic_clk(iic_clk)
	);
	
	wire [7:0]data;
	
	//内存 直接用ram会导致无法更新到寄存器和eeprom读取出来
	cail_param cail_param(
		.clock(clk),
		.data(ram_w_data),
		.rdaddress(ram_r_addr),
		.wraddress(ram_w_addr),
		.wren(ram_wr),
		.q(ram_r_data)
	);
	
endmodule
