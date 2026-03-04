`timescale 1ns/1ps

module imm_generate_tb;

    reg  [31:0] instruction;
    wire [31:0] imm_out;

    imm_generate uut (
        .instruction(instruction),
        .imm_out(imm_out)
    );

    initial begin

        $display("-------------------------------------------------------------");
        $display(" Type | Instruction    | Expected Imm | Actual Imm");
        $display("-------------------------------------------------------------");

        // -------------------------------------------------
        // I-TYPE : addi x1,x0,10
        // imm = 10 = 0x0000000A
        instruction = 32'h00A00093;  
        #1;
        $display(" I    | %h | 0000000A | %h", instruction, imm_out);

        // -------------------------------------------------
        // I-TYPE (negative) : addi x1,x0,-1
        // imm = -1 = FFFFFFFF
        instruction = 32'hFFF00093;  
        #1;
        $display(" I    | %h | FFFFFFFF | %h", instruction, imm_out);

        // -------------------------------------------------
        // S-TYPE : sw x1,8(x0)
        // imm = 8 = 00000008
        instruction = 32'h00100423;  
        #1;
        $display(" S    | %h | 00000008 | %h", instruction, imm_out);

        // -------------------------------------------------
        // B-TYPE : beq x0,x0,16
        // imm = 16 = 00000010
        instruction = 32'h00000863;  
        #1;
        $display(" B    | %h | 00000010 | %h", instruction, imm_out);

        // -------------------------------------------------
        // U-TYPE : lui x1,0x12345
        // imm = 0x12345000
        instruction = 32'h123450B7;  
        #1;
        $display(" U    | %h | 12345000 | %h", instruction, imm_out);

        // -------------------------------------------------
        // J-TYPE : jal x0,32
        // imm = 32 = 00000020
        instruction = 32'h0200006F;  
        #1;
        $display(" J    | %h | 00000020 | %h", instruction, imm_out);

        $display("-------------------------------------------------------------");

        $finish;
    end

endmodule