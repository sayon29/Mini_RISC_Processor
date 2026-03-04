`timescale 1ns / 1ps

module alu_tb();
    reg signed [31:0] in_1, in_2;
    reg [3:0] ALU_CON;
    wire signed [31:0] out;
    wire CY, OV;

    alu uut (.in_1(in_1), .in_2(in_2), .ALU_CON(ALU_CON), .out(out), .CY(CY), .OV(OV));

    initial begin
        $display("--- Expanded ALU Tests ---");
        
        // 1. Edge Case: Addition Overflow (Positive + Positive = Negative)
        in_1 = 32'h7FFFFFFF; in_2 = 32'h00000001; ALU_CON = 4'd2;
        #10; $display("ADD Max: %d + %d = %d (Overflow bit should trigger)", in_1, in_2, out);

        // 2. Logical vs Arithmetic Shift
        in_1 = 32'h8000_0000; in_2 = 32'd1; 
        ALU_CON = 4'd7; #10; $display("SRL: %h >> 1 = %h (Should have 0 at MSB)", in_1, out);
        ALU_CON = 4'd9; #10; $display("SRA: %h >> 1 = %h (Should have 1 at MSB)", in_1, out);

        // 3. Multiplication: Large numbers
        in_1 = 32'd65536; in_2 = 32'd65536; ALU_CON = 4'd10;
        #10; $display("MUL: %d * %d = %d", in_1, in_2, out);
        ALU_CON = 4'd11; #10; $display("MULH: High bits of same product = %d", out);

        // 4. Division & Remainder
        in_1 = 32'd7; in_2 = 32'd3; 
        ALU_CON = 4'd12; #10; $display("DIV: 7 / 3 = %d", out);
        ALU_CON = 4'd13; #10; $display("REM: 7 %% 3 = %d", out);

        // 5. Comparison Logic
        in_1 = -32'd10; in_2 = 32'd5;
        ALU_CON = 4'd14; #10; $display("SLT: Is -10 < 5? %d", out);
        ALU_CON = 4'd15; #10; $display("SLTU: Is unsigned(-10) > unsigned(5)? %d", out);

        $finish;
    end
endmodule