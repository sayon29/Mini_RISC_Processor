module logical_ops_unit (
    input wire [31:0] src1,
    input wire [31:0] src2,
    input wire [3:0] aluOp,
    output reg [31:0] logical_out
);
    always @(*) begin
        case (aluOp)
            4'b1000: logical_out = src1 | src2;
            4'b1001: logical_out = src1 ^ src2;
            4'b1010: logical_out = ~(src1 | src2);
            4'b1011: logical_out = src1 & src2;
            4'b1100: logical_out = ~src1;
            default: logical_out = 32'd0;
        endcase
    end
endmodule
