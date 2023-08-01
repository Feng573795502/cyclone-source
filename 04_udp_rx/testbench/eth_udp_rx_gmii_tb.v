`timescale 1ns / 1ps
`define CLK_PERIOD 8

	module eth_udp_rx_gmii_tb();
	
	reg clk_125m;
	reg rst_n;
	
	reg tx_en_pulse;
	reg [15:0]data_len;
	wire tx_done;
	
	wire payload_req_o;
	reg [7:0]payload_dat_i;
	
	wire gmii_tx_clk;
	wire gmii_tx_en;
	wire [7:0]gmii_txd;
	
	wire clk_125m_o;
	wire [47:0]exter_mac;
	wire [31:0]exter_ip;
	wire [15:0]exter_port;
	wire [15:0]rx_data_len;
	wire       payload_valid_o;
	wire [7:0] payload_data_o;
	wire       one_pkt_done;
	wire       pkt_error;
	wire [31:0]debug_crc_check;
	
	//clock generate
	initial clk_125m = 1;
	always #(`CLK_PERIOD/2)clk_125m = ~clk_125m;
	
	initial begin
	
	rst_n = 0;
	tx_en_pulse = 0;
	
	data_len = 0;
	payload_dat_i = 0;
	
	#201;
	rst_n = 1;
	#200;
	
	//发送第一包数据
	data_len = 100;
	@(posedge clk_125m);
	#1;
	tx_en_pulse = 1;
	#(`CLK_PERIOD);
	tx_en_pulse = 0;
	
	@(posedge payload_req_o);
	#1;
	repeat(data_len)
	begin
		#(`CLK_PERIOD);
		payload_dat_i = payload_dat_i + 1;
	end

	@(posedge tx_done)
	#200

	//发送第二包数据
	data_len = 10;
	payload_dat_i   = 200;
	@(posedge clk_125m);
	#1;
	tx_en_pulse = 1;
	#(`CLK_PERIOD);
	tx_en_pulse = 0;
	
    @(posedge payload_req_o);
    #1;
    repeat(data_len)
    begin
      #(`CLK_PERIOD);
      payload_dat_i = payload_dat_i + 1;
    end

    #200;
    $stop;  
	
	end
	
	eth_udp_tx_gmii eth_udp_tx_gmii(
        .clk_125m(clk_125m),
        .rst_n(rst_n),
        
        .tx_en_pulse(tx_en_pulse),
        .tx_done(tx_done),
        
        .dst_mac(48'hC8_5B_76_DD_0B_38 ),
        .src_mac(48'h00_0a_35_01_fe_c0 ),  
        .dst_ip(32'hc0_a8_00_03       ),
        .src_ip(32'hc0_a8_00_02       ),	
        .dst_port(16'd6000              ),
        .src_port(16'd5000              ),
        
        .data_len(data_len),
        
        .payload_req_o(payload_req_o),
        .payload_dat_i(payload_dat_i),
        
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_txen(gmii_tx_en),
        .gmii_txd(gmii_txd)
    );

eth_udp_rx_gmii eth_udp_rx_gmii(
		.rst_n(rst_n),
		
		//本地mac和IP端口
		.local_mac(48'hC8_5B_76_DD_0B_38 ),
		.local_ip(32'hc0_a8_00_03),
		.local_port(16'd6000),
		
		//clk
		.clk_125m_o(clk_125m_o),
		//接收到都包的mac和ip端口
		.exter_mac(exter_mac),
		.exter_ip(exter_ip),
		.exter_port(exter_port),
		
		//接收到的数据长度
		.rx_data_len(rx_data_len),
		
		.data_overflow_i(1'b0),
		
		//数据输出有效值
		.payload_valid_o(payload_valid_o),
		//输出数据
		.payload_data_o(payload_data_o),
		
		//包接收完成
		.one_pkt_done(one_pkt_done),
		//包错误
		.pkt_err(pkt_err),
		//crc校验输出
		.debug_crc_check(debug_crc_check),
		
		//clk和数据引脚以及使能
		.gmii_rx_clk(gmii_tx_clk),
		.gmii_rxd(gmii_txd),
		.gmii_rxdv(gmii_tx_en)

	);
	
	endmodule