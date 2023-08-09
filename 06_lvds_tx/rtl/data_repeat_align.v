

//数据发送起始符号接收比对 接收完成标志

module data_repeat_align(
  input clk,
  input rst_n,
  input [7:0] data,
  input [16:0] rx_cnt,
  output data_cnt_done   //接收数据完成输出
);

  reg [9:0]cnt;
  reg [7:0]data_reg1;
  reg [7:0]data_reg2;

  reg head_flag;  //是否接收到头

  assign data_cnt_done=(cnt==124 ? 1'b0 : 1'b1);

  //捕获数据打两拍
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
      data_reg1 <= 8'b0;
      data_reg2 <= 8'b0;
    end
    else begin
      data_reg1 <= data;
      data_reg2 <= data_reg1;
    end
  end

  //数据头标志
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
      head_flag <= 10'b0;
    else if((data_reg1 == 8'h33)&&(data_reg2 == 8'hee))
      head_flag <= 1'b1;
    else 
      head_flag <= 1'b0;
  end

  //出现数据头开始拆机数据
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
      cnt<=0;
    else if ((cnt != 0)&&(cnt < 10'd124))
      cnt <= cnt + 1'b1;
    else if(head_flag)
      cnt <= 10'b1;
    else 
      cnt <= 0; 
  end

endmodule 