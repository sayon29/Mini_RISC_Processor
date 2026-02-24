`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module: tb_top
//////////////////////////////////////////////////////////////////////////////////
module tb_top();

    // Inputs
    reg clk;
    reg reset_btn;
    reg [0:0] sw;

    // Outputs 
    wire [15:0] led;

    // Instantiate the Device Under Test (DUT)
    top dut (
        .clk(clk),
        .reset_btn(reset_btn),
        .led(led),
        .sw(sw)
    );

    // Clock Generation 
    localparam CLK_PERIOD = 10;
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2);
        clk = 1'b1;
        #(CLK_PERIOD / 2);
    end

    always @(posedge clk) begin
        if (reset_btn == 0) begin
            $display("[$time] PC: %h | INST: %h | RESULT: %h | PC_NEXT: %h | HALT: %b | DISP: %h | SRC1: %h | SRC2: %h | RES: %h",
                     dut.processor_inst.pc,         
                     dut.processor_inst.instruction, 
                     dut.display_reg,                  
                     dut.processor_inst.pc_next,        
                     dut.processor_inst.halt,               
                     dut.led,
                     dut.processor_inst.datapath_inst.alu_inst.src1,
                     dut.processor_inst.datapath_inst.alu_inst.src2,
                     dut.processor_inst.datapath_inst.alu_inst.aluOut
            );
        end
    end

    // Simulation Control
    initial begin
        // 1. Initialize all inputs
        $display("[$time] --- Simulation Started ---");
        
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        reset_btn = 1'b0; 
        sw        = 1'b0; 
        
        #(CLK_PERIOD * 2);

        // 2. Apply the reset button press
        $display("[$time] --- Pressing Reset Button (BTNC) ---");
        reset_btn = 1'b1;
        
        @(negedge clk);
        @(negedge clk);
        
        // 3. Release reset and let the program run
        $display("[$time] --- Releasing Reset. Processor is RUNNING. ---");
        reset_btn = 1'b0;

        // Wait 60 cycles
        repeat(300000) @(posedge clk);

        // 4. Check the final result
        $display("[$time] --- Program should be HALTED. Checking LEDs. ---");
        
        #(CLK_PERIOD / 2);
        
        if (led === 16'h000f) begin
            $display("[$time] --- TEST PASSED (Lower Bits): LEDs show %h ---", led);
        end else begin
            $display("[$time] --- TEST FAILED (Lower Bits): Expected 16'h000f, got %h ---", led);
        end

        // 5. Check the upper bits
        $display("[$time] --- Setting SW[0] to ON. ---");
        sw = 1'b1; 
        
        #(CLK_PERIOD); 
        
        if (led === 16'h0000) begin
            $display("[$time] --- TEST PASSED (Upper Bits): LEDs show %h ---", led);
        end else begin
            $display("[$time] --- TEST FAILED (Upper Bits): Expected 16'h0000, got %h ---", led);
        end

        // 6. Finish simulation
        $display("[$time] --- Simulation Finished ---");
        $finish;
    end

endmodule