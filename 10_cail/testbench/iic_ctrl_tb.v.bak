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
	reg reset_n;
	reg w_reg;
	reg r_reg;
	reg [15:0]reg_addr;
	reg addr_mode;
	reg [7:0]wr_data;
	wire [7:0]rd_data;
	reg [7:0]device_id;
	wire wr_done;
	wire ack;
	wire iic_clk;
	wire iic_sda;
	
	pullup PUP(iic_sda);
	
iic_ctrl iic_ctrl_inst(
    .clk(clk),
    .reset_n(reset_n),
    
    .w_reg(w_reg),
    .r_reg(r_reg),
    .device_id(device_id),
    .reg_addr(reg_addr),
    .addr_mode(addr_mode),
    .wr_done(wr_done),
    .ack(ack),
    
    .wr_data(wr_data),
    .rd_data(rd_data),

    .iic_sda(iic_sda),
    .iic_clk(iic_clk)
    );
	
    initial clk = 1;
    always #(`CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        reset_n = 0;
        w_reg = 0;
        r_reg = 0;
        wr_data = 0;
        
        #(`CLK_PERIOD*20);
        reset_n = 1;
        w_reg = 1;
        addr_mode = 1;
        device_id = 8'h11;
        wr_data = 8'h23;
        reg_addr = 16'h1234;
        while(wr_done == 0)
            #10;
        w_reg = 0;
        #100;
        
        w_reg = 1;
        addr_mode = 0;
        device_id = 8'h22;
        wr_data = 8'hf8;
        reg_addr = 16'h1234;
        while(wr_done == 0)
            #10;
        w_reg = 0;
        #100;
        
        r_reg = 1;
        addr_mode = 0;
        device_id = 8'h22;
        wr_data = 8'hf8;
        reg_addr = 16'h1234;
        while(wr_done == 0)
            #10;
        w_reg = 0;
        #100;
        $stop;
    end
endmodule
