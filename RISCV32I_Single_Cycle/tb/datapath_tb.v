`timescale 1ns / 1ps

module datapath_tb();

    // Inputs
    reg clk, rst, reg_write_en, alu_src_A, alu_src_B;
    reg [3:0] alu_op;
    reg [3:0] mem_write_en;
    reg [1:0] write_back;

    // Outputs
    wire [31:0] instruction, result;
    wire alu_overflow;

    // Instantiate Datapath
    datapath uut (
        .clk(clk), .rst(rst), .reg_write_en(reg_write_en),
        .alu_src_A(alu_src_A), .alu_src_B(alu_src_B),
        .alu_op(alu_op), .mem_write_en(mem_write_en),
        .write_back(write_back), .instruction(instruction),
        .result(result), .alu_overflow(alu_overflow)
    );

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // --- Initialization ---
        rst = 1; reg_write_en = 0; alu_src_A = 0; alu_src_B = 0;
        alu_op = 0; mem_write_en = 4'b0000; write_back = 2'b00;
        #15 rst = 0;

        $display("--- Starting Comprehensive Datapath Tests ---");

        // TEST 1: Register-Register Addition (R-Type Simulation)
        // Operation: rd = rs1 + rs2
        @(negedge clk);
        alu_src_A    = 1;      // Select rs_data
        alu_src_B    = 1;      // Select rt_data (rs2)
        alu_op       = 4'd2;   // ADD
        reg_write_en = 1;      // Write result to rd
        write_back   = 2'b01;  // Source: ALU
        #10;
        $display("[R-TYPE] PC: %h | ALU Result: %d | Writing to Reg: %b", uut.pc_reg, result, reg_write_en);

        // TEST 2: Load Word Flow (Memory -> Reg)
        // ALU calculates address, Data Mem provides data, Writeback to Reg
        @(negedge clk);
        alu_src_A    = 1;      // Base address from rs1
        alu_src_B    = 0;      // Offset from Imm
        alu_op       = 4'd2;   // Add for effective address
        mem_write_en = 4'b0000; // Just reading
        write_back   = 2'b00;  // Source: Data Memory
        reg_write_en = 1;
        #10;
        $display("[LOAD]   Address: %h | Data from Mem: %h", result, uut.data_from_mem_net);

        // TEST 3: Branch Taken (Control Flow)
        // Test if PC updates to ALU target when branch_cond is high
        // Note: Forcing internal branch_cond for testing if necessary
        @(negedge clk);
        alu_src_A    = 0;      // PC
        alu_src_B    = 0;      // Imm offset
        alu_op       = 4'd2;   // Target = PC + Imm
        reg_write_en = 0;
        // We assume the branch_condition module logic results in branch_cond = 1 here
        #10;
        $display("[BRANCH] New PC Target: %h | Current PC: %h", result, uut.pc_reg);

        // TEST 4: JAL (Jump and Link)
        // Store PC+1 into a register and jump to a new address
        @(negedge clk);
        write_back   = 2'b10;  // Select PC + 1
        reg_write_en = 1;      // Write PC+1 to rd (Link)
        alu_src_A    = 0;      // PC
        alu_src_B    = 0;      // Imm
        alu_op       = 4'd2;   // Target Address
        #10;
        $display("[JAL]    Link Value (PC+1): %d | Jump Target: %h", uut.write_back_data, result);

        #50;
        $display("--- Datapath Tests Complete ---");
        $finish;
    end

endmodule