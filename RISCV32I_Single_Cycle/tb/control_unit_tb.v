`timescale 1ns/1ps

module control_unit_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] instruction;

    // Outputs
    wire reg_write_en;
    wire alu_srcA;
    wire alu_srcB;
    wire [3:0] alu_op;
    wire [3:0] mem_write_en;
    wire [1:0] write_back;

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
    
        //R-type
        // ADD
        // funct7=0000000 funct3=000
        instruction = 32'b0000000_00011_00010_000_00001_0110011;
        #10;
        
        // SUB
        // funct7=0100000 funct3=000
        instruction = 32'b0100000_00011_00010_000_00001_0110011;
        #10;
        
        // SLL
        // funct7=0000000 funct3=001
        instruction = 32'b0000000_00011_00010_001_00001_0110011;
        #10;
        
        // SLT
        // funct7=0000000 funct3=010
        instruction = 32'b0000000_00011_00010_010_00001_0110011;
        #10;
        
        // SLTU
        // funct7=0000000 funct3=011
        instruction = 32'b0000000_00011_00010_011_00001_0110011;
        #10;
        
        // XOR
        // funct7=0000000 funct3=100
        instruction = 32'b0000000_00011_00010_100_00001_0110011;
        #10;
        
        // SRL
        // funct7=0000000 funct3=101
        instruction = 32'b0000000_00011_00010_101_00001_0110011;
        #10;
        
        // SRA
        // funct7=0100000 funct3=101
        instruction = 32'b0100000_00011_00010_101_00001_0110011;
        #10;
        
        // OR
        // funct7=0000000 funct3=110
        instruction = 32'b0000000_00011_00010_110_00001_0110011;
        #10;
        
        // AND
        // funct7=0000000 funct3=111
        instruction = 32'b0000000_00011_00010_111_00001_0110011;
        #10;
        
        //M-type
        // MUL
        // funct7=0000001 funct3=000
        instruction = 32'b0000001_00011_00010_000_00001_0110011;
        #10;
        
        // MULH
        // funct7=0000001 funct3=001
        instruction = 32'b0000001_00011_00010_001_00001_0110011;
        #10;
             
        // MULH
        // funct7=0000001 funct3=001
        instruction = 32'b0000001_00011_00010_001_00001_0110011;
        #10;
        
        // DIV
        // funct7=0000001 funct3=100
        instruction = 32'b0000001_00011_00010_100_00001_0110011;
        #10;
        
        // REM
        // funct7=0000001 funct3=110
        instruction = 32'b0000001_00011_00010_110_00001_0110011;
        #10;
        
        //I-Type
        //ADDI x1, x2, 5
        // funct3=000 opcode=0010011
        instruction = 32'b000000000101_00010_000_00001_0010011;
        #10;
        
        // SLTI x1, x2, 5
        // funct3=010
        instruction = 32'b000000000101_00010_010_00001_0010011;
        #10;
        
        // SLTIU x1, x2, 5
        // funct3=011
        instruction = 32'b000000000101_00010_011_00001_0010011;
        #10;
        
        // XORI x1, x2, 5
        // funct3=100
        instruction = 32'b000000000101_00010_100_00001_0010011;
        #10;
        
        // ORI x1, x2, 5
        // funct3=110
        instruction = 32'b000000000101_00010_110_00001_0010011;
        #10;
        
        // ANDI x1, x2, 5
        // funct3=111
        instruction = 32'b000000000101_00010_111_00001_0010011;
        #10;
        
        // SLLI x1, x2, 5
        // funct7=0000000 funct3=001
        instruction = 32'b0000000_00101_00010_001_00001_0010011;
        #10;
        
        // SRLI x1, x2, 5
        // funct7=0000000 funct3=101
        instruction = 32'b0000000_00101_00010_101_00001_0010011;
        #10;
        
        // SRAI x1, x2, 5
        // funct7=0100000 funct3=101
        instruction = 32'b0100000_00101_00010_101_00001_0010011;
        #10;


        // LB x1, 5(x2)
        instruction = 32'b000000000101_00010_000_00001_0000011;
        #10;
        
        // LH x1, 5(x2)
        instruction = 32'b000000000101_00010_001_00001_0000011;
        #10;
        
        // LW x1, 5(x2)
        instruction = 32'b000000000101_00010_010_00001_0000011;
        #10;
        
        
        //B-type
        // BEQ x2, x3, 16
        // funct3 = 000
        instruction = 32'b0_000000_00011_00010_000_1000_0_1100011;
        #10;
        
        // BNE x2, x3, 16
        // funct3 = 001
        instruction = 32'b0_000000_00011_00010_001_1000_0_1100011;
        #10;
        
        // BLT x2, x3, 16
        // funct3 = 100
        instruction = 32'b0_000000_00011_00010_100_1000_0_1100011;
        #10;
        
        // BGE x2, x3, 16
        // funct3 = 101
        instruction = 32'b0_000000_00011_00010_101_1000_0_1100011;
        #10;
        
        // BLTU x2, x3, 16
        // funct3 = 110
        instruction = 32'b0_000000_00011_00010_110_1000_0_1100011;
        #10;
        
        // BGEU x2, x3, 16
        // funct3 = 111
        instruction = 32'b0_000000_00011_00010_111_1000_0_1100011;
        #10;

        //S-type
        // SB x3, 5(x2)
        instruction = 32'b0000000_00011_00010_000_00101_0100011;
        #10;
        
        // SH x3, 5(x2)
        instruction = 32'b0000000_00011_00010_001_00101_0100011;
        #10;
        
        // SW x3, 5(x2)
        instruction = 32'b0000000_00011_00010_010_00101_0100011;
        #10;
        
        //L-type
        // LUI x1, 0x00010
        // opcode = 0110111
        instruction = 32'b00000000000000010000_00001_0110111;
        #10;
        
        //J-type
        // JAL x1, 16
        instruction = 32'b0_0000001000_0_00000000_00001_1101111;
        #10;
        
        $display("Testbench Finished");
        $stop;
    end
    
    // Instantiate the Control Unit
    control_unit uut (.clk(clk),.rst(rst), .instruction(instruction),.reg_write_en(reg_write_en),.alu_srcA(alu_srcA),.alu_srcB(alu_srcB),.alu_op(alu_op),.mem_write_en(mem_write_en),.write_back(write_back));

endmodule