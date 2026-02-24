//////////////////////////////////////////////////////////////////////////////////
// Module: top
// Description: Top-level module.
// Instantiates the processor and connects it to LEDs/switches.
//////////////////////////////////////////////////////////////////////////////////

module top(
    // Hardware Interface
    input wire         clk,         // 100MHz System Clock
    input wire         reset_btn,   // CPU Reset Button (BTNC)
    output wire [15:0] led,         // 16 LEDs
    input wire [0:0]   sw           // Display Select Switch
);

    // Wires to connect to the processor
    wire [31:0] processor_result;
    wire        update_display_en;

    // Processor Instantiation
    risc_processor processor_inst (
        .clk(clk),
        .rst(reset_btn),
        
        .processor_result(processor_result),
        .update_display_en(update_display_en)
    );

    // Display and LED Logic 
    reg [31:0] display_reg;         // Holds the final result

    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn)
            display_reg <= 32'b0;
            
        else if (update_display_en) 
            display_reg <= processor_result;
     
    end
    
    // Mux to display either upper or lower 16 bits based on SW[0]
    assign led = sw[0] ? display_reg[31:16] : display_reg[15:0];

endmodule