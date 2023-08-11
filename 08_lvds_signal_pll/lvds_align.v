module lvds_align(
input rx_clk,
input [9:0]rx_data,
input rx_locked,
input data_cnt_done,
output reg align_done,
output reg  rx_data_align    
);

parameter comma1=10'b01_0111_1100,
          comma2=10'b10_1000_0011;

reg [4:0] cnt;
wire realign;
//assign realign=;
always @(posedge rx_clk or negedge rx_locked)
    begin
        if(!rx_locked)
            begin
                cnt<=5'b0;
            end  
        else if(align_done)
              cnt<=5'b0;
        else 
             cnt<=cnt+1'b1;           
    end
always @(posedge rx_clk or negedge rx_locked)
    begin
        if(!rx_locked)
            begin
                rx_data_align<=1'b0;
            end 
        else if(cnt==10)
             rx_data_align<=1'b1;
        else
             rx_data_align<=1'b0;     
    end
reg [2:0]judge_done;
always @(posedge rx_clk or negedge rx_locked)
    begin
        if(!rx_locked)
         judge_done<=3'b0;
        else if((cnt==16)&&(rx_data==comma1||rx_data==comma2)) judge_done[0]<=1'b1;
        else if((cnt==17)&&(rx_data==comma1||rx_data==comma2)) judge_done[1]<=1'b1;
        else if((cnt==18)&&(rx_data==comma1||rx_data==comma2)) judge_done[2]<=1'b1;
        else if(cnt==10) judge_done<=3'b0;
    end
always @(posedge rx_clk or negedge rx_locked)
    begin
        if(!rx_locked)
         align_done<=1'b0;
        else if(!data_cnt_done) 
          align_done<=1'b0;
        else if(cnt==19)
         begin
            if(judge_done==3'b111)
            align_done<=1'b1;
            else 
            align_done<=1'b0;   
         end
        else 
           align_done<=align_done; 

    end
endmodule 