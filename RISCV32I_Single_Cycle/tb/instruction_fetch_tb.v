`timescale 1ns/1ps

module instruction_fetch_tb;

  reg clk;
  reg [6:0] pc_address;
  wire [31:0] instruction;

  // Instantiate DUT
  instruction_fetch uut (
    .clk(clk),
    .pc_address(pc_address),
    .instruction(instruction)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    pc_address = 0;

    // Wait first clock
    @(posedge clk);

    // Read first 10 instructions
    repeat (10) begin
      @(posedge clk);      // apply new address
      pc_address <= pc_address + 1;
      @(posedge clk);      // wait for instruction
      $display("Time=%0t | PC=%0d | Instruction=%h",
               $time, pc_address-1, instruction);
    end

    $finish;
  end

endmodule