`timescale 1ns / 1ps

module uart_rx_tb();

reg clk;
reg rst_n;

reg send_en;
reg [7:0]tx_data;
wire [7:0]rx_data;
wire tx_done;
wire uart_state;

wire uart;
wire rx_done;

	uart_tx uart_tx(
	.clk(clk),
	.rst_n(rst_n), 

	.send_en(send_en),
	.data_byte(tx_data),
	.baud_set(3'd0),

	.tx_done(tx_done),
	.uart_state(uart_state),
	.uart_tx(uart)
	);

	uart_rx uart_rx(
	.clk(clk),               //系统时钟
	.rst_n(rst_n),             //复位
	.uart_rx(uart),           //接收wire
	.baud_set(3'd0),     //波特率
	.data_byte(rx_data),
	.rx_done(rx_done)
	);
	
	initial clk = 1;
	always #(10)clk = ~clk;
	
	initial begin
	
	rst_n = 0;
	#200;
	rst_n = 1;
	tx_data = 8'h12;
	send_en = 1;
	#20;
	send_en = 0;
	@(negedge tx_done);
	#20;
	tx_data = 8'h22;
	send_en = 1;
	#20;
	send_en = 0;
	@(negedge tx_done);
	#2000;
	$stop;
	
	
	end
	
	endmodule