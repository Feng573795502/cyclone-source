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
	wire tx_outclk;
	wire rst_n;
	
	wire data_cnt_done;
	
	//发送数据
	data_transmit_auto_align trans_inst(
		.sys_clk(sys_clk),
		.tx_outclk(tx_outclk),
		.data_txp(data_txp),
		.rst_n(rst_n)
	);
	
	
		