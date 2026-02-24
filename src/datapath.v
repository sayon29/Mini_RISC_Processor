//////////////////////////////////////////////////////////////////////////////////
// Module: datapath
//////////////////////////////////////////////////////////////////////////////////
module datapath(
    input wire         clk,
    input wire         rst,
    
    // Decoded Instruction Inputs
    input wire  [5:0]  opcode,         
    input wire  [4:0]  rs_addr,
    input wire  [4:0]  rt_addr,
    input wire  [4:0]  rd_addr,
    input wire  [15:0] immediate_1,    
    input wire  [25:0] immediate_2,    

    // PC Input
    input wire  [31:0] pc_next_in,     

    // Control Signal Inputs
    input wire         reg_write_en,
    input wire         alu_src_sel,    
    input wire         reg_dest_sel,   
    input wire  [3:0]  alu_op,
    input wire         immeadiate_sel,
    input wire         move_or_branch,
    input wire  [3:0]  mem_write_en,
    input wire         read_enable,    
    
    // Outputs
    output wire [31:0] result,
    output wire        alu_overflow,
    output wire [31:0] pc_next_out     
);

    wire [31:0] rs_data, rt_data, alu_result, alu_src_b; 
    wire [31:0] src1, alu_src_a; 
    wire [4:0]  write_reg_addr;
    wire        isBranch;  
    wire [31:0] data_from_mem;
    wire [31:0] write_back_data;
    wire [31:0] src2; 
    wire        is_store; 
    wire        c_Mov_Comp; 

    wire [31:0] extended_imm_1;
    wire [31:0] extended_imm_2;
    wire [31:0] imm_final;

    assign extended_imm_1 = {{16{immediate_1[15]}}, immediate_1};
    assign extended_imm_2 = {{ 6{immediate_2[25]}}, immediate_2};
    
    // Mux for immediate selection
    assign imm_final = immeadiate_sel ? extended_imm_2 : extended_imm_1;

    // Register File Logic
    reg_bank reg_file_inst (
        .clk(clk),.rst(rst), .wr_en(reg_write_en),
        .r_addr_a(rs_addr), 
        .r_addr_b(rt_addr),
        .w_addr(write_reg_addr), 
        .w_data(write_back_data),
        .r_data_a(rs_data), 
        .r_data_b(rt_data)
    );
    
    // Branch Comparator Instantiation
    branch_comparator branch_comp_inst (
        .opcode(opcode),
        .rs_data(rs_data),
        .is_branch(isBranch)
    );
    
    // CMOV Comparator Instantiation
    Cmov_comparator cmov_comp_inst (
        .rs_data(rs_data),
        .rt_data(rt_data),
        .opcode(opcode),
        .cmov(c_Mov_Comp) 
    );

    // ALU Source A Logic
    // Mux for src1 (rs_data or pc_next_in)
    assign src1 = isBranch ? pc_next_in : rs_data;
    
    // Mux for alu_src_a (src1 or 0)
    assign alu_src_a = move_or_branch ? 32'b0 : src1;

    // ALU Source B Logic
    // Mux for src2 (imm_final or rt_data)
    assign src2 = alu_src_sel ? rt_data : imm_final;
    
    // Mux for alu_src_b (src2 or src1)
    assign alu_src_b = c_Mov_Comp ? src1 : src2;
    
    // Register File Write Mux 
    assign write_reg_addr = reg_dest_sel ? rd_addr : rt_addr;

    // ALU
    alu alu_inst (
        .src1(alu_src_a), 
        .src2(alu_src_b), 
        .aluOp(alu_op),
        .aluOut(alu_result), 
        .overflow(alu_overflow)
    );

    // Data Memory Instantiation 
    data_memory data_mem_inst (
        .clk(clk),
        .wea(mem_write_en),       
        .addra(alu_result[7:0]),   
        .dina(rt_data),           
        .douta(data_from_mem)     
    );

    // Mux for write_back_data (alu_result or data_from_mem)
    assign write_back_data = read_enable ? data_from_mem : alu_result;

    // Mux for pc_next_out (pc_next_in or alu_result)
    assign pc_next_out = isBranch ? alu_result : pc_next_in;

    // Final Result Output Logic
    assign is_store = (mem_write_en != 4'b0);
    
    // Mux for final result (write_back_data or rt_data)
    assign result = is_store ? rt_data : write_back_data;
    
endmodule