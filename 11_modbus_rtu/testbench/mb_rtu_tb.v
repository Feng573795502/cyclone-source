`timescale 1ns/1ns
module mb_rtu_tb();

reg clk;
reg rst_n;
wire [15:0]mb_reg;
wire [15:0]mb_num;
wire wr_en;
wire [7:0]wr_data;

wire uart_data_wire;

reg send_en;
reg rd_en;
wire crc_err;
reg [7:0]data_byte;
wire tx_done;


mb_rtu mb_rtu(
		.clk(clk),
		.rst_n(rst_n),
		.mb_reg(mb_reg),
		.mb_num(mb_num),
		.wr_en(wr_en),
		.wr_data(wr_data),
		.rd_en(rd_en),
		.crc_err(crc_err),
		.uart_rx_wire(uart_data_wire)
	);
	
defparam mb_rtu.TIMER_OUT = (200000/20);
	
uart_tx uart_tx(
    .clk(clk),            //系统时钟和复位时钟
    .rst_n(rst_n), 
    
    .send_en(send_en),           //启动发送标志
    .data_byte(data_byte),    //数据线
    .baud_set(3'd4),    //波特率设置线
    
    .tx_done(tx_done),     //发送完成标志
    .uart_state(),  //空闲状态
    .uart_tx(uart_data_wire)      //发送线
    );
	 
	 initial clk = 1;
	 always#(10)clk = ~clk;
	 
	 
	 initial begin
		rst_n = 0;
		#200;
		rst_n = 1;
		data_byte = 8'h01;
		send_en = 1;
		@(posedge tx_done);
		data_byte = 8'h10;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h02;
		@(posedge tx_done);
		data_byte = 8'h04;
		@(posedge tx_done);
		data_byte = 8'h41;
		@(posedge tx_done);
		data_byte = 8'h30;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'he7;
		@(posedge tx_done);
		data_byte = 8'h9c;
		#40;
		send_en = 0;
		@(posedge tx_done);
		#60000;
		#60000;
		#60000;
		#60000;
		$stop;
	 end
	 
endmodule