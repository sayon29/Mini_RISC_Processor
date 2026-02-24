//////////////////////////////////////////////////////////////////////////////////
// Module: control_unit
// Description: Generates datapath control signals based on the instruction.
// MODIFIED: Correctly enables reg_write, reg_dest_sel, and alu_src_sel
//           for MOV and CMOV instructions.
//////////////////////////////////////////////////////////////////////////////////
module control_unit(
    
    input  wire        clk,
    input  wire        rst,
    
    input  wire [5:0]  opcode,
    input  wire [3:0]  funct,
    
    output wire        pc_stall,

    output wire        reg_write_en,
    output wire        alu_src_sel,  
    output wire        reg_dest_sel,
    output wire [3:0]  alu_op,       
    output wire        immeadiate_sel,
    output wire        move_or_branch,
    output wire [3:0]  mem_write_en,
    output wire        halt,           
    output wire        halt_now,       
    output wire        read_enable     
);

    localparam STATE_FETCH    = 2'b00;
    localparam STATE_EXECUTE  = 2'b01;
    localparam STATE_MEM_WAIT = 2'b10;

    reg [1:0] state;
    reg       halt_reg;       

    reg       reg_wr_reg;
    reg       read_en_reg; 

    wire is_execute_state = (state == STATE_EXECUTE);


    // Combinational Control Signals 
    wire is_r_type     = (opcode == 6'b000000) && is_execute_state;
    wire is_i_type_alu = (opcode[5:4] == 2'b01) && is_execute_state;
    wire is_j_type     = (opcode == 6'b100011) && is_execute_state;
    wire is_cmov       = (opcode == 6'b110001) && is_execute_state;
    wire is_move       = (opcode == 6'b110000) && is_execute_state;
    wire is_store_op   = (opcode == 6'b101001) && is_execute_state;
    wire is_load_op    = (opcode == 6'b101000) && is_execute_state;
    
    wire is_mov_op     = is_move | is_cmov;

    wire read_en_in;
    wire reg_wr_in;
    wire mem_wr_in;
    wire halt_signal; 
    
    assign read_en_in  = is_load_op;
   
    assign reg_wr_in   = is_r_type | is_i_type_alu | is_load_op | is_mov_op;
    assign mem_wr_in   = is_store_op;
    assign halt_signal = (opcode == 6'b111000); 

    // Combinational signals
    assign alu_src_sel    = is_r_type | is_mov_op ; 
  
    assign reg_dest_sel   = is_r_type | is_mov_op;
    
    assign alu_op         = is_r_type ? funct : (is_i_type_alu ? opcode[3:0] : 4'b0);
    assign immeadiate_sel = is_j_type;
    assign move_or_branch = is_mov_op | is_j_type;
   
    assign pc_stall = (state == STATE_FETCH) || (is_execute_state && read_en_in);
    
    assign halt = halt_reg; 
    
    assign halt_now = halt_signal && is_execute_state;

    assign mem_write_en = mem_wr_in ? 4'b1111 : 4'b0000;

    assign reg_write_en = (reg_wr_in && is_execute_state && !read_en_in) || 
                          (reg_wr_reg && (state == STATE_MEM_WAIT));      
                          
    assign read_enable = read_en_reg;
    
    
    // FSM state transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_FETCH;
            halt_reg <= 1'b0;
            reg_wr_reg <= 1'b0;
            read_en_reg <= 1'b0;
        end
        
        else if (halt_reg || (halt_signal && is_execute_state)) begin
            state <= state; 
            if (halt_signal && is_execute_state)
                halt_reg <= 1'b1; 
        end
        else begin
            
            case (state)
                STATE_FETCH: begin
                    state <= STATE_EXECUTE;
                    reg_wr_reg <= 1'b0;
                    read_en_reg <= 1'b0;
                end
                STATE_EXECUTE: begin
                    reg_wr_reg <= reg_wr_in;
                    read_en_reg <= read_en_in; 

                    if (read_en_in) 
                        state <= STATE_MEM_WAIT;
                    else
                        state <= STATE_FETCH;
                end
                STATE_MEM_WAIT: begin
                    state <= STATE_FETCH;
                    reg_wr_reg <= 1'b0;
                    read_en_reg <= 1'b0;
                end
                default: state <= STATE_FETCH;
            endcase
        end
    end

endmodule