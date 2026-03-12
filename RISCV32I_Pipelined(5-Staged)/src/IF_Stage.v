module IF_Stage(
    input wire clk,
    output wire [31:0] instruction_ID,
    output wire [31:0] pc_ID
);
    wire [31:0] pc_plus_one;
    wire [31:0] pc_net;
    
    assign pc_plus_one = pc_net + 1;
    
    register_32bit pc(
        .out(pc_net),
        .in(pc_plus_one),
        .clk(clk),
        .flush(0),
        .freeze(0)
    );
    
    register_32bit pc_IF(
        .out(pc_ID),
        .in(pc_plus_one),
        .clk(clk),
        .flush(0),
        .freeze(0)
    );
    
    instruction_mem instruction_mem_inst (
        .clk(clk),
        .addr(pc_net),
        .out(instruction_ID),
        .flush(0),
        .freeze(0)
    );
endmodule
