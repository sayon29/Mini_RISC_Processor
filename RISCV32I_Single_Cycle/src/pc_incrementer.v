//////////////////////////////////////////////////////////////////////////////////
// Module: Update_PC
// Description: Holds the PC register and calculates PC+1.
//////////////////////////////////////////////////////////////////////////////////
module pc_incrementer (
    input  wire        clk,
    input  wire        rst,            
    input  wire        pc_in, 
    input  wire        halt,
    output wire        pc_stall,
    output wire        pc_out
    
);


    reg [31:0] pc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;    // Freeze PC if stalling OR if sticky halt is set
        
        else if (!pc_stall && !halt) 
            pc <= pc_in; 
    end

    assign pc_out = pc;
    
    assign pc_plus_one_out = pc + 1;

endmodule