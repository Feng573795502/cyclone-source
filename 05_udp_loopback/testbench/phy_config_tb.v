`timescale 1ns/1ps

module phy_config_tb;
	
	reg  clk;        //模块时钟50MHz
	reg  rst_n;      //模块复位，低电平有效
	wire phy_rst_n;  //phy芯片复位，低电平有效
	wire mdc;        //时钟接口
	wire  mdio;       //数据接口
	wire phy_init;    //初始化完成标志，高电平有效
	
	pullup PUP(mdio);
	
	phy_config DUT(
		.clk      (clk),        //模块时钟50MHz
		.rst_n    (rst_n),      //模块复位，低电平有效
		.phy_rst_n(phy_rst_n),  //phy芯片复位，低电平有效
		.mdc      (mdc),        //时钟接口
		.mdio     (mdio),       //数据接口
		.init_done (phy_init)    //初始化完成标志，高电平有效
	);
	
	
	always #10 clk = ~clk;
	
	initial begin
		clk = 1;
		rst_n = 0;
		#201;
		rst_n = 1;
		
		@(posedge phy_init)
		#20;
		
		#201;
		$stop;
	end

endmodule

