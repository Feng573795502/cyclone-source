`timescale 1ns/1ns
module vtb();
reg clk_10M;
reg rst_n;
wire  wr_req;
wire rd_req;
//reg access_start;
reg cfg_valid;
wire [15:0]ad_voltage;
wire [15:0]ad_voltage_valid;
wire ads_scl;
wire ads_sda;

initial
	begin
	   clk_10M=1'b0;
	   rst_n=1'b0;
	   #1000 rst_n=1'b1;	
	end

always #50 clk_10M=~clk_10M;	

ads_ctrl ads_ins(
.clk(clk_10M),
.rst_n(rst_n),
.wr_req(wr_req),
.rd_req(rd_req),
.ad_voltage(ad_voltage),
.ads_scl(ads_scl),
.ads_sda(ads_sda)
);

iic_cfg  iic_cfg_ins(
.clk(clk_10M),
.rst_n(rst_n),
.m_wr_req(wr_req),
.m_rd_req(rd_req),
.m_ad_voltage(ad_voltage),
.ad_voltage_valid(ad_voltage_valid)

);


endmodule