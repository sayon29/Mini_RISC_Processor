module instruction_fetch_unit(
    input  wire        clk,
    input  wire [31:0] pc_address,  
    output wire [31:0] instruction
);

    blk_mem_gen_1 instruction_rom_inst (
    .clka(clk),
    .addra(pc_address),
    .douta(instruction)
  );
endmodule