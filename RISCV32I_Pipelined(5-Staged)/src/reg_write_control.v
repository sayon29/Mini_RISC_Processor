
module reg_write_control(
    input  wire [31:0] instruction,
    output reg reg_write_en
);
    wire [6:0] opcode = instruction[6:0];
    
    always@(instruction) begin
        case(opcode)
            7'b0110111, 7'b1101111, 7'b0000011, 7'b0110011, 7'b0010011, 7'b1100111, 7'b0010111: reg_write_en = 1; //LUI, JAL, L_type, I_type, R_type, JALR, AUIPC
            default: reg_write_en = 0; //B_type, S_type
        endcase
    end
endmodule
