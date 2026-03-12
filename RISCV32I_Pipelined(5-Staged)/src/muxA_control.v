

module muxA_control(
    input  wire [31:0] instruction,
    output reg muxA_con
);
    
    wire [6:0] opcode = instruction[6:0];
  
    always@(instruction)begin

        case(opcode)
            7'b1100011:muxA_con=0;  //B-type:BEW BNE BLT BGE BLTU BGEU
            7'b1101111:muxA_con=0;  //J-type:JAL
            7'b0010111:muxA_con=0;  //AUIPC
            default:muxA_con=1;
        endcase
    end
    
endmodule
