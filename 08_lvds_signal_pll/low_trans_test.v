module low_trans_test(
input                                     sysclk,
output                           [9:0]    datatx,                         
output                                    snd_clk,
input                            [9:0]    datarx,
output                                    refclk,
input                                     recover_clk,
input                                     lock_n,
input                                     rst_n,
output                                    sync_tx,
output                                    clk_out,   //16.384Mhz
output                                    clk_out_en,
input                                     clk_in,
output                                    clk_in_en,

input                                     mes_in_up, 
output                                    mes_in_up_en, 
output                                    mes_out_down,
output                                    mes_out_down_en,
output                                    clk_49x152
//ads_scl,
//ads_sda,
//ad_voltage,
//ad_voltage_valid
);
assign clk_out_en=1'b1;
assign mes_out_down_en=1'b1;
assign clk_in_en=1'b0;
assign mes_in_up_en=1'b0;
//inout ads_sda;
//output  ads_scl;
//output [15:0] ad_voltage_valid;
//output [15:0]ad_voltage;
assign  sync_tx=1'b0;
//reg [9:0]datareg;
wire locked;
wire clk;
wire clk_10M;
//wire clk_49x152;
reg [20:0] cnt/*synthesis noprune*/;


clk_pll clk_ins(
.inclk0(sysclk),
.c0(clk),
.c1(clk_10M),
.c2(clk_49x152),
.locked(locked)
);
assign clk_out=clk;
assign mes_out_down=clk_10M;

assign refclk=clk;
assign snd_clk=clk;
//assign rst_n=locked;

// generated unencoded data  
 reg [7:0] unendata/*synthesis noprune*/;

always@(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		 begin
		  
	     unendata<=8'd0;
		 end
		else 
			begin
				if(unendata==8'd62) 
					unendata<=8'd0;
				else 
				   unendata<=unendata+8'd1;
			end  
	end
  
 //8B/10B encode 
  wire valid;

encode encoder(
.clk(clk),
.rst_n(rst_n),
.kin(1'b0),
.datain(unendata),
.dataout(datatx),
.valid(valid)
);
 // 10B/8B  decode
  wire [7:0]dedata/*synthesis noprune*/;
  wire kout;
  
decode decoder(
.clk(recover_clk),
.rst_n(rst_n),
.datain(datarx),
.lock_n(1'b0),
.dataout(dedata),
.kout( )

);
reg [7:0]datarx_reg/*synthesis noprune*/;
reg [7:0]datarx_reg1;

always@(posedge recover_clk)
begin	
	datarx_reg1<=dedata;
	datarx_reg<=datarx_reg1;
end




 reg signed [7:0]count;
 reg [64:1] timer_count[0:63]/*synthesis noprune*/;
 reg [7:0] i;
  reg [64:1] err_timer;
always@(posedge recover_clk or negedge rst_n)
 begin
   if(~rst_n)
	  begin
	    i<=6'b0;
		 count<=8'b0;
		 cnt<=0;
	  end
	else 
	begin 
		count<=datarx_reg1-datarx_reg;
		case(count)
			8'd1: cnt<=cnt;
			-8'd62:cnt<=cnt;
			8'd0:cnt<=cnt;
			default: 
			  begin cnt<=cnt+1;
					  timer_count[i]<=err_timer;
						i<=i+1;
			  end
		endcase
	end 
end


reg [32:1] clk_div;
reg clk_timer;
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
	 begin
	 
	 clk_div<=32'b0;
	  clk_timer<=1'b0;
	 end
    else 
	   begin 
		  if(clk_div==(16384000/2-1))
		  begin
		    clk_timer<=~clk_timer;
			 clk_div<=32'b0;
		  end
			else clk_div<=clk_div+1'b1; 
      end
end


  always @(posedge clk_timer or negedge rst_n)
   begin
	    if (~rst_n)
		  err_timer=0;
		  else err_timer<=err_timer+1'b1;
	end
//wire wr_req,rd_req;
//
////wire [15:0]ad_voltage/*synthesis noprune*/;
//
//ads_ctrl ads_ins(
//.clk(clk_10M),
//.rst_n(rst_n),
//.wr_req(wr_req),
//.rd_req(rd_req),
//.ad_voltage(ad_voltage),
//.ads_scl(ads_scl),
//.ads_sda(ads_sda)
//);
//
//iic_cfg  iic_cfg_ins(
//.clk(clk_10M),
//.rst_n(rst_n),
//.m_wr_req(wr_req),
//.m_rd_req(rd_req),
//.m_ad_voltage(ad_voltage),
//.ad_voltage_valid(ad_voltage_valid)
//
//);
	

endmodule 