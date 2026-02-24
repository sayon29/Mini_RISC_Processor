//////////////////////////////////////////////////////////////////////////////////
// Module: branch_comparator
//////////////////////////////////////////////////////////////////////////////////
module branch_comparator (
    input wire [5:0]  opcode,
    input wire [31:0] rs_data,
    output reg        is_branch 
);

    wire is_minus = rs_data[31];
    
    wire is_zero = (rs_data == 32'd0);
    
    wire is_greater_than_zero = !is_minus & !is_zero;

    always @(*) begin
        case (opcode)
            // Branch on Plus: if (rs > 0)
            6'b100010: begin
                is_branch = is_greater_than_zero;
            end
            
            // Branch on Zero: if (rs == 0)
            6'b100000: begin
                is_branch = is_zero;
            end
            
            // Branch on Minus: if (rs < 0)
            6'b100001: begin
                is_branch = is_minus;
            end
            
            6'b100011: begin
                is_branch = 1'b1; // Always branch on unconditional branch
            end

            default: begin
                is_branch = 1'b0; 
            end
        endcase
    end

endmodule