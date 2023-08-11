module data_repeat_align(
input clk,
input rst_n,
input [7:0] data,
//output reg [9:0] cnt
output data_cnt_done
);
reg [9:0]cnt;
reg [7:0]data_reg1;
reg [7:0]data_reg2;
//wire data_cnt_done;
assign data_cnt_done=(cnt==124?1'b0:1'b1);
always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
          begin
            data_reg1<=8'b0;
            data_reg2<=8'b0;
          end
        else 
          begin
              data_reg1<=data;
              data_reg2<=data_reg1;
          end
    end
reg head_flag;
always @(posedge clk or negedge rst_n)
     begin
         if(!rst_n)
         head_flag<=10'b0;
         else if((data_reg1==8'h33)&&(data_reg2==8'hee))
         head_flag<=1'b1;
         else 
         head_flag<=1'b0;
            
     end    
always @(posedge clk or negedge rst_n)
     begin
         if(!rst_n)
          cnt<=0;
         else if ((cnt!=0)&&(cnt<10'd124))
          cnt<=cnt+1'b1;
          else if(head_flag)
          cnt<=10'b1;
         else 
          cnt<=0; 
     end



endmodule 