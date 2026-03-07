`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2026 03:46:37 AM
// Design Name: 
// Module Name: muxB_control
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


module muxB_control(
    input  wire [31:0] instruction,
    output reg muxB_con
);
    
    wire [6:0] opcode = instruction[6:0];
 
    always@(instruction) begin
      
        case(opcode)
            7'b0110011: muxB_con = 1; //R_type
            default: muxB_con = 0;  // All Other Types
        endcase
    end
    
endmodule

