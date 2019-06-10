/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  if_stage.v                                          //
//                                                                     //
//  Description :  instruction fetch (IF) stage of the pipeline;       // 
//                 fetch instruction, compute next PC location, and    //
//                 send them down the pipeline.                        //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module if_stage(
    input         clock,                  // system clock
    input         reset,                  // system reset
    input         ex_mem_take_branch,      // taken-branch signal
    input  [63:0] ex_mem_target_pc,        // target pc: use if take_branch is TRUE
    input  [63:0] Imem2proc_data,          // Data coming back from instruction-memory
    input         Imem_valid,
    input         structural_hazard,
    //input         cachemem_valid,
    input  [63:0] pre_target_PC,
    input 	  br_sol_target,

    output logic [63:0] proc2Imem_addr,    // Address sent to Instruction memory
    output logic [63:0] if_NPC_out_0,        // PC of instruction after fetched (PC+4).
    output logic [31:0] if_IR_out_0,        // fetched instruction out
    output logic        if_valid_inst_out_0,  // when low, instruction is garbage
    output logic [63:0] if_NPC_out_1,        // PC of instruction after fetched (PC+4).
    output logic [31:0] if_IR_out_1,        // fetched instruction out
    output logic        if_valid_inst_out_1  // when low, instruction is garbage
  );

  logic    [63:0] PC_reg;             // PC we are currently fetching

  logic    [63:0] PC_plus_4, PC_plus_8;
  logic    [63:0] next_PC;
  logic           PC_enable;
  logic	flush_0;

  assign proc2Imem_addr = {PC_reg[63:3], 3'b0};	// Addr for Inst, fetch 2 inst now

  assign if_IR_out_0 = Imem2proc_data[31:0];	// Inst 0 opcode
  assign if_IR_out_1 = Imem2proc_data[63:32];	// Inst 1 opcode

  assign PC_plus_8 = PC_reg + 8;		// NPC for Inst_1
  assign PC_plus_4 = PC_reg + 4;		// NPC for Inst_0

  assign flush_0 = PC_reg[2];

  // next PC is target_pc if there is a taken branch or
  // the next sequential PC (PC+4) if no branch
  // (halting is handled with the enable PC_enable;
  assign next_PC = ex_mem_take_branch ? ex_mem_target_pc : br_sol_target ? pre_target_PC : flush_0? PC_plus_4 : PC_plus_8;  //ex_mem_take_branch represent to fix branch & ex_mem_target_pc represent the correct NPC of br

  // The take-branch signal must override stalling (otherwise it may be lost)
  always_comb begin
    if(flush_0)
      if_valid_inst_out_0 =  0;	
    else if(ex_mem_take_branch)
      if_valid_inst_out_0 =  1;	
    else if(structural_hazard || !Imem_valid)
      if_valid_inst_out_0 =  0;
    else
      if_valid_inst_out_0 = 1;
  end 
  always_comb begin
    if(ex_mem_take_branch)
      if_valid_inst_out_1 =  1;	
    else if(structural_hazard || !Imem_valid)
      if_valid_inst_out_1 =  0;
    else 
      if_valid_inst_out_1 = 1;
  end

  assign PC_enable = (!structural_hazard && Imem_valid) || ex_mem_take_branch;  //no need maybe ?

  // Pass PC+4 down pipeline w/instruction
  assign if_NPC_out_0 = (PC_enable)? PC_plus_4 : 0;
  assign if_NPC_out_1 = (PC_enable)? (flush_0 ? PC_plus_4 : PC_plus_8) : 0;

  // This register holds the PC value

  // synopsys sync_set_reset "reset"
  always_ff @(posedge clock) begin
    if(reset)
      PC_reg <= `SD 0;       	// initial PC value is 0
    else if(PC_enable)		//enable when no hazard or branch to fix
      PC_reg <= `SD next_PC; 	// transition to next PC
  end  // always
  
endmodule  // module if_stage
