module control_unit(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] instruction,

    output wire        reg_write_en,
    output wire        muxA_con,
    output wire        muxB_con,
    output wire [3:0]  alu_op,
    output wire [3:0]  mem_write_en,
    output wire [1:0]  mux_writeback_con,
    output wire        mem_enable
);

    alu_control alu_ctrl(
        .instruction(instruction),
        .alu_op(alu_op)
    );
    
    muxB_control muxb_ctrl(
        .instruction(instruction),
        .muxB_con(muxB_con)
    );
    
    reg_write_control regwrite_ctrl(
        .instruction(instruction),
        .reg_write_en(reg_write_en)
    );
    
    writeback_mux_control wb_ctrl(
        .instruction(instruction),
        .mux_writeback_con(mux_writeback_con)
    );
    
    muxA_control muxa_ctrl(
        .instruction(instruction),
        .muxA_con(muxA_con)
    );
    
    mem_write_control memwrite_ctrl(
        .instruction(instruction),
        .mem_write_en(mem_write_en)
    );
    
    mem_enable_control memenable_ctrl(
        .instruction(instruction),
        .mem_enable(mem_enable)
    );

endmodule