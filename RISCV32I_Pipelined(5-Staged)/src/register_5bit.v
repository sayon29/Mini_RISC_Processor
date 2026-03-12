`timescale 1ns / 1ps

module register_5bit(output reg [4:0] out,input [4:0] in,input clk,input flush,input freeze);

always @(posedge clk)begin
    if(flush==1 && freeze==0)begin out=5'b0; end               //For flush
    else if(flush==0 && freeze==1)begin  out <= out; end        //For Freeze
    else if(flush==0 && freeze ==0)begin out<=in; end           //Out=In
end

endmodule