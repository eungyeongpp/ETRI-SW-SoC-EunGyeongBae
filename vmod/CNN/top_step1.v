module top_step1(
			input clk,rst,
			input signed [31:0] iX,w1,w2,w3,w4,w5,
			input signed [31:0] iPsum,
			output signed [31:0] oQ_iPsum
			);


wire signed [31:0] oPsum_in;
wire signed [31:0] out_iD;

top_pe		u_top_pe	(clk,rst,iX,w1,w2,w3,w4,w5,iPsum,oPsum_in);
sat			u_sat		(oPsum_in,out_iD);
top_dff		u_top_dff	(clk,rst,out_iD,oQ_iPsum);


endmodule
