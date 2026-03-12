`timescale 1ns / 1ps

module register_4bit(output reg [3:0] out,input [3:0] in,input clk,input flush);

always @(posedge clk)begin
    if(flush==1)begin out=3'b0; end               //For flush
    else if(flush==0)begin out<=in; end           //Out=In
end

endmodule