module datapath(
    input wire         clk,
    input wire         rst,
    input wire  [31:0] instruction,
    input wire  [31:0] pc_next_in,

    input wire         reg_write_en,
    input wire         alu_src_A,
    input wire         alu_src_B,
    input wire         dest_reg_sel,
    input wire  [3:0]  alu_op,
    input wire  [3:0]  mem_write_en,
    input wire         read_enable,

    output wire [31:0] result,
    output wire        alu_overflow,
    output wire [31:0] pc_next_out
);

    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [4:0] rd_addr;
    wire [6:0] opcode;
    wire [2:0] funct3;

    wire [31:0] rs_data;
    wire [31:0] rt_data;
    wire [31:0] imm_out;
    wire [31:0] alu_result;
    wire [31:0] data_from_mem;
    wire [31:0] alu_src_a;
    wire [31:0] alu_src_b;
    wire [31:0] write_back_data;
    wire [4:0]  write_reg_addr;
    wire        branch_cond_out;
    wire        alu_carry;

    //Instruction Decode
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];
    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];

    //Register File
    reg_bank reg_file_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(reg_write_en),
        .r_addr_a(rs1_addr),
        .r_addr_b(rs2_addr),
        .w_addr(write_reg_addr),
        .w_data(write_back_data),
        .r_data_a(rs_data),
        .r_data_b(rt_data)
    );

    //Immediate Generator
    imm_generate imm_gen_inst (
        .instruction(instruction),
        .imm_out(imm_out)
    );

    //ALU
    alu alu_inst (
        .in1(alu_src_a),
        .in2(alu_src_b),
        .ALU_CON(alu_op),
        .out(alu_result),
        .OV(alu_overflow),
        .CY(alu_carry)
    );

    //Data Memory
    data_memory data_mem_inst (
        .clk(clk),
        .wea(mem_write_en),
        .addra(alu_result[7:0]),
        .dina(rt_data),
        .douta(data_from_mem)
    );

    //Branch Condition
    branch_condition branch_condition_inst (
        .rs_data(rs_data),
        .rt_data(rt_data),
        .funct3(funct3),
        .branch_cond_out(branch_cond_out)
    );

endmodule