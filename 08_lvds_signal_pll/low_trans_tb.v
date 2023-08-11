`timescale 1ns/100ps
module low_trans_tb;
  reg sysclk;
  reg [9:0]datarx;
  reg recover_clk;
  reg lock_n;
  wire [9:0]datatx;
 
  wire snd_clk;
  wire refclk;
  
  //wire [15:0]cnt;
  //wire[9:0] datareg;
  
 initial 
     begin
	     sysclk=1'b0;
		 datarx=10'd1;
	     lock_n=1'b0;
		
		 
     end
	 
 always #30 sysclk=~sysclk;
 //always #30 datatx=datatx+1'b1;

  always #30 datarx=datarx+1'b1;
  low_trans_test tb_pp(
	.sysclk(sysclk),
	.datarx(datarx),
	.recover_clk(recover_clk),
	.lock_n(lock_n),
	.datatx(datatx),
	.snd_clk(snd_clk),
	.refclk(refclk)
  );
endmodule
