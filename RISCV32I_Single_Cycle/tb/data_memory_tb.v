`timescale 1ns/1ps

module data_memory_tb;

  reg clk;
  reg [3:0] wea;
  reg [6:0] addra;
  reg [31:0] dina;
  wire [31:0] douta;

  data_memory uut (
    .clk(clk),
    .wea(wea),
    .addra(addra),
    .dina(dina),
    .douta(douta)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    wea = 0;
    addra = 0;
    dina = 0;

    // Wait for first clock
    @(posedge clk);

    // WRITE
    addra <= 7'd10;
    dina  <= 32'hDEADBEEF;
    wea   <= 4'b1111;
    @(posedge clk);   // write happens here

    // Disable write
    wea <= 4'b0000;
    @(posedge clk);

    // READ
    addra <= 7'd10;
    @(posedge clk);   // address registered
    @(posedge clk);   // data available

    $display("Read Data = %h", douta);

    $finish;
  end

endmodule