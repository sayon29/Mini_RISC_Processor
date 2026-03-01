module control_unit(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] instruction,

    output reg         reg_write_en,
    output reg         alu_srcA,
    output reg         alu_srcB,
    output reg         dest_reg_sel,
    output reg  [3:0]  alu_op,
    output reg  [3:0]  mem_write_en,
    output reg         pc_stall,
    output reg         halt,
    output reg         halt_now,
    output reg         read_enable
);

endmodule