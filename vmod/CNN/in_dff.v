module in_dff(
		input clk, rst,
		input [31:0] iX,
		output reg [31:0] iX_d
		);


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		iX_d<=0;
	end
	else begin
		iX_d<=iX;
	end
end


endmodule
