module mem_enable_control(
    input  wire [31:0] instruction,
    output reg mem_enable
);

    wire [6:0] opcode = instruction[6:0];
    
    always@(instruction)begin
        case(opcode)
            7'b0100011, 7'b0000011 : mem_enable = 1; //L_type, S_type
            default: mem_enable = 0; //Others
        endcase
    end
    
endmodule
