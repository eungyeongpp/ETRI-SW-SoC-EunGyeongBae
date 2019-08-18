module pe	#(parameter BW1=16, BW2=17)	(	
		input clk, rst,
		input signed [31:0] iX,iW,
		input signed [BW1-1:0] iPsum,
		output reg signed [BW2-1:0] oPsum
		);


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		oPsum<=0;
	end
	else begin
		oPsum<=(iX*iW)+iPsum;
	end
end


endmodule
