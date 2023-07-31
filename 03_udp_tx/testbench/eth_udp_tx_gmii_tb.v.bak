`timescale 1ns / 1ps
`define CLK_PERIOD 8
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 14:48:21
// Design Name: 
// Module Name: eth_udp_tx_gmii_tb
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


module eth_udp_tx_gmii_tb();
    reg clk_125m;
    reg rst_n;
    reg tx_en_pulse;
    
    wire tx_done;
    wire payload_req_o;
    reg [7:0]payload_dat_i;
    
    wire gmii_tx_clk;
    wire gmii_tx_en;
    wire[7:0]gmii_txd;
    reg [15:0]tx_byte_cnt;
    
    eth_udp_tx_gmii eth_udp_tx_gmii(
        .clk_125m(clk_125m),
        .rst_n(rst_n),
        
        .tx_en_pulse(tx_en_pulse),
        .tx_done(tx_done),
        
        .dst_mac(48'hC8_5B_76_DD_0B_38),
        .src_mac(48'h00_0a_35_01_fe_c0),
        .dst_ip(32'hc0_a8_00_03),
        .src_ip(32'hc0_a8_00_02),
        .dst_port(16'd6000),
        .src_port(16'd5000),
        
        .data_len(23),
        
        .payload_req_o(payload_req_o),
        .payload_dat_i(payload_dat_i),
        
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_txen(gmii_tx_en),
        .gmii_txd(gmii_txd)
    );
    
    initial clk_125m = 1'b1;
    always #(`CLK_PERIOD/2)clk_125m = ~clk_125m;
    
    always@(posedge clk_125m or negedge rst_n)
    if(!rst_n)
        tx_byte_cnt <= 16'd0;
    else if(payload_req_o)
        tx_byte_cnt <= tx_byte_cnt + 1'b1;
    else
        tx_byte_cnt <= 16'd0;
        
    always@(*)
    begin
        case(tx_byte_cnt)
            16'd0 : payload_dat_i = "H";
            16'd1 : payload_dat_i = "e";
            16'd2 : payload_dat_i = "l";
            16'd3 : payload_dat_i = "l";
            16'd4 : payload_dat_i = "o";
            16'd5 : payload_dat_i = ",";
            16'd6 : payload_dat_i = " ";
            16'd7 : payload_dat_i = "w";
            16'd8 : payload_dat_i = "e";
            16'd9 : payload_dat_i = "l";
            16'd10 : payload_dat_i = "c";
            16'd11 : payload_dat_i = "o";
            16'd12 : payload_dat_i = "m";
            16'd13 : payload_dat_i = "e";
            16'd14 : payload_dat_i = " ";
            16'd15 : payload_dat_i = "t";
            16'd16 : payload_dat_i = "o";
            16'd17 : payload_dat_i = " ";
            16'd18 : payload_dat_i = "F";
            16'd19 : payload_dat_i = "P";
            16'd20 : payload_dat_i = "G";
            16'd21 : payload_dat_i = "A";
            16'd22 : payload_dat_i = "!";
            default: payload_dat_i = 8'd0;
            endcase
        end
        
        initial begin
        rst_n = 1;
        tx_en_pulse = 0;
        
        #201;
        rst_n = 1;
        #200;
        
        tx_en_pulse = 1;
        #(`CLK_PERIOD);
        tx_en_pulse = 0;
        @(posedge tx_done);
        #200;
        $stop;
        
        end
        
endmodule
