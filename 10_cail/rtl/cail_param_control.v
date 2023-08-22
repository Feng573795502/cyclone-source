module cail_param_control(
	clk,
	rst_n,
	
	wr_req,
	rd_req,
	
	ch,    //通道
	type,  //类型
	mult,
	
	in_data,
	result,
	
	iic_clk,
	iic_sda
);

	input clk;
	input rst_n;
	
	input  wr_req;
	input  rd_req;
	
	input [3:0]ch;
	input [1:0]type;
	input mult;
	
	input  [31:0]in_data;
	output reg [31:0]result;
	
	output iic_clk;
	inout  iic_sda;
	
	//与IIC控制器连接
	reg ee_w_req;
	reg ee_r_req;
	wire ee_wr_done;
	
	wire ee_rvalid;
	wire ee_wvalid;
	
	reg [5:0]w_num;
	reg [5:0]r_num;
	
	wire [7:0]wr_data;
	wire [7:0]rd_data;
	
	wire   [8:0]ch_pos;
	
	reg [31:0]cnt;
	
	localparam EE_ID = 8'hA0,
				  EE_ADDR = 16'h00;
				  
	localparam 
		IDLE   = 4'b0001,
		INIT   = 4'b0010,
		SAVE   = 4'b0100;
		
	parameter RST_TIME = 18'd249_999;
	reg [18:0]rst_cnt;
	
	reg [9:0]rdaddress;
	reg [9:0]wraddress;
	
	reg [3:0]state;
	
	//上电初始化
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rst_cnt <= 19'b0;
		else if(rst_cnt < RST_TIME)
			rst_cnt <= rst_cnt + 1'b1;
		else 
			rst_cnt <= RST_TIME + 1'b1;
	end
		
	//从eeprom中读取数据出来
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			wraddress <= 10'b0;
		else if(state == INIT)begin
			if(ee_rvalid)begin
				wraddress <= wraddress + 1'b1;
			end
		end
		else 
			wraddress <= 10'b0;
			
	end
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			state <= IDLE;
		else begin
			case (state)
				IDLE:begin
					if(rst_cnt == RST_TIME)begin
						state <= INIT;
						r_num <= 192;
						ee_r_req <= 1'b1;
					end
				end
				
				INIT:begin
				ee_r_req <= 1'b0;
				if(ee_wr_done == 1)
					state <= IDLE;
				end
				
			endcase
		end
	end
	
	//连接eeporm
	iic_ctrl iic_ctrl(
		.clk(clk),
		.rst_n(rst_n),
		
		.w_req(ee_w_req),
		.r_req(ee_r_req),
		.device_id(EE_ID),
		.reg_addr(EE_ADDR),
		.addr_mode(1'b0),
		.wr_done(ee_wr_done),
		.ack(ack),
		.r_valid(ee_rvalid),
		.w_valid(ee_wvalid),
		
		.w_num(w_num),
		.r_num(r_num),
		
		.wr_data(wr_data),
		.rd_data(rd_data),
		
		.iic_sda(iic_sda),
		.iic_clk(iic_clk)
	);
	
	wire [7:0]data;
	
	
	//内存 直接用ram会导致无法更新到寄存器和eeprom读取出来
	cail_param cail_param(
		.clock(clk),
		.data(data),
		.rdaddress(rdaddress),
		.wraddress(wraddress),
		.wren(ee_rvalid),
		.q(wr_data)
	);
	
	
	
endmodule
