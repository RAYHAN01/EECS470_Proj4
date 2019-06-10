/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  visual_testbench.v                                  //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline        //
//                   for the visual debugger                           //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

extern void initcurses(int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int);
extern void flushpipe();
extern void waitforresponse();
extern void initmem();
extern int get_instr_at_pc(int);
extern int not_valid_pc(int);

module testbench;

  // variables used in the testbench
  logic        clock;
  logic        reset;
  logic [31:0] clock_count;
  logic [31:0] instr_count;
  int          wb_fileno;

  logic [1:0]  proc2mem_command;
  logic [63:0] proc2mem_addr;
  logic [63:0] proc2mem_data;
  logic  [3:0] mem2proc_response;
  logic [63:0] mem2proc_data;
  logic  [3:0] mem2proc_tag;

  logic  [3:0] pipeline_completed_insts_0,pipeline_completed_insts_1;
  ERROR_CODE  pipeline_error_status;
  logic  [$clog2(`N_ENTRY_ROB+33)-1:0] pipeline_commit_wr_idx_0, pipeline_commit_wr_idx_1;
  logic [63:0] pipeline_commit_wr_data_0, pipeline_commit_wr_data_1;
  logic        pipeline_commit_wr_en_0, pipeline_commit_wr_en_1;
  logic [63:0] pipeline_commit_NPC_0, pipeline_commit_NPC_1;


  logic [63:0] if_NPC_out_0;
  logic [31:0] if_IR_out_0;
  logic        if_valid_inst_out_0;
  logic [63:0] if_NPC_out_1;
  logic [31:0] if_IR_out_1;
  logic        if_valid_inst_out_1;
  logic [63:0] if_id_NPC_0;
  logic [31:0] if_id_IR_0;
  logic        if_id_valid_inst_0;
  logic [63:0] if_id_NPC_1;
  logic [31:0] if_id_IR_1;
  logic        if_id_valid_inst_1;
  logic [63:0] id_ex_NPC_0;
  logic [31:0] id_ex_IR_0;
  logic        id_ex_valid_inst_0;
  logic [63:0] id_ex_NPC_1;
  logic [31:0] id_ex_IR_1;
  logic        id_ex_valid_inst_1;
  logic [63:0] ex_mem_NPC_0;
  logic [31:0] ex_mem_IR_0;
  logic        ex_mem_valid_inst_0;
  logic [63:0] ex_mem_NPC_1;
  logic [31:0] ex_mem_IR_1;
  logic        ex_mem_valid_inst_1;
  logic [63:0] mem_wb_NPC_0;
  logic [31:0] mem_wb_IR_0;
  logic        mem_wb_valid_inst_0;
  logic [63:0] mem_wb_NPC_1;
  logic [31:0] mem_wb_IR_1;
  logic        mem_wb_valid_inst_1;

  logic valid_wb_0;
  logic valid_wb_1; //valid bit

// add
logic 	[31:0][63:0] test_rf_value;
logic	[4:0] wr_idx_0_out;
logic	[4:0] wr_idx_1_out;
logic	[63:0] wr_value_0_out;
logic	[63:0] wr_value_1_out;
logic	retire_valid_0_out;
logic	retire_valid_1_out;
logic	[63:0] retire_NPC_0_out;
logic	[63:0] retire_NPC_1_out;

logic [63:0] ROB_rt_NPC_out_0;
logic [63:0] ROB_rt_NPC_out_1;
logic [31:0] ROB_rt_IR_out_0;
logic [31:0] ROB_rt_IR_out_1;


logic [31:0] [$clog2(`N_ENTRY_ROB+33)-1:0] rt_tag_out;
logic [`N_ENTRY_ROB+32:0][63:0] rf_value_out;
logic free_PR_1;
logic free_PR_0;
logic [4:0] wr_idx_0;
logic [4:0] wr_idx_1;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out_0;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out_1;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Told_out_0;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] rt_Told_out_1;

logic is_0_br;
logic recovery_request;
logic [$clog2(`N_ENTRY_ROB)-1:0] recovery_tail;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_0;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_1;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0; 
logic [$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1; 
logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_0;
logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_1;
logic fetch_PR_0;
logic fetch_PR_1;
logic id_halt_out_0;
logic id_halt_out_1;
logic id_wr_mem_out_0;
logic id_wr_mem_out_1;




  // Instantiate the Pipeline
  pipeline pipeline_0 (
    //ah hahahahahaha
	.rf_value_out(rf_value_out),
	.free_PR_1(free_PR_1),
	.free_PR_0(free_PR_0),
  .rt_Told_out_0(rt_Told_out_0),
  .rt_Told_out_1(rt_Told_out_1),
  .rt_Tnew_out_0(rt_Tnew_out_0),
  .rt_Tnew_out_1(rt_Tnew_out_1),
	.is_0_br(is_0_br),
	.recovery_request(recovery_request),
	.recovery_tail(recovery_tail),
	.free_list_in_0(free_list_in_0),
	.free_list_in_1(free_list_in_1),
	.CDB_in_0(CDB_in_0),
	.CDB_in_1(CDB_in_1),
	.T_old_0(T_old_0),
	.T_old_1(T_old_1),
	.fetch_PR_0(fetch_PR_0),
	.fetch_PR_1(fetch_PR_1),
	.id_halt_out_0(id_halt_out_0),
	.id_halt_out_1(id_halt_out_1),
	.id_wr_mem_out_0(id_wr_mem_out_0),
	.id_wr_mem_out_1(id_wr_mem_out_1),

    // Inputs
    .clock             (clock),
    .reset             (reset),
    .mem2proc_response (mem2proc_response),
    .mem2proc_data     (mem2proc_data),
    .mem2proc_tag      (mem2proc_tag),
    //

    .valid_wb_0(valid_wb_0),
    .valid_wb_1(valid_wb_1), //valid bit
    // Outputs

    .proc2mem_command  (proc2mem_command),
    .proc2mem_addr     (proc2mem_addr),
    .proc2mem_data     (proc2mem_data),

    .pipeline_completed_insts_0(pipeline_completed_insts_0),
    .pipeline_error_status(pipeline_error_status),
    .pipeline_commit_wr_data_0(pipeline_commit_wr_data_0),
    .pipeline_commit_wr_idx_0(pipeline_commit_wr_idx_0),
    .pipeline_commit_wr_en_0(pipeline_commit_wr_en_0),
    .pipeline_commit_NPC_0(pipeline_commit_NPC_0),

    .if_NPC_out_0(if_NPC_out_0),
    .if_IR_out_0(if_IR_out_0),
    .if_valid_inst_out_0(if_valid_inst_out_0),
    .if_id_NPC_0(if_id_NPC_0),
    .if_id_IR_0(if_id_IR_0),
    .if_id_valid_inst_0(if_id_valid_inst_0),
    .id_ex_NPC_0(id_ex_NPC_0),
    .id_ex_IR_0(id_ex_IR_0),
    .id_ex_valid_inst_0(id_ex_valid_inst_0),
    .ex_mem_NPC_0(ex_mem_NPC_0),
    .ex_mem_IR_0(ex_mem_IR_0),
    .ex_mem_valid_inst_0(ex_mem_valid_inst_0),

    .pipeline_completed_insts_1(pipeline_completed_insts_1),
    .pipeline_commit_wr_data_1(pipeline_commit_wr_data_1),
    .pipeline_commit_wr_idx_1(pipeline_commit_wr_idx_1),
    .pipeline_commit_wr_en_1(pipeline_commit_wr_en_1),
    .pipeline_commit_NPC_1(pipeline_commit_NPC_1),

    .if_NPC_out_1(if_NPC_out_1),
    .if_IR_out_1(if_IR_out_1),
    .if_valid_inst_out_1(if_valid_inst_out_1),
    .if_id_NPC_1(if_id_NPC_1),
    .if_id_IR_1(if_id_IR_1),
    .if_id_valid_inst_1(if_id_valid_inst_1),
    .id_ex_NPC_1(id_ex_NPC_1),
    .id_ex_IR_1(id_ex_IR_1),
    .id_ex_valid_inst_1(id_ex_valid_inst_1),
    .ex_mem_NPC_1(ex_mem_NPC_1),
    .ex_mem_IR_1(ex_mem_IR_1),
    .ex_mem_valid_inst_1(ex_mem_valid_inst_1)

    //For DEBUG

  );

  ArchMap ArchMap_0(
    .clock(clock),
    .reset(reset),
    .valid_0(free_PR_0),
    .valid_1(free_PR_1),
    .Told_out_0(rt_Told_out_0), 
    .Told_out_1(rt_Told_out_1),
    .Tnew_out_0(rt_Tnew_out_0),
    .Tnew_out_1(rt_Tnew_out_1),

    .tag(rt_tag_out),   //modified for test
    .wr_idx_0(wr_idx_0),  //modified for test
    .wr_idx_1(wr_idx_1)   //modified for test
  );

  test_reg test_reg0(
	.clk(clock),
	.rst(reset),
	.tag(rt_tag_out),
	.value_RF(rf_value_out),
	.valid_1(free_PR_1),
	.valid_0(free_PR_0),
	.wr_idx_0(wr_idx_0),
	.wr_idx_1(wr_idx_1),
	.Tnew_out_0(rt_Tnew_out_0),
	.Tnew_out_1(rt_Tnew_out_1),
	.retire_NPC_0_in(ROB_rt_NPC_out_0),
	.retire_NPC_1_in(ROB_rt_NPC_out_1),

	.test_rf_value(test_rf_value),
	.wr_idx_0_out(wr_idx_0_out),
	.wr_idx_1_out(wr_idx_1_out),
	.wr_value_0_out(wr_value_0_out),
	.wr_value_1_out(wr_value_1_out),

	.retire_valid_0_out(retire_valid_0_out),
	.retire_valid_1_out(retire_valid_1_out),
	.retire_NPC_0_out(retire_NPC_0_out),
	.retire_NPC_1_out(retire_NPC_1_out)
  ); 


 ROB_test ROB_test_0 (
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
    .if_id_NPC_0(if_id_NPC_0), .if_id_NPC_1(if_id_NPC_1),
	.if_id_IR_0(if_id_IR_0), .if_id_IR_1(if_id_IR_1),

	// Output
    .ROB_rt_NPC_out_0(ROB_rt_NPC_out_0),
    .ROB_rt_NPC_out_1(ROB_rt_NPC_out_1),
    .ROB_rt_IR_out_0(ROB_rt_IR_out_0),
    .ROB_rt_IR_out_1(ROB_rt_IR_out_1)
  );




  // Instantiate the Data Memory
  mem memory (
    // Inputs
    .clk               (clock),
    .proc2mem_command  (proc2mem_command),
    .proc2mem_addr     (proc2mem_addr),
    .proc2mem_data     (proc2mem_data),

    // Outputs

    .mem2proc_response (mem2proc_response),
    .mem2proc_data     (mem2proc_data),
    .mem2proc_tag      (mem2proc_tag)
  );

  // Generate System Clock
  always begin
    #(`VERILOG_CLOCK_PERIOD/2.0);
    clock = ~clock;
  end

  // Count the number of posedges and number of instructions completed
  // till simulation ends
  always @(posedge clock)
  begin
    if(reset)
    begin
      clock_count <= `SD 0;
      instr_count <= `SD 0;
    end else begin
      clock_count <= `SD (clock_count + 1);
      //instr_count <= `SD (instr_count + pipeline_completed_insts_0 + pipeline_completed_insts_0);
      instr_count <= `SD (instr_count + valid_wb_0 + valid_wb_1);
    end
  end  

  initial
  begin
    clock = 0;
    reset = 0;

    // Call to initialize visual debugger
    // *Note that after this, all stdout output goes to visual debugger*
    // each argument is number of registers/signals for the group
    // (IF, IF/ID, ID, ID/EX, EX, EX/MEM, MEM, MEM/WB=0, WB=6, Misc, RS, ROB+2)
    initcurses(9,7,28,32,12,14,5,0,6,3,`N_ENTRY_RS,`N_ENTRY_ROB+2,`N_ENTRY_SQ+`N_ENTRY_SQ,`N_ENTRY_LQ+`N_ENTRY_LQ,5,10,9);///////////////////////////////////////////revised

    // Pulse the reset signal
    reset = 1'b1;
    @(posedge clock);
    @(posedge clock);

    // Read program contents into memory array
    $readmemh("program.mem", memory.unified_memory);

    @(posedge clock);
    @(posedge clock);
    `SD;
    // This reset is at an odd time to avoid the pos & neg clock edges
    reset = 1'b0;
  end

  always @(negedge clock)
  begin
    if(!reset)
    begin
      `SD;
      `SD;

      // deal with any halting conditions
      if(pipeline_error_status!=NO_ERROR)
      begin
        #100
        $display("\nDONE\n");
        waitforresponse();
        flushpipe();
        $finish;
      end

    end
  end 

  // This block is where we dump all of the signals that we care about to
  // the visual debugger.  Notice this happens at *every* clock edge.
  always @(clock) begin
    #2;

    // Dump clock and time onto stdout
    $display("c%h%7.0d",clock,clock_count);
    $display("t%8.0f",$time);
    $display("z%h",reset);

    // dump ARF contents
    $write("a");
    for(int i = 0; i < 65; i=i+1)
    begin
      $write("%h", pipeline_0.RF_0.registers[i]);
    end
    $display("");

    // dump IR information so we can see which instruction
    // is in each stage
    
    $write("p%h%h%h%h%h%h%h%h%h%h",
            pipeline_0.if_IR_out_0, pipeline_0.if_valid_inst_out_0,
            pipeline_0.if_id_IR_0,  pipeline_0.if_id_valid_inst_0,
            pipeline_0.id_ex_IR_0,  pipeline_0.id_ex_valid_inst_0,
            pipeline_0.ex_mem_IR_0, pipeline_0.ex_mem_valid_inst_0,
            ROB_rt_IR_out_0, pipeline_0.free_PR_0);
    $display("");
    $write("-%h%h%h%h%h%h%h%h%h%h",
            pipeline_0.if_IR_out_1, pipeline_0.if_valid_inst_out_1,
            pipeline_0.if_id_IR_1,  pipeline_0.if_id_valid_inst_1,
            pipeline_0.id_ex_IR_1,  pipeline_0.id_ex_valid_inst_1,
            pipeline_0.ex_mem_IR_1, pipeline_0.ex_mem_valid_inst_1,
            ROB_rt_IR_out_1, pipeline_0.free_PR_1);
    $display("");
    
    // Dump interesting register/signal contents onto stdout
    // format is "<reg group prefix><name> <width in hex chars>:<data>"
    // Current register groups (and prefixes) are:
    // f: IF   d: ID   e: EX   m: MEM    w: WB  v: misc. reg
    // g: IF/ID   h: ID/EX  i: EX/MEM  j: MEM/WB

    // IF signals (6) - prefix 'f'
    $display("fNPC0 16:%h",            pipeline_0.if_NPC_out_0);
    $display("fNPC1 16:%h",          pipeline_0.if_NPC_out_1);//add
    $display("fIR0 8:%h",              pipeline_0.if_IR_out_0);
    $display("fIR1 8:%h",            pipeline_0.if_IR_out_1);//add
    $display("fImem_addr 16:%h",       pipeline_0.if_stage_0.proc2Imem_addr);
    $display("fPC_en 1:%h",            pipeline_0.if_stage_0.PC_enable);
    $display("fPC_reg 16:%h",          pipeline_0.if_stage_0.PC_reg);
    $display("fif_valid0 1:%h",        pipeline_0.if_valid_inst_out_0);
    $display("fif_valid1 1:%h",      pipeline_0.if_valid_inst_out_1);//add

    // IF/ID signals (4) - prefix 'g'
    $display("genable 1:%h",        pipeline_0.if_id_enable);
    $display("gNPC0 16:%h",          pipeline_0.if_id_NPC_0);
    $display("gNPC1 16:%h",          pipeline_0.if_id_NPC_1);//add
    $display("gIR0 8:%h",            pipeline_0.if_id_IR_0);
    $display("gIR1 8:%h",            pipeline_0.if_id_IR_1);//add
    $display("gvalid0 1:%h",         pipeline_0.if_id_valid_inst_0);
    $display("gvalid1 1:%h",         pipeline_0.if_id_valid_inst_1);//add

    // ID signals (28) - prefix 'd'
    $display("ddest_reg0 2:%h",      pipeline_0.id_dest_reg_idx_out_0);
    $display("ddest_reg1 2:%h",      pipeline_0.id_dest_reg_idx_out_1);//add
    $display("drd_mem0 1:%h",        pipeline_0.id_rd_mem_out_0);
    $display("drd_mem1 1:%h",        pipeline_0.id_rd_mem_out_1);//add
    $display("dwr_mem0 1:%h",        pipeline_0.id_wr_mem_out_0);
    $display("dwr_mem1 1:%h",        pipeline_0.id_wr_mem_out_1);//add
    $display("dopa_sel0 1:%h",       pipeline_0.id_opa_select_out_0);
    $display("dopa_sel1 1:%h",       pipeline_0.id_opa_select_out_1);//add
    $display("dopb_sel0 1:%h",       pipeline_0.id_opb_select_out_0);
    $display("dopb_sel1 1:%h",       pipeline_0.id_opb_select_out_1);//add
    $display("dalu_func0 2:%h",      pipeline_0.id_alu_func_out_0);
    $display("dalu_func1 2:%h",      pipeline_0.id_alu_func_out_1);//add
    $display("dcond_br0 1:%h",       pipeline_0.id_cond_branch_out_0);
    $display("dcond_br1 1:%h",       pipeline_0.id_cond_branch_out_1);//add
    $display("duncond_br0 1:%h",     pipeline_0.id_uncond_branch_out_0);
    $display("duncond_br1 1:%h",     pipeline_0.id_uncond_branch_out_1);//add
    $display("dhalt0 1:%h",          pipeline_0.id_halt_out_0);
    $display("dhalt1 1:%h",          pipeline_0.id_halt_out_1);//add
    $display("dillegal0 1:%h",       pipeline_0.id_illegal_out_0);
    $display("dillegal1 1:%h",       pipeline_0.id_illegal_out_1);//add
    $display("dvalid0 1:%h",         pipeline_0.id_valid_inst_out_0);
    $display("dvalid1 1:%h",         pipeline_0.id_valid_inst_out_1);//add
    $display("db_mask0 1:%h",         pipeline_0.id_b_mask_out_0);//add
    $display("db_mask1 1:%h",         pipeline_0.id_b_mask_out_1);//add
    $display("dpre_tarPC0 16:%h",         pipeline_0.id_pre_target_PC_0);//add
    $display("dpre_tarPC1 16:%h",         pipeline_0.id_pre_target_PC_1);//add
    $display("dbr_sol_out0 1:%h",         pipeline_0.id_br_sol_out_0);//add
    $display("dbr_sol_out0 1:%h",         pipeline_0.id_br_sol_out_1);//add


    // ID/EX signals (16) - prefix 'h'
    $display("henable0 1:%h",        pipeline_0.id_ex_enable_0);
    $display("henable1 1:%h",        pipeline_0.id_ex_enable_1);//add
    $display("hNPC0 16:%h",          pipeline_0.id_ex_NPC_0);
    $display("hNPC1 16:%h",          pipeline_0.id_ex_NPC_1); //add
    $display("hIR0 8:%h",            pipeline_0.id_ex_IR_0); 
    $display("hIR1 8:%h",            pipeline_0.id_ex_IR_1); //add
    $display("hrega0 16:%h",         pipeline_0.id_ex_rega_0); 
    $display("hrega1 16:%h",         pipeline_0.id_ex_rega_1); //add
    $display("hregb0 16:%h",         pipeline_0.id_ex_regb_0); 
    $display("hregb1 16:%h",         pipeline_0.id_ex_regb_1); //add
    $display("hdest_reg0 2:%h",      pipeline_0.id_ex_dest_reg_idx_0);
    $display("hdest_reg1 2:%h",      pipeline_0.id_ex_dest_reg_idx_1);//add
    $display("hrd_mem0 1:%h",        pipeline_0.id_ex_rd_mem_0);
    $display("hrd_mem1 1:%h",        pipeline_0.id_ex_rd_mem_1);//add
    $display("hwr_mem0 1:%h",        pipeline_0.id_ex_wr_mem_0);
    $display("hwr_mem1 1:%h",        pipeline_0.id_ex_wr_mem_1);//add
    $display("hopa_sel0 1:%h",       pipeline_0.id_ex_opa_select_0);
    $display("hopa_sel1 1:%h",       pipeline_0.id_ex_opa_select_1);//add
    $display("hopb_sel0 1:%h",       pipeline_0.id_ex_opb_select_0);
    $display("hopb_sel1 1:%h",       pipeline_0.id_ex_opb_select_1);//add
    $display("halu_func0 2:%h",      pipeline_0.id_ex_alu_func_0);
    $display("halu_func1 2:%h",      pipeline_0.id_ex_alu_func_1);//add
    $display("hcond_br0 1:%h",       pipeline_0.id_ex_cond_branch_0);
    $display("hcond_br1 1:%h",       pipeline_0.id_ex_cond_branch_1);//add
    $display("huncond_br0 1:%h",     pipeline_0.id_ex_uncond_branch_0);
    $display("huncond_br1 1:%h",     pipeline_0.id_ex_uncond_branch_1);//add
    $display("hhalt0 1:%h",          pipeline_0.id_ex_halt_0);
    $display("hhalt1 1:%h",          pipeline_0.id_ex_halt_1);//add
    $display("hillegal0 1:%h",       pipeline_0.id_ex_illegal_0);
    $display("hillegal1 1:%h",       pipeline_0.id_ex_illegal_1);//add
    $display("hvalid0 1:%h",         pipeline_0.id_ex_valid_inst_0);
    $display("hvalid1 1:%h",         pipeline_0.id_ex_valid_inst_1);//add

    // EX signals (4) - prefix 'e'
    $display("ealu_resul0 16:%h",   pipeline_0.ex_alu_result_out_0);
    $display("ealu_resul1 16:%h",   pipeline_0.ex_alu_result_out_1);//add
    $display("edest_reg0 2:%h",      pipeline_0.ex_stage_0.id_ex_dest_reg_idx_next_0);
    $display("edest_reg1 2:%h",      pipeline_0.ex_stage_0.id_ex_dest_reg_idx_next_1);//add
    $display("edone0 1:%h",      pipeline_0.ex_stage_0.done_0);
    $display("edone1 1:%h",      pipeline_0.ex_stage_0.done_1);//add
    $display("etake_branch0 1:%h",   pipeline_0.ex_take_branch_out_0);
    $display("etake_branch1 1:%h",   pipeline_0.ex_take_branch_out_1);//add
    $display("ebr_corr0 1:%h",   pipeline_0.br_correct_to_com_0);
    $display("ebr_corr1 1:%h",   pipeline_0.br_correct_to_com_1);//add
    $display("ebtb_misp0 1:%h",   pipeline_0.btb_mispred_0);
    $display("ebtb_misp1 1:%h",   pipeline_0.btb_mispred_1);//add

    // EX/MEM signals (14) - prefix 'i'
    //$display("ienable 1:%h",        pipeline_0.ex_mem_enable);
    $display("iNPC0 16:%h",          pipeline_0.ex_mem_NPC_0);
    $display("iNPC1 16:%h",          pipeline_0.ex_mem_NPC_1);//add
    $display("iIR0 8:%h",            pipeline_0.ex_mem_IR_0);
    $display("iIR1 8:%h",            pipeline_0.ex_mem_IR_1);//add
    //$display("irega0 16:%h",         pipeline_0.ex_mem_rega_0);
    //$display("irega1 16:%h",         pipeline_0.ex_mem_rega_1);//add
    $display("ialu_resul0 16:%h",   pipeline_0.ex_mem_alu_result_0);
    $display("ialu_resul1 16:%h",   pipeline_0.ex_mem_alu_result_1);//add
    $display("idest_reg0 2:%h",      pipeline_0.ex_mem_dest_reg_idx_0);
    $display("idest_reg1 2:%h",      pipeline_0.ex_mem_dest_reg_idx_1);//add
    //$display("ird_mem0 1:%h",        pipeline_0.ex_mem_rd_mem_0);
    //$display("ird_mem1 1:%h",        pipeline_0.ex_mem_rd_mem_1);//add
    //$display("iwr_mem0 1:%h",        pipeline_0.ex_mem_wr_mem_0);
    //$display("iwr_mem1 1:%h",        pipeline_0.ex_mem_wr_mem_1);//add
    $display("itake_branch0 1:%h",   pipeline_0.ex_mem_take_branch_0);
    $display("itake_branch1 1:%h",   pipeline_0.ex_mem_take_branch_1);//add
    //$display("ihalt0 1:%h",          pipeline_0.ex_mem_halt_0);
    //$display("ihalt1 1:%h",          pipeline_0.ex_mem_halt_1);//add
    $display("iillegal0 1:%h",       pipeline_0.ex_mem_illegal_0);
    $display("iillegal1 1:%h",       pipeline_0.ex_mem_illegal_1);//add
    $display("ivalid0 1:%h",         pipeline_0.ex_mem_valid_inst_0);
    $display("ivalid1 1:%h",         pipeline_0.ex_mem_valid_inst_1);//add

    // MEM signals (5) - prefix 'm'
    $display("mmem_data 16:%h",     pipeline_0.dcache_data_in[0]);
    $display("mresult_out 16:%h",   pipeline_0.LQ_data[0]);
    $display("m2Dmem_data 16:%h",   pipeline_0.proc2mem_data);
    $display("m2Dmem_addr 16:%h",   pipeline_0.proc2Dmem_addr);
    $display("m2Dmem_cmd 1:%h",     pipeline_0.proc2Dmem_command);

    // MEM/WB signals (9) - prefix 'j'
     //$display("jenable 1:%h",        pipeline_0.mem_wb_enable);//revise
    //$display("jNPC 16:%h",          pipeline_0.mem_wb_NPC);//revise
    //$display("jIR 16:%h",            pipeline_0.mem_wb_IR);//revise
    //$display("jresult 16:%h",       pipeline_0.mem_wb_result);//revise
    //$display("jdest_reg 2:%h",      pipeline_0.mem_wb_dest_reg_idx);//revise
    //$display("jtake_branch 1:%h",   pipeline_0.mem_wb_take_branch);//revise
    //$display("jhalt 1:%h",          pipeline_0.mem_wb_halt);//revise
    //$display("jillegal 1:%h",       pipeline_0.mem_wb_illegal);//revise
    //$display("jvalid 1:%h",         pipeline_0.mem_wb_valid_inst);//revise

    // WB signals (3) - prefix 'w'
    $display("wwr_data0 16:%h",      pipeline_0.wb_reg_wr_data_out_0);
    $display("wwr_data1 16:%h",      pipeline_0.wb_reg_wr_data_out_1);//add
    $display("wwr_idx0 2:%h",        pipeline_0.wb_reg_wr_idx_out_0);
    $display("wwr_idx1 2:%h",        pipeline_0.wb_reg_wr_idx_out_1);//add
    $display("wwr_en0 1:%h",         pipeline_0.wb_reg_wr_en_out_0);
    $display("wwr_en1 1:%h",         pipeline_0.wb_reg_wr_en_out_1);//add

    // Misc signals(2) - prefix 'v'
    $display("vcompleted0 1:%h",     pipeline_0.pipeline_completed_insts_0);
    $display("vcompleted1 1:%h",     pipeline_0.pipeline_completed_insts_1);//add
    $display("vpipe_err 1:%h",       pipeline_error_status);
    
    $display("1T_0 2:%h",   pipeline_0.RS_0.T_table[0]);
    $display("1T_1 2:%h",   pipeline_0.RS_0.T_table[1]);//add
    $display("1T_2 2:%h",   pipeline_0.RS_0.T_table[2]);
    $display("1T_3 2:%h",   pipeline_0.RS_0.T_table[3]);
    $display("1T_4 2:%h",   pipeline_0.RS_0.T_table[4]);
    $display("1T_5 2:%h",   pipeline_0.RS_0.T_table[5]);
    $display("1T_6 2:%h",   pipeline_0.RS_0.T_table[6]);
    $display("1T_7 2:%h",   pipeline_0.RS_0.T_table[7]);

    $display("2T1_0 2:%h",    pipeline_0.RS_0.T1_table[0]);
    $display("2T1_1 2:%h",    pipeline_0.RS_0.T1_table[1]);//add
    $display("2T1_2 2:%h",    pipeline_0.RS_0.T1_table[2]);
    $display("2T1_3 2:%h",    pipeline_0.RS_0.T1_table[3]);
    $display("2T1_4 2:%h",    pipeline_0.RS_0.T1_table[4]);
    $display("2T1_5 2:%h",    pipeline_0.RS_0.T1_table[5]);
    $display("2T1_6 2:%h",    pipeline_0.RS_0.T1_table[6]);
    $display("2T1_7 2:%h",    pipeline_0.RS_0.T1_table[7]);

    $display("30 1:%h",   pipeline_0.RS_0.T1_ready_table[0]);
    $display("31 1:%h",   pipeline_0.RS_0.T1_ready_table[1]);//add
    $display("32 1:%h",   pipeline_0.RS_0.T1_ready_table[2]);
    $display("33 1:%h",   pipeline_0.RS_0.T1_ready_table[3]);
    $display("34 1:%h",   pipeline_0.RS_0.T1_ready_table[4]);
    $display("35 1:%h",   pipeline_0.RS_0.T1_ready_table[5]);
    $display("36 1:%h",   pipeline_0.RS_0.T1_ready_table[6]);
    $display("37 1:%h",   pipeline_0.RS_0.T1_ready_table[7]);

    $display("4T2_0 2:%h",    pipeline_0.RS_0.T2_table[0]);
    $display("4T2_1 2:%h",    pipeline_0.RS_0.T2_table[1]);//add
    $display("4T2_2 2:%h",    pipeline_0.RS_0.T2_table[2]);
    $display("4T2_3 2:%h",    pipeline_0.RS_0.T2_table[3]);
    $display("4T2_4 2:%h",    pipeline_0.RS_0.T2_table[4]);
    $display("4T2_5 2:%h",    pipeline_0.RS_0.T2_table[5]);
    $display("4T2_6 2:%h",    pipeline_0.RS_0.T2_table[6]);
    $display("4T2_7 2:%h",    pipeline_0.RS_0.T2_table[7]);

    $display("50 1:%h",   pipeline_0.RS_0.T2_ready_table[0]);
    $display("51 1:%h",   pipeline_0.RS_0.T2_ready_table[1]);//add
    $display("52 1:%h",   pipeline_0.RS_0.T2_ready_table[2]);
    $display("53 1:%h",   pipeline_0.RS_0.T2_ready_table[3]);
    $display("54 1:%h",   pipeline_0.RS_0.T2_ready_table[4]);
    $display("55 1:%h",   pipeline_0.RS_0.T2_ready_table[5]);
    $display("56 1:%h",   pipeline_0.RS_0.T2_ready_table[6]);
    $display("57 1:%h",   pipeline_0.RS_0.T2_ready_table[7]);

    $display("60 1:%h",   pipeline_0.RS_0.busy_table[0]);
    $display("61 1:%h",   pipeline_0.RS_0.busy_table[1]);//add
    $display("62 1:%h",   pipeline_0.RS_0.busy_table[2]);
    $display("63 1:%h",   pipeline_0.RS_0.busy_table[3]);
    $display("64 1:%h",   pipeline_0.RS_0.busy_table[4]);
    $display("65 1:%h",   pipeline_0.RS_0.busy_table[5]);
    $display("66 1:%h",   pipeline_0.RS_0.busy_table[6]);
    $display("67 1:%h",   pipeline_0.RS_0.busy_table[7]);

    $display("7Rd_00 1:%h", pipeline_0.ROB_0.T_ready[0]);
    $display("7Rd_01 1:%h", pipeline_0.ROB_0.T_ready[1]);
    $display("7Rd_02 1:%h", pipeline_0.ROB_0.T_ready[2]);
    $display("7Rd_03 1:%h", pipeline_0.ROB_0.T_ready[3]);
    $display("7Rd_04 1:%h", pipeline_0.ROB_0.T_ready[4]);
    $display("7Rd_05 1:%h", pipeline_0.ROB_0.T_ready[5]);
    $display("7Rd_06 1:%h", pipeline_0.ROB_0.T_ready[6]);
    $display("7Rd_07 1:%h", pipeline_0.ROB_0.T_ready[7]);
    $display("7Rd_08 1:%h", pipeline_0.ROB_0.T_ready[8]);
    $display("7Rd_09 1:%h", pipeline_0.ROB_0.T_ready[9]);
    for (int i = 10; i < `N_ENTRY_ROB; i++) begin
      $display("7Rd_%2d 1:%h", i, pipeline_0.ROB_0.T_ready[i]);
    end
    $display("7rt_v0 1:%h",   pipeline_0.ROB_0.rt_valid_0);
    $display("7rt_v1 1:%h",   pipeline_0.ROB_0.rt_valid_1);//add

    $display("8Tn_00 2:%h", pipeline_0.ROB_0.Tnew_table[0]);
    $display("8Tn_01 2:%h", pipeline_0.ROB_0.Tnew_table[1]);
    $display("8Tn_02 2:%h", pipeline_0.ROB_0.Tnew_table[2]);
    $display("8Tn_03 2:%h", pipeline_0.ROB_0.Tnew_table[3]);
    $display("8Tn_04 2:%h", pipeline_0.ROB_0.Tnew_table[4]);
    $display("8Tn_05 2:%h", pipeline_0.ROB_0.Tnew_table[5]);
    $display("8Tn_06 2:%h", pipeline_0.ROB_0.Tnew_table[6]);
    $display("8Tn_07 2:%h", pipeline_0.ROB_0.Tnew_table[7]);
    $display("8Tn_08 2:%h", pipeline_0.ROB_0.Tnew_table[8]);
    $display("8Tn_09 2:%h", pipeline_0.ROB_0.Tnew_table[9]);
    for (int i = 10; i < `N_ENTRY_ROB; i++) begin
      $display("8Tn_%2d 2:%h", i, pipeline_0.ROB_0.Tnew_table[i]);
    end
    $display("8tn0_o 2:%h",   pipeline_0.ROB_0.Tnew_out_0);
    $display("8tn1_o 2:%h",   pipeline_0.ROB_0.Tnew_out_0);


    $display("9To_00 2:%h", pipeline_0.ROB_0.Told_table[0]);
    $display("9To_01 2:%h", pipeline_0.ROB_0.Told_table[1]);
    $display("9To_02 2:%h", pipeline_0.ROB_0.Told_table[2]);
    $display("9To_03 2:%h", pipeline_0.ROB_0.Told_table[3]);
    $display("9To_04 2:%h", pipeline_0.ROB_0.Told_table[4]);
    $display("9To_05 2:%h", pipeline_0.ROB_0.Told_table[5]);
    $display("9To_06 2:%h", pipeline_0.ROB_0.Told_table[6]);
    $display("9To_07 2:%h", pipeline_0.ROB_0.Told_table[7]);
    $display("9To_08 2:%h", pipeline_0.ROB_0.Told_table[8]);
    $display("9To_09 2:%h", pipeline_0.ROB_0.Told_table[9]);
    for (int i = 10; i < `N_ENTRY_ROB; i++) begin
      $display("9To_%2d 2:%h", i, pipeline_0.ROB_0.Told_table[i]);
    end
    $display("9to0_o 2:%h",   pipeline_0.ROB_0.Told_out_0);
    $display("9to1_o 2:%h",   pipeline_0.ROB_0.Told_out_1);

    $display("oST_00 1:%h", pipeline_0.ROB_0.st_table[0]);
    $display("oST_01 1:%h", pipeline_0.ROB_0.st_table[1]);
    $display("oST_02 1:%h", pipeline_0.ROB_0.st_table[2]);
    $display("oST_03 1:%h", pipeline_0.ROB_0.st_table[3]);
    $display("oST_04 1:%h", pipeline_0.ROB_0.st_table[4]);
    $display("oST_05 1:%h", pipeline_0.ROB_0.st_table[5]);
    $display("oST_06 1:%h", pipeline_0.ROB_0.st_table[6]);
    $display("oST_07 1:%h", pipeline_0.ROB_0.st_table[7]);
    $display("oST_08 1:%h", pipeline_0.ROB_0.st_table[8]);
    $display("oST_09 1:%h", pipeline_0.ROB_0.st_table[9]);
    for (int i = 10; i < `N_ENTRY_ROB; i++) begin
      $display("oST_%2d 1:%h", i, pipeline_0.ROB_0.st_table[i]);
    end
    $display("ohead 2:%h",    pipeline_0.ROB_0.head);
    $display("otail 2:%h",    pipeline_0.ROB_0.tail);

    $display("rfr_00 2:%h", pipeline_0.Freelist_0.tag[0]);
    $display("rfr_01 2:%h", pipeline_0.Freelist_0.tag[1]);
    $display("rfr_02 2:%h", pipeline_0.Freelist_0.tag[2]);
    $display("rfr_03 2:%h", pipeline_0.Freelist_0.tag[3]);
    $display("rfr_04 2:%h", pipeline_0.Freelist_0.tag[4]);
    $display("rfr_05 2:%h", pipeline_0.Freelist_0.tag[5]);
    $display("rfr_06 2:%h", pipeline_0.Freelist_0.tag[6]);
    $display("rfr_07 2:%h", pipeline_0.Freelist_0.tag[7]);
    $display("rfr_08 2:%h", pipeline_0.Freelist_0.tag[8]);
    $display("rfr_09 2:%h", pipeline_0.Freelist_0.tag[9]);
    for (int i = 10; i < `N_ENTRY_ROB; i++) begin
      $display("rfr_%2d 2:%h", i, pipeline_0.Freelist_0.tag[i]);
    end
    $display("rTn_o0 2:%h",   pipeline_0.Freelist_0.Tnew_out_0);
    $display("rTn_o1 2:%h",   pipeline_0.Freelist_0.Tnew_out_1);


    $display(";map_00 2:%h", pipeline_0.Maptable_0.Tag_table[0]);
    $display(";map_01 2:%h", pipeline_0.Maptable_0.Tag_table[1]);
    $display(";map_02 2:%h", pipeline_0.Maptable_0.Tag_table[2]);
    $display(";map_03 2:%h", pipeline_0.Maptable_0.Tag_table[3]);
    $display(";map_04 2:%h", pipeline_0.Maptable_0.Tag_table[4]);
    $display(";map_05 2:%h", pipeline_0.Maptable_0.Tag_table[5]);
    $display(";map_06 2:%h", pipeline_0.Maptable_0.Tag_table[6]);
    $display(";map_07 2:%h", pipeline_0.Maptable_0.Tag_table[7]);
    $display(";map_08 2:%h", pipeline_0.Maptable_0.Tag_table[8]);
    $display(";map_09 2:%h", pipeline_0.Maptable_0.Tag_table[9]);

    for (int i = 10; i < 32; i++) begin
      $display(";map_%2d 2:%h", i,  pipeline_0.Maptable_0.Tag_table[i]);
    end
    $display(";T1out0 2:%h", pipeline_0.Maptable_0.map_table_T1_out_0);
    $display(";T1out1 2:%h", pipeline_0.Maptable_0.map_table_T1_out_1);

    $display("[mRd_00 1:%h", pipeline_0.Maptable_0.ready_table[0]);
    $display("[mRd_01 1:%h", pipeline_0.Maptable_0.ready_table[1]);
    $display("[mRd_02 1:%h", pipeline_0.Maptable_0.ready_table[2]);
    $display("[mRd_03 1:%h", pipeline_0.Maptable_0.ready_table[3]);
    $display("[mRd_04 1:%h", pipeline_0.Maptable_0.ready_table[4]);
    $display("[mRd_05 1:%h", pipeline_0.Maptable_0.ready_table[5]);
    $display("[mRd_06 1:%h", pipeline_0.Maptable_0.ready_table[6]);
    $display("[mRd_07 1:%h", pipeline_0.Maptable_0.ready_table[7]);
    $display("[mRd_08 1:%h", pipeline_0.Maptable_0.ready_table[8]);
    $display("[mRd_09 1:%h", pipeline_0.Maptable_0.ready_table[9]);

    for (int i = 10; i < 32; i++) begin
      $display("[mRd_%2d 1:%h", i,  pipeline_0.Maptable_0.ready_table[i]);
    end
    $display("[T2out0 2:%h", pipeline_0.Maptable_0.map_table_T2_out_0);
    $display("[T2out1 2:%h", pipeline_0.Maptable_0.map_table_T2_out_1);
    // must come last

    $display("]data_0 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[0]);
    $display("]data_1 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[1]);
    $display("]data_2 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[2]);
    $display("]data_3 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[3]);
    $display("]data_4 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[4]);
    $display("]data_5 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[5]);
    $display("]data_6 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[6]);
    $display("]data_7 16:%h", pipeline_0.LSQ_0.SQ_0.store_Data_table[7]);
    $display("]addr_0 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[0]);
    $display("]addr_1 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[1]);
    $display("]addr_2 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[2]);
    $display("]addr_3 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[3]);
    $display("]addr_4 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[4]);
    $display("]addr_5 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[5]);
    $display("]addr_6 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[6]);
    $display("]addr_7 16:%h", pipeline_0.LSQ_0.SQ_0.store_address_table[7]);



    $display("}ready_0 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[0]);
    $display("}ready_1 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[1]);
    $display("}ready_2 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[2]);
    $display("}ready_3 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[3]);
    $display("}ready_4 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[4]);
    $display("}ready_5 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[5]);
    $display("}ready_6 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[6]);
    $display("}ready_7 16:%h", pipeline_0.LSQ_0.SQ_0.ST_ready[7]);
    $display("}data_en_D 1:%h", pipeline_0.LSQ_0.SQ_0.Data_out_en);
    $display("}data_to_D 16:%h", pipeline_0.LSQ_0.SQ_0.Data_out);
    $display("}addr_to_D 16:%h", pipeline_0.LSQ_0.SQ_0.address_out);
    $display("}store_pos 1:%h", pipeline_0.LSQ_0.SQ_0.store_position_out);
    $display("}empty 1:%h"  , pipeline_0.LSQ_0.SQ_0.all_empty);
    $display("}busy 1:%h" , pipeline_0.LSQ_0.SQ_0.busy);
    $display("}head 1:%h" , pipeline_0.LSQ_0.SQ_0.head);
    $display("}tail 1:%h" , pipeline_0.LSQ_0.SQ_0.tail);


    $display("{value_$D0 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[0]);
    $display("{value_$D1 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[1]);
    $display("{value_$D2 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[2]);
    $display("{value_$D3 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[3]);
    $display("{value_$D4 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[4]);
    $display("{value_$D5 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[5]);
    $display("{value_$D6 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[6]);
    $display("{value_$D7 16:%h" , pipeline_0.LSQ_0.LQ_0.load_dcache_value_table[7]);
    $display("{value_Fwd0 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[0]);
    $display("{value_Fwd1 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[1]);
    $display("{value_Fwd2 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[2]);
    $display("{value_Fwd3 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[3]);
    $display("{value_Fwd4 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[4]);
    $display("{value_Fwd5 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[5]);
    $display("{value_Fwd6 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[6]);
    $display("{value_Fwd7 16:%h"  , pipeline_0.LSQ_0.LQ_0.load_forwarding_value_table[7]);

    $display("+addr_0 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[0]);
    $display("+addr_1 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[1]);
    $display("+addr_2 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[2]);
    $display("+addr_3 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[3]);
    $display("+addr_4 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[4]);
    $display("+addr_5 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[5]);
    $display("+addr_6 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[6]);
    $display("+addr_7 2:%h" , pipeline_0.LSQ_0.LQ_0.load_addr_table[7]);
    $display("+dest_0 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[0]);
    $display("+dest_1 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[1]);
    $display("+dest_2 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[2]);
    $display("+dest_3 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[3]);
    $display("+dest_4 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[4]);
    $display("+dest_5 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[5]);
    $display("+dest_6 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[6]);
    $display("+dest_7 2:%h" , pipeline_0.LSQ_0.LQ_0.dest_reg_table[7]);

   $display("!store_pos_0 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[0]);
   $display("!store_pos_1 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[1]);
   $display("!store_pos_2 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[2]);
   $display("!store_pos_3 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[3]);
   $display("!store_pos_4 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[4]);
   $display("!store_pos_5 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[5]);
   $display("!store_pos_6 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[6]);
   $display("!store_pos_7 1:%h" , pipeline_0.LSQ_0.LQ_0.store_position_table[7]);
   $display("!busy_0 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[0]);
   $display("!busy_1 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[1]);
   $display("!busy_2 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[2]);
   $display("!busy_3 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[3]);
   $display("!busy_4 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[4]);
   $display("!busy_5 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[5]);
   $display("!busy_6 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[6]);
   $display("!busy_7 1:%h"  , pipeline_0.LSQ_0.LQ_0.busy_table[7]);

   $display("@data_pipe0 16:%h" , pipeline_0.LSQ_0.LQ_0.LQ_data_out[0]);
   $display("@data_pipe1 16:%h" , pipeline_0.LSQ_0.LQ_0.LQ_data_out[1]);
   $display("@dest_pipe0 2:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dest_reg_out[0]);
   $display("@dest_pipe1 2:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dest_reg_out[1]);
   $display("@addr_to_$D0 16:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_address_out[0]);
   $display("@addr_to_$D1 16:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_address_out[1]);
   $display("@index_to_$D0 1:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_index_out[0]);
   $display("@index_to_$D1 1:%h"  , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_index_out[1]);
   $display("@fetch_en0 1:%h" , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_en[0]);
   $display("@fetch_en1 1:%h" , pipeline_0.LSQ_0.LQ_0.LQ_dcache_fetch_en[1]);
   $display("@issue0 1:%h"  , pipeline_0.LSQ_0.LQ_0.issued[0]);
   $display("@issue1 1:%h"  , pipeline_0.LSQ_0.LQ_0.issued[1]);
   $display("@busy  1:%h" , pipeline_0.LSQ_0.LQ_0.busy_out);
   $display("@head  1:%h" , pipeline_0.LSQ_0.LQ_0.head_sel);
   $display("@issue_$D_rdy 1:%h"  , pipeline_0.LSQ_0.LQ_0.issue_dcache_ready);
   $display("@issue_fwd_rdy 1:%h" , pipeline_0.LSQ_0.LQ_0.issue_forwarding_ready);

  $display("#rd0_d_hit 16:%h" , pipeline_0.dcache_0.rd0_data_hit);
  $display("#rd1_d_hit 16:%h" , pipeline_0.dcache_0.rd1_data_hit);
  $display("#rd0_v_hit 1:%h"  , pipeline_0.dcache_0.rd0_valid_hit);
  $display("#rd1_v_hit 1:%h"  , pipeline_0.dcache_0.rd1_valid_hit);
  $display("#wr_store_hit 1:%h" , pipeline_0.dcache_0.wr_store_hit);

  $display("$ld_idx0 1:%h"  , pipeline_0.dcache_control_0.load_index_0);
  $display("$ld_idx1 1:%h"  , pipeline_0.dcache_control_0.load_index_1);
  $display("$ld_tag_0 3:%h" , pipeline_0.dcache_control_0.load_tag_0);
  $display("$ld_tag_1 3:%h" , pipeline_0.dcache_control_0.load_tag_1);
  $display("$st_index 1:%h" , pipeline_0.dcache_control_0.store_index);
  $display("$st_tag 3:%h" , pipeline_0.dcache_control_0.store_tag);
  $display("$mem_ld_idx 1:%h" , pipeline_0.dcache_control_0.mem_ld_index);
  $display("$mem_ld_tags 3:%h"  , pipeline_0.dcache_control_0.mem_ld_tag);
  $display("$data_wr_en 1:%h" , pipeline_0.dcache_control_0.data_write_mem_enable);
  $display("$MSHR_ld_pos 1:%h"  , pipeline_0.dcache_control_0.MSHR_ld_position_out);

  $display("&I$_data 16:%h" , pipeline_0.icache_0.Icache_data_out);
  $display("&I$_valid 1:%h" , pipeline_0.icache_0.Icache_valid_out);
  $display("&rd_idx 1:%h" , pipeline_0.icache_0.read_index);
  $display("&read_tag 3:%h" , pipeline_0.icache_0.read_tag);
  $display("&current_idx 1:%h"  , pipeline_0.icache_0.current_index);
  $display("&current_tag 3:%h"  , pipeline_0.icache_0.current_tag);
  $display("&wr_idx 1:%h" , pipeline_0.icache_0.write_index);
  $display("&wr_tag 3:%h" , pipeline_0.icache_0.write_tag);
  $display("&wr_en 1:%h"  , pipeline_0.icache_0.data_write_enable);






    $display("break");

    // This is a blocking call to allow the debugger to control when we
    // advance the simulation
    waitforresponse();
  end
endmodule
