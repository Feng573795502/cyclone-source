module phy_config(
	input clk,
	input rst_n,
	
	
	output phy_rst_n,
	output mdc,
	inout  mdio,
	output init_done
	);
	
	//时钟寄存器
	reg mdc_clk;
	
	//寄存器数据和
	reg  [15:0]reg_data;
	reg  [15:0]mdio_data;
	
	//启动和完成
	reg  start;
	wire done;
	
	//时钟反转标志
	wire mdc_pulse;
	
	//mdc时钟控制
	parameter SYS_CLOCK = 50_000_000;
	parameter SCL_CLOCK = 30_000;
	parameter SCL_CNT_M = SYS_CLOCK / SCL_CLOCK / 2 - 1;
	
	//寄存器数量
	parameter MAX_CNT = 1;
	
	//时钟计数器
	reg [19:0] div_cnt;
	
	//状态机启动
	wire go;
	wire [15:0]rddata;
	reg [15:0] cnt;
	reg [4:0]  reg_addr;
	
	//状态机状态和寄存器发送计数
	reg [1:0]state;
	reg [2:0]reg_cnt;
	
	mdio_bit_shift mdio_bit_shift(
		.rst_n(rst_n),

		.mdc(mdc),
		.mdio(mdio),
		
		.if_read(1'b0),
		.phy_addr(5'b00001),
		.reg_addr(reg_addr),
		.mdio_data(mdio_data),
		.rddata(rddata),
		.start(start),
		.done(done)
	);
	
	assign init_done = (reg_cnt == MAX_CNT);
	
	//时钟计算
	assign mdc_pulse = (div_cnt == SCL_CNT_M);
	//时钟
	assign mdc = mdc_clk;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			div_cnt <= 20'd0;
		else if(div_cnt < SCL_CNT_M)
			div_cnt <= div_cnt + 1'b1;
		else 
			div_cnt <= 20'd0;
	end
	
	//时钟反转
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			mdc_clk <= 1'b0;
		else if(mdc_pulse)
			mdc_clk <= ~mdc_clk;
	end
	
	
	//计数器 主状态机 用作设备复位和启动
	assign phy_rst_n = (cnt > 'd400);
	assign go = (cnt > 'd2000 - 1'b1);
	always @ (posedge mdc or negedge rst_n)begin 
		if(!rst_n)
			cnt <= 0;
		else if(cnt < 16'd2000)
			cnt <= cnt + 1'b1;
	end
	
	//主函数
	always @(posedge mdc) begin
		if(!go)begin
			state   <= 0;
			start   <= 0;
			reg_cnt <= 0;
		end
		else if(reg_cnt < MAX_CNT)begin
			case(state)
				0:begin
					start <= 1;
					state <= 1;
					mdio_data <= reg_data;
				end
				
				1:begin
					if(done)begin
						start <= 0;
						state <= 0;
						reg_cnt <= reg_cnt + 1'b1;
					end
				end
			endcase
		end
	end
		
	//phy 寄存器数据
	always @(reg_cnt)begin
		case (reg_cnt)
			0: begin 
				reg_addr <= 5'd0;
				reg_data <= 16'h1200;
			end
			default: reg_data <= 24'h008000;
		endcase
	end
	
endmodule
