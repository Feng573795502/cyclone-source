//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/24 14:34:08
// Design Name: 
// Module Name: ip_checksum
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


module ip_checksum(
    input clk,
    input rst_n,
    
    input cal_en,
    
    input [3:0]ip_ver,
    input [3:0]ip_hdr_len,
    input [7:0]ip_tos,
    input [15:0]ip_total_len,
    input [15:0]ip_id,
    input       ip_rsv,
    input       ip_df,
    input       ip_mf,
    input [12:0]ip_frag_offset,
    input [7:0] ip_ttl,
    input [7:0] ip_protocol,
    input [31:0]src_ip,
    input [31:0]dst_ip,
    
    output [15:0]check_sum
    );
    
    reg [31:0]suma;
    wire [16:0]sumb;
    wire [15:0]sumc;
    
    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            suma <= 32'd0;
        else if(cal_en)//每16bit进行二进制求和
            suma <= {ip_ver, ip_hdr_len, ip_tos} + ip_total_len + ip_id +
            {ip_rsv, ip_df,ip_mf, ip_frag_offset} + {ip_ttl, ip_protocol}+
            src_ip[31:16] + src_ip[15:0] + dst_ip[31:16] + dst_ip[15:0];
        else 
            suma <= suma;
            
    assign sumb = suma[31:16] + suma[15:0];
    assign sumc = sumb[16] + sumb[15:0];
    
    //将16bit的值取反,即为最终计算的check sum值
    assign check_sum = ~sumc;
        
endmodule
