//////////////////////////////////////////////////////////////////////////////////
// Module: risc_processor
// Description: The complete processor core.
//////////////////////////////////////////////////////////////////////////////////

module risc_processor(
    input  wire        clk,
    input  wire        rst,
    
    // Outputs to the top-level 
    output wire [31:0] processor_result,
    output wire        update_display_en
);

    wire [31:0] instruction;
    wire [31:0] pc_next_out;     
    wire [31:0] datapath_result; 
    wire        alu_overflow;

    // PC Wires 
    wire [31:0] pc;      
    wire [31:0] pc_next;     

    // Decoder Wires
    wire [5:0]  opcode;
    wire [4:0]  rs_addr, rt_addr, rd_addr;
    wire [3:0]  funct;
    wire [15:0] immediate_1;
    wire [25:0] immediate_2;

    // Control Wires 
    wire        pc_stall;        
    wire        reg_write_en;   
    wire        alu_src_sel;
    wire        reg_dest_sel;
    wire [3:0]  alu_op;
    wire        immeadiate_sel;
    wire        move_or_branch;
    wire [3:0]  mem_write_en;   
    wire        halt;           
    wire        halt_now;       
    wire        read_enable;    

    // Pass the datapath result to the output
    assign processor_result = datapath_result;
    
    // Update display signal
    assign update_display_en = !pc_stall && !halt && !halt_now;


    // Module Instantiations 

    // 1. PC Logic Unit
    pc_incrementer pc_incrementer_inst (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next_out),         
        .pc_out(pc),         
        .pc_plus_one_out(pc_next),
        .halt(halt),
        .pc_stall(pc_stall)
    );

    // 2. Instruction Fetch Unit
    instruction_fetch fetch_inst (
        .clk(clk),
        .pc_address(pc),
        .instruction(instruction) 
    );

    // 3. Control Unit
    control_unit control_inst (
        .clk(clk),
        .rst(rst), 
        .instruction(instruction),
        .reg_write_en(reg_write_en),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB), 
        .dest_reg_sel(dest_reg_sel), 
        .alu_op(alu_op),
        .mem_write_en(mem_write_en),
        .pc_stall(pc_stall),
        .halt(halt),
        .halt_now(halt_now),
        .read_enable(read_enable)
    );

    // 4. Datapath
    datapath datapath_inst (
        .clk(clk),
        .rst(rst), 
        .result(datapath_result),
        .instruction(instruction),
        .alu_overflow(alu_overflow),   
        .pc_next_in(pc_next),
        .pc_next_out(pc_next_out), 
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB), 
        .reg_write_en(reg_write_en), 
        .dest_reg_sel(dest_reg_sel),
        .alu_op(alu_op),
        .mem_write_en(mem_write_en), 
        .read_enable(read_enable)    
    );

endmodule