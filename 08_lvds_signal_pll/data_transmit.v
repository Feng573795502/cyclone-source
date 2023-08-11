module data_transmit(
input sysclk,
output tx_outclock,
output data_txp,
output rst_n

);
wire clk;
wire locked;
wire clk_10M;
wire clk_81x92;
reg [20:0] cnt/*synthesis noprune*/;
//wire rst_n;
reg reset_i;
clk_pll clk_ins(
.inclk0(sysclk),
.c0(clk),
.c1(clk_10M),
.c2(clk_81x92),
.locked(locked)
);
assign rst_n=reset_i;
parameter comma_8B=8'hBC;


always@(posedge sysclk or negedge locked)
	begin
		if(!locked)
			begin
				reset_i<=1'b0;
				cnt<=0;
			end
		else 
		   begin
			   if(cnt==300)
			   begin
				   reset_i<=1'b1;
				   cnt<=cnt;
			   end 
			   else 
			     begin
					 reset_i<=1'b0;
					 cnt<=cnt+1'b1;
				 end
		   end
	end

    // generated unencoded data  
 reg [7:0] unendata/*synthesis noprune*/;
 reg comma;
 always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)  
		 begin
			 unendata<=comma_8B;
			 comma<=1'b1;
		 end
		else 
		   begin
			   unendata<=unendata+1'b1;
			   comma<=1'b0;
		   end       
	end
 
 wire valid; 
 wire [9:0]datatx;

encode encoder(
.clk(clk),
.rst_n(locked),
.kin(comma),
.datain(unendata),
.dataout(datatx),
.valid(valid)
);


oserdes ser_ins(
.tx_in(datatx),
.tx_inclock(clk),
.tx_out(data_txp),
.tx_outclock(tx_outclock),
.tx_coreclock(tx_coreclock),
.tx_locked(tx_locked)
);


endmodule