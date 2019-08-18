module top_pe	(
		input clk, rst,
		input signed [31:0] iX,
		input signed [31:0] w1,w2,w3,w4,w5,
		input signed [31:0] iPsum,
		output signed [31:0] oPsum
		);


wire signed [31:0] oPsum1,oPsum2;
wire signed [31:0] oPsum3,oPsum4;

pe	#(32,32)	u_pe1	(clk,rst,iX,w1,iPsum,oPsum1);
pe	#(32,32)	u_pe2	(clk,rst,iX,w2,oPsum1,oPsum2);
pe	#(32,32)	u_pe3	(clk,rst,iX,w3,oPsum2,oPsum3);
pe	#(32,32)	u_pe4	(clk,rst,iX,w4,oPsum3,oPsum4);
pe	#(32,32)	u_pe5	(clk,rst,iX,w5,oPsum4,oPsum);


endmodule
