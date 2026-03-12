`timescale 1ns / 1ps

module WB_Stage (input reg_write_en_WB,//reg
                 input [31:0] alu_res_WB,//mux
                 input [31:0] pc_WB,//mux
                 input [31:0] memdata_WB,//mux
                 input [1:0] mux_writeback_con_WB,//control
                 input [4:0]  rd_addr_WB,//reg
                 output [31:0] write_back_data_WB);
                 

assign  write_back_data_WB=(mux_writeback_con_WB == 2'b00) ? memdata_WB :
                           (mux_writeback_con_WB == 2'b01) ? alu_res_WB :
                           (mux_writeback_con_WB == 2'b10) ? pc_WB:32'b0 ;
                           
                           
endmodule