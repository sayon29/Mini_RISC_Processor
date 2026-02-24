//////////////////////////////////////////////////////////////////////////////////
// Module: instruction_decoder
// Description: Decodes a 32-bit instruction into its R-type and I-type fields.
//////////////////////////////////////////////////////////////////////////////////
module instruction_decoder(
    input  wire [31:0] instruction,
    
    output wire [5:0]  opcode,
    output wire [4:0]  rs,
    output wire [4:0]  rt,
    output wire [4:0]  rd,
    output wire [3:0]  funct,
    output wire [15:0] immediate_1,
    output wire [25:0] immediate_2
);

    assign opcode    = instruction[31:26]; // Opcode
    assign rs        = instruction[25:21]; // R-type and I-type 
    assign rt        = instruction[20:16]; // R-type and I-type 
    assign rd        = instruction[15:11]; // R-type only
    assign funct     = instruction[3:0];   // R-type only 
    assign immediate_1 = instruction[15:0];  // I-type only
    assign immediate_2 = instruction[25:0];  // I-type only

endmodule