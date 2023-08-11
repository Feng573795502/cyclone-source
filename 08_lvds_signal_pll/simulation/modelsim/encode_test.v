`timescale 1 ns/ 1 ns
module encode_test();
reg clk;
reg rst_n;
reg kin;
reg [7:0]datain;
wire [9:0]dataout;
wire valid;


encode inst(
.clk(clk),
.rst_n(rst_n),
.kin(kin),
.datain(datain),
.dataout(dataout),
.valid(valid)

);

initial 
    begin
        clk=1'b0;
        kin=1'b0;
    end
initial
    begin
        #0 rst_n=1'b0;
        #200 rst_n=1'b1;
    end        
always  #5 clk=~clk;
 always @(posedge clk or negedge rst_n)
 begin
     if(!rst_n)
        begin
        datain<=8'hbc;
        end
      else
        begin
        datain<=datain+1'b1;
        end   
 end
endmodule 