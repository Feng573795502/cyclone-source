module cail_param_control(
	clk,
	rst_n,
	
	wr_req,
	rd_req,
	
	ch,
	type,
	
	in_data,
	result
//	
//	iic_clk,
//	iic_sda
);

	input clk;
	input rst_n;
	
	input  wr_req;
	input rd_req;
	
//	output iic_clk;
//	inout  iic_sda;
	
	input [3:0]ch;
	input [1:0]type;
	
	input  [31:0]in_data;
	output [31:0]result;
	
	//校准参数一共有 8(min)+8(mult) = 16 * 3 = 48
	reg [7:0]data[0:48];
	
	assign result = {data[ch * 24 + type * 8], data[ch/8], data[ch/8], data[ch/8+1]};
	
	always @(posedge clk)begin
		if(wr_req)begin
			data[3][ch][type] <= in_data[31:24];
			data[2][ch][type] <= in_data[23:16];
			data[1][ch][type] <= in_data[15:8];
			data[0][ch][type] <= in_data[7:0];
		end
	end
//	
	//连接eeporm
//	iic_ctrl iic_ctrl(
//		.clk(clk),
//		.rst_n(rst),
//		
//		.w_req(w_req),
//		.r_req(r_req),
//		.device_id(device_id),
//		.reg_addr(reg_addr),
//		.addr_mode(1'b0),
//		.wr_done(wr_done),
//		.ack(ack),
//		.r_valid(r_valid),
//		.w_valid(w_valid),
//		
//		.w_num(w_num),
//		.r_num(r_num),
//		
//		.wr_data(wr_data),
//		.rd_data(rd_data),
//		
//		.iic_sda(iic_sda),
//		.iic_clk(iic_clk)
//	);
//	
//	input clk;
//	input rst_n;
//	
//	input w_req;
//	input r_req;
//	
//	//读ID
//	input [7:0] device_id;
//	input [15:0]reg_addr;
//	input addr_mode;
//
//	output reg wr_done;
//	output reg ack;
//	output reg r_valid; //读有效值输出
//	output reg w_valid;
//	input [5:0]w_num;
//	input [5:0]r_num;
//	
//	//读写数据
//	input [7:0]wr_data;
//	output reg [7:0]rd_data;
//	
//	output    iic_clk;
//	inout     iic_sda;
	
endmodule
