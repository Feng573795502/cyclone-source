module data_receive(
input data_rxp,
input rx_inclock,
output [7:0]dedata,
//input rst_n,
output rx_locked,
input align_done,
input rx_data_align,
output rx_outclock,
output [9:0]rx_out

);

//wire [9:0]rx_out;
iserdes des_ins(
 .rx_data_align(rx_data_align),
 .rx_in(data_rxp),
 .rx_inclock(rx_inclock),
 .rx_locked(rx_locked),
 .rx_out(rx_out),
 .rx_outclock(rx_outclock)   
);

wire kout;
wire code_err;
decode decoder(
.clk(rx_outclock),
.rst_n(align_done),
.datain(rx_out),
.lock_n(1'b0),
.dataout(dedata),
.kout(kout),
.code_err(code_err)

); 

endmodule 