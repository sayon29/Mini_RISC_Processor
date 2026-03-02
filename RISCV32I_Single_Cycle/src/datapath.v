module datapath(
    input wire           clk,
    input wire           rst,
    input wire           reg_write_en,
    input wire           alu_src_A,
    input wire           alu_src_B,
    input wire  [3:0]    alu_op,
    input wire  [3:0]    mem_write_en, 
    input wire  [1:0]    write_back, 
    
    output reg  [31:0]   instruction,
    output wire [31:0]   result,
    output wire          alu_overflow
);

    wire [31:0] imm_out_net;
    wire [31:0] alu_result_net;
    wire [31:0] data_from_mem_net;
    wire [31:0] rs_data_net;
    wire [31:0] rt_data_net;
    wire [31:0] alu_src_a, alu_src_b;
    wire [31:0] instruction_fetch_out;
    wire        branch_cond;
    wire        alu_carry;

    reg  [31:0] pc_reg;
    reg  [31:0] pc_plus_one;
    reg  [31:0] rs_data, rt_data;
    reg  [31:0] imm_out;
    reg  [31:0] alu_result;
    reg  [31:0] data_from_mem;
    reg  [31:0] write_back_data;

    always @(*) begin
        instruction   = instruction_fetch_out;
        rs_data       = rs_data_net;
        rt_data       = rt_data_net;
        imm_out       = imm_out_net;
        alu_result    = alu_result_net;
        data_from_mem = data_from_mem_net;

        pc_plus_one   = pc_reg + 1; 

        case (write_back)
            2'b00:   write_back_data = data_from_mem;
            2'b01:   write_back_data = alu_result;
            2'b10:   write_back_data = pc_plus_one;
            default: write_back_data = 32'h0;
        endcase
    end
    
    always @(posedge clk) begin
        if (rst)
            pc_reg <= 32'h0;
        else
            pc_reg <= (branch_cond) ? alu_result : pc_plus_one;
    end

    wire [4:0] rs1_addr = instruction[19:15];
    wire [4:0] rs2_addr = instruction[24:20];
    wire [4:0] rd_addr  = instruction[11:7];
    wire [2:0] funct3   = instruction[14:12];

    assign result    = alu_result;
    assign alu_src_a = (alu_src_A) ? rs_data : pc_plus_one;
    assign alu_src_b = (alu_src_B) ? rt_data : imm_out;

    instruction_fetch fetch_unit (
        .clk(clk), 
        .pc_address(pc_reg), 
        .instruction(instruction_fetch_out)
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
        .in1(alu_src_a), 
        .in2(alu_src_b), 
        .ALU_CON(alu_op),
        .out(alu_result_net), 
        .OV(alu_overflow), 
        .CY(alu_carry)
    );

    data_memory data_mem_inst (
        .clk(clk), 
        .wea(mem_write_en), 
        .addra(alu_result[7:0]),
        .dina(rt_data), 
        .douta(data_from_mem_net)
    );

    branch_condition branch_condition_inst (
        .rs_data(rs_data), 
        .rt_data(rt_data), 
        .funct3(funct3),
        .branch_cond_out(branch_cond)
    );

endmodule