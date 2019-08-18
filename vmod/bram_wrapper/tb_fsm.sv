`timescale 1ns / 1ps

module tb_fsm#(
    parameter READ_LATENCY = 3,
    parameter ADDR_WIDTH = 15,
    parameter DATA_WIDTH = 31
);

reg clk, rst;
reg [ADDR_WIDTH-1 : 0] addr;
reg en, we;
reg [DATA_WIDTH-1 : 0] din;
wire [DATA_WIDTH-1 : 0] dout;
wire valid;

fsm#(
    READ_LATENCY,
    ADDR_WIDTH,
    DATA_WIDTH
) u1(
.clk(clk),
.rst(rst),
.addr(addr),
.en(en),
.we(we),
.din(din),
.dout(dout),
.valid(valid)
);

always #5 clk = ~clk;

initial begin
clk = 0; rst = 0;
addr = 0;
en = 0; we = 0;
din = 0;
@(posedge clk);
#1 rst = 1;
@(posedge clk);
#1 en = 1; addr = 15'ha;
@(posedge clk);
#1 en = 0; addr = 0;
repeat(10) @(posedge clk);

$finish;
end

endmodule
