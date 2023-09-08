module calibration_top
(
	input clk,
	input rst_n,
	
	//数据和数据有效值
	input [32:0]data,
	input valid,
	
	input go //清除缓存区
);

	reg        rdreq;
	wire [7:0] rdusedw;
	wire[31:0]  data1;
	wire[31:0]  data2;
	wire[31:0]  data3;
	wire[31:0]  data4;
	wire[31:0]  data5;
	wire[31:0]  data6;
	wire[31:0]  data7;
	wire[31:0]  data8;
	

	data_cache data_cache (
	.aclr(go),
	.data(data),
	.rdclk(clk),
	.rdreq(rdreq),
	.wrclk(clk),
	.wrreq(valid),
	.q(
	{data1,data2,data3,data4,data5,data6,data7,data8}
	),
	.rdusedw(rdusedw)
	);
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)
			rdreq <= 1'b0;
		else if(rdusedw == 8'd2)
			rdreq <= 1'b1;
		else 
			rdreq <= 1'b0;
	end
	
endmodule