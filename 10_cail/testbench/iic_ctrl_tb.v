`timescale 1ns / 1ps
`define CLK_PERIOD 20
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/13 08:44:32
// Design Name: 
// Module Name: iic_ctrl_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module iic_ctrl_tb(

    );
    
    reg clk;
	reg rst_n;
	reg w_req;
	reg r_req;
	reg [15:0]reg_addr;
	reg addr_mode;
	reg [7:0]wr_data;
	wire [7:0]rd_data;
	reg [7:0]device_id;
	wire wr_done;
	wire ack;
	wire r_valid;
	reg [5:0]r_num;
	wire iic_clk;
	wire iic_sda;
	
	pullup PUP(iic_sda);
	
iic_ctrl iic_ctrl_inst(
    .clk(clk),
    .rst_n(rst_n),
    
    .w_req(w_req),
    .r_req(r_req),
    .device_id(device_id),
    .reg_addr(reg_addr),
    .addr_mode(addr_mode),
    .wr_done(wr_done),
    .ack(ack),
    .r_valid(r_valid),
	 .r_num(r_num),
    .wr_data(wr_data),
    .rd_data(rd_data),

    .iic_sda(iic_sda),
    .iic_clk(iic_clk)
    );
	
	M24LC04B M24LC04B(
		.A0(0), 
		.A1(0), 
		.A2(0), 
		.WP(0), 
		.SDA(iic_sda), 
		.SCL(iic_clk), 
		.RESET(~rst_n)
	);
	
    initial clk = 1;
    always #(`CLK_PERIOD/2) clk = ~clk;
    
    initial begin
			rst_n = 0;
			w_req = 0;
			r_req = 0;
			wr_data = 0;

			#(`CLK_PERIOD*20);
			rst_n = 1;
			#2000;
			write_one_byte(0,8'hA0,16'h0A,8'hd1);
			write_one_byte(0,8'hA0,16'h0B,8'hd2);
			write_one_byte(0,8'hA0,16'h0C,8'hd3);
			write_one_byte(0,8'hA0,16'h0F,8'hd4);
			#2000000;
//        r_req = 1;
//        addr_mode = 0;
//        device_id = 8'h22;
//        wr_data = 8'hf8;
//        reg_addr = 16'h1234;
//		  r_num    = 1;
//        while(wr_done == 0)
//            #10;
//        r_req = 0;
//        #100;
        $stop;
    end
	 
	 
	task write_one_byte;
	    input mode;
		input [7:0]id;
		input [15:0]mem_address; 
		input [7:0]data;
		begin
			reg_addr = mem_address;
			device_id = id;
			addr_mode = mode;
			wr_data = data;
			w_req = 1;
			#20;
			w_req = 0;
			@(posedge wr_done);
			#5000000;
		end
	endtask
endmodule
