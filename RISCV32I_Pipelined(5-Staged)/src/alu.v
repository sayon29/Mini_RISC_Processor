`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 02:58:17 AM
// Design Name: 
// Module Name: control_unit
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


module alu(
    input signed [31:0] in_1,
    input signed [31:0] in_2,
    input [3:0] ALU_CON,
    output reg signed [31:0] out,
    output reg CY,
    output reg OV 
);

    reg signed [63:0] temp;
    
    always @(in_1 or in_2 or ALU_CON)begin
        case(ALU_CON)
            4'd0 :out = in_1;  //pass in_1
            4'd1 :out = in_2;  //pass in_2
            4'd2 :out = in_1+in_2;  //add
            4'd3 :out = in_1-in_2;  //sub
            4'd4 :out = in_1^in_2;  //xor
            4'd5 :out = in_1|in_2;  //or
            4'd6 :out = in_1&in_2;  //and
            4'd7 :out = in_1>>in_2[4:0];  //in_1 offset SRL
            4'd8 :out = in_1<<in_2[4:0];  //in_1 offset SLL
            4'd9 :out = $signed(in_1)>>>in_2[4:0];  //in_1 offset SRA
            4'd10 :begin                            //MUL
                    temp=$signed(in_2)*$signed(in_1);
                    out=temp[31:0];
                   end
            4'd11 :begin                            //MULH
                    temp=$signed(in_2)*$signed(in_1);
                    out=temp[63:32];
                   end 
            4'd12 :out=in_1/in_2 ;   //DIV      
            4'd13 :out=in_1%in_2;    //REM        
            4'd14 :out=(in_1<in_2)?1:0; //SLT
            4'd15 :out=($unsigned(in_1)>$unsigned(in_2))?1:0; //SLTU           
            default: out=0;
        endcase
    end
    
    
    
endmodule