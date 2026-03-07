module datapath(
    input wire           clk,
    input wire           rst,
    input wire           reg_write_en,
    input wire           muxA_con,
    input wire           muxB_con,
    input wire  [3:0]    alu_op,
    input wire  [3:0]    mem_write_en, 
    input wire  [1:0]    mux_writeback_con, 
    input wire           mem_enable,
    
    output reg  [31:0]   instruction,
    output reg  [31:0]   alu_result,
    output reg  [31:0]   pc_reg,
    output reg  [31:0]   write_back_data,
    output wire          alu_overflow
);

    wire [31:0] pc_reg_net;
    wire [31:0] imm_out_net;
    wire [31:0] alu_result_net;
    wire [31:0] data_from_mem;
    wire [31:0] rs_data_net;
    wire [31:0] rt_data_net;
    wire [31:0] muxA_out, muxB_out;
    wire [31:0] instruction_fetch_net;
    wire        branch_cond;
    wire        alu_carry;
    
    reg  [31:0] pc_plus_one;
    reg  [31:0] rs_data, rt_data;
    reg  [31:0] imm_out;

    always @(*) begin
        pc_reg        = pc_reg_net;
        instruction   = instruction_fetch_net;
        rs_data       = rs_data_net;
        rt_data       = rt_data_net;
        imm_out       = imm_out_net;
        alu_result    = alu_result_net;

        pc_plus_one   = pc_reg + 1; 

        case (mux_writeback_con)
            2'b00:   write_back_data = data_from_mem;
            2'b01:   write_back_data = alu_result;
            2'b10:   write_back_data = pc_plus_one;
            default: write_back_data = 32'h0;
        endcase
    end

    wire [4:0] rs1_addr = instruction[19:15];
    wire [4:0] rs2_addr = instruction[24:20];
    wire [4:0] rd_addr  = instruction[11:7];
    wire [2:0] funct3   = instruction[14:12];
    wire [6:0] opcode   = instruction[6:0];

    assign muxA_out = (muxA_con) ? rs_data : pc_plus_one;
    assign muxB_out = (muxB_con) ? rt_data : imm_out;
    
    update_pc update_pc_inst (
        .clk(clk),
        .pc_reg(pc_reg_net),
        .branch_cond(branch_cond),
        .alu_result(alu_result),
        .pc_plus_one(pc_plus_one)
    );
    
    instruction_mem instruction_mem_inst (
        .clka(clk),
        .addra(pc_reg),
        .douta(instruction_fetch_net)
    );

    reg_bank reg_file_inst (
        .clk(clk), 
        .rst(rst), 
        .wr_en(reg_write_en),
        .r_addr_a(rs1_addr), 
        .r_addr_b(rs2_addr),
        .w_addr(rd_addr), 
        .w_data(write_back_data),
        .r_data_a(rs_data_net), 
        .r_data_b(rt_data_net)
    );

    imm_generate imm_gen_inst (
        .instruction(instruction), 
        .imm_out(imm_out_net)
    );

    alu alu_inst (
        .in_1(muxA_out), 
        .in_2(muxB_out), 
        .ALU_CON(alu_op),
        .out(alu_result_net), 
        .OV(alu_overflow), 
        .CY(alu_carry)
    );
    
    data_mem data_mem_inst (
        .clka(clk),
        .enable(mem_enable),
        .w_en(mem_write_en), 
        .addra(alu_result[6:0]),
        .dina(rt_data),
        .douta(data_from_mem)
    );


    branch_condition branch_condition_inst (
        .rs_data(rs_data), 
        .rt_data(rt_data), 
        .funct3(funct3),
        .opcode(opcode),
        .branch_cond_out(branch_cond)
    );

endmodule