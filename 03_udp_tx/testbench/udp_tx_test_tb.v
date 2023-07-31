`timescale 1ns/1ns
`define CLK_PERIOD 20

module udp_tx_test_tb;

	 reg clk;
	 reg rst_n;
	 

	 wire rgmii_tx_clk;
	 wire rgmii_tx_en;
	 wire [3:0]rgmii_tx_data;

eht_udp_tx_gmii_test eht_udp_tx_gmii_test(
    .clk(clk),
    .rst_n(rst_n),

	 .rgmii_tx_clk(rgmii_tx_clk), //RGMII发送时钟
	 .rgmii_tx_en(rgmii_tx_en), //RGMII发送数据控制信号
	 .rgmii_tx_data(rgmii_tx_data) //RGMII发送数据  
    );
	 
	 initial clk = 1;
	 always#(`CLK_PERIOD/2) clk = ~clk;
	 
	 initial begin
	 
	 rst_n = 0;
	 #(200)
	 rst_n = 1;
	 #5000;
	 
	 $stop;
	 end
	 
endmodule