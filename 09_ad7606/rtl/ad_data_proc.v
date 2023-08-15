	module ad_data_proc(
		input clk,
		input rst_n,
		
		output [31:0]result
	};

	
	reg ad_req;
	reg [15:0]cnt;


	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 16'd0;
		else 
			cnt <= cnt + 1'b1;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(
	end

	endmodule
	