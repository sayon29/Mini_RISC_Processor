`timescale 1ns / 1ps

module reg_bank(
    input clk,
    input rst,
    input [4:0] r_addr_a,
    input [4:0] r_addr_b,
    input [4:0] w_addr,
    input [31:0] w_data,
    input wr_en,
    output [31:0] r_data_a,
    output [31:0] r_data_b
);

    // 32 registers, 32 bits each
    reg [31:0] register_file [0:31];
    integer i;

    // Asynchronous reads
    assign r_data_a = (r_addr_a == 5'd0) ? 32'd0 : register_file[r_addr_a];
    assign r_data_b = (r_addr_b == 5'd0) ? 32'd0 : register_file[r_addr_b];

    // Synchronous write and reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear all registers
            for (i = 0; i < 32; i = i + 1)
                register_file[i] <= 32'd0;

            // Optional debug initialization
            register_file[1]  <= 32'd5;
            register_file[2]  <= 32'd2;
            register_file[3]  <= 32'd20;
            register_file[4]  <= 32'd25;
            register_file[5]  <= 32'd30;
            register_file[6]  <= 32'd35;
            register_file[7]  <= 32'd40;
            register_file[8]  <= 32'd45;
            register_file[9]  <= 32'd50;
            register_file[10] <= 32'd55;
            register_file[11] <= 32'd60;
            register_file[12] <= 32'd65;
            register_file[13] <= 32'd70;
            register_file[14] <= 32'd75;
            register_file[15] <= 32'd80;
            register_file[16] <= 32'd128;

        end 
        else if (wr_en && w_addr != 5'd0) begin
            register_file[w_addr] <= w_data;
        end
    end

endmodule