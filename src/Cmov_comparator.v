//////////////////////////////////////////////////////////////////////////////////
// Module: Cmov_comparator
//////////////////////////////////////////////////////////////////////////////////

module Cmov_comparator(
    input wire [31:0] rs_data,
    input wire [31:0] rt_data,
    input wire [5:0]  opcode,
    output wire       cmov
);

    wire is_move = (opcode == 6'b110000); // MOVE 
    wire is_cmov = (opcode == 6'b110001); // CMOV
    
    wire is_less_than = ($signed(rs_data) < $signed(rt_data));
    
    assign cmov = (is_move) ? 1'b1 : 
                  (is_cmov && is_less_than) ? 1'b1 : 
                  1'b0;                          
endmodule