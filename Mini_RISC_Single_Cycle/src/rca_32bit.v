module adder_subtractor (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sub_op,
    output wire [31:0] out,
    output wire overflow
);
    wire [31:0] b_in;
    wire [32:0] carry;

    assign b_in = b ^ {32{sub_op}};
    assign carry[0] = sub_op;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : full_adder_chain
            full_adder fa (
                .a(a[i]),
                .b(b_in[i]),
                .cin(carry[i]),
                .sum(out[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign overflow = (sub_op == 1'b0) ?
                      (a[31] == b[31] && out[31] != a[31]) :
                      (a[31] != b[31] && out[31] != a[31]);

endmodule