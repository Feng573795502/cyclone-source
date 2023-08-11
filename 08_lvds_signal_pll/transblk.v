module transblk(
snd_clk,
rst_n,
datatx,
datarx,

);

input [7:0] datatx;
input snd_clk;
input rst_n;




assign refclk=clk;
assign snd_clk=clk;
assign rst_n=locked;


always@(posedge clk or negedge rst_n)
  begin
	if(~rst_n) datatx<=8'd1;
	else if(datatx==8'd62) datatx<=8'd1;
	else datatx<=datatx+8'd1;
  end
encode encoder;

  
  
reg [9:0]datarx_reg;
reg [9:0]datarx_reg1;

always@(posedge clk)
begin	
	datarx_reg1<=datarx;
	datarx_reg<=datarx_reg1;
end


always@(posedge clk)
begin
	if(datarx_reg==10'd62) datareg<=10'd1;
	else if(datareg==10'd62) datareg<=10'd1;
	else datareg<=datareg+10'd1;
end

always@(posedge clk or negedge rst_n)
begin
   if(~rst_n)
	  cnt<=21'd0;
	else
   	begin
			if((datareg!=datarx_reg))
				cnt<=cnt+1'b1;
			else 
				cnt<=cnt;
		end
end

endmodule 