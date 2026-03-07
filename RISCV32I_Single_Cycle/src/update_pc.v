module update_pc(
    input wire clk,
    input wire rst,
    input wire branch_cond,
    input wire [31:0] alu_result,
    input wire [31:0] pc_plus_one,
    
    output reg [31:0] pc_reg
    
);
    initial begin
       pc_reg <= 32'b0;
    end
    
    always @(posedge clk) begin
        if (rst)
            pc_reg <= 32'b0;
        else
            pc_reg <= (branch_cond) ? alu_result : pc_plus_one;
    end
    
endmodule
