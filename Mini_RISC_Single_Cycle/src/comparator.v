module comparator (
    input wire [31:0] src1,
    input wire [31:0] src2,
    input wire [1:0] op,
    output reg [31:0] comp_out
);
    always @(*) begin
        case (op)
            2'b00: begin
                if ($signed(src1) < $signed(src2))
                    comp_out = 32'd1;
                else
                    comp_out = 32'd0;
            end
            2'b01: begin
                if ($signed(src1) > $signed(src2))
                    comp_out = 32'd1;
                else
                    comp_out = 32'd0;
            end
            default: comp_out = 32'd0;
        endcase
    end
endmodule
