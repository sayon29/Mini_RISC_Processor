`timescale 1ns/1ps

module branch_condition_tb;

    reg  [31:0] rs_data;
    reg  [31:0] rt_data;
    reg  [2:0]  funct3;
    wire        branch_cond_out;

    branch_condition uut (
        .rs_data(rs_data),
        .rt_data(rt_data),
        .funct3(funct3),
        .branch_cond_out(branch_cond_out)
    );

    initial begin
        $display("---------------------------------------------------------------");
        $display("Type | rs_data      | rt_data      | Exp | Act");
        $display("---------------------------------------------------------------");

        // BEQ (true)
        rs_data = 32'd10; rt_data = 32'd10; funct3 = 3'b000; #1;
        $display("BEQ  | 0000000A     | 0000000A     |  1  |  %b", branch_cond_out);

        // BNE (true)
        rs_data = 32'd10; rt_data = 32'd5; funct3 = 3'b001; #1;
        $display("BNE  | 0000000A     | 00000005     |  1  |  %b", branch_cond_out);

        // BLT signed (true)
        rs_data = -5; rt_data = 10; funct3 = 3'b100; #1;
        $display("BLT  | FFFFFFFB     | 0000000A     |  1  |  %b", branch_cond_out);

        // BGE signed (false)
        rs_data = -5; rt_data = 10; funct3 = 3'b101; #1;
        $display("BGE  | FFFFFFFB     | 0000000A     |  0  |  %b", branch_cond_out);

        // BLTU unsigned (false)
        rs_data = 32'hFFFFFFFF; rt_data = 32'd1; funct3 = 3'b110; #1;
        $display("BLTU | FFFFFFFF     | 00000001     |  0  |  %b", branch_cond_out);

        // BGEU unsigned (true)
        rs_data = 32'hFFFFFFFF; rt_data = 32'd1; funct3 = 3'b111; #1;
        $display("BGEU | FFFFFFFF     | 00000001     |  1  |  %b", branch_cond_out);

        $display("---------------------------------------------------------------");
        $finish;
    end

endmodule