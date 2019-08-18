module ctrl	#(parameter xs=32, ws=5, STRIDE=1)	(
		input clk,rst,
		input iValid,
		output reg oValid
		);

reg iValid_d;
reg [4:0] col_next,row_next;
reg [4:0] i,j;


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		j<=0;
	end
	else if(j==xs-1) begin
		j<=0;
	end
	else if(iValid==1)  begin
		j<=j+1;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		i<=0;
	end
	else if(j==xs-1&&i==xs-1) begin
		i<=0;
	end
	else if(j==xs-1) begin
		i<=i+1;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		col_next<=ws-1;
	end
	else if(i==row_next&&j==col_next&&j==xs-1) begin
		col_next<=ws-1;
	end
	else if(i==row_next&&j==col_next) begin
		col_next<=col_next+STRIDE;
	end
end

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		row_next<=ws-1;
	end
	else if(i==row_next&&j==col_next&&j==xs-1&&i==xs-1) begin
		row_next<=ws-1;
	end
	else if(i==row_next&&j==col_next&&j==xs-1) begin
		row_next<=row_next+STRIDE;
	end
end


always @(posedge clk, negedge rst) begin
	if(!rst) begin
		oValid<=0;
	end
	else if(i==row_next&&j==col_next&&iValid) begin
		oValid<=1;
	end
	else begin
		oValid<=0;
	end
end


endmodule
