`timescale 1ns / 1ps

module register_1bit(output reg  out,input in,input clk,input flush);

always @(posedge clk)begin
    if(flush==1)begin out=2'b0; end               //For flush
    else if(flush==0)begin out<=in; end           //Out=In
end

endmodule