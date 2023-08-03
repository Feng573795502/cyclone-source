//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 09:55:26
// Design Name: 
// Module Name: eth_udp_tx_gmii
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module eth_udp_tx_gmii(
        input  clk_125m,
        input  rst_n,
        
        input  tx_en_pulse,
        output reg tx_done,
        
        input  [47:0]dst_mac,
        input  [47:0]src_mac,
        input  [31:0]dst_ip,
        input  [31:0]src_ip,
        input  [15:0]dst_port,
        input  [15:0]src_port,
        
        input  [15:0]data_len,
        
        output payload_req_o,
        input  [7:0]payload_dat_i,
        
        output gmii_tx_clk,
        (*IOB = "TRUE"*) output reg      gmii_txen,
        (*IOB = "TRUE"*) output reg [7:0]gmii_txd
    );
    
    //定制参数主要是eth的
    parameter ETH_TYPE       = 16'h0800,
            IP_VER         = 4'h4,
            IP_HDR_LEN     = 4'h5,
            IP_TOS         = 8'h00,
            IP_ID          = 16'h0000,
            IP_RSV         = 1'b0,
            IP_DF          = 1'b0,
            IP_MF          = 1'b0,
            IP_FRAG_OFFSET = 13'h0000,
            IP_TTL         = 8'h40,
            IP_PROTOCOL    = 8'h11;
    
      //状态定义
      localparam
        IDLE          = 8'b00000001,
        TX_PREAMBLE   = 8'b00000010,
        TX_ETH_HEADER = 8'b00000100,
        TX_IP_HEADER  = 8'b00001000,
        TX_UDP_HEADER = 8'b00010000,
        TX_DATA       = 8'b00100000,
        TX_FILL_DATA  = 8'b01000000,
        TX_CRC        = 8'b10000000;
        
    //校验值
    wire [15:0]ip_check_sum;
    wire [15:0]udp_len;
    wire [15:0]ip_total_len;
    
    wire [15:0] udp_check_sum = 16'h0000;
    //传入参数缓存寄存器
    reg  [47:0] dst_mac_reg;
    reg  [47:0] src_mac_reg;
    reg  [15:0] dst_port_reg;
    reg  [15:0] src_port_reg;
    reg  [31:0] dst_ip_reg;
    reg  [31:0] src_ip_reg;
    reg  [15:0] data_len_reg; 
    reg  [15:0] ip_total_len_reg;
    reg  [15:0] udp_len_reg;
    
    //状态机计数器和状态记录
    reg  [3:0]  cnt_preamble;
    reg  [3:0]  cnt_eth_header;
    reg  [4:0]  cnt_ip_header;
    reg  [3:0]  cnt_udp_header;
    reg  [15:0] cnt_data;
    reg  [4:0]  cnt_fill_data;
    reg  [1:0]  cnt_crc;
    reg  [7:0]  tx_data;
    reg         tx_en;
    reg  [7:0]  curr_state;
    reg  [7:0]  next_state;
    
    //crc控制
    wire      crc_state;
    reg       crc_state_dly1;
    reg       crc_state_dly2;
    
    reg [1:0] cnt_crc_dly1;
    reg [1:0] cnt_crc_dly2;
    
    reg       tx_en_dly1;
    reg [7:0] tx_data_dly1;
    reg       crc_init;
    reg       crc_en_temp;
    reg       crc_en;
    reg [7:0] crc_in;
    wire [31:0]crc_result;
    
    reg [7:0] gmii_txd_renewcrc;
    reg       gmii_txen_renewcrc;
    
    
    //输出同一个时钟
    assign gmii_tx_clk = clk_125m;
    
    assign udp_len = data_len + 8'd8;       //udp头 8byte
    assign ip_total_len = udp_len + 8'd20;  //ip头  20byte
    
    ip_checksum ip_checksum(
        .clk            (clk_125m       ),
        .rst_n          (rst_n          ),
        
        .cal_en         (tx_en_pulse    ),
        
        .ip_ver         (IP_VER         ),
        .ip_hdr_len     (IP_HDR_LEN     ),
        .ip_tos         (IP_TOS         ),
        .ip_total_len   (ip_total_len   ),
        .ip_id          (IP_ID          ),
        .ip_rsv         (IP_RSV         ),
        .ip_df          (IP_DF          ),
        .ip_mf          (IP_MF          ),
        .ip_frag_offset (IP_FRAG_OFFSET ),
        .ip_ttl         (IP_TTL         ),
        .ip_protocol    (IP_PROTOCOL    ),
        .src_ip         (src_ip         ),
        .dst_ip         (dst_ip         ),
        
        .check_sum       (ip_check_sum   )
    );
    
    //获取寄存器置
    always@(posedge clk_125m or negedge rst_n) begin
        if(!rst_n)begin
            dst_mac_reg <= 48'd0;
            src_mac_reg <= 48'd0;
            dst_ip_reg <= 32'd0;
            src_ip_reg <= 32'd0;
            dst_port_reg <= 16'd0;
            src_port_reg <= 16'd0;
        end
        else if(tx_en_pulse)begin
            dst_mac_reg <= dst_mac;
            src_mac_reg <= src_mac;
            dst_ip_reg <= dst_ip;
            src_ip_reg <= src_ip;
            dst_port_reg <= dst_port;
            src_port_reg <= src_port;
        end 
        else begin
            dst_mac_reg <= dst_mac_reg;
            src_mac_reg <= src_mac_reg;
            dst_ip_reg <= dst_ip_reg;
            src_ip_reg <= src_ip_reg;
            dst_port_reg <= dst_port_reg;
            src_port_reg <= src_port_reg;
        end 
    end
    
    //数据保温长度等寄存器存储
    always@(posedge clk_125m or negedge rst_n) begin
        if(!rst_n)begin
            data_len_reg <= 16'd0;
            ip_total_len_reg <= 16'd0;
            udp_len_reg <= 16'd0;
        end
        else if(tx_en_pulse)begin
             data_len_reg <= data_len;
            ip_total_len_reg <= ip_total_len;
            udp_len_reg <= udp_len;
        end 
    end
    
    //状态变换
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
            if(tx_en_pulse)
                next_state <= TX_PREAMBLE;
            else 
                next_state <= IDLE;
                
        TX_PREAMBLE:
            if(cnt_preamble == 4'd7)
                next_state <= TX_ETH_HEADER;
            else 
                next_state <= TX_PREAMBLE;
                
        TX_ETH_HEADER:
            if(cnt_eth_header == 4'd13)
                next_state <= TX_IP_HEADER;
            else 
                next_state <= TX_ETH_HEADER;
                
        TX_IP_HEADER:
            if(cnt_ip_header == 5'd19)
                next_state <= TX_UDP_HEADER;
            else 
                next_state <= TX_IP_HEADER;
                
        TX_UDP_HEADER:
            if(cnt_udp_header == 4'd7)
                next_state <= TX_DATA;
            else 
                next_state <= TX_UDP_HEADER;
                
        TX_UDP_HEADER:
            if(cnt_data == 4'd7)
                next_state <= TX_DATA;
            else 
                next_state <= TX_UDP_HEADER;  
                
        TX_DATA:
            if(data_len_reg <5'd18 && cnt_data == data_len_reg - 1'b1)
                next_state <= TX_FILL_DATA;
            else if(cnt_data == data_len_reg - 1'b1)
                next_state <= TX_CRC;
            else 
                next_state <= TX_DATA;  
        TX_FILL_DATA:
            if( cnt_fill_data == 5'd17 - data_len_reg)
                next_state = TX_CRC;
            else
                next_state = TX_FILL_DATA;
                
        TX_CRC:
            if( cnt_crc == 2'd3)
                next_state = IDLE;
            else
                next_state = TX_CRC;
                
        default: next_state = IDLE;
    endcase
    end
    
    //cnt_preamble
    always@(posedge clk_125m or negedge rst_n)
        if(!rst_n)
            cnt_preamble <= 4'd0;
        else if(curr_state == TX_PREAMBLE)
            cnt_preamble <= cnt_preamble + 1'b1;
        else 
           cnt_preamble <= 4'd0;
           
    //cnt_eth_header
    always@(posedge clk_125m or negedge rst_n)
        if(!rst_n)
            cnt_eth_header <= 4'd0;
        else if(curr_state == TX_ETH_HEADER)
            cnt_eth_header <= cnt_eth_header + 1'b1;
        else 
           cnt_eth_header <= 4'd0;
          
    //cnt_ip_header
    always@(posedge clk_125m or negedge rst_n)
        if(!rst_n)
            cnt_ip_header <= 5'd0;
        else if(curr_state == TX_IP_HEADER)
            cnt_ip_header <= cnt_ip_header + 1'b1;
        else 
           cnt_ip_header <= 5'd0;
           
    //cnt_udp_header
    always@(posedge clk_125m or negedge rst_n)
        if(!rst_n)
            cnt_udp_header <= 4'd0;
        else if(curr_state == TX_UDP_HEADER)
            cnt_udp_header <= cnt_udp_header + 1'b1;
        else 
           cnt_udp_header <= 4'd0; 
           
    //cnt_data
    always@(posedge clk_125m or negedge rst_n)
        if(!rst_n)
            cnt_data <= 16'd0;
        else if(curr_state == TX_DATA)
            cnt_data <= cnt_data + 1'b1;
        else 
           cnt_data <= 16'd0; 
           
  //cnt_fill_data
    always@(posedge clk_125m or negedge rst_n)
    if(!rst_n)
        cnt_fill_data <= 5'd0;
    else if(curr_state == TX_FILL_DATA)
        cnt_fill_data <= cnt_fill_data + 1'b1;
    else
        cnt_fill_data <= 5'd0;
    
    //cnt_crc
    always@(posedge clk_125m or negedge rst_n)
    if(!rst_n)
        cnt_crc <= 5'd0;
    else if(curr_state == TX_CRC)
        cnt_crc <= cnt_crc + 1'b1;
    else
        cnt_crc <= 5'd0;
        
    //数据处理
    always@(posedge clk_125m or negedge rst_n)begin
    if(!rst_n)
        begin
            tx_en   <= 1'b0;
            tx_data <= 8'h00;
        end
    else
    begin
        case(curr_state)
        IDLE:begin
            tx_en <= 1'b0;
            tx_data <= 8'b0;
        end
        
        TX_PREAMBLE:begin
            tx_en <= 1'b1;
            if(cnt_preamble == 4'd7)
                tx_data <= 8'hd5;
            else         
                tx_data <= 8'h55;
        end
        
        TX_ETH_HEADER:begin
            tx_en <= 1'b1;
            case(cnt_eth_header)
              4'd0:   tx_data <= dst_mac_reg[47:40];
              4'd1:   tx_data <= dst_mac_reg[39:32];
              4'd2:   tx_data <= dst_mac_reg[31:24];
              4'd3:   tx_data <= dst_mac_reg[23:16];
              4'd4:   tx_data <= dst_mac_reg[15:8];
              4'd5:   tx_data <= dst_mac_reg[7:0];
              4'd6:   tx_data <= src_mac_reg[47:40];
              4'd7:   tx_data <= src_mac_reg[39:32];
              4'd8:   tx_data <= src_mac_reg[31:24];
              4'd9:   tx_data <= src_mac_reg[23:16];
              4'd10:  tx_data <= src_mac_reg[15:8];
              4'd11:  tx_data <= src_mac_reg[7:0];
              4'd12:  tx_data <= ETH_TYPE[15:8];
              4'd13:  tx_data <= ETH_TYPE[7:0];
              default:tx_data <= 8'h00; 
        endcase
      end
        TX_IP_HEADER:begin
            tx_en <= 1'b1;
            case(cnt_ip_header)
              5'd0:   tx_data <= {IP_VER,IP_HDR_LEN};
              5'd1:   tx_data <= IP_TOS;
              5'd2:   tx_data <= ip_total_len_reg[15:8];
              5'd3:   tx_data <= ip_total_len_reg[7:0];
              5'd4:   tx_data <= IP_ID[15:8];
              5'd5:   tx_data <= IP_ID[7:0];
              5'd6:   tx_data <= {IP_RSV,IP_DF,IP_MF,IP_FRAG_OFFSET[12:8]};
              5'd7:   tx_data <= IP_FRAG_OFFSET[7:0];
              5'd8:   tx_data <= IP_TTL;
              5'd9:   tx_data <= IP_PROTOCOL;
              5'd10:  tx_data <= ip_check_sum[15:8];
              5'd11:  tx_data <= ip_check_sum[7:0];
              5'd12:  tx_data <= src_ip_reg[31:24];
              5'd13:  tx_data <= src_ip_reg[23:16];
              5'd14:  tx_data <= src_ip_reg[15:8];
              5'd15:  tx_data <= src_ip_reg[7:0];
              5'd16:  tx_data <= dst_ip_reg[31:24];
              5'd17:  tx_data <= dst_ip_reg[23:16];
              5'd18:  tx_data <= dst_ip_reg[15:8];
              5'd19:  tx_data <= dst_ip_reg[7:0];
              default:tx_data <= 8'h00; 
        endcase
      end
      
        TX_UDP_HEADER: begin
            tx_en <= 1'b1;
            case(cnt_udp_header)
              4'd0:   tx_data <= src_port_reg[15:8];
              4'd1:   tx_data <= src_port_reg[7:0];
              4'd2:   tx_data <= dst_port_reg[15:8];
              4'd3:   tx_data <= dst_port_reg[7:0];
              4'd4:   tx_data <= udp_len_reg[15:8];
              4'd5:   tx_data <= udp_len_reg[7:0];
              4'd6:   tx_data <= udp_check_sum[15:8];
              4'd7:   tx_data <= udp_check_sum[7:0];
              default:tx_data <= 8'h00; 
            endcase
          end
        
        TX_DATA: begin
            tx_en <= 1'b1;
            tx_data <= payload_dat_i;
        end
        
        TX_FILL_DATA: begin
            tx_en <= 1'b1;
            tx_data <= 8'h00;
        end
        
        TX_CRC:begin
            tx_en <= 1'b1;
            tx_data <= 8'h00;
        end
        endcase
    end
    end   
    
    //crc的处理
    assign payload_req_o = (curr_state == TX_DATA) ? 1'b1: 1'b0;
    
    //初始化crc
    always@(posedge clk_125m or negedge rst_n)begin
        if(!rst_n)
            crc_init <= 1'b0;
        else if(tx_en_pulse && (curr_state == IDLE))
            crc_init <= 1'b1;
        else 
            crc_init <= 1'b0;
    end
    
    //crc使能判断
    always@(posedge clk_125m or negedge rst_n)begin
      if(!rst_n)
        crc_en_temp <= 1'b0;
      else if (curr_state == TX_ETH_HEADER || curr_state == TX_IP_HEADER || 
               curr_state == TX_UDP_HEADER || curr_state == TX_FILL_DATA || curr_state == TX_DATA) //除了IDLE都使能CRC
        crc_en_temp <= 1'b1;
      else 
        crc_en_temp <= 1'b0;
    end
    
    //crc使能 delay了一个时钟周期
    always@(posedge clk_125m or negedge rst_n)begin
      if(!rst_n)
        crc_en <= 1'b0;
      else if(crc_en_temp)
        crc_en <= 1'b1;
      else 
        crc_en <= 1'b0;
    end
    
    //crc数据
    always@(posedge clk_125m or negedge rst_n)begin
      if(!rst_n)
        crc_in <= 8'h00;
      else if(crc_en_temp)
        crc_in <= tx_data;
      else 
        crc_in <= crc_in;
    end
    
    crc32_d8 crc32_d8(
        .clk         (clk_125m    ),
        .rst_n     (rst_n    ),
    
        .data        (crc_in     ),
        .crc_init    (crc_init   ),
        .crc_en      (crc_en     ),
        .crc_result  (crc_result )//latency=1
    );
    
    //crc状态
    assign crc_state = curr_state == TX_CRC;
    
    //状态延时和数据延时
    always@(posedge clk_125m or negedge rst_n) begin
        if(!rst_n)begin
            tx_en_dly1 <= 1'b0;
            tx_data_dly1 <= 8'h00;
        end
        else begin
            tx_en_dly1 <= tx_en;
            tx_data_dly1 <= tx_data;
        end
    end
    
    //延时两个时钟周期，状态和crc_cnt
    always @(posedge clk_125m or negedge rst_n)begin
      if(!rst_n)
      begin
        crc_state_dly1 <= 1'b0;
        crc_state_dly2 <= 1'b0;
        cnt_crc_dly1   <= 2'd0;
        cnt_crc_dly2   <= 2'd0;
      end
      else
      begin
        crc_state_dly1 <= crc_state;
        crc_state_dly2 <= crc_state_dly1;
        cnt_crc_dly1   <= cnt_crc;
        cnt_crc_dly2   <= cnt_crc_dly1;
      end
    end
    
    //数据输出然后转到crc输出
    always @(posedge clk_125m or negedge rst_n)begin
        if(!rst_n)
            gmii_txd_renewcrc <= 8'h00;
        else if(crc_state_dly2)
        begin
            case(cnt_crc_dly2)
              2'd0:gmii_txd_renewcrc <= crc_result[7:0];
              2'd1:gmii_txd_renewcrc <= crc_result[15:8];
              2'd2:gmii_txd_renewcrc <= crc_result[23:16];
              2'd3:gmii_txd_renewcrc <= crc_result[31:24];
            endcase
        end
        else 
            gmii_txd_renewcrc <= tx_data_dly1;
    end
      always@(posedge clk_125m or negedge rst_n)begin
          if(!rst_n)
            gmii_txen_renewcrc <= 1'b0;
          else if(tx_en_dly1)
            gmii_txen_renewcrc <= 1'b1;
          else
            gmii_txen_renewcrc <= 1'b0;
      end
      always@(posedge clk_125m or negedge rst_n)begin
          if(!rst_n)
          begin
            gmii_txen <= 1'b0;
            gmii_txd  <= 8'h00;
          end
          else
          begin
            gmii_txen <= gmii_txen_renewcrc;
            gmii_txd  <= gmii_txd_renewcrc;
          end
      end
    //发送完成 
    always@(posedge clk_125m or negedge rst_n) begin
        if(!rst_n)
            tx_done <= 1'b0;
        else if(curr_state == TX_CRC && cnt_crc == 2'd3) //发送结束
            tx_done <= 1'b1;
        else
            tx_done <= 1'b0;
    end
endmodule
