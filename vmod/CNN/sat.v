module sat(
		input signed [31:0] in,
		output reg signed [31:0] out
		);


always @(*) begin
	if(in>32767) begin
		out=32767;
	end
	else if(in<-32768)	begin
		out=-32768;
	end
	else begin
		out=in[15:0];
	end
end


endmodule
