module lvds_test(
	input    sys_clk,      //系统时钟
	output   data_txp,    //数据发送差分端口
	input    data_rxp,    //数据接收差分端口
	output   clk_out,     //
	output   clk_out_en,
	input    clk_in,
	output   clk_in_en
	);
	
	//输出和输入时钟使能
	assign clk_out_en = 1'b1;
	assign clk_in_en  = 1'b0;
	
	//输出时钟和复位
	wire tx_outclock;
	wire rst_n;
	
	wire data_cnt_done;
	
	//发送数据
	data_transmit_auto_align trans_inst(
		.sys_clk(sys_clk),
		.tx_outclock(tx_outclock),
		.data_txp(data_txp),
		.rst_n(rst_n)
	);
	
	//数据接收
	wire rx_locked;
	wire rx_data_align;
	wire [9:0]rx_out;
	wire [7:0]dedata;
	wire align_done;
	
	//接收模块
	lvds_recv lvds_recv(
		.data_rxp(data_rxp),
		.rx_inclock(clk_in),
		
		.rx_locked(rx_locked),
		.rx_data_align(rx_data_align),
		.rx_outclock(rx_outclock),
		.rx_out(rx_out),
		
		.align_done(align_done),
		.dedata(dedata)
	);
	
	//时钟对齐
	lvds_align lvds_align(
		.rx_clk(rx_outclock),
		.rx_data(rx_out),
		.rst_n(rx_locked),
		.data_cnt_done(data_cnt_done),
		.clk_align_done(clk_align_done),
		.rx_data_align(rx_data_align)
	);
	
	//捕获数据 等待时钟对齐后才进行判断
	data_repeat_align data_repeat_align(
		.clk(rx_outclock),
      .rst_n(clk_align_done),   //等待对齐再进行操作
		.data(dedata),
		.rx_cnt(125),
      .data_cnt_done(data_cnt_done)   //接收数据完成输出
	);

	endmodule
		