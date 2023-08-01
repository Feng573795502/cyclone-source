module rgmii_udp_loopback_test(
	//系统时钟
	input clk,
	input rst_n,
	
	//eth接收端口
	input eth_rxc,
	input [3:0]eth_rxd,
	input eth_rxdv,
	
	//eth输出接口
	output eth_gtxc,
	output [3:0]eth_txd,
	output eth_txen,
	
	//mdio 目前未实现 后续安排
	output eth_rst_n
	};
	
	parameter LOCAL_MAC  = 48'h00_0a_35_01_fe_c0;
	parameter LOCAL_IP   = 32'hc0_a8_00_02;
	parameter LOCAL_PORT = 16'd5000;
	
	//eth rx
	wire clk_125m;
	wire [47:0] exter_mac;
	wire [31:0] exter_ip;
	wire [15:0] exter_port;
	wire [15:0] rx_data_len;
	wire        data_overflow;
	wire [7:0]  rx_payload_dat;
	wire        rx_payload_valid;
	wire        rx_pkt_done;
	wire        rx_pkt_err;
	
	reg  [3:0]  pkt_right_cnt;
	reg  [3:0]  pkt_err_cnt;
	
	wire gmii_rxc;
	wire [7:0]gmii_rxd;
	wire gmii_rxdv;
	
	wire       gmii_gtxc;
	wire [7:0] gmii_txd;
	wire       gmii_txen;
	
	
	//上电先清空FIFO
	reg [32:0]dly_cnt;
	
	assign fifo_aclr = (dly_cnt >= 24'd100) ? 1'b0:1'b1;
	assign gmii_gtxc = gmii_rxc;
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			dly_cnt <= 24'd0;
		else if(dly_cnt >= 24'hfffffd)
			dly_cnt <= dly_cnt;
		else
			dly_cnt <= dly_cnt + 1'd1;
	end
	
	//读写请求 转发到TXD
//	eth_dcfifo eth_dcfifo(
//	.aclr(fifo_aclr),
//	.data(),
//	.rdclk,
//	.rdreq,
//	.wrclk,
//	.wrreq,
//	.q,
//	.rdusedw,
//	.wrusedw);
	
	rx_pll rx_pll(
		.inclk0(eth_rxc),
		.c0(gmii_rxc)
	);
	
//	rgmii_to_gmii u_rgmii_to_gmii(
//		.rgmii_rxc(gmii_rxc),
//		.rgmii_rxd(eth_rxd),
//		.rgmii_rxdv(eth_rxdv),
//		.gmii_rxc()	,
//		.gmii_rxd(gmii_rxd),
//		.gmii_rxdv(gmii_rxdv)
//	);
//	
//	eth_udp_rx_gmii eth_udp_rx_gmii(
//		.rst_n(rst_n),
//		
//		.local_mac(LOCAL_MAC),
//		.local_ip(LOCAL_IP),
//		.local_port(LOCAL_PORT),
//		
//		.clk_125m_o(clk_125m_o),
//		.exter_mac(exter_mac),
//		.exter_ip(exter_ip),
//		.exter_port(exter_port),
//		
//		.rx_data_len(rx_data_len),
//		
//		.data_overflow_i(0),
//
//		.payload_valid_o(rx_),
//		.payload_data_o(fifo_wrdata),
//		
//		.one_pkt_done(one_pkt_done),
//		.pkt_err(),
//		.debug_crc_check(),
//		
//		.gmii_rx_clk(gmii_rxc),
//		.gmii_rxd(gmii_rxd),
//		.gmii_rxdv(gmii_rxdv)
//	);
//	
	
	eth_udp_tx_gmii eth_udp_tx_gmii(
			//由接收时钟输入 转换
        .clk_125m(gmii_gtxc),
        .rst_n(rst_n),
        
		  //完成自动使能发送 接收完成使能发送
        .tx_en_pulse(one_pkt_done),
        .tx_done(),
        
        .dst_mac(48'hFF_FF_FF_FF_FF_FF),
        .src_mac(LOCAL_IP),
        .dst_ip(32'hc0_a8_00_03),
        .src_ip,
        .dst_port(16'd6102),
        .src_port(LOCAL_IP),
        
        .data_len(rx_data_len),
        
        .payload_req_o(),
        .payload_dat_i,
        
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_txen(gmii_txen),
        .gmii_txd(gmii_txd)
    );
	
	gmii_to_rgmii u_gmii_to_rgmii(
		.gmii_gtxc(gmii_tx_clk),
		.gmii_txd(gmii_txd),
		.gmii_txen(gmii_txen),
		.rgmii_gtxc(eth_gtxc),
		.rgmii_txd(eth_txd),
		.rgmii_txen(eth_txen)
);
