`timescale 1ns/100ps
module trans_tb();
reg sysclk;
reg [9:0]datarx;
reg recover_clk;
reg lock_n;
wire ads_scl;
wire ads_sda;
wire [15:0]ad_voltage;
wire [15:0]ad_voltage_valid;
wire snd_clk;
wire [9:0]datatx;
wire refclk;
reg rst_n;


initial 
  begin
    sysclk=1'b0;
	lock_n=1'b0;
	rst_n=1'b0;
	#1000 rst_n=1'b1;
	
  end
  always #30 sysclk=~sysclk;

  
  low_trans_test tb(
   .rst_n(rst_n),   
	.sysclk(sysclk),
	.datarx(datatx),
	.recover_clk(recover_clk),
	.lock_n(lock_n),
	.datatx(datatx),
	.snd_clk(snd_clk),
	.refclk(refclk),
   .ads_scl(ads_scl),
   .ads_sda(ads_sda),
   .ad_voltage(ad_voltage),
   .ad_voltage_valid(ad_voltage_valid)
  );
  endmodule