module io(
	input clk,
	input rst_n,
	
	input in,
	output reg out
);


always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		out <= 1'b0;
	else 
		out <= in;
end

//always @(posedge clk or negedge rst_n)begin
//	if(!rst_n)
//		in <= 1'b0;
//	else 
//		in = ~in;
//end

endmodule