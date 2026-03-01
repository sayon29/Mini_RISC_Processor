module shift_ops_unit (
    input wire [31:0] src1,
    input wire [4:0] shamt,
    input wire [3:0] aluOp,
    output reg [31:0] shift_out
);
    always @(*) begin
        case (aluOp)
            4'b1101: shift_out = src1 << shamt;
            4'b1110: shift_out = src1 >> shamt;
            4'b1111: shift_out = $signed(src1) >>> shamt;
            default: shift_out = 32'd0;
        endcase
    end
endmodule
