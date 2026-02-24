module alu (
    input wire [31:0] src1,
    input wire [31:0] src2,
    input wire [3:0]  aluOp,
    output reg [31:0] aluOut,
    output reg        overflow
);
    wire is_subtraction;
    assign is_subtraction = (aluOp == 4'b0001) || (aluOp == 4'b0011);

    wire [31:0] adder_src2;
    assign adder_src2 = (aluOp == 4'b0010 || aluOp == 4'b0011) ? 32'd1 : src2;

    wire [31:0] add_sub_out;
    wire add_sub_overflow;
    adder_subtractor add_sub_unit (
        .a(src1),
        .b(adder_src2),
        .sub_op(is_subtraction),
        .out(add_sub_out),
        .overflow(add_sub_overflow)
    );
    
    wire [1:0] comp_op_select;
    assign comp_op_select = aluOp[1:0];

    wire [31:0] comp_out;
    comparator comp_unit (
        .src1(src1),
        .src2(src2),
        .op(comp_op_select),
        .comp_out(comp_out)
    );

    wire [5:0] ham_out;
    hamming_unit ham_unit (
        .src1(src1),
        .ham_out(ham_out)
    );
    
    wire [31:0] logical_out;
    logical_ops logical_unit (
        .src1(src1),
        .src2(src2),
        .aluOp(aluOp),
        .logical_out(logical_out)
    );
    
    always @(*) begin
        case(aluOp)
            4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
                aluOut = add_sub_out;
                overflow = add_sub_overflow;
            end
            4'b0100, 4'b0101: begin
                aluOut = comp_out;
                overflow = 1'b0;
            end
            4'b0110: begin
                aluOut = {26'b0, ham_out};
                overflow = 1'b0;
            end
            4'b1000, 4'b1001, 4'b1010, 4'b1011,
            4'b1100, 4'b1101, 4'b1110, 4'b1111: begin
                aluOut = logical_out;
                overflow = 1'b0;
            end
            default: begin
                aluOut = 32'd0;
                overflow = 1'b0;
            end
        endcase
    end
endmodule