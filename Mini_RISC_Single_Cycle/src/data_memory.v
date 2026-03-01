
module data_memory (
  input wire clk,
  input wire [3:0] wea,         
  input wire [7:0] addra,
  input wire [31:0] dina,
  output wire [31:0] douta
);

  blk_mem_gen_0 ram_instance (
    .clka(clk),
    .wea(wea), 
    .addra(addra),
    .dina(dina),
    .douta(douta)
  );

endmodule