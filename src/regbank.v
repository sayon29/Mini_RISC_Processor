
`timescale 1ns / 1ps

module reg_bank(
    input clk,
    input rst,
    input [4:0] r_addr_a, r_addr_b, w_addr,
    input [31:0] w_data,
    input wr_en,
    output [31:0] r_data_a, r_data_b
);
    // 16 registers, 32 bits each
    reg [31:0] register_file [0:15];

    // Asynchronous reads 
    assign r_data_a = (r_addr_a == 4'd0) ? 32'd0 : register_file[r_addr_a];
    assign r_data_b = (r_addr_b == 4'd0) ? 32'd0 : register_file[r_addr_b];

    // Synchronous write and reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            register_file[0]  <= 32'h00000000;
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
            
        end else if (wr_en && w_addr != 4'd0) begin //R0 forced to be 0
            register_file[w_addr] <= w_data;
        end
    end
endmodule