	module crc16_d8(
		input clk,
		input rst_n,
		
		input [7:0]data,
		input crc_init,
		input crc_en,
		
		output [15:0]crc_result
	);
	
	function [15:0] nextCRC16_D8;

		input [7:0] Data;
		input [15:0] crc;
		reg [7:0] d;
		reg [15:0] c;
		reg [15:0] newcrc;
		begin
			d = Data;
			c = crc;

			newcrc[0]  = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
			newcrc[1]  = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
			newcrc[2]  = d[1] ^ d[0] ^ c[8] ^ c[9];
			newcrc[3]  = d[2] ^ d[1] ^ c[9] ^ c[10];
			newcrc[4]  = d[3] ^ d[2] ^ c[10] ^ c[11];
			newcrc[5]  = d[4] ^ d[3] ^ c[11] ^ c[12];
			newcrc[6]  = d[5] ^ d[4] ^ c[12] ^ c[13];
			newcrc[7]  = d[6] ^ d[5] ^ c[13] ^ c[14];
			newcrc[8]  = d[7] ^ d[6] ^ c[0] ^ c[14] ^ c[15];
			newcrc[9]  = d[7] ^ c[1] ^ c[15];
			newcrc[10] = c[2];
			newcrc[11] = c[3];
			newcrc[12] = c[4];
			newcrc[13] = c[5];
			newcrc[14] = c[6];
			newcrc[15] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
			nextCRC16_D8 = newcrc;
		end
		endfunction
	
	
	reg [15:0]crc_result_o;
	wire [7:0]data_i;
	
	assign data_i = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};
	
	assign crc_result = 
	{crc_result_o[0], crc_result_o[1],crc_result_o[2],crc_result_o[3],
	crc_result_o[4],crc_result_o[5],crc_result_o[6],crc_result_o[7],
	crc_result_o[8],crc_result_o[9],crc_result_o[10],crc_result_o[11],
	crc_result_o[12],crc_result_o[13],crc_result_o[14],crc_result_o[15]};
	
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			crc_result_o <= 16'hffff;
		else if(crc_init)
			crc_result_o <= 16'hffff;
		else if(crc_en)
			crc_result_o <= nextCRC16_D8(data_i, crc_result_o);
		else 
			crc_result_o <= crc_result_o;
	end
	

endmodule
	
	
	
	