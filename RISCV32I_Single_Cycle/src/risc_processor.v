module risc_processor(
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] processor_result
);

    // Internal Wires
    wire [31:0] instruction;
    wire        reg_write_en, alu_srcA, alu_srcB, dest_reg_sel;
    wire [3:0]  alu_op, mem_write_en;
    wire        write_back;
    wire [31:0] datapath_result;
    wire        alu_overflow;

    // 1. Datapath 
    datapath datapath_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_en(reg_write_en),
        .alu_src_A(alu_srcA),
        .alu_src_B(alu_srcB),
        .dest_reg_sel(dest_reg_sel),
        .alu_op(alu_op),
        .mem_write_en(mem_write_en),
        .write_back(write_back),
        .instruction(instruction), 
        .result(datapath_result),
        .alu_overflow(alu_overflow)
    );

    // 2. Control Unit
    control_unit control_inst (
        .clk(clk),
        .rst(rst),
        .instruction(instruction), 
        .reg_write_en(reg_write_en),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .dest_reg_sel(dest_reg_sel),
        .alu_op(alu_op),
        .mem_write_en(mem_write_en),
        .write_back(write_back)
    );

    assign processor_result = datapath_result;
    
endmodule