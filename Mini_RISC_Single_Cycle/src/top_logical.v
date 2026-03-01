module logical_ops (
    input wire [31:0] src1,
    input wire [31:0] src2,
    input wire [3:0] aluOp,
    output reg [31:0] logical_out
);
    wire [31:0] logical_unit_out;
    wire [31:0] shift_unit_out;



    logical_ops_unit logical_unit (
        .src1(src1),
        .src2(src2),
        .aluOp(aluOp),
        .logical_out(logical_unit_out)
    );

    shift_ops_unit shift_unit (
        .src1(src1),
        .shamt(src2),
        .aluOp(aluOp),
        .shift_out(shift_unit_out)
    );
    
    always @(*) begin
        if (aluOp[3:2] == 2'b10 || aluOp[3:2] == 2'b11) begin
            case (aluOp[3:0])
                4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100:
                    logical_out = logical_unit_out;
                4'b1101, 4'b1110, 4'b1111:
                    logical_out = shift_unit_out;
                default:
                    logical_out = 32'd0;
            endcase
        end else begin
            logical_out = 32'd0;
        end
    end
endmodule