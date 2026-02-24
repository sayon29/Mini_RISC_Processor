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
    Update_PC pc_updater_inst (
        .clk(clk),
        .rst(rst),
        .pc_stall(pc_stall),
        .halt(halt),
        .pc_in(pc_next_out),         
        .pc_out(pc),         
        .pc_plus_one_out(pc_next)
    );

    // 2. Instruction Fetch Unit
    instruction_fetch_unit fetch_inst (
        .clk(clk),
        .pc_address(pc),
        .instruction(instruction) 
    );

    // 3. Instruction Decoder
    instruction_decoder decoder_inst (
        .instruction(instruction), 
        .opcode(opcode), 
        .rs(rs_addr), 
        .rt(rt_addr),
        .rd(rd_addr), 
        .funct(funct), 
        .immediate_1(immediate_1),
        .immediate_2(immediate_2)
    );

    // 4. Control Unit
    control_unit control_inst (
        .clk(clk),
        .rst(rst), 
        .opcode(opcode), 
        .funct(funct),   
        .pc_stall(pc_stall),
        .reg_write_en(reg_write_en),
        .alu_src_sel(alu_src_sel), 
        .reg_dest_sel(reg_dest_sel), 
        .alu_op(alu_op),
        .immeadiate_sel(immeadiate_sel),
        .move_or_branch(move_or_branch),
        .mem_write_en(mem_write_en),
        .halt(halt),
        .halt_now(halt_now),
        .read_enable(read_enable)
    );

    // 5. Datapath
    datapath datapath_inst (
        .clk(clk),
        .rst(rst), 
        .result(datapath_result), 
        .alu_overflow(alu_overflow),
        .pc_next_out(pc_next_out), 
        .opcode(opcode), 
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .immediate_1(immediate_1),
        .immediate_2(immediate_2),
        .pc_next_in(pc_next),
        .reg_write_en(reg_write_en), 
        .alu_src_sel(alu_src_sel),
        .reg_dest_sel(reg_dest_sel),
        .alu_op(alu_op),
        .immeadiate_sel(immeadiate_sel),
        .move_or_branch(move_or_branch),
        .mem_write_en(mem_write_en), 
        .read_enable(read_enable)    
    );

endmodule