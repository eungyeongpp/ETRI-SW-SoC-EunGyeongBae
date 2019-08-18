//ALL

module convolution	#(parameter stride=1)	(
		input iCLK,iRSTn,
		input signed [31:0] iX,iW,
		input [9:0] iADDR,
		input iWren,
		input iValid,
		output signed [31:0] oY,
		output oValid
		);


wire signed [31:0] iX_dff;
wire iValid_d;
wire signed [31:0] oQ_iPsum,oQ_iPsum1,oQ_iPsum2,oQ_iPsum3;
wire signed [31:0] oPsum;
wire signed [31:0] w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25;

in_dff		u_indff1		(iCLK,iRSTn,iX,iX_dff);
in_dff		u_indff2		(iCLK,iRSTn,iValid,iValid_d);
weight		u_weight		(iCLK,iRSTn,iWren,iADDR,iW,	w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25);
top_step1	u_step1			(iCLK,iRSTn,iX_dff,	w1,w2,w3,w4,w5,			0,			oQ_iPsum1);
top_step1	u_step2			(iCLK,iRSTn,iX_dff,	w6,w7,w8,w9,w10,		oQ_iPsum1,	oQ_iPsum2);
top_step1	u_step3			(iCLK,iRSTn,iX_dff,	w11,w12,w13,w14,w15,	oQ_iPsum2,	oQ_iPsum3);
top_step1	u_step4			(iCLK,iRSTn,iX_dff,	w16,w17,w18,w19,w20,	oQ_iPsum3,	oQ_iPsum);
top_pe		u_step5_1		(iCLK,iRSTn,iX_dff,	w21,w22,w23,w24,w25,	oQ_iPsum,	oPsum);
sat			u_step5_2		(oPsum,oY);
ctrl		#(32,5,stride)	u_ctrl	(iCLK,iRSTn,iValid_d,oValid);

endmodule
