module weight(
		input clk,rst,iWren,
		input [9:0] iAddr,
		input signed [31:0] iW,
		output reg signed [31:0] w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25
		); 


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w1<=0;
	end
	else if(iWren&&iAddr==10'd0) begin
		w1<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w2<=0;
	end
	else if(iWren&&iAddr==10'd1) begin
		w2<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w3<=0;
	end
	else if(iWren&&iAddr==10'd2) begin
		w3<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w4<=0;
	end
	else if(iWren&&iAddr==10'd3) begin
		w4<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w5<=0;
	end
	else if(iWren&&iAddr==10'd4) begin
		w5<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w6<=0;
	end
	else if(iWren&&iAddr==10'd5) begin
		w6<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w7<=0;
	end
	else if(iWren&&iAddr==10'd6) begin
		w7<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w8<=0;
	end
	else if(iWren&&iAddr==10'd7) begin
		w8<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w9<=0;
	end
	else if(iWren&&iAddr==10'd8) begin
		w9<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w10<=0;
	end
	else if(iWren&&iAddr==10'd9) begin
		w10<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w11<=0;
	end
	else if(iWren&&iAddr==10'd10) begin
		w11<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w12<=0;
	end
	else if(iWren&&iAddr==10'd11) begin
		w12<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w13<=0;
	end
	else if(iWren&&iAddr==10'd12) begin
		w13<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w14<=0;
	end
	else if(iWren&&iAddr==10'd13) begin
		w14<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w15<=0;
	end
	else if(iWren&&iAddr==10'd14) begin
		w15<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w16<=0;
	end
	else if(iWren&&iAddr==10'd15) begin
		w16<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w17<=0;
	end
	else if(iWren&&iAddr==10'd16) begin
		w17<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w18<=0;
	end
	else if(iWren&&iAddr==10'd17) begin
		w18<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w19<=0;
	end
	else if(iWren&&iAddr==10'd18) begin
		w19<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w20<=0;
	end
	else if(iWren&&iAddr==10'd19) begin
		w20<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w21<=0;
	end
	else if(iWren&&iAddr==10'd20) begin
		w21<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w22<=0;
	end
	else if(iWren&&iAddr==10'd21) begin
		w22<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w23<=0;
	end
	else if(iWren&&iAddr==10'd22) begin
		w23<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w24<=0;
	end
	else if(iWren&&iAddr==10'd23) begin
		w24<=iW;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		w25<=0;
	end
	else if(iWren&&iAddr==10'd24) begin
		w25<=iW;
	end
end


endmodule
