module udp_loopback(
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
	
	output reg led,
	
	//mdio 目前未实现 后续安排
	output eth_rst_n,
	output mdc,
	inout  mdio
	);
	
	parameter LOCAL_MAC  = 48'h00_07_ed_ac_62_00;
	parameter LOCAL_IP   = 32'hc0_a8_00_02;
	parameter LOCAL_PORT = 16'd5000;
	
	wire [47:0] exter_mac;
	wire [31:0] exter_ip;
	wire [15:0] exter_port;
	wire [15:0] rx_data_len;
	wire        rx_pkt_done;
	
	wire gmii_rxc;
	wire [7:0]gmii_rxd;
	wire gmii_rxdv;
	
	wire       gmii_tx_clk;
	wire [7:0] gmii_txd;
	wire       gmii_txen;
	
	wire fifo_aclr;
	wire [7:0]fifo_wdat;
	wire rdreq;
	wire wrreq;
	wire [7:0]fifo_rdat;
	//上电先清空FIFO
	reg [32:0]dly_cnt;
	wire init_done;
	
	assign fifo_aclr = (dly_cnt >= 24'd100) ? 1'b0:1'b1;
	//时钟
	assign gmii_tx_clk = gmii_rxc;

	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			dly_cnt <= 24'd0;
		else if(dly_cnt >= 24'hfffffd)
			dly_cnt <= dly_cnt;
		else
			dly_cnt <= dly_cnt + 1'd1;
	end
	
	always @(posedge gmii_rxc or negedge rst_n)
	if(!rst_n)
		led <= 1'b0;
	else if(rx_pkt_done == 1'b1)
		led <= ~led;
	else 
		led <= led;
	
	//读写请求 转发到TXD
	eth_dcfifo eth_dcfifo(
	.aclr(fifo_aclr),
	.data(fifo_wdat),
	.rdclk(gmii_rxc),
	.rdreq(rdreq),
	.wrclk(gmii_rxc),
	.wrreq(wrreq),
	.q(fifo_rdat),
	.rdusedw(),
	.wrusedw()
	);
	
	//用接收时钟作为主时钟
	pll_rx pll_rx(
		.inclk0(eth_rxc),
		.c0(gmii_rxc)
	);
	
	//rgmii转gmii
	rgmii_to_gmii u_rgmii_to_gmii(
		.rgmii_rxc(gmii_rxc),
		.rgmii_rxd(eth_rxd),
		.rgmii_rxdv(eth_rxdv),
		.gmii_rxc(),
		.gmii_rxd(gmii_rxd),
		.gmii_rxdv(gmii_rxdv)
	);
	
	//接收gmii控制器
	eth_udp_rx_gmii eth_udp_rx_gmii(
		.rst_n(rst_n),
		
		.local_mac(LOCAL_MAC),
		.local_ip(LOCAL_IP),
		.local_port(LOCAL_PORT),
		
		.clk_125m_o(),
		.exter_mac(exter_mac),
		.exter_ip(exter_ip),
		.exter_port(exter_port),
		
		.rx_data_len(rx_data_len),
		
		.data_overflow_i(0),

		//写入使能
		.payload_valid_o(wrreq),
		.payload_data_o(fifo_wdat),
		
		.one_pkt_done(rx_pkt_done),
		.pkt_err(),
		.debug_crc_check(),
		
		.gmii_rx_clk(gmii_rxc),
		.gmii_rxd(gmii_rxd),
		.gmii_rxdv(gmii_rxdv)
	);
	

	gmii_to_rgmii u_gmii_to_rgmii(
		.gmii_tx_clk(gmii_tx_clk),
		.gmii_tx_data(gmii_txd),
		.gmii_tx_en(gmii_txen),
		.rgmii_tx_clk(eth_gtxc),
		.rgmii_tx_data(eth_txd),
		.rgmii_tx_en(eth_txen)
	);
	
	
	//eth发送
	eth_udp_tx_gmii eth_udp_tx_gmii(
			//由接收时钟输入 转换
        .clk_125m(gmii_tx_clk),
        .rst_n(rst_n),
        
		  //完成自动使能发送 接收完成使能发送
        .tx_en_pulse(rx_pkt_done),
        .tx_done(),
        
        .dst_mac(exter_mac),
        .src_mac(LOCAL_MAC),
        .dst_ip(exter_ip),
        .src_ip(LOCAL_IP),
        .dst_port(exter_port),
        .src_port(LOCAL_PORT),
        
        .data_len(rx_data_len),
        
		  //从FIFO中读取数据
        .payload_req_o(rdreq),
        .payload_dat_i(fifo_rdat),
        
        .gmii_tx_clk   (gmii_tx_clk),
        .gmii_txen     (gmii_txen),
        .gmii_txd      (gmii_txd)
    );
	 
	 phy_config phy_config(
		.clk      (clk),        //模块时钟50MHz
		.rst_n    (rst_n),      //模块复位，低电平有效
		.phy_rst_n(eth_rst_n),  //phy芯片复位，低电平有效
		.mdc      (mdc),        //时钟接口
		.mdio     (mdio),       //数据接口
		.init_done (init_done)    //初始化完成标志，高电平有效
	);
	
endmodule
