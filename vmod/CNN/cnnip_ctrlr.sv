`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/17 16:56:29
// Design Name: 
// Module Name: cnnip_ctrlr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cnnip_ctrlr
(
      // clock and reset signals from domain a
      input wire clk_a,
      input wire arstz_aq,
    
      // internal memories
      cnnip_mem_if.master to_input_mem,
      cnnip_mem_if.master to_weight_mem,
      cnnip_mem_if.master to_feature_mem,
     
      // configuration registers
      input wire         CMD_START,  
      input wire   [7:0] MODE_KERNEL_SIZE,
      input wire   [7:0] MODE_KERNEL_NUMS,
      input wire   [1:0] MODE_STRIDE,
      input wire         MODE_PADDING,
      output wire        CMD_DONE,
      output wire        CMD_DONE_VALID
    
    );
    
    wire [31:0] iX,iW;
    wire [9:0] iADDR;
    wire iWren;
    wire iValid;
    wire [31:0] oY;
    wire oValid;
    
    convolution 	#(.stride(1))	
    u_convolution(
		.iCLK(clk_a),
		.iRSTn(arstz_aq),
		.iX(iX),
		.iW(iW),
		.iADDR(iADDR),
		.iWren(iWren),
		.iValid(iValid),
		
		.oY(oY),
		.oValid(oValid)
		);   
    
      // sample FSM
      enum { IDLE, READ, CONV } state_aq, state_next;  
    
    // State Counter
      reg [4:0] cnt_read;
      reg [9:0] cnt_conv;
      
      always @(posedge clk_a, negedge arstz_aq)
          if (!arstz_aq) cnt_read <= 5'b0;
          else if (state_aq == READ) cnt_read <= cnt_read + 1'b1;
          else cnt_read <= 5'b0;
            
      always @(posedge clk_a, negedge arstz_aq)
          if (!arstz_aq) cnt_conv <= 10'b0;
          else if (state_aq == CONV) cnt_conv <= cnt_conv + 1'b1;
          else cnt_conv <= 10'b0;
          
      // State Done Signal
      wire read_done;
      wire conv_done; 
      
      assign read_done = (cnt_read == 5'd24);
      assign conv_done = (cnt_conv == 10'd1023); // convolution이 언제 끝나는지 보충 조건 필요...?
      
      // Address Counter    
      reg [9:0] cnt_waddr;
      reg [9:0] cnt_xaddr;
      reg [9:0] cnt_faddr;    
          
      always @(posedge clk_a, negedge arstz_aq)
         if (!arstz_aq) cnt_waddr <= 10'b0;
         else if (state_aq == READ) cnt_waddr <= cnt_waddr + 4;
         else cnt_waddr <= 10'b0;         
         
      always @(posedge clk_a, negedge arstz_aq)
         if (!arstz_aq) cnt_xaddr <= 10'b0;
         else if (state_aq == CONV) cnt_xaddr <= cnt_xaddr + 4;
         else cnt_xaddr <= 10'b0;
         
      always @(posedge clk_a, negedge arstz_aq) 
         if (!arstz_aq) cnt_faddr <= 10'b0;
         else if (state_aq == CONV && oValid) cnt_faddr <= cnt_faddr + 4;
         else cnt_faddr <= 10'b0;
    
      // state transition
      always @(posedge clk_a, negedge arstz_aq)
        if (arstz_aq == 1'b0) state_aq <= IDLE;
        else state_aq <= state_next;
    
      // state transition condition
      always @(*) begin
          state_next = state_aq;
          case (state_aq)
              IDLE : if (CMD_START) state_next =READ;
    
              READ : if (read_done) state_next = CONV;
                
              CONV : if (CMD_DONE) state_next = IDLE;
          endcase
      end
    
      // output signals
      assign CMD_DONE = (state_aq == CONV) && (conv_done);
      assign CMD_DONE_VALID = (state_aq == CONV) &&(conv_done);
      
      // control signals
      assign to_input_mem.en   = (state_aq == CONV);
      assign to_input_mem.we   = 0;
      assign to_input_mem.addr = cnt_xaddr;
      assign to_input_mem.din  = 0;
    
      assign to_weight_mem.en   = (state_aq == READ);
      assign to_weight_mem.we   = 0;
      assign to_weight_mem.addr = cnt_waddr;
      assign to_weight_mem.din  = 0;
    
      assign to_feature_mem.en   = (state_aq == CONV);
      assign to_feature_mem.we   = (oValid);
      assign to_feature_mem.addr = cnt_faddr;
      assign to_feature_mem.din  = oY; 
      
      assign iX = to_input_mem.dout;
      assign iW = to_weight_mem.dout;
      assign iADDR = cnt_read;
      assign iWren = (state_aq == READ);
      assign iValid = (state_aq == CONV);
    
endmodule // cnnip_ctrlr




