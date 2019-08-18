module dff	#(parameter N=16)	( 
		input clk,rst,
		input [N-1:0] iD,
		output reg [N-1:0] oQ
		);


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		oQ<=0;
	end
	else begin
		oQ<=iD;
	end
end


endmodule
