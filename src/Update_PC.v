//////////////////////////////////////////////////////////////////////////////////
// Module: Update_PC
// Description: Holds the PC register and calculates PC+1.
//////////////////////////////////////////////////////////////////////////////////
module Update_PC (
    input  wire        clk,
    input  wire        rst,            
    input  wire        pc_stall,       
    input  wire        halt,           
    input  wire [31:0] pc_in,          // Selected next PC from datapath
    
    output wire [31:0] pc_out,         
    output wire [31:0] pc_plus_one_out 
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