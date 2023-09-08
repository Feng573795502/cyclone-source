`timescale 1ns/1ns
module analyzer_tb();

reg clk;
reg rst_n;

reg busy_i;
wire ad_clk_o;
wire ad_conv_o;
reg [15:0]data_i;

wire ad_reset_o;
wire ad_rd_o;
wire [2:0]ad_os_o;

wire [31:0]result;
wire iic_clk;
wire iic_sda;

pullup PUP(iic_sda);

analyzer analyzer(
	.clk(clk),
	.rst_n(rst_n),
	
	//ADC 接口
	.busy_i(),
	.ad_clk_o(ad_clk_o),
	.ad_conv_o(ad_conv_o),
	.data_i(data_i),
	
	//后续不需要
	.ad_reset_o(ad_reset_o),
	.ad_rd_o(ad_rd_o),
	.ad_os_o(ad_os_o),
	
	.result(result),
	
	.iic_clk(iic_clk),
	.iic_sda(iic_sda)
	
);
initial clk = 1;
always #10 clk = ~clk;

initial begin

rst_n = 0;
#200;
rst_n = 1;
data_i = 16'd8;
#100000;
$stop;
end


endmodule
