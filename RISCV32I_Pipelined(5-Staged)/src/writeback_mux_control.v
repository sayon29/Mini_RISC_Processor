

module writeback_mux_control(
    input  wire [31:0] instruction,
    output reg [1:0] mux_writeback_con
);
    wire [6:0] opcode = instruction[6:0];
    
    always@(instruction) begin

        case(opcode)
           7'b0000011: mux_writeback_con = 0; //L_type
           7'b0110111, 7'b0110011, 7'b0010011, 7'b0010111: mux_writeback_con = 1; //LUI, R_type, I_type, AUIPC
           7'b1101111, 7'b1100111: mux_writeback_con = 2; //JAL, JALR
           default: mux_writeback_con = 1;
        endcase
    end
    
endmodule
