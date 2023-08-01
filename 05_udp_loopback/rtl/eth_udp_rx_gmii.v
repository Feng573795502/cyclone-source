	module eth_udp_rx_gmii(
		input rst_n,
		
		//本地mac和IP端口
		input [47:0]local_mac,
		input [31:0]local_ip,
		input [15:0]local_port,
		
		//clk
		output clk_125m_o,
		//接收到都包的mac和ip端口
		output reg[47:0]exter_mac,
		output reg[31:0]exter_ip,
		output reg[15:0]exter_port,
		
		//接收到的数据长度
		output reg[15:0]rx_data_len,
		
		input data_overflow_i,
		
		//数据输出有效值
		output reg    payload_valid_o,
		//输出数据
		output reg [7:0]payload_data_o,
		
		//包接收完成
		output reg     one_pkt_done,
		//包错误
		output reg     pkt_err,
		//crc校验输出
		output [31:0]  debug_crc_check,
		
		//clk和数据引脚以及使能
		input          gmii_rx_clk,
		input  [7:0]   gmii_rxd,
		input          gmii_rxdv

	);

	parameter ETH_TYPE       = 16'h0800,
				 IP_VER         = 4'h4,
				 IP_HDR_LEN     = 4'h5,
				 IP_PROTOCOL    = 8'h11;
			 
	//设备运行状态
	localparam
		IDLE          = 9'b000000001,
		RX_PREAMBLE   = 9'b000000010,
		RX_ETH_HEADER = 9'b000000100,
		RX_IP_HEADER  = 9'b000001000,
		RX_UDP_HEADER = 9'b000010000,
		RX_DRP_DATA   = 9'b000100000,
		RX_DATA       = 9'b001000000,
		RX_CRC        = 9'b010000000,
		PKT_CHECK     = 9'b100000000;
	
	//接收数据和使能状态
	reg [7:0]reg_gmii_rxd;
	reg      reg_gmii_rxdv;
	reg [7:0]rx_data_dly1;
	reg [7:0]rx_data_dly2;
	reg      rx_datav_dly1;
	reg      rx_datav_dly2;
	
	//本地信息寄存器
	reg [47:0]reg_local_mac;
	reg [31:0]reg_local_ip;
	reg [15:0]reg_local_port;
	
	//状态机状态
	reg [8:0] curr_state;
	reg [8:0] next_state;
	
	//暂时不适用
	reg reg_data_overflow;
	
	//mac地址暂存
	reg [47:0]rx_dst_mac;
	reg [47:0]rx_src_mac;
	reg [15:0]rx_eth_type;
	
	//检测eth头状态
	reg eth_header_check_ok;
	
	//接收到的IP头信息和检测状态
	reg [3:0]   rx_ip_ver;
	reg [3:0]   rx_ip_hdr_len;
	reg [7:0]   rx_ip_tos;
	reg [15:0]  rx_total_len;
	reg [15:0]  rx_ip_id;
	reg         rx_ip_rsv;
	reg         rx_ip_df;
	reg         rx_ip_mf;
	reg  [12:0] rx_ip_frag_offset;
	reg  [7:0]  rx_ip_ttl;
	reg  [7:0]  rx_ip_protocol;
	reg  [15:0] rx_ip_check_sum;
	reg  [31:0] rx_src_ip;
	reg  [31:0] rx_dst_ip;
	
	reg         ip_checksum_cal_en;  
	wire [15:0] cal_check_sum;
	reg         ip_header_check_ok;
	
	//接收到的端口号
	reg  [15:0] rx_src_port;
	reg  [15:0] rx_dst_port;
	reg  [15:0] rx_udp_len;
	reg         udp_header_check_ok;
	
	//crc校验
	reg [31:0]rx_crc_data;
	reg  crc_init;
	reg  crc_en;
	reg  [7:0]crc_data;
	wire  [31:0]crc_check;
	
	//状态机计数器
	reg  [3:0]  cnt_preamble;
	reg  [3:0]  cnt_eth_header;
	reg  [4:0]  cnt_ip_header;
	reg  [3:0]  cnt_udp_header;
	reg  [15:0] cnt_data;
	reg  [4:0]  cnt_drp_data;
	reg  [1:0]  cnt_crc;
	
	
	//时钟
	wire clk_125m = gmii_rx_clk;
	assign clk_125m_o = clk_125m;
	
	//crc输出
	assign debug_crc_check = crc_check;
	
	
	//获取本机端口和mac地址IP等参数
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)begin
			reg_local_mac   <= 48'h00_00_00_00_00_00;
			reg_local_ip    <= 32'h00_00_00_00;
			reg_local_port  <= 16'h00_00;
		end
		else if(curr_state == IDLE) begin
			reg_local_mac   <= local_mac;
			reg_local_ip    <= local_ip;
			reg_local_port  <= local_port;
		end
	end
	
	//将数据放到寄存器 延时一个clk
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)begin
			reg_gmii_rxd  <= 8'h00;
			reg_gmii_rxdv <= 1'b0;
		end
		else begin
			reg_gmii_rxd  <= gmii_rxd;
			reg_gmii_rxdv <= gmii_rxdv;
		end
	end
	
	//将以太网输入的接收信号寄存后打拍
	always@(posedge clk_125m)begin
		rx_data_dly1  <= reg_gmii_rxd;
		rx_data_dly2  <= rx_data_dly1;
		rx_datav_dly1 <= reg_gmii_rxdv;
		rx_datav_dly2 <= rx_datav_dly1;
	end
	
	//接收起始符，用状态和数据判断，防止在接收数据过程中影响
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_preamble <= 4'd0;
		else if(curr_state == RX_PREAMBLE && rx_data_dly2 == 8'h55)
			cnt_preamble <= cnt_preamble + 1'b1;
		else 
			cnt_preamble <= 4'd0;
	end
	
	//eth头累加
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_eth_header <= 4'd0;
		else if(curr_state == RX_ETH_HEADER)
			cnt_eth_header <= cnt_eth_header + 1'b1;
		else 
			cnt_eth_header <= 4'd0;
	end
	
	//eth头处理
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n) begin
			rx_dst_mac  <= 48'h00_00_00_00_00_00;
			rx_src_mac  <= 48'h00_00_00_00_00_00;
			rx_eth_type <= 16'h0000;
		end
		else if(curr_state == RX_ETH_HEADER)begin
			case (cnt_eth_header)
				4'd0 :rx_dst_mac[47:40] <= rx_data_dly2;
				4'd1 :rx_dst_mac[39:32] <= rx_data_dly2;
				4'd2 :rx_dst_mac[31:24] <= rx_data_dly2;
				4'd3 :rx_dst_mac[23:16] <= rx_data_dly2;
				4'd4 :rx_dst_mac[15:8]  <= rx_data_dly2;
				4'd5 :rx_dst_mac[7:0]   <= rx_data_dly2;

				4'd6 :rx_src_mac[47:40] <= rx_data_dly2;
				4'd7 :rx_src_mac[39:32] <= rx_data_dly2;
				4'd8 :rx_src_mac[31:24] <= rx_data_dly2;
				4'd9 :rx_src_mac[23:16] <= rx_data_dly2;
				4'd10:rx_src_mac[15:8]  <= rx_data_dly2;
				4'd11:rx_src_mac[7:0]   <= rx_data_dly2;

				4'd12:rx_eth_type[15:8] <= rx_data_dly2;
				4'd13:rx_eth_type[7:0]  <= rx_data_dly2;      
				default: ;
			endcase
		end
		else begin
			rx_dst_mac <= rx_dst_mac;
			rx_src_mac <= rx_src_mac;
			rx_eth_type <= rx_eth_type;
		end
			
	end
		
	//eth头层比较，mac地址要不就是ff广播要不就是local地址
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			eth_header_check_ok <= 1'b0;
		else if(rx_eth_type == ETH_TYPE && 
				  (rx_dst_mac == reg_local_mac || rx_dst_mac  == 48'hFF_FF_FF_FF_FF_FF))
			eth_header_check_ok <= 1'b1;
		else 
			eth_header_check_ok <= 1'b0;
	end
		
	//cnt ip头
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_ip_header <= 5'd0;
		else if(curr_state == RX_IP_HEADER)
			cnt_ip_header <= cnt_ip_header + 1'b1;
		else 
			cnt_ip_header <= 5'd0;
	end
		
	//ip head处理
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)begin
			 {rx_ip_ver,rx_ip_hdr_len}     <= 8'h0;
			 rx_ip_tos                     <= 8'h0;  
			 rx_total_len                  <= 16'h0; 
			 rx_ip_id                      <= 16'h0;
			 {rx_ip_rsv,rx_ip_df,rx_ip_mf} <= 3'h0;  
			 rx_ip_frag_offset             <= 13'h0;  
			 rx_ip_ttl                     <= 8'h0;  
			 rx_ip_protocol                <= 8'h0; 
			 rx_ip_check_sum               <= 16'h0;
			 rx_src_ip                     <= 32'h0;
			 rx_dst_ip                     <= 32'h0; 
		end
		else if(curr_state == RX_IP_HEADER) begin
			case(cnt_ip_header)
				5'd0:   {rx_ip_ver, rx_ip_hdr_len}                            <= rx_data_dly2;
				5'd1:   rx_ip_tos                                             <= rx_data_dly2;
				5'd2:   rx_total_len[15:8]                                    <= rx_data_dly2;
				5'd3:   rx_total_len[7:0]                                     <= rx_data_dly2;
				5'd4:   rx_ip_id[15:8]                                        <= rx_data_dly2;
				5'd5:   rx_ip_id[7:0]                                         <= rx_data_dly2;
				5'd6:   {rx_ip_rsv,rx_ip_df,rx_ip_mf,rx_ip_frag_offset[12:8]} <= rx_data_dly2;
				5'd7:   rx_ip_frag_offset[7:0]                                <= rx_data_dly2;
				5'd8:   rx_ip_ttl                                             <= rx_data_dly2;
				5'd9:   rx_ip_protocol                                        <= rx_data_dly2;
				5'd10:  rx_ip_check_sum[15:8]                                 <= rx_data_dly2;
				5'd11:  rx_ip_check_sum[7:0]                                  <= rx_data_dly2;
				5'd12:  rx_src_ip[31:24]                                      <= rx_data_dly2;
				5'd13:  rx_src_ip[23:16]                                      <= rx_data_dly2;
				5'd14:  rx_src_ip[15:8]                                       <= rx_data_dly2;
				5'd15:  rx_src_ip[7:0]                                        <= rx_data_dly2;
				5'd16:  rx_dst_ip[31:24]                                      <= rx_data_dly2;
				5'd17:  rx_dst_ip[23:16]                                      <= rx_data_dly2;
				5'd18:  rx_dst_ip[15:8]                                       <= rx_data_dly2;
				5'd19:  rx_dst_ip[7:0]                                        <= rx_data_dly2;      
				default: ;
			endcase
		end
	end
	
	//udp_header:8byte
	//ip_header
	//数据处理
	always @(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			rx_data_len <= 16'd0;
		else if(curr_state == RX_IP_HEADER && cnt_ip_header == 5'd19)
			rx_data_len = rx_total_len - 8'd20 - 8'd8;
		else 
			rx_data_len <= rx_data_len;
	end
	
	//ip校验启动
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			ip_checksum_cal_en <= 1'b0;
		else if(curr_state == RX_IP_HEADER && cnt_ip_header == 5'd19)
			ip_checksum_cal_en <= 1'b1;
		else
			ip_checksum_cal_en <= 1'b0;
	end
	
	//接收完成
	ip_checksum ip_checksum(
    .clk               (clk_125m),
    .rst_n             (rst_n),
    
    .cal_en            (ip_checksum_cal_en),
    
    .ip_ver            (rx_ip_ver),
    .ip_hdr_len        (rx_ip_hdr_len),
    .ip_tos            (rx_ip_tos),
    .ip_total_len      (rx_total_len),
    .ip_id             (rx_ip_id),
    .ip_rsv            (rx_ip_rsv),
    .ip_df             (rx_ip_df),
    .ip_mf             (rx_ip_mf),
    .ip_frag_offset    (rx_ip_frag_offset),
    .ip_ttl            (rx_ip_ttl),
    .ip_protocol       (rx_ip_protocol),
    .src_ip            (rx_src_ip),
    .dst_ip            (rx_dst_ip),
    
    .check_sum         (cal_check_sum)
    );
	 
	 //ip head检测
	 always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			ip_header_check_ok <= 1'b0;
		else if({IP_VER,IP_HDR_LEN,IP_PROTOCOL,cal_check_sum,reg_local_ip} == 
				  {rx_ip_ver,rx_ip_hdr_len,rx_ip_protocol,rx_ip_check_sum,rx_dst_ip})
			ip_header_check_ok <= 1'b1;
		else
			ip_header_check_ok <= 1'b0;  
	 end
	 
	 //cnt_udp_header
	 always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_udp_header <= 4'd0;
		else if(curr_state == RX_UDP_HEADER)
			cnt_udp_header <= cnt_udp_header + 1'b1;
		else 
			cnt_udp_header <= 4'd0;
	 end
	 
	 //udp参数捕获
	 always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)begin
			rx_src_port <= 16'h0;
			rx_dst_port <= 16'h0;
			rx_udp_len  <= 16'h0;
		end
		else if(curr_state == RX_UDP_HEADER)begin
			case(cnt_udp_header)
				4'd0: rx_src_port[15:8]   <= rx_data_dly2;
				4'd1: rx_src_port[7:0]    <= rx_data_dly2;
				4'd2: rx_dst_port[15:8]   <= rx_data_dly2;
				4'd3: rx_dst_port[7:0]    <= rx_data_dly2;
				4'd4: rx_udp_len[15:8]    <= rx_data_dly2;
				4'd5: rx_udp_len[7:0]     <= rx_data_dly2;      
				default: ;
			endcase
		end
	 end
	 
  //udp数据检测
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			udp_header_check_ok <= 1'b0;
		else if(rx_dst_port == reg_local_port)
			udp_header_check_ok <= 1'b1;
		else
			udp_header_check_ok <= 1'b0;
	end
	
	//cnt_data数据cnt
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_data <= 16'd0;
		else if(curr_state == RX_DATA)
			cnt_data <= cnt_data + 1'b1;
		else 
			cnt_data <= 16'd0;
	 end
	 
	 //cnt_drp_data
	 always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_drp_data <= 5'd0;
		else if(curr_state == RX_DRP_DATA)
			cnt_drp_data <= cnt_drp_data + 1'b1;
		else 
			cnt_drp_data <= 5'd0;
	 end
	 
	//cnt_crc
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			cnt_crc <= 2'd0;
		else if(curr_state == RX_CRC)
			cnt_crc <= cnt_crc + 1'b1;
		else
			cnt_crc <= 2'd0;
	end
	
	//rx_crc_data  
	always@(posedge clk_125m or negedge rst_n)begin
	if(!rst_n)
		rx_crc_data <= 32'd0;
	else if(curr_state == RX_CRC)begin
		case(cnt_crc)
			2'd0:rx_crc_data[7:0] <= rx_data_dly2;
			2'd1:rx_crc_data[15:8] <= rx_data_dly2;
			2'd2:rx_crc_data[23:16]  <= rx_data_dly2;
			2'd3:rx_crc_data[31:24]   <= rx_data_dly2;
		endcase
	end
	end
	 
	 //FSM
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			curr_state <= IDLE;
		else
			curr_state <= next_state;
	end
	
	//主状态机
	always@(*)
	begin
    case(curr_state)
		IDLE:
			if(!rx_datav_dly2 && rx_datav_dly1)
				next_state = RX_PREAMBLE;
			else 
				next_state = IDLE;
		
		RX_PREAMBLE:
			if(rx_data_dly2 == 8'hd5 && cnt_preamble > 4'd5) //最后一个直接为d5
				next_state = RX_ETH_HEADER;
			else if(cnt_preamble > 4'd7)
				next_state = IDLE;
			else 
				next_state = RX_PREAMBLE;
		
		RX_ETH_HEADER:
			if(cnt_eth_header == 4'd13) //接收完成进入ip header接收
				next_state = RX_IP_HEADER;
			else 
				next_state = RX_ETH_HEADER;
		
		RX_IP_HEADER:
			if(cnt_ip_header == 5'd2 && eth_header_check_ok == 1'b0) //判断eth header是否为设备的数据
				next_state = IDLE;
			else if(cnt_ip_header == 5'd19)  //跳转到下一个模式
				next_state = RX_UDP_HEADER;
			else
				next_state = RX_IP_HEADER;
		
		RX_UDP_HEADER:
			if(cnt_udp_header == 4'd2 && ip_header_check_ok == 1'b0) //判断iphead是否成功
				next_state = IDLE;
			else if(cnt_udp_header == 4'd7 && udp_header_check_ok == 1'b0) //判断端口是否准确
				next_state = IDLE;
			else if(cnt_udp_header == 4'd7)
				next_state = RX_DATA;
			else	
				next_state = RX_UDP_HEADER;
		
		RX_DATA:
			if((rx_data_len < 5'd18) && (cnt_data == rx_data_len - 1'b1))
				next_state = RX_DRP_DATA;
			else if(cnt_data == rx_data_len - 1'b1)
				next_state = RX_CRC;
			else 
				next_state = RX_DATA;
		
		RX_DRP_DATA:
        if(cnt_drp_data == 5'd17 - rx_data_len)                           //结束
          next_state = RX_CRC;
        else
          next_state = RX_DRP_DATA;
      
		RX_CRC:
			if(cnt_crc == 2'd3)  //发送结束
				next_state = PKT_CHECK;
			else 
				next_state = RX_CRC;
				
		PKT_CHECK:
				next_state = IDLE;
		default :next_state = IDLE;
		endcase
	end
	
	//crc init启动标志 接收到启动信号就进入crc
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			crc_init <= 1'b0;
		else if(rx_datav_dly1 && (~rx_datav_dly2)) //上升沿
			crc_init <= 1'b1;
		else 
			crc_init <= 1'b0;
	end
	
	//crc en
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			crc_en <= 1'b0;
		else if(curr_state == IDLE)
			crc_en <= 1'b0;
		else if (curr_state == RX_ETH_HEADER && cnt_eth_header == 1'b0)
			crc_en <= 1'b1;
		else if(curr_state == RX_CRC && cnt_crc == 1'b0)
			crc_en <= 1'b0;
		else 
			crc_en <= crc_en;
	end
	
	//crcdata
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			crc_data <= 8'd0;
		else 
			crc_data <= rx_data_dly2;
	end
	
	
	crc32_d8 crc32_d8_inst
	(
		.clk(clk_125m),
		.rst_n(rst_n),
		
		.data(crc_data),
		.crc_init(crc_init),
		.crc_en(crc_en),
		.crc_result(crc_check)
	);
	
	
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n)
			reg_data_overflow <= 1'b0;
		else if(curr_state == RX_DATA && data_overflow_i == 1'b1)
			reg_data_overflow <= 1'b1;
		else
			reg_data_overflow <= reg_data_overflow;
	end
	
	//payload输出和状态输出
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n) begin
			payload_valid_o <= 1'b0;
			payload_data_o  <= 8'h0;
		end
		else if(curr_state == RX_DATA) begin
			payload_valid_o <= 1'b1;
			payload_data_o  <= rx_data_dly2;
		end
		else begin
			payload_valid_o <= 1'b0;
			payload_data_o  <= 8'h0;
		end
	end
	
	//接收数据转移
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n) begin
			exter_mac  <= 48'h0;
			exter_ip   <= 32'h0;
			exter_port <= 16'h0;
		end
		else if(curr_state == PKT_CHECK)begin
			exter_mac  <= rx_src_mac;
			exter_ip   <= rx_src_ip;
			exter_port <= rx_src_port;
		end
	end
	
	//接收完成
	always@(posedge clk_125m or negedge rst_n)begin
		if(!rst_n) begin
			one_pkt_done <= 1'b0;
			pkt_err <= 1'b0;
		end
		else if(curr_state == PKT_CHECK)begin
			one_pkt_done <= 1'b1;
			if(crc_check == rx_crc_data && reg_data_overflow == 1'b0)
				pkt_err <= 1'b0;
			else 
				pkt_err <= 1'b1;
		end
		else begin
			one_pkt_done <= 1'b0;
			pkt_err      <= 1'b0;
		end
		
		
	end
		
	 
 endmodule