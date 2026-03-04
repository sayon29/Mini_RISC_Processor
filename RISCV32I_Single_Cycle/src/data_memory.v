
module data_memory (
  input wire clk,
  input wire [3:0] wea,         
  input wire [6:0] addra,
  input wire [31:0] dina,
  input wire enable,
  output wire [31:0] douta
);

  blk_mem_gen_0 ram_instance (
    .clka(clk),
    .ena(enable),
    .wea(wea), 
    .addra(addra),
    .dina(dina),
    .douta(douta)
  );

endmodule