`timescale 1ns/1ps

module reg_bank_tb;

    reg clk;
    reg rst;
    reg [4:0] r_addr_a;
    reg [4:0] r_addr_b;
    reg [4:0] w_addr;
    reg [31:0] w_data;
    reg wr_en;
    wire [31:0] r_data_a;
    wire [31:0] r_data_b;

    reg_bank uut (
        .clk(clk),
        .rst(rst),
        .r_addr_a(r_addr_a),
        .r_addr_b(r_addr_b),
        .w_addr(w_addr),
        .w_data(w_data),
        .wr_en(wr_en),
        .r_data_a(r_data_a),
        .r_data_b(r_data_b)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;

        // Apply reset
        #10;
        rst = 0;

        $display("---------------------------------------------------");
        $display("Test | Expected        | Actual");
        $display("---------------------------------------------------");

        // Check initialized register x1
        r_addr_a = 5'd1; #1;
        $display("x1   | 00000005        | %h", r_data_a);

        // Check x16
        r_addr_a = 5'd16; #1;
        $display("x16  | 00000080        | %h", r_data_a);

        // Check x0 always zero
        r_addr_a = 5'd0; #1;
        $display("x0   | 00000000        | %h", r_data_a);

        // Write to x5
        @(posedge clk);
        w_addr = 5'd5;
        w_data = 32'hDEADBEEF;
        wr_en  = 1;

        @(posedge clk);
        wr_en = 0;

        r_addr_a = 5'd5; #1;
        $display("x5   | DEADBEEF        | %h", r_data_a);

        // Try writing to x0 (should fail)
        @(posedge clk);
        w_addr = 5'd0;
        w_data = 32'hAAAAAAAA;
        wr_en  = 1;

        @(posedge clk);
        wr_en = 0;

        r_addr_a = 5'd0; #1;
        $display("x0   | 00000000        | %h", r_data_a);

        $display("---------------------------------------------------");

        $finish;
    end

endmodule