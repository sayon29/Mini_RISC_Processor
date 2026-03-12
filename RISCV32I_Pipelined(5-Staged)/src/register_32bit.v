`timescale 1ns / 1ps

module register_32bit(output reg [31:0] out,input [31:0] in,input clk,input flush,input freeze);

always @(posedge clk)begin
    if(flush==1 && freeze==0)begin out=32'b0; end               //For flush
    else if(flush==0 && freeze==1)begin  out <= out; end        //For Freeze
    else if(flush==0 && freeze ==0)begin out<=in; end           //Out=In
end

endmodule