/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  pipeline.v                                          //
//                                                                     //
//  Description :  Top-level module of the verisimple pipeline;        //
//                 This instantiates and connects the 5 stages of the  //
//                 Verisimple pipeline togeather.                      //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module pipeline (

    input         clock,                    // System clock
    input         reset,                    // System reset
    input [3:0]   mem2proc_response,        // Tag from memory about current request
    input [63:0]  mem2proc_data,            // Data coming back from memory
    input [3:0]   mem2proc_tag,              // Tag from memory about current reply

 
    output logic	valid_wb_0,
    output logic	valid_wb_1, //valid bit

//////////////////////////////////////////////////////////////////////////////////////

    output logic [1:0]  proc2mem_command,    	// command sent to memory
    output logic [63:0] proc2mem_addr,      	// Address sent to memory
    output logic [63:0] proc2mem_data,      	// Data sent to memory

    output logic [3:0]  pipeline_completed_insts_0, pipeline_completed_insts_1,
    output ERROR_CODE   pipeline_error_status,
    output logic [$clog2(`N_ENTRY_ROB+33)-1:0]  pipeline_commit_wr_idx_0, pipeline_commit_wr_idx_1,
    output logic [63:0] pipeline_commit_wr_data_0, pipeline_commit_wr_data_1,
    output logic        pipeline_commit_wr_en_0, pipeline_commit_wr_en_1,
    output logic [63:0] pipeline_commit_NPC_0, pipeline_commit_NPC_1,


//test_reg
output  logic [`N_ENTRY_ROB+32:0][63:0] rf_value_out,
output	logic free_PR_1,
output	logic free_PR_0,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out_0,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out_1,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Told_out_0,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Told_out_1,

//ROB

output  logic is_0_br,
output	logic recovery_request,
output  logic [$clog2(`N_ENTRY_ROB)-1:0] recovery_tail,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_0,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_1,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0, 
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1, 
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_0,
output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_1,
output  logic fetch_PR_0,
output  logic fetch_PR_1,
output  logic id_halt_out_0,
output  logic id_halt_out_1,
output  logic id_wr_mem_out_0,
output  logic id_wr_mem_out_1,
output  logic [63:0] if_id_NPC_0,
output  logic [63:0] if_id_NPC_1,
output  logic [31:0] if_id_IR_0,
output  logic [31:0] if_id_IR_1,


///////////////////////////////////////////////////////////////////////////////



    // testing hooks (these must be exported so we can test
    // the synthesized version) data is tested by looking at
    // the final values in memory


    // Outputs from IF-Stage 
    output logic [63:0] if_NPC_out_0,
    output logic [31:0] if_IR_out_0,
    output logic        if_valid_inst_out_0,
    output logic [63:0] if_NPC_out_1,
    output logic [31:0] if_IR_out_1,
    output logic        if_valid_inst_out_1,

    // Outputs from IF/ID Pipeline Register
    output logic        if_id_valid_inst_0,
    output logic        if_id_valid_inst_1,


    // Outputs from ID/EX Pipeline Register
    output logic [63:0] id_ex_NPC_0,
    output logic [31:0] id_ex_IR_0,
    output logic        id_ex_valid_inst_0,
    output logic [63:0] id_ex_NPC_1,
    output logic [31:0] id_ex_IR_1,
    output logic        id_ex_valid_inst_1,


    // Outputs from EX/MEM Pipeline Register
    output logic [63:0] ex_mem_NPC_0,
    output logic [31:0] ex_mem_IR_0,
    output logic        ex_mem_valid_inst_0,
    output logic [63:0] ex_mem_NPC_1,
    output logic [31:0] ex_mem_IR_1,
    output logic        ex_mem_valid_inst_1

  );


   // recovery SQ
   logic [$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_tail_shot;

   // Pipeline register enables
   logic	if_id_enable, id_ex_enable_0, id_ex_enable_1;

   //IF
   logic structural_hazard;
   // Outputs

   logic	recovery_busy;

//////////////////////////////////////////


  // Outputs from Decoder
  ALU_OPA_SELECT id_opa_select_out_0;
  ALU_OPB_SELECT id_opb_select_out_0;
  logic  [4:0]   id_dest_reg_idx_out_0;
  ALU_FUNC       id_alu_func_out_0;
  logic          id_rd_mem_out_0;
  logic          id_cond_branch_out_0;
  logic          id_uncond_branch_out_0;

  logic          id_illegal_out_0;
  logic          id_valid_inst_out_0;
  ALU_OPA_SELECT id_opa_select_out_1;
  ALU_OPB_SELECT id_opb_select_out_1;
  logic  [4:0]   id_dest_reg_idx_out_1;
  ALU_FUNC       id_alu_func_out_1;
  logic          id_rd_mem_out_1;
  logic          id_cond_branch_out_1;
  logic          id_uncond_branch_out_1;
  logic          id_illegal_out_1;
  logic          id_valid_inst_out_1;
  logic [4:0]    id_ra_idx_0, id_ra_idx_1;
  logic [4:0]    id_rb_idx_0, id_rb_idx_1;
  logic [4:0]    id_rc_idx_0, id_rc_idx_1;



  //freelist branch recovery
  logic	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] recovery_tag_table_freelist;
  logic	[$clog2(`N_ENTRY_ROB)-1:0] recovery_pointer_freelist;
  logic	recovery_empty_freelist;

  logic [`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] tag_table_br_freelist;
  logic empty_br_freelist;
  logic [$clog2(`N_ENTRY_ROB)-1:0] pointer_br_freelist;


  //LQ
  logic [1:0][$clog2(`N_ENTRY_ROB+33)-1:0] LQ_dest_reg;
  logic [1:0] LQ_issued;
  
  logic [1:0][63:0] LQ_data;
  logic ex_stall_sol_0,ex_stall_sol_1;
  logic busy_SQ, busy_LQ;

  logic [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_0;
  logic [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_1;


  //Maptable T1/T2 reset to ZERO REG for imm
  logic [4:0] maptable_T1_idx_0;
  logic [4:0] maptable_T2_idx_0;
  logic [4:0] maptable_T1_idx_1;
  logic [4:0] maptable_T2_idx_1;

  logic [31:0] recovery_ready_table; //from BP recovery
  logic [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] recovery_Tag_table; //from BP recovery
  //Maptable
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_out_0;	// T1 tag for RS 
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_out_1;	//
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_out_0;	// T2 tag for RS
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_out_1;	//
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T_out;	// the first T tag (for fixing RAW)
  logic map_table_T1_ready_in_0;			// + for T1's tag in RS
  logic map_table_T1_ready_in_1;			//
  logic map_table_T2_ready_in_0;			// + for T2's tag in RS
  logic map_table_T2_ready_in_1;
  logic [31:0] ready_table_br;
  logic [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] Tag_table_br;

  logic is_1_br;
  //RS
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T1_out_0;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T1_out_1;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T2_out_0;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T2_out_1;		
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_out_0;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_out_1;		
  logic [31:0] INSTR_out_0;
  logic [31:0] INSTR_out_1;
  logic busy_RS;
  logic br_sol_0;///////from predecoder_br
  logic br_sol_1;///////from predecoder_br
  logic [`STACK_NUM-1:0] b_mask_out;///////from BP reovery			

  ALU_FUNC func_out_0;
  ALU_FUNC func_out_1;
  ALU_OPA_SELECT opa_select_out_0;		
  ALU_OPA_SELECT opa_select_out_1;		
  ALU_OPB_SELECT opb_select_out_0;		
  ALU_OPB_SELECT opb_select_out_1;		
  logic rd_mem_out_0;
  logic rd_mem_out_1;
  logic wr_mem_out_0;
  logic wr_mem_out_1;
  logic ldl_mem_out_0;
  logic ldl_mem_out_1;
  logic stc_mem_out_0;
  logic stc_mem_out_1;
  logic cond_branch_out_0;
  logic cond_branch_out_1;
  logic uncond_branch_out_0;
  logic uncond_branch_out_1;
  logic halt_out_0;
  logic halt_out_1;
  logic cpuid_out_0;
  logic cpuid_out_1;
  logic illegal_out_0;
  logic illegal_out_1;
  logic valid_inst_out_0;
  logic valid_inst_out_1;
  logic [63:0] id_NPC_out_0, id_NPC_out_1;
  logic [`STACK_NUM-1:0] id_b_mask_out_0;
  logic [`STACK_NUM-1:0] id_b_mask_out_1;
  logic id_br_sol_out_0;
  logic id_br_sol_out_1;
  logic issue_0_flush;
  logic issue_1_flush;

  //br signal
  logic snapshot_enable;
  logic	[$clog2(`STACK_NUM)-1:0] space_address;
  logic [`STACK_NUM-1:0] b_mask_RS_0;
  logic [`STACK_NUM-1:0] b_mask_RS_1;
  logic	[63:0] pre_target_PC; //from BTB
  logic	[63:0] if_id_pre_target_PC_0;
  logic	[63:0] if_id_pre_target_PC_1;
  logic	[63:0] id_pre_target_PC_0;
  logic	[63:0] id_pre_target_PC_1;
  logic	[63:0] id_ex_pre_target_PC_0;
  logic	[63:0] id_ex_pre_target_PC_1;
  logic btb_mispred_0; // for BTB, from EX
  logic btb_mispred_1; // for BTB, from EX
  logic btb_wr_enable;
  logic tnt_wr;
  logic ex_mem_btb_mispred_0;
  logic ex_mem_btb_mispred_1;
  logic ex_mem_cond_branch_0;
  logic ex_mem_cond_branch_1;
  logic cond_wr_enable;
  logic [63:0] br_NPC;
  logic ras_structural_hazard;
  logic [31:0] if_IR_out_0_inter;
  logic [31:0] if_IR_out_1_inter;
  logic if_valid_inst_out_0_inter;
  logic if_valid_inst_out_1_inter;
  logic br_sol_target;
  logic br_sol_0_pre;
  logic br_sol_1_pre;
  logic br_is_on_0;
  logic br_is_on_1;
  logic br_is_on_ex;
  logic [$clog2(`N_ENTRY_SQ)-1:0] SQ_tail;
  logic [$clog2(`N_ENTRY_SQ)-1:0] SQ_tail_out;
  logic [1:0][`STACK_NUM-1:0] b_mask_to_dcache;
  logic empty_shot;
  logic SQ_empty_recovery;
  logic	[$clog2(`STACK_NUM)-1:0]br_correct_address;

  //ROB,RS
  logic enable_dispatch;

  logic busy_ROB;
  logic [$clog2(`N_ENTRY_ROB)-1:0] tail_pointer;//to BP recovery

  //RF
  logic [63:0] id_ra_value_out_0; 
  logic [63:0] id_ra_value_out_1;

  logic [63:0] id_rb_value_out_0;
  logic [63:0] id_rb_value_out_1;

  logic wb_reg_wr_en_out_0;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] wb_reg_wr_idx_out_0;
  logic [63:0] wb_reg_wr_data_out_0;
  logic wb_reg_wr_en_out_1;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] wb_reg_wr_idx_out_1;
  logic [63:0] wb_reg_wr_data_out_1;

  //LSQ
  logic [2:0] dcache_data_ready_in;
  logic [$clog2(`N_ENTRY_LQ)-1:0] dcache_load_index_in;
  logic [2:0][63:0] dcache_data_in;

  logic SQ_dcache_Data_en_out;
  logic [63:0] SQ_dcache_address_out;//output store address for Dcache.

  logic [1:0][63:0] LQ_dcache_fetch_address_out;
  logic [1:0][$clog2(`N_ENTRY_LQ)-1:0] LQ_dcache_fetch_index_out;
  logic [1:0]	LQ_dcache_fetch_en;

  //dcache
  logic [3:0] mem_ld_index;
  logic [8:0] mem_ld_tag;
  logic [3:0] store_index;
  logic [8:0] store_tag;
  logic [3:0] load_index_0;
  logic [8:0] load_tag_0;
  logic [3:0] load_index_1;
  logic [8:0] load_tag_1;
  logic wr_store_hit;

  // Outputs from ID/EX Pipeline Register
  logic	[`STACK_NUM-1:0] id_b_mask_correct_0,id_b_mask_correct_1; 



  logic  [63:0]   id_ex_rega_0;
  logic  [63:0]   id_ex_regb_0;
  ALU_OPA_SELECT  id_ex_opa_select_0;
  ALU_OPB_SELECT  id_ex_opb_select_0;
  ALU_FUNC        id_ex_alu_func_0;
  logic           id_ex_rd_mem_0;
  logic           id_ex_wr_mem_0;
  logic           id_ex_cond_branch_0;
  logic           id_ex_uncond_branch_0;
  logic           id_ex_halt_0;
  logic           id_ex_illegal_0;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] id_ex_dest_reg_idx_0;
  logic [`STACK_NUM-1:0] id_ex_b_mask_out_0;
  logic           id_ex_br_sol_out_0; 
  
  logic  [63:0]   id_ex_rega_1;
  logic  [63:0]   id_ex_regb_1;
  ALU_OPA_SELECT  id_ex_opa_select_1;
  ALU_OPB_SELECT  id_ex_opb_select_1;
  ALU_FUNC        id_ex_alu_func_1;
  logic           id_ex_rd_mem_1;
  logic           id_ex_wr_mem_1;
  logic           id_ex_cond_branch_1;
  logic           id_ex_uncond_branch_1;
  logic           id_ex_halt_1;
  logic           id_ex_illegal_1;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] id_ex_dest_reg_idx_1;
  logic [`STACK_NUM-1:0] id_ex_b_mask_out_1;
  logic           id_ex_br_sol_out_1;
  logic		  id_ldl_mem_out_0, id_ldl_mem_out_1;
  logic		  id_stc_mem_out_0, id_stc_mem_out_1;
  logic		  id_cpuid_out_0, id_cpuid_out_1;
  // Outputs from EX-Stage
  logic  alu_flush_0;
  logic  alu_flush_1;
  logic  br_correct_to_com_0;
  logic  br_correct_to_com_1;
  logic  [`STACK_NUM-1:0] recovery_b_mask_to_com;
  logic mult_done_0, mult_done_1; 
  logic mult_enable_0, mult_enable_1; 
  logic ex_stall_0, ex_stall_1;
  logic [63:0] id_ex_NPC_next_0;
  logic [63:0] id_ex_NPC_next_1;
  logic [31:0] id_ex_IR_next_0;
  logic [31:0] id_ex_IR_next_1;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] id_ex_dest_reg_idx_next_0; 
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] id_ex_dest_reg_idx_next_1; 
  logic [63:0] ex_alu_result_out_0;
  logic        ex_take_branch_out_0;
  logic [63:0] ex_alu_result_out_1;
  logic        ex_take_branch_out_1;
  logic [63:0] ex_LQ_addr_0, ex_LQ_addr_1;
  // Outputs from EX/MEM Pipeline Register
  logic  br_correct;
  logic  br_correct_0;
  logic  br_correct_1;
  logic  flush_id_ex_0,flush_id_ex_1;
  logic  [`STACK_NUM-1:0] recovery_b_mask;
  logic [$clog2(`N_ENTRY_ROB+33)-1:0] ex_mem_dest_reg_idx_0;
  logic         ex_mem_illegal_0;
  logic  [63:0] ex_mem_alu_result_0;
  logic         ex_mem_take_branch_0;

  logic [$clog2(`N_ENTRY_ROB+33)-1:0] ex_mem_dest_reg_idx_1;
  logic         ex_mem_illegal_1;
  logic  [63:0] ex_mem_rega_1;
  logic  [63:0] ex_mem_alu_result_1;
  logic         ex_mem_take_branch_1;


  // Memory interface/arbiter wires
  logic [63:0] proc2Dmem_addr, proc2Imem_addr;
  logic  [1:0] proc2Dmem_command, proc2Imem_command;
  logic  [3:0] Imem2proc_response, Dmem2proc_response;

  // Icache wires
  logic [63:0] cachemem_data;
  logic        cachemem_valid, prefetch_valid;
  logic  [3:0] Icache_rd_idx, prefetch_rd_idx;
  logic  [8:0] Icache_rd_tag, prefetch_rd_tag;
  logic  [3:0] Icache_wr_idx;
  logic  [8:0] Icache_wr_tag;
  logic        Icache_wr_en;
  logic [63:0] Icache_data_out, proc2Icache_addr;
  logic        Icache_valid_out;

  logic ROB_halt_out_0;
  logic ROB_halt_out_1;

  logic	SQ_valid_0;
  logic	SQ_valid_1;

  logic [63:0]	if_recovery_NPC,ex_mem_target_result_0,ex_mem_target_result_1,ex_target_result_0,ex_target_result_1;
  logic		if_recovery_enable,ex_mem_NPC_branch_enable_0, ex_mem_NPC_branch_enable_1,ex_NPC_branch_enable_0,ex_NPC_branch_enable_1;

  assign pipeline_completed_insts_0 = {3'b0, ex_mem_valid_inst_0};
  assign pipeline_completed_insts_1 = {3'b0, ex_mem_valid_inst_1};
  assign pipeline_error_status =  (ex_mem_illegal_0 || ex_mem_illegal_1)? HALTED_ON_ILLEGAL :
				  (ROB_halt_out_0 || ROB_halt_out_1)? HALTED_ON_HALT :
				  NO_ERROR;

  assign pipeline_commit_wr_idx_0 = wb_reg_wr_idx_out_0;
  assign pipeline_commit_wr_data_0 = wb_reg_wr_data_out_0;
  assign pipeline_commit_wr_en_0 = wb_reg_wr_en_out_0;
  assign pipeline_commit_wr_idx_1 = wb_reg_wr_idx_out_1;
  assign pipeline_commit_wr_data_1 = wb_reg_wr_data_out_1;
  assign pipeline_commit_wr_en_1 = wb_reg_wr_en_out_1;
  assign pipeline_commit_NPC_0 = ex_mem_NPC_0;
  assign pipeline_commit_NPC_1 = ex_mem_NPC_1;

  assign proc2mem_command = (proc2Dmem_command == BUS_NONE) ? proc2Imem_command:proc2Dmem_command;
  assign proc2mem_addr = (proc2Dmem_command == BUS_NONE) ? proc2Imem_addr:proc2Dmem_addr;
  assign Dmem2proc_response = (proc2Dmem_command == BUS_NONE) ? 0 : mem2proc_response;
  assign Imem2proc_response = (proc2Dmem_command == BUS_NONE) ? mem2proc_response : 0;

  assign valid_wb_0 = free_PR_0;	//output for test delete finally
  assign valid_wb_1 = free_PR_1;	//output for test delete finally

  assign dcache_data_in[2] = mem2proc_data;

  // Actual cache (data and tag RAMs)
  cache cachememory (// inputs
    .clock(clock),
    .reset(reset),
    .wr1_en(Icache_wr_en),
    .wr1_idx(Icache_wr_idx),
    .wr1_tag(Icache_wr_tag),
    .wr1_data(mem2proc_data),

    .prefetch_rd_idx(prefetch_rd_idx),//
    .prefetch_rd_tag(prefetch_rd_tag),//
    .rd1_idx(Icache_rd_idx),
    .rd1_tag(Icache_rd_tag),

    // outputs
    .rd1_data(cachemem_data),
    .rd1_valid(cachemem_valid),
    .prefetch_rd_valid(prefetch_valid)//
  );

  // Cache controller
  icache icache_0(// inputs 
    .clock(clock),
    .reset(reset),

    .Imem2proc_response(Imem2proc_response),
    .Imem2proc_data(mem2proc_data),
    .Imem2proc_tag(mem2proc_tag),

    .proc2Icache_addr(proc2Icache_addr),
    .ex_mem_take_branch(recovery_request),
    .pre_target_PC(pre_target_PC),
    .br_sol_target(br_sol_target),
    .ex_mem_target_pc(if_recovery_NPC),	
    .cachemem_data(cachemem_data),
    .cachemem_valid(cachemem_valid),
    .prefetch_valid(prefetch_valid),//icache
    .structural_hazard(structural_hazard),

    // outputs
    .proc2Imem_command(proc2Imem_command),
    .proc2Imem_addr(proc2Imem_addr),

    .Icache_data_out(Icache_data_out),
    .Icache_valid_out(Icache_valid_out),
    .read_index(Icache_rd_idx),
    .read_tag(Icache_rd_tag),
    .current_index(prefetch_rd_idx),//
    .current_tag(prefetch_rd_tag),//
    .write_index(Icache_wr_idx),
    .write_tag(Icache_wr_tag),
    .data_write_enable(Icache_wr_en)
  );

//  assign br_sol_target = br_sol_0_pre||br_sol_1_pre;	//mispred

  //////////////////////////////////////////////////
  //                                              //
  //                  IF-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  assign structural_hazard = busy_SQ || busy_LQ || busy_RS || busy_ROB || recovery_busy;		// structural_hazard signal
  assign enable_dispatch = ~structural_hazard;			// no structural hazard
  if_stage if_stage_0 (
    // Inputs
    .clock (clock),
    .reset (reset),
    .ex_mem_take_branch(recovery_request),
    .ex_mem_target_pc(if_recovery_NPC),		// right NPC of br
    .Imem2proc_data(Icache_data_out),
    .Imem_valid(Icache_valid_out),
    .structural_hazard(structural_hazard),
    //.cachemem_valid(cachemem_valid),
    .pre_target_PC(pre_target_PC),
    .br_sol_target(br_sol_target),

    // Outputs
    .if_NPC_out_0(if_NPC_out_0), 		// Inst NPC
    .if_NPC_out_1(if_NPC_out_1), 
    .if_IR_out_0(if_IR_out_0_inter),			// Inst opcode
    .if_IR_out_1(if_IR_out_1_inter),
    .proc2Imem_addr(proc2Icache_addr),		// Inst Addr
    .if_valid_inst_out_0(if_valid_inst_out_0_inter),	// Inst valid when br to fix or no hazard & cachemiss
    .if_valid_inst_out_1(if_valid_inst_out_1_inter)
  );

  predecode_br predecode_br_0 (
    .clock(clock),
    .reset(reset),
    .insn_0(if_IR_out_0_inter),
    .insn_1(if_IR_out_1_inter),
    .valid_inst_in_0(if_valid_inst_out_0_inter),
    .valid_inst_in_1(if_valid_inst_out_1_inter),
    .ex_pc_idx(br_NPC),
    .target_pc(if_recovery_NPC),
    .if_pc_idx_0(if_NPC_out_0),
    .if_pc_idx_1(if_NPC_out_1),
    .btb_mispred(btb_wr_enable),
    .ex_br_valid(cond_wr_enable),
    .ex_br_res(tnt_wr),

    .insn_out_0(if_IR_out_0),
    .insn_out_1(if_IR_out_1),
    .target_sol(pre_target_PC),
    .br_sol_0(br_sol_0_pre),
    .br_sol_1(br_sol_1_pre),
    .valid_out_0(if_valid_inst_out_0),
    .valid_out_1(if_valid_inst_out_1),
    .ras_structural_hazard(ras_structural_hazard),
    .br_sol_target(br_sol_target)
);
  //////////////////////////////////////////////////
  //                                              //
  //            IF/ID Pipeline Register           //
  //                                              //
  //////////////////////////////////////////////////
  assign if_id_enable = enable_dispatch;

  // synopsys sync_set_reset "reset"
  // when recovery_request need to flush so push noop
  // when cache miss, push noop (!if_valid_inst_out_0 & !structural_hazard)
  // if_id_enable to hold inst when structural hazard
  always_ff @(posedge clock) begin
    if(reset || recovery_request || (!if_valid_inst_out_0 & !structural_hazard)) begin
      br_sol_0			<= `SD 0;
      if_id_pre_target_PC_0	<= `SD 0;
      if_id_NPC_0        	<= `SD 0;
      if_id_IR_0         	<= `SD `NOOP_INST;
      if_id_valid_inst_0 	<= `SD `FALSE;           
    end
    else if(!if_id_enable) begin
      br_sol_0			<= `SD br_sol_0;
      if_id_pre_target_PC_0	<= `SD if_id_pre_target_PC_0;
      if_id_NPC_0        	<= `SD if_id_NPC_0 ;
      if_id_IR_0         	<= `SD if_id_IR_0 ;
      if_id_valid_inst_0 	<= `SD if_id_valid_inst_0;          
    end
    else begin
      br_sol_0			<= `SD br_sol_0_pre;
      if_id_pre_target_PC_0	<= `SD pre_target_PC;
      if_id_NPC_0        	<= `SD if_NPC_out_0;
      if_id_IR_0         	<= `SD if_IR_out_0;
      if_id_valid_inst_0 	<= `SD if_valid_inst_out_0;   
    end
 
    if(reset ||recovery_request|| (!if_valid_inst_out_1 & !structural_hazard)) begin
      br_sol_1			<= `SD 0;
      if_id_pre_target_PC_1	<= `SD 0;
      if_id_NPC_1        	<= `SD 0;
      if_id_IR_1         	<= `SD `NOOP_INST;
      if_id_valid_inst_1 	<= `SD `FALSE;           
    end
    else if(!if_id_enable) begin  
      if_id_pre_target_PC_1	<= `SD if_id_pre_target_PC_1;
      br_sol_1			<= `SD br_sol_1;
      if_id_NPC_1        	<= `SD if_id_NPC_1;
      if_id_IR_1         	<= `SD if_id_IR_1 ;
      if_id_valid_inst_1 	<= `SD if_id_valid_inst_1;           
    end
    else begin
      br_sol_1			<= `SD br_sol_1_pre;
      if_id_pre_target_PC_1	<= `SD pre_target_PC;
      if_id_NPC_1        	<= `SD if_NPC_out_1;
      if_id_IR_1        	<= `SD if_IR_out_1;
      if_id_valid_inst_1 	<= `SD if_valid_inst_out_1;            
    end      
  end // always

   
  //////////////////////////////////////////////////
  //                                              //
  //                  ID-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  id_stage id_stage_0 (
    // Inputs
    .clock(clock),
    .reset(reset),
    .if_id_IR_0(if_id_IR_0),
    .if_id_valid_inst_0(if_id_valid_inst_0),
    .if_id_IR_1(if_id_IR_1),
    .if_id_valid_inst_1(if_id_valid_inst_1),

    // Outputs
    .id_opa_select_out_0(id_opa_select_out_0),
    .id_opb_select_out_0(id_opb_select_out_0),
    .id_dest_reg_idx_out_0(id_dest_reg_idx_out_0),
    .id_alu_func_out_0(id_alu_func_out_0),
    .id_rd_mem_out_0(id_rd_mem_out_0),
    .id_wr_mem_out_0(id_wr_mem_out_0),
    .id_ldl_mem_out_0(id_ldl_mem_out_0),
    .id_stc_mem_out_0(id_stc_mem_out_0),
    .id_cond_branch_out_0(id_cond_branch_out_0),
    .id_uncond_branch_out_0(id_uncond_branch_out_0),
    .id_halt_out_0(id_halt_out_0),
    .id_cpuid_out_0(id_cpuid_out_0),
    .id_illegal_out_0(id_illegal_out_0),
    .id_valid_inst_out_0(id_valid_inst_out_0),

    .ra_idx_0(id_ra_idx_0),
    .ra_idx_1(id_ra_idx_1),
    .rb_idx_0(id_rb_idx_0),
    .rb_idx_1(id_rb_idx_1),
    .rc_idx_0(id_rc_idx_0),
    .rc_idx_1(id_rc_idx_1),

    .id_opa_select_out_1(id_opa_select_out_1),
    .id_opb_select_out_1(id_opb_select_out_1),
    .id_dest_reg_idx_out_1(id_dest_reg_idx_out_1),
    .id_alu_func_out_1(id_alu_func_out_1),
    .id_rd_mem_out_1(id_rd_mem_out_1),
    .id_wr_mem_out_1(id_wr_mem_out_1),
    .id_ldl_mem_out_1(id_ldl_mem_out_1),
    .id_stc_mem_out_1(id_stc_mem_out_1),
    .id_cond_branch_out_1(id_cond_branch_out_1),
    .id_uncond_branch_out_1(id_uncond_branch_out_1),
    .id_halt_out_1(id_halt_out_1),
    .id_cpuid_out_1(id_cpuid_out_1),
    .id_illegal_out_1(id_illegal_out_1),
    .id_valid_inst_out_1(id_valid_inst_out_1)
  );

  assign is_0_br = (!recovery_request && id_valid_inst_out_0 && !structural_hazard && (id_cond_branch_out_0 || id_uncond_branch_out_0));
  assign is_1_br = (!recovery_request && id_valid_inst_out_1 && !structural_hazard && (id_cond_branch_out_1 || id_uncond_branch_out_1));

  assign fetch_PR_0 = id_valid_inst_out_0 && enable_dispatch && !recovery_request;
  assign fetch_PR_1 = id_valid_inst_out_1 && enable_dispatch && !recovery_request;

  Freelist Freelist_0 (
    .clock(clock),
    .reset(reset),
    .Told_out_0(rt_Told_out_0),
    .Told_out_1(rt_Told_out_1),
    .free_PR_0(free_PR_0),
    .free_PR_1(free_PR_1),
    .fetch_PR_0(fetch_PR_0),
    .fetch_PR_1(fetch_PR_1),

    .is_0_br(is_0_br),
    .recovery_br(recovery_request),
    .recovery_empty(recovery_empty_freelist),
    .recovery_pointer(recovery_pointer_freelist),
    .recovery_tag_table(recovery_tag_table_freelist),

    .tag_table_br(tag_table_br_freelist),
    .empty_br(empty_br_freelist),
    .pointer_br(pointer_br_freelist),

    .Tnew_out_0(free_list_in_0),
    .Tnew_out_1(free_list_in_1)
  );

  assign maptable_T1_idx_0 = ((id_opa_select_out_0 != ALU_OPA_IS_REGA)&&(id_opa_select_out_0 != ALU_OPA_IS_NPC)&& (id_opa_select_out_0 !=ALU_OPA_IS_MEM_DISP)) ? `ZERO_REG : id_ra_idx_0;
  assign maptable_T2_idx_0 = (id_opb_select_out_0 != ALU_OPB_IS_REGB) ? `ZERO_REG : id_rb_idx_0;
  assign maptable_T1_idx_1 = ((id_opa_select_out_1 != ALU_OPA_IS_REGA)&&(id_opa_select_out_1 != ALU_OPA_IS_NPC)&& (id_opa_select_out_1 !=ALU_OPA_IS_MEM_DISP)) ? `ZERO_REG : id_ra_idx_1;
  assign maptable_T2_idx_1 = (id_opb_select_out_1 != ALU_OPB_IS_REGB) ? `ZERO_REG : id_rb_idx_1;

  assign snapshot_enable = (is_0_br || is_1_br);

  recovery recovery_0 (
    .rt_Tnew_out0(rt_Tnew_out_0),
    .rt_Tnew_out1(rt_Tnew_out_1),
    .rt_valid_0(free_PR_0),
    .rt_valid_1(free_PR_1),


    .clock(clock),
    .reset(reset),
    .dest_reg_tail_shot(dest_reg_tail_shot),
    .empty_shot(empty_shot),
    .CDB_in_0(CDB_in_0),
    .CDB_in_1(CDB_in_1),
    .free_PR_0(free_PR_0),
    .free_PR_1(free_PR_1),
    .Told_free_0(rt_Told_out_0),
    .Told_free_1(rt_Told_out_1),
    .snapshot_enable(snapshot_enable),
    .map_tag_table(Tag_table_br),
    .map_ready_table(ready_table_br),
    .ROB_tail(tail_pointer),
    .freelist_tag(tag_table_br_freelist),
    .freelist_pointer(pointer_br_freelist),
    .freelist_empty(empty_br_freelist),
    .br_correct(br_correct),
    .br_correct_address(br_correct_address),
    .recovery_request(recovery_request),///////from EX-mem stage
    .recovery_mask(recovery_b_mask),///////from EX-mem stage
    .SQ_tail(SQ_tail),

    .map_tag_table_out(recovery_Tag_table),
    .map_ready_table_out(recovery_ready_table),
    .ROB_tail_out(recovery_tail),
    .freelist_tag_out(recovery_tag_table_freelist),
    .freelist_pointer_out(recovery_pointer_freelist),
    .freelist_empty_out(recovery_empty_freelist),
    .b_mask_out(b_mask_out),
    .space_address(space_address),
    .recovery_busy(recovery_busy),
    .SQ_tail_out(SQ_tail_out),
    .SQ_empty_recovery(SQ_empty_recovery)
  );

  Maptable Maptable_0 (
    .clock(clock),
    .reset(reset),
    .is_0_br(is_0_br),
    .recovery_br(recovery_request),///////from EX-mem stage
    .recovery_ready_table(recovery_ready_table),
    .recovery_Tag_table(recovery_Tag_table),
    .T1_index_0(maptable_T1_idx_0),
    .T1_index_1(maptable_T1_idx_1),
    .T2_index_0(maptable_T2_idx_0),
    .T2_index_1(maptable_T2_idx_1),
    .T_old_index_0(id_dest_reg_idx_out_0),
    .T_old_index_1(id_dest_reg_idx_out_1),
    .free_list_in_0(free_list_in_0),
    .free_list_in_1(free_list_in_1),
    .CDB_in_0(CDB_in_0),
    .CDB_in_1(CDB_in_1),
    .fetch_PR_0(fetch_PR_0),
    .fetch_PR_1(fetch_PR_1),
    .ready_table_br_next(ready_table_br),
    .Tag_table_br(Tag_table_br),
    .T_old_0(T_old_0),		// T_old for ROB
    .T_old_1(T_old_1),		//
    .map_table_T1_out_0(map_table_T1_out_0),	// T1 tag for RS
    .map_table_T1_out_1(map_table_T1_out_1),	//
    .map_table_T2_out_0(map_table_T2_out_0),	// T2 tag for RS
    .map_table_T2_out_1(map_table_T2_out_1),	//
    .map_table_T_out(map_table_T_out),	// the first T tag (for fixing RAW)
    .map_table_T1_ready_in_0(map_table_T1_ready_in_0),			// + for T1's tag in RS
    .map_table_T1_ready_in_1(map_table_T1_ready_in_1),
    .map_table_T2_ready_in_0(map_table_T2_ready_in_0),			// + for T2's tag in RS
    .map_table_T2_ready_in_1(map_table_T2_ready_in_1)	
  ); 

    assign b_mask_RS_1 = b_mask_out;
    always_comb begin
        b_mask_RS_0 = b_mask_out;
        if (is_1_br==1) begin
            b_mask_RS_0[space_address]=0;
        end
    end

  RS RS_0 (
    .br_is_on_ex(br_is_on_ex),
    .pre_target_PC_in_0(if_id_pre_target_PC_0),
    .pre_target_PC_in_1(if_id_pre_target_PC_1),
    .br_sol_0(br_sol_0),			//from predecode_br
    .br_sol_1(br_sol_1),			//from predecode_br
    .recovery_request(recovery_request),	//from EX-mem stage
    .recovery_b_mask(recovery_b_mask),		//from EX-mem stage
    .br_correct(br_correct),			//from EX-mem stage
    .br_correct_address(br_correct_address),
    .b_mask_in_0(b_mask_RS_0),			//from BP reovery
    .b_mask_in_1(b_mask_RS_1),			//from BP reovery
    .clock(clock),
    .reset(reset),
    .dispatch_enable_0(fetch_PR_0),
    .dispatch_enable_1(fetch_PR_1),
    .is_br_0(is_0_br),
    .is_br_1(is_1_br),
    .issue_enable_0(id_ex_enable_0), .issue_enable_1(id_ex_enable_1),
    .if_id_NPC_0(if_id_NPC_0), .if_id_NPC_1(if_id_NPC_1),
    .free_list_in_0(free_list_in_0), .free_list_in_1(free_list_in_1), 
    .CDB_in_0(CDB_in_0), .CDB_in_1(CDB_in_1), 
    .map_table_T1_in_0(map_table_T1_out_0), .map_table_T1_in_1(map_table_T1_out_1), 
    .map_table_T2_in_0(map_table_T2_out_0), .map_table_T2_in_1(map_table_T2_out_1), 
    .map_table_T_in(map_table_T_out), 
    .map_table_T1_ready_in_0(map_table_T1_ready_in_0), .map_table_T1_ready_in_1(map_table_T1_ready_in_1), 
    .map_table_T2_ready_in_0(map_table_T2_ready_in_0), .map_table_T2_ready_in_1(map_table_T2_ready_in_1),
    .INSTR_in_0(if_id_IR_0), .INSTR_in_1(if_id_IR_1), 
    .func_in_0(id_alu_func_out_0), .func_in_1(id_alu_func_out_1), 
    .opa_select_in_0(id_opa_select_out_0),.opa_select_in_1(id_opa_select_out_1), 
    .opb_select_in_0(id_opb_select_out_0),.opb_select_in_1(id_opb_select_out_1), 
    .rd_mem_in_0(id_rd_mem_out_0), .rd_mem_in_1(id_rd_mem_out_1),
    .wr_mem_in_0(id_wr_mem_out_0), .wr_mem_in_1(id_wr_mem_out_1),
    .ldl_mem_in_0(id_ldl_mem_out_0), .ldl_mem_in_1(id_ldl_mem_out_1),
    .stc_mem_in_0(id_stc_mem_out_0), .stc_mem_in_1(id_stc_mem_out_1), 
    .cond_branch_in_0(id_cond_branch_out_0), .cond_branch_in_1(id_cond_branch_out_1), 
    .uncond_branch_in_0(id_uncond_branch_out_0), .uncond_branch_in_1(id_uncond_branch_out_1),
    .halt_in_0(id_halt_out_0),.halt_in_1(id_halt_out_1), 
    .cpuid_in_0(id_cpuid_out_0), .cpuid_in_1(id_cpuid_out_1),
    .illegal_in_0(id_illegal_out_0),.illegal_in_1(id_illegal_out_1),
    .valid_inst_in_0(id_valid_inst_out_0),.valid_inst_in_1(id_valid_inst_out_1),
    


//output
    .pre_target_PC_out_0(id_pre_target_PC_0),
    .pre_target_PC_out_1(id_pre_target_PC_1),
    .br_sol_out_0(id_br_sol_out_0),
    .br_sol_out_1(id_br_sol_out_1),
    .b_mask_out_0(id_b_mask_out_0),
    .b_mask_out_1(id_b_mask_out_1),
    .id_NPC_out_0(id_NPC_out_0), .id_NPC_out_1(id_NPC_out_1),
    .T1_out_0(T1_out_0), .T1_out_1(T1_out_1),
    .T2_out_0(T2_out_0), .T2_out_1(T2_out_1),
    .T_out_0(T_out_0), .T_out_1(T_out_1),
    .INSTR_out_0(INSTR_out_0), .INSTR_out_1(INSTR_out_1),
    .busy_out(busy_RS),
    .func_out_0(func_out_0),.func_out_1(func_out_1), 
    .opa_select_out_0(opa_select_out_0), .opa_select_out_1(opa_select_out_1),
    .opb_select_out_0(opb_select_out_0), .opb_select_out_1(opb_select_out_1),
    .rd_mem_out_0(rd_mem_out_0), .rd_mem_out_1(rd_mem_out_1),
    .wr_mem_out_0(wr_mem_out_0), .wr_mem_out_1(wr_mem_out_1), 
    .ldl_mem_out_0(ldl_mem_out_0), .ldl_mem_out_1(ldl_mem_out_1),
    .stc_mem_out_0(stc_mem_out_0), .stc_mem_out_1(stc_mem_out_1),
    .cond_branch_out_0(cond_branch_out_0), .cond_branch_out_1(cond_branch_out_1),
    .uncond_branch_out_0(uncond_branch_out_0),.uncond_branch_out_1(uncond_branch_out_1),
    .halt_out_0(halt_out_0), .halt_out_1(halt_out_1),
    .cpuid_out_0(cpuid_out_0), .cpuid_out_1(cpuid_out_1),
    .illegal_out_0(illegal_out_0),.illegal_out_1(illegal_out_1),
    .valid_inst_out_0(valid_inst_out_0), .valid_inst_out_1(valid_inst_out_1)
  );


//ROB
  ROB ROB_0 (
    .clock(clock),
    .reset(reset),
    .is_0_br(is_0_br),
    .recovery_br(recovery_request),///////from EX-mem stage
    .recovery_tail(recovery_tail),
    .freelist_0(free_list_in_0), .freelist_1(free_list_in_1),
    .CDB_in_0(CDB_in_0), .CDB_in_1(CDB_in_1),
    .map_table_Told_in_0(T_old_0),
    .map_table_Told_in_1(T_old_1),
    .fetch_PR_0(fetch_PR_0),
    .fetch_PR_1(fetch_PR_1),
    .ROB_halt_in_0(id_halt_out_0),
    .ROB_halt_in_1(id_halt_out_1),
    .is_0_st(id_wr_mem_out_0),
    .is_1_st(id_wr_mem_out_1),
//Output
    .tail_pointer(tail_pointer),
    .busy(busy_ROB),
    .rt_valid_0(free_PR_0),
    .rt_valid_1(free_PR_1),
    .Told_out_0(rt_Told_out_0), .Told_out_1(rt_Told_out_1),
    .Tnew_out_0(rt_Tnew_out_0), .Tnew_out_1(rt_Tnew_out_1),
    .ROB_halt_out_0(ROB_halt_out_0),.ROB_halt_out_1(ROB_halt_out_1)
  );


  //RF
  Regfile RF_0 (
    .rda_idx_0(T1_out_0),
    .rda_out_0(id_ra_value_out_0), 
    .rda_idx_1(T1_out_1),
    .rda_out_1(id_ra_value_out_1),

    .rdb_idx_0(T2_out_0),
    .rdb_out_0(id_rb_value_out_0),
    .rdb_idx_1(T2_out_1),
    .rdb_out_1(id_rb_value_out_1),


    .value_RF(rf_value_out),	//output for test delete finally

    .wr_clk(clock),
    .wr_en_0(wb_reg_wr_en_out_0),
    .wr_idx_0(wb_reg_wr_idx_out_0),
    .wr_data_0(wb_reg_wr_data_out_0),
    .wr_en_1(wb_reg_wr_en_out_1),
    .wr_idx_1(wb_reg_wr_idx_out_1),
    .wr_data_1(wb_reg_wr_data_out_1)
  );

  LSQ LSQ_0(
//input
	.LQ_issue_pos_0(LQ_issue_pos_0),
	.LQ_issue_pos_1(LQ_issue_pos_1),
	.clock(clock),
	.reset(reset),

	.is_0_br(is_0_br),
	.recovery_tail(SQ_tail_out),
	.b_mask_in_0(b_mask_RS_0),
	.b_mask_in_1(b_mask_RS_1),
	.recovery_request(recovery_request),
	.br_correct(br_correct),
	.br_correct_address(br_correct_address),
	.recovery_b_mask(recovery_b_mask),
	.SQ_empty_recovery(SQ_empty_recovery),

	.tail_pointer(SQ_tail),
	
	.id_wr_mem_in({id_wr_mem_out_1, id_wr_mem_out_0}),
	.id_rd_mem_in({id_rd_mem_out_1, id_rd_mem_out_0}),
	.dispatch_en_in({fetch_PR_1, fetch_PR_0}),
	.freelist_pr_in({free_list_in_1, free_list_in_0}),

	.EX_data_in({id_ex_rega_1, id_ex_rega_0}),				///
	.EX_LQ_addr_in({ex_LQ_addr_1, ex_LQ_addr_0}),
	.EX_SQ_addr_in({ex_alu_result_out_1, ex_alu_result_out_0}),		///
	.EX_LQ_dest_reg_in({id_ex_dest_reg_idx_1, id_ex_dest_reg_idx_0}),
	.EX_SQ_dest_reg_in({id_ex_dest_reg_idx_1, id_ex_dest_reg_idx_0}),		///
	.EX_mem_rd_valid_in({id_ex_rd_mem_1, id_ex_rd_mem_0}),
	.EX_mem_wr_valid_in({SQ_valid_1, SQ_valid_0}),
	.ROB_dest_in({rt_Tnew_out_1, rt_Tnew_out_0}),.rt_ready({free_PR_1, free_PR_0}),
	.dcache_data_ready_in(dcache_data_ready_in),// 3-way for dcache [2:0] 0, 1 from dcache hit, 2 from dcache miss
	.dcache_load_index_in(dcache_load_index_in),// 1 index due to dcache miss
	.dcache_data_in(dcache_data_in),//  3-way for dcache [2:0] 0, 1 from dcache hit, 2 from dcache miss
	.Mult_issue_enable({~mult_done_1, ~mult_done_0}),
//TO DO
	.SQ_busy_out(busy_SQ),
	.LQ_busy_out(busy_LQ),
	.SQ_dcache_Data_out(proc2mem_data),// for dcache
	.SQ_dcache_address_out(SQ_dcache_address_out),// for dcache
	.SQ_dcache_Data_en_out(SQ_dcache_Data_en_out),// for dcache
	
	.LQ_dcache_fetch_address_out(LQ_dcache_fetch_address_out),// for dcache
	.LQ_dcache_fetch_index_out(LQ_dcache_fetch_index_out),// for dcache
	.LQ_dcache_fetch_en(LQ_dcache_fetch_en),// for dcache
	.LQ_data_out(LQ_data),
	.LQ_dest_reg_out(LQ_dest_reg),
	.LQ_issued_out(LQ_issued),
	.b_mask_to_dcache(b_mask_to_dcache),
	.empty_shot(empty_shot),
	.dest_reg_tail_shot(dest_reg_tail_shot)

	);

	assign SQ_valid_0 = ex_stall_sol_0? 1'b0 : id_ex_wr_mem_0;
	assign SQ_valid_1 = ex_stall_sol_1? 1'b0 : id_ex_wr_mem_1;


  // Note: Decode signals for load-lock/store-conditional and "get CPU ID"
  //  instructions (id_{ldl,stc}_mem_out, id_cpuid_out) are not connected
  //  to anything because the provided EX and MEM stages do not implement
  //  these instructions.  You will have to implement these instructions
  //  if you plan to do a multicore project.

  //////////////////////////////////////////////////
  //                                              //
  //            ID/EX Pipeline Register           //
  //                                              //
  //////////////////////////////////////////////////
  assign ex_stall_sol_0 = (ex_stall_0 && !id_ex_rd_mem_0) || (LQ_issued[0] && !mult_enable_0 && !id_ex_rd_mem_0);
  assign ex_stall_sol_1 = (ex_stall_1 && !id_ex_rd_mem_1) || (LQ_issued[1] && !mult_enable_1 && !id_ex_rd_mem_1);
  assign id_ex_enable_0 = ~ex_stall_sol_0 || flush_id_ex_0; 
  assign id_ex_enable_1 = ~ex_stall_sol_1 || flush_id_ex_1;

  always_comb begin
	id_b_mask_correct_0 = id_ex_b_mask_out_0;
	id_b_mask_correct_1 = id_ex_b_mask_out_1;
	flush_id_ex_0 = 1'b0;
	flush_id_ex_1 = 1'b0;
	if (recovery_request) begin
		for (int i = 0; i < `N_ENTRY_RS; i++) begin
			if (id_ex_b_mask_out_0 >= recovery_b_mask) begin
				flush_id_ex_0 = 1'b1;
			end
			if (id_ex_b_mask_out_1 >= recovery_b_mask) begin
				flush_id_ex_1 = 1'b1;
			end
		end
	end
	else if(br_correct) begin
		id_b_mask_correct_0[br_correct_address]=0;
		id_b_mask_correct_1[br_correct_address]=0;

	end
  end

  assign br_is_on_0 = (id_ex_cond_branch_0||id_ex_uncond_branch_0)&&((mult_done_0==1)||LQ_issued[0]);
  assign br_is_on_1 = (id_ex_cond_branch_1||id_ex_uncond_branch_1)&&((mult_done_1==1)||LQ_issued[1]);
  assign br_is_on_ex = br_is_on_0||br_is_on_1;
  // synopsys sync_set_reset "reset"
  always_ff @(posedge clock) begin
    if (reset) begin
      id_ex_pre_target_PC_0 <= `SD 0;
      id_ex_br_sol_out_0    <= `SD 0;
      id_ex_b_mask_out_0    <= `SD 0;
      id_ex_NPC_0           <= `SD 0;
      id_ex_IR_0            <= `SD `NOOP_INST;
      id_ex_rega_0          <= `SD 0;
      id_ex_regb_0          <= `SD 0;
      id_ex_opa_select_0    <= `SD ALU_OPA_IS_REGA;
      id_ex_opb_select_0    <= `SD ALU_OPB_IS_REGB;
      id_ex_dest_reg_idx_0  <= `SD `ZERO_REG;
      id_ex_alu_func_0      <= `SD ALU_ADDQ;
      id_ex_rd_mem_0        <= `SD 0;
      id_ex_wr_mem_0        <= `SD 0;
      id_ex_cond_branch_0   <= `SD 0;
      id_ex_uncond_branch_0 <= `SD 0;
      id_ex_halt_0          <= `SD 0;
      id_ex_illegal_0       <= `SD 0;
      id_ex_valid_inst_0    <= `SD 0;
     end else  // if (reset)
     if (id_ex_enable_0) begin
        id_ex_pre_target_PC_0 <= `SD id_pre_target_PC_0;
        id_ex_br_sol_out_0    <= `SD id_br_sol_out_0;
        id_ex_b_mask_out_0    <= `SD id_b_mask_out_0;
        id_ex_NPC_0           <= `SD id_NPC_out_0;
        id_ex_IR_0            <= `SD INSTR_out_0;
        id_ex_rega_0          <= `SD id_ra_value_out_0;
        id_ex_regb_0          <= `SD id_rb_value_out_0;
        id_ex_opa_select_0    <= `SD opa_select_out_0;
        id_ex_opb_select_0    <= `SD opb_select_out_0;
        id_ex_dest_reg_idx_0  <= `SD T_out_0;
        id_ex_alu_func_0      <= `SD func_out_0;
        id_ex_rd_mem_0        <= `SD rd_mem_out_0;
        id_ex_wr_mem_0        <= `SD wr_mem_out_0;
        id_ex_cond_branch_0   <= `SD cond_branch_out_0;
        id_ex_uncond_branch_0 <= `SD uncond_branch_out_0;
        id_ex_halt_0          <= `SD halt_out_0;
        id_ex_illegal_0       <= `SD illegal_out_0;
        id_ex_valid_inst_0    <= `SD valid_inst_out_0;
      end
	else begin
	id_ex_b_mask_out_0 <= id_b_mask_correct_0;
	end

    if (reset) begin
      id_ex_pre_target_PC_1 <= `SD 0;
      id_ex_br_sol_out_1    <= `SD 0;
      id_ex_b_mask_out_1    <= `SD 0;
      id_ex_NPC_1           <= `SD 0;
      id_ex_IR_1            <= `SD `NOOP_INST;
      id_ex_rega_1          <= `SD 0;
      id_ex_regb_1          <= `SD 0;
      id_ex_opa_select_1    <= `SD ALU_OPA_IS_REGA;
      id_ex_opb_select_1    <= `SD ALU_OPB_IS_REGB;
      id_ex_dest_reg_idx_1  <= `SD `ZERO_REG;
      id_ex_alu_func_1      <= `SD ALU_ADDQ;
      id_ex_rd_mem_1        <= `SD 0;
      id_ex_wr_mem_1        <= `SD 0;
      id_ex_cond_branch_1   <= `SD 0;
      id_ex_uncond_branch_1 <= `SD 0;
      id_ex_halt_1          <= `SD 0;
      id_ex_illegal_1       <= `SD 0;
      id_ex_valid_inst_1    <= `SD 0;
    end else // if (reset)
    if(id_ex_enable_1) begin	
        id_ex_pre_target_PC_1 <= `SD id_pre_target_PC_1;
        id_ex_br_sol_out_1    <= `SD id_br_sol_out_1;
        id_ex_b_mask_out_1    <= `SD id_b_mask_out_1;		
        id_ex_NPC_1           <= `SD id_NPC_out_1;
        id_ex_IR_1            <= `SD INSTR_out_1;
        id_ex_rega_1          <= `SD id_ra_value_out_1;
        id_ex_regb_1          <= `SD id_rb_value_out_1;
        id_ex_opa_select_1    <= `SD opa_select_out_1;
        id_ex_opb_select_1    <= `SD opb_select_out_1;
        id_ex_dest_reg_idx_1  <= `SD T_out_1;
        id_ex_alu_func_1      <= `SD func_out_1;
        id_ex_rd_mem_1        <= `SD rd_mem_out_1;
        id_ex_wr_mem_1        <= `SD wr_mem_out_1;
        id_ex_cond_branch_1   <= `SD cond_branch_out_1;
        id_ex_uncond_branch_1 <= `SD uncond_branch_out_1;
        id_ex_halt_1          <= `SD halt_out_1;
        id_ex_illegal_1       <= `SD illegal_out_1;
        id_ex_valid_inst_1    <= `SD valid_inst_out_1;
      // if
    end 
    else begin
	id_ex_b_mask_out_1 <= id_b_mask_correct_1;
    end
  end // always


  //////////////////////////////////////////////////
  //                                              //
  //                  EX-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  ex_stage ex_stage_0 (
    // Inputs
    .clock(clock),
    .reset(reset),
    .recovery_request(recovery_request),///////from complete stage
    .recovery_b_mask(recovery_b_mask),///////from complete stage
    .br_correct(br_correct),///////from complete stage
    .br_correct_address(br_correct_address),
    .id_ex_pre_target_PC_0(id_ex_pre_target_PC_0),
    .id_ex_b_mask_out_0(id_ex_b_mask_out_0),
    .id_ex_br_sol_out_0(id_ex_br_sol_out_0),
    .id_ex_NPC_0(id_ex_NPC_0), 
    .id_ex_IR_0(id_ex_IR_0),
    .id_ex_rega_0(id_ex_rega_0),
    .id_ex_regb_0(id_ex_regb_0),
    .id_ex_opa_select_0(id_ex_opa_select_0),
    .id_ex_opb_select_0(id_ex_opb_select_0),
    .id_ex_alu_func_0(id_ex_alu_func_0),
    .id_ex_cond_branch_0(id_ex_cond_branch_0),
    .id_ex_uncond_branch_0(id_ex_uncond_branch_0),
    .id_ex_pre_target_PC_1(id_ex_pre_target_PC_1),
    .id_ex_b_mask_out_1(id_ex_b_mask_out_1),
    .id_ex_br_sol_out_1(id_ex_br_sol_out_1),
    .id_ex_NPC_1(id_ex_NPC_1), 
    .id_ex_IR_1(id_ex_IR_1),
    .id_ex_rega_1(id_ex_rega_1),
    .id_ex_regb_1(id_ex_regb_1),
    .id_ex_opa_select_1(id_ex_opa_select_1),
    .id_ex_opb_select_1(id_ex_opb_select_1),
    .id_ex_alu_func_1(id_ex_alu_func_1),
    .id_ex_cond_branch_1(id_ex_cond_branch_1),
    .id_ex_uncond_branch_1(id_ex_uncond_branch_1),
    .id_ex_dest_reg_idx_0(id_ex_dest_reg_idx_0),
    .id_ex_dest_reg_idx_1(id_ex_dest_reg_idx_1),

    // Outputs
    .alu_flush_0(alu_flush_0),
    .alu_flush_1(alu_flush_1),///////from EX stage
    .recovery_b_mask_to_com(recovery_b_mask_to_com),///////from EX stage
    .br_correct_to_com_0(br_correct_to_com_0),///////from EX stage
    .br_correct_to_com_1(br_correct_to_com_1),
    .done_0(mult_done_0),
    .done_1(mult_done_1), 
    .mult_enable_0(mult_enable_0), 
    .mult_enable_1(mult_enable_1), 
    .ex_stall_0(ex_stall_0), 
    .ex_stall_1(ex_stall_1),
    .id_ex_NPC_next_0(id_ex_NPC_next_0), 
    .id_ex_NPC_next_1(id_ex_NPC_next_1),
    .id_ex_IR_next_0(id_ex_IR_next_0), 
    .id_ex_IR_next_1(id_ex_IR_next_1),
    .id_ex_dest_reg_idx_next_0(id_ex_dest_reg_idx_next_0), 
    .id_ex_dest_reg_idx_next_1(id_ex_dest_reg_idx_next_1), 
    .ex_alu_result_out_0(ex_alu_result_out_0),
    .ex_take_branch_out_0(ex_take_branch_out_0),
    .ex_alu_result_out_1(ex_alu_result_out_1),
    .ex_take_branch_out_1(ex_take_branch_out_1),
    .btb_mispred_0(btb_mispred_0),
    .btb_mispred_1(btb_mispred_1),

    .ex_NPC_branch_enable_0(ex_NPC_branch_enable_0),
    .ex_NPC_branch_enable_1(ex_NPC_branch_enable_1),
    .ex_target_result_0(ex_target_result_0),
    .ex_target_result_1(ex_target_result_1),  //target
    .ex_LQ_addr_0(ex_LQ_addr_0),
    .ex_LQ_addr_1(ex_LQ_addr_1)
  );

  assign cond_wr_enable = ex_mem_cond_branch_0||ex_mem_cond_branch_1;
  assign btb_wr_enable = ex_mem_btb_mispred_0||ex_mem_btb_mispred_1;
  assign tnt_wr = ex_mem_take_branch_0||ex_mem_take_branch_1;
  assign br_correct = br_correct_0||br_correct_1;
  assign br_NPC = ex_mem_cond_branch_0 ? ex_mem_NPC_0 : ex_mem_NPC_1;
  //////////////////////////////////////////////////
  //                                              //
  //           EX/COMPLETE Pipeline Register      //
  //                                              //
  //////////////////////////////////////////////////
  // synopsys sync_set_reset "reset"
  always_ff @(posedge clock) begin
    if (reset) begin
      ex_mem_cond_branch_0  <= `SD 0;
      ex_mem_btb_mispred_0  <= `SD 0;
      recovery_b_mask       <= `SD 0;
      br_correct_0          <= `SD 0;
      ex_mem_NPC_0          <= `SD 0;
      ex_mem_IR_0          <= `SD `NOOP_INST;
      ex_mem_dest_reg_idx_0 <= `SD `ZERO_REG;
      ex_mem_illegal_0      <= `SD 0;
      ex_mem_valid_inst_0   <= `SD 0;
      ex_mem_alu_result_0   <= `SD 0;
      ex_mem_take_branch_0  <= `SD 0;
      ex_mem_btb_mispred_1  <= `SD 0;
      ex_mem_cond_branch_1  <= `SD 0;
      br_correct_1          <= `SD 0;
      ex_mem_NPC_1          <= `SD 0;
      ex_mem_IR_1           <= `SD `NOOP_INST;
      ex_mem_dest_reg_idx_1 <= `SD `ZERO_REG;
      ex_mem_illegal_1      <= `SD 0;
      ex_mem_valid_inst_1   <= `SD 0;
      ex_mem_alu_result_1   <= `SD 0;
      ex_mem_take_branch_1  <= `SD 0;
      ex_mem_NPC_branch_enable_0 <= `SD 0;
      ex_mem_NPC_branch_enable_1 <= `SD 0;
      ex_mem_target_result_0	 <= `SD 0;
      ex_mem_target_result_1	 <= `SD 0;
    end else begin // else: !if(reset)
        recovery_b_mask       <= `SD recovery_b_mask_to_com;
        casex({mult_done_0, LQ_issued[0], mult_enable_0 || alu_flush_0, id_ex_rd_mem_0})
		4'b1???: begin
			ex_mem_NPC_0          <= `SD id_ex_NPC_next_0;
			ex_mem_IR_0           <= `SD id_ex_IR_next_0;
			ex_mem_dest_reg_idx_0 <= `SD id_ex_dest_reg_idx_next_0;
			ex_mem_illegal_0      <= `SD 0;
			ex_mem_valid_inst_0   <= `SD 1;
			ex_mem_alu_result_0   <= `SD ex_alu_result_out_0;
			ex_mem_take_branch_0  <= `SD 0;	
			ex_mem_NPC_branch_enable_0 <= `SD 0;
			ex_mem_btb_mispred_0	     <= `SD 0;
			br_correct_0      	<= `SD 0; 
			ex_mem_cond_branch_0  <= `SD 0;
			ex_mem_target_result_0     <= `SD 0;
		end

		4'b01??: begin
			ex_mem_NPC_0          <= `SD 0;
			ex_mem_IR_0           <= `SD 0;
			ex_mem_dest_reg_idx_0 <= `SD LQ_dest_reg[0];
			ex_mem_illegal_0      <= `SD 0;
			ex_mem_valid_inst_0   <= `SD 1;
			ex_mem_alu_result_0   <= `SD LQ_data[0];	//////
			ex_mem_take_branch_0  <= `SD 0;	//////
			ex_mem_NPC_branch_enable_0 <= `SD 0;
			ex_mem_btb_mispred_0	     <= `SD 0;
			br_correct_0      	<= `SD 0; 
			ex_mem_cond_branch_0  <= `SD 0;
			ex_mem_target_result_0     <= `SD 0;	
		end

		4'b0001: begin
			ex_mem_NPC_0          <= `SD 0;
			ex_mem_IR_0          <= `SD `NOOP_INST;
			ex_mem_dest_reg_idx_0 <= `SD `ZERO_REG;
			ex_mem_illegal_0      <= `SD 0;
			ex_mem_valid_inst_0   <= `SD 0;
			ex_mem_alu_result_0   <= `SD 0;
			ex_mem_take_branch_0  <= `SD 0; 
			ex_mem_NPC_branch_enable_0 <= `SD 0;
			ex_mem_btb_mispred_0	     <= `SD 0;
			br_correct_0      	<= `SD 0;
			ex_mem_cond_branch_0  <= `SD 0;
			ex_mem_target_result_0     <= `SD 0;
		end
		4'b0000: begin
			ex_mem_NPC_0          <= `SD id_ex_NPC_0;
			ex_mem_IR_0           <= `SD id_ex_IR_0;
			ex_mem_dest_reg_idx_0 <= `SD id_ex_dest_reg_idx_0;
			ex_mem_illegal_0      <= `SD id_ex_illegal_0;
			ex_mem_valid_inst_0   <= `SD id_ex_valid_inst_0;
			ex_mem_alu_result_0   <= `SD ex_alu_result_out_0;
			ex_mem_take_branch_0  <= `SD ex_take_branch_out_0;
			ex_mem_NPC_branch_enable_0 <= `SD ex_NPC_branch_enable_0;
			ex_mem_btb_mispred_0	     <= `SD btb_mispred_0;
			br_correct_0      	<= `SD br_correct_to_com_0;
			ex_mem_cond_branch_0  <= `SD id_ex_cond_branch_0;
			ex_mem_target_result_0     <= `SD ex_target_result_0;
		end
		4'b001?: begin
			ex_mem_NPC_0          <= `SD 0;
			ex_mem_IR_0          <= `SD `NOOP_INST;
			ex_mem_dest_reg_idx_0 <= `SD `ZERO_REG;
			ex_mem_illegal_0      <= `SD 0;
			ex_mem_valid_inst_0   <= `SD 0;
			ex_mem_alu_result_0   <= `SD 0;
			ex_mem_take_branch_0  <= `SD 0; 
			ex_mem_NPC_branch_enable_0 <= `SD 0;
			ex_mem_btb_mispred_0	     <= `SD 0;
			br_correct_0      	<= `SD 0;
			ex_mem_cond_branch_0  <= `SD 0;
			ex_mem_target_result_0     <= `SD 0;
		end
	endcase

	casex({mult_done_1, LQ_issued[1], mult_enable_1||alu_flush_1, id_ex_rd_mem_1})
		4'b1???: begin
			ex_mem_NPC_1          <= `SD id_ex_NPC_next_1;
			ex_mem_IR_1           <= `SD id_ex_IR_next_1;
			ex_mem_dest_reg_idx_1 <= `SD id_ex_dest_reg_idx_next_1;
			ex_mem_illegal_1      <= `SD 0;
			ex_mem_valid_inst_1   <= `SD 1;
			ex_mem_alu_result_1   <= `SD ex_alu_result_out_1;
			ex_mem_take_branch_1  <= `SD 0;
			ex_mem_NPC_branch_enable_1 <= `SD 0;
			ex_mem_btb_mispred_1	     <= `SD 0;
			br_correct_1      	<= `SD 0;
			ex_mem_cond_branch_1  <= `SD 0;
			ex_mem_target_result_1     <= `SD 0;
		end
		4'b01??: begin
			ex_mem_NPC_1          <= `SD 0;
			ex_mem_IR_1           <= `SD 0;
			ex_mem_dest_reg_idx_1 <= `SD LQ_dest_reg[1];
			ex_mem_illegal_1      <= `SD 0;
			ex_mem_valid_inst_1   <= `SD 1;
			ex_mem_alu_result_1   <= `SD LQ_data[1];	//////
			ex_mem_take_branch_1  <= `SD 0;	//////
			ex_mem_NPC_branch_enable_1 <= `SD 0;
			ex_mem_btb_mispred_1	     <= `SD 0;
			br_correct_1      	<= `SD 0; 
			ex_mem_cond_branch_1  <= `SD 0;
			ex_mem_target_result_1     <= `SD 0;				
		end
		4'b0001: begin
			ex_mem_NPC_1          <= `SD 0;
			ex_mem_IR_1          <= `SD `NOOP_INST;
			ex_mem_dest_reg_idx_1 <= `SD `ZERO_REG;
			ex_mem_illegal_1      <= `SD 0;
			ex_mem_valid_inst_1   <= `SD 0;
			ex_mem_alu_result_1   <= `SD 0;
			ex_mem_take_branch_1  <= `SD 0;
			ex_mem_NPC_branch_enable_1 <= `SD 0;
			ex_mem_btb_mispred_1	     <= `SD 0;
			br_correct_1      	<= `SD 0;
			ex_mem_cond_branch_1  <= `SD 0;
			ex_mem_target_result_1     <= `SD 0;			
		end
		4'b0000: begin
			ex_mem_NPC_1          <= `SD id_ex_NPC_1;
			ex_mem_IR_1           <= `SD id_ex_IR_1;
			ex_mem_dest_reg_idx_1 <= `SD id_ex_dest_reg_idx_1;
			ex_mem_illegal_1      <= `SD id_ex_illegal_1;
			ex_mem_valid_inst_1   <= `SD id_ex_valid_inst_1;
			ex_mem_NPC_branch_enable_1 <= `SD ex_NPC_branch_enable_1;
			ex_mem_btb_mispred_1	     <= `SD btb_mispred_1;
			br_correct_1      	<= `SD br_correct_to_com_1;
			ex_mem_cond_branch_1  <= `SD id_ex_cond_branch_1;
			ex_mem_target_result_1     <= `SD ex_target_result_1;
			// these are results of EX stage        
			ex_mem_alu_result_1   <= `SD ex_alu_result_out_1;
			ex_mem_take_branch_1  <= `SD ex_take_branch_out_1;
		end
		4'b001?: begin
			ex_mem_NPC_1          <= `SD 0;
			ex_mem_IR_1          <= `SD `NOOP_INST;
			ex_mem_dest_reg_idx_1 <= `SD `ZERO_REG;
			ex_mem_illegal_1      <= `SD 0;
			ex_mem_valid_inst_1   <= `SD 0;
			ex_mem_alu_result_1   <= `SD 0;
			ex_mem_take_branch_1  <= `SD 0;
			ex_mem_NPC_branch_enable_1 <= `SD 0;
			ex_mem_btb_mispred_1	     <= `SD 0;
			br_correct_1      	<= `SD 0;
			ex_mem_cond_branch_1  <= `SD 0;
			ex_mem_target_result_1     <= `SD 0;
		end
	endcase
    end // else: !if(reset)
  end // always

  dcache_control dcache_control_0(
    .LQ_issued_0(LQ_issued[0]),
    .LQ_issued_1(LQ_issued[1]),
    .LQ_issue_pos_0(LQ_issue_pos_0),
    .LQ_issue_pos_1(LQ_issue_pos_1),
    .clock(clock),
    .reset(reset),
    .alu_flush_0(alu_flush_0),
    .alu_flush_1(alu_flush_1),///////from EX stage
    .b_mask_to_dcache(b_mask_to_dcache),
    .recovery_request(recovery_request),
    .br_correct(br_correct),
    .br_correct_address(br_correct_address),
    .recovery_b_mask(recovery_b_mask),
    .Dmem2proc_response(Dmem2proc_response),	//given by mem while sending command to mem
    .Dmem2proc_tag(mem2proc_tag),	//given by mem while data from mem is back (to cam)

    .load_0_valid(LQ_dcache_fetch_en[0]),		//if there is a ld in way_0
    .load_1_valid(LQ_dcache_fetch_en[1]),		//if there is a ld in way_1
    .proc2Dcache_addr_0(LQ_dcache_fetch_address_out[0]), 	//to search address in D$ (to cam) for load_0
    .proc2Dcache_addr_1(LQ_dcache_fetch_address_out[1]), 	//to search address in D$ (to cam) for load_1
    .store_valid(SQ_dcache_Data_en_out),		//if there is a store retired (need to write to )
    .proc2Dcache_addr_st(SQ_dcache_address_out), 	//to search address in D$ (to cam) for store
    
    .MSHR_ld_position_in_0(LQ_dcache_fetch_index_out[0]),	//the position in LQ
    .MSHR_ld_position_in_1(LQ_dcache_fetch_index_out[1]),	//the position in LQ
    
    .cachemem_valid_0(dcache_data_ready_in[0]),		//the data found in D$ is correct, connect rd0_valid_hit in D$
    .cachemem_valid_1(dcache_data_ready_in[1]),		//the data found in D$ is correct, connect rd1_valid_hit in D$
    .cachemem_valid_st(wr_store_hit),		//the address is found in D cache, actually not used now

    .proc2Dmem_command(proc2Dmem_command),	//need data from mem
    .proc2Dmem_addr(proc2Dmem_addr),		//address that would be cam in mem

    .load_index_0(load_index_0),	//the entry it belongs in D$, connect rd0_idx_hit in D$
    .load_tag_0(load_tag_0),	//the tag to cam with the entry chosen above, connect rd0_tag_hit in D$
    .load_index_1(load_index_1),	//the entry it belongs in D$, connect rd1_idx_hit in D$
    .load_tag_1(load_tag_1),	//the tag to cam with the entry chosen above, connect rd1_tag_hit in D$
    .store_index(store_index),	//the entry it belongs in D$, connect wr_store_idx in D$
    .store_tag(store_tag),	//the tag to cam with the entry chosen above, connect wr_store_tag in D$
    .mem_ld_index(mem_ld_index),	//the entry it belongs in D$, connect wr_mem_idx in D$
    .mem_ld_tag(mem_ld_tag),	//the tag to cam with the entry chosen above, connect wr_mem_tag in D$

    .data_write_mem_enable(dcache_data_ready_in[2]),	// connect wr_mem_en in D$
    .MSHR_ld_position_out(dcache_load_index_in)	// the position the data from mem should go to in LSQ
  );
 
  dcache dcache_0(
    .clock(clock),
    .reset(reset),
    .wr_mem_en(dcache_data_ready_in[2]),	//get from mem, for load
    .wr_store_en(SQ_dcache_Data_en_out),	//when store hit
    .wr_mem_idx(mem_ld_index), .wr_store_idx(store_index), .rd0_idx_hit(load_index_0), .rd1_idx_hit(load_index_1),//,rd_idx_miss,
    .wr_mem_tag(mem_ld_tag), .wr_store_tag(store_tag), .rd0_tag_hit(load_tag_0),.rd1_tag_hit(load_tag_1),//,rd_tag_miss,
    .wr_mem_data(mem2proc_data), .wr_store_data(proc2mem_data), 
    .ld_valid_0(LQ_dcache_fetch_en[0]), .ld_valid_1(LQ_dcache_fetch_en[1]),
    .rd0_data_hit(dcache_data_in[0]),
    .rd1_data_hit(dcache_data_in[1]),
    .rd0_valid_hit(dcache_data_ready_in[0]),
    .rd1_valid_hit(dcache_data_ready_in[1]),
    .wr_store_hit(wr_store_hit)
  );
  //////////////////////////////////////////////////
  //                                              //
  //                  Complete-Stage              //
  //                                              //
  //////////////////////////////////////////////////
  assign recovery_request = ex_mem_NPC_branch_enable_0 || ex_mem_NPC_branch_enable_1;
  assign if_recovery_NPC = ex_mem_NPC_branch_enable_0 ? ex_mem_target_result_0 : ex_mem_target_result_1;
  wb_stage_0 wb_stage0 (
    //Inputs
    .clock(clock),
    .reset(reset),
    .ex_mem_NPC_0(ex_mem_NPC_0),          
    .ex_mem_alu_result_0(ex_mem_alu_result_0),       
    .ex_mem_take_branch_0(ex_mem_take_branch_0), 
    .ex_mem_dest_reg_idx_0(ex_mem_dest_reg_idx_0),  
    .ex_mem_NPC_1(ex_mem_NPC_1),          
    .ex_mem_alu_result_1(ex_mem_alu_result_1),       
    .ex_mem_take_branch_1(ex_mem_take_branch_1), 
    .ex_mem_dest_reg_idx_1(ex_mem_dest_reg_idx_1),  

    .reg_wr_data_out_0(wb_reg_wr_data_out_0),
    .reg_wr_data_out_1(wb_reg_wr_data_out_1),      // register writeback data
    .reg_wr_idx_out_0(wb_reg_wr_idx_out_0), 
    .reg_wr_idx_out_1(wb_reg_wr_idx_out_1),       // register writeback index
    .reg_wr_en_out_0(wb_reg_wr_en_out_0), 
    .reg_wr_en_out_1(wb_reg_wr_en_out_1),          // register writeback enable
    .CDB_0(CDB_in_0), 
    .CDB_1(CDB_in_1)
  );

  //////////////////////////////////////////////////
  //                                              //
  //                  Retire-Stage                //
  //                                              //
  //////////////////////////////////////////////////

endmodule  // module verisimple
