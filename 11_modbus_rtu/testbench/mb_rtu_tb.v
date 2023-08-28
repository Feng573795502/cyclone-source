`timescale 1ns/1ns
module mb_rtu_tb();

reg clk;
reg rst_n;

wire uart_data_wire;

reg send_en;
reg [7:0]data_byte;
wire tx_done;


mb_rtu mb_rtu(
		.clk(clk),
		.rst_n(rst_n),
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
		data_byte = 8'h03;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h01;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h02;
		@(posedge tx_done);
		data_byte = 8'h00;
		@(posedge tx_done);
		data_byte = 8'h00;
		send_en = 0;
		@(posedge tx_done);
		#2000;
		$stop;
	 end
	 
endmodule