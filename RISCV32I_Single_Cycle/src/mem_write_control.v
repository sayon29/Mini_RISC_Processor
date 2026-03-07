`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2026 03:46:37 AM
// Design Name: 
// Module Name: mem_write_control
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


module mem_write_control(
    input  wire [31:0] instruction,
    output reg [3:0] mem_write_en
);
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    
    always@(instruction)begin
        case(opcode)
            7'b0100011:begin    //S-types
                case(funct3)
                    3'b000:mem_write_en=4'b0001;    //SB
                    3'b001:mem_write_en=4'b0011;    //SH
                    3'b010:mem_write_en=4'b1111;    //SW
                    default:mem_write_en=0;
                endcase
            end 
            default:mem_write_en=0;
        endcase
    end
    
endmodule
