module control_unit(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] instruction,

    output reg         reg_write_en,
    output reg         alu_srcA,
    output reg         alu_srcB,
    output reg  [3:0]  alu_op,
    output reg  [3:0]  mem_write_en,
    output reg  [1:0]  write_back
);

    reg [6:0] opcode;
    reg [6:0] funct7;
    reg [2:0] funct3;
    
    always@(instruction)begin
    opcode= instruction[6:0];
    case(opcode)
        7'b0110011:begin                    //Register and Multiply Type
            funct7= instruction[31:25];
            funct3= instruction[14:12];
            case(funct7)
                7'd0:begin
                        case(funct3)
                            3'd0:alu_op=2;  //ADD
                            3'd1:alu_op=8;  //SLL
                            3'd2:alu_op=14; //SLT
                            3'd3:alu_op=15; //SLTU
                            3'd4:alu_op=4;  //XOR
                            3'd5:alu_op=7;  //SRL
                            3'd6:alu_op=5;  //OR
                            3'd7:alu_op=6;  //AND
                        endcase
                end
                7'd32:begin
                        case(funct3)
                            3'd0:alu_op=3;  //SUB
                            3'd5:alu_op=9;  //SRA
                         endcase
                end
                7'd1:begin
                        case(funct3)
                            3'd0:alu_op=10; //MUL
                            3'd1:alu_op=11; //MULH
                            3'd4:alu_op=12; //DIV
                            3'd6:alu_op=13; //REM
                         endcase
                end
                default:alu_op=0;
                endcase
        end
        7'b110011:begin     //Branch-type
            case(funct3)
            3'd0,3'd1,3'd4,3'd5,3'd6,3'd7:  //BEQ BNE BLT BGE BLTU BGEU
                alu_op=2;
            default:alu_op=0;
            endcase     
        end
        7'b110011:begin     //Immediate arithmatic-type
            case(funct3)
            3'd0:alu_op=2;  //ADDI
            3'd2:alu_op=14; //SLTI
            3'd3:alu_op=15; //SLTUI
            3'd4:alu_op=4;  //XORI
            3'd6:alu_op=5;  //ORI
            3'd7:alu_op=6;  //ANDI
            3'd1:alu_op=8;  //SLLI
            3'd5:begin      
            if(funct7==0) alu_op=7; //SRLI
            else if(funct7==32) alu_op=9;   //SRAI
            end      
            default:alu_op=0;
            endcase     
        end
        7'b0000011:begin     //Immediate load-type
            case(funct3)
            3'd0,3'd1,3'd2,3'd4,3'd5:   //LB LH LW LBU LHU
                alu_op=2;
            default:alu_op=0;
            endcase     
        end
        7'b110111:alu_op=1; //LUI
        7'b0100011:begin     //S-type
            case(funct3)
            3'd0,3'd1,3'd2:     //SB SH SW
                alu_op=2;
            default:alu_op=0;
            endcase     
        end
        7'b1101111:alu_op=2; //JAL
            
    endcase
    end

endmodule