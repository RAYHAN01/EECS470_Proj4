`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version O-2018.06 -- May 21, 2018
//

// For simulation only. Do not modify.

module pipeline_svsim (

    input         clock,                        input         reset,                        input [3:0]   mem2proc_response,            input [63:0]  mem2proc_data,                input [3:0]   mem2proc_tag,              
 
    output logic	valid_wb_0,
    output logic	valid_wb_1, 

    output logic [1:0]  proc2mem_command,    	    output logic [63:0] proc2mem_addr,      	    output logic [63:0] proc2mem_data,      	
    output logic [3:0]  pipeline_completed_insts_0, pipeline_completed_insts_1,
    output ERROR_CODE   pipeline_error_status,
    output logic [$clog2(32+33)-1:0]  pipeline_commit_wr_idx_0, pipeline_commit_wr_idx_1,
    output logic [63:0] pipeline_commit_wr_data_0, pipeline_commit_wr_data_1,
    output logic        pipeline_commit_wr_en_0, pipeline_commit_wr_en_1,
    output logic [63:0] pipeline_commit_NPC_0, pipeline_commit_NPC_1,


output  logic [32+32:0][63:0] rf_value_out,
output	logic free_PR_1,
output	logic free_PR_0,
output  logic [$clog2(32+33)-1:0] rt_Tnew_out_0,
output  logic [$clog2(32+33)-1:0] rt_Tnew_out_1,
output  logic [$clog2(32+33)-1:0] rt_Told_out_0,
output  logic [$clog2(32+33)-1:0] rt_Told_out_1,


output  logic is_0_br,
output	logic recovery_request,
output  logic [$clog2(32)-1:0] recovery_tail,
output  logic [$clog2(32+33)-1:0] free_list_in_0,
output  logic [$clog2(32+33)-1:0] free_list_in_1,
output  logic [$clog2(32+33)-1:0] CDB_in_0, 
output  logic [$clog2(32+33)-1:0] CDB_in_1, 
output  logic [$clog2(32+33)-1:0] T_old_0,
output  logic [$clog2(32+33)-1:0] T_old_1,
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





            

        output logic [63:0] if_NPC_out_0,
    output logic [31:0] if_IR_out_0,
    output logic        if_valid_inst_out_0,
    output logic [63:0] if_NPC_out_1,
    output logic [31:0] if_IR_out_1,
    output logic        if_valid_inst_out_1,

        output logic        if_id_valid_inst_0,
    output logic        if_id_valid_inst_1,


        output logic [63:0] id_ex_NPC_0,
    output logic [31:0] id_ex_IR_0,
    output logic        id_ex_valid_inst_0,
    output logic [63:0] id_ex_NPC_1,
    output logic [31:0] id_ex_IR_1,
    output logic        id_ex_valid_inst_1,


        output logic [63:0] ex_mem_NPC_0,
    output logic [31:0] ex_mem_IR_0,
    output logic        ex_mem_valid_inst_0,
    output logic [63:0] ex_mem_NPC_1,
    output logic [31:0] ex_mem_IR_1,
    output logic        ex_mem_valid_inst_1

  );


      

  pipeline pipeline( {>>{ clock }}, {>>{ reset }}, {>>{ mem2proc_response }}, 
        {>>{ mem2proc_data }}, {>>{ mem2proc_tag }}, {>>{ valid_wb_0 }}, 
        {>>{ valid_wb_1 }}, {>>{ proc2mem_command }}, {>>{ proc2mem_addr }}, 
        {>>{ proc2mem_data }}, {>>{ pipeline_completed_insts_0 }}, 
        {>>{ pipeline_completed_insts_1 }}, {>>{ pipeline_error_status }}, 
        {>>{ pipeline_commit_wr_idx_0 }}, {>>{ pipeline_commit_wr_idx_1 }}, 
        {>>{ pipeline_commit_wr_data_0 }}, {>>{ pipeline_commit_wr_data_1 }}, 
        {>>{ pipeline_commit_wr_en_0 }}, {>>{ pipeline_commit_wr_en_1 }}, 
        {>>{ pipeline_commit_NPC_0 }}, {>>{ pipeline_commit_NPC_1 }}, 
        {>>{ rf_value_out }}, {>>{ free_PR_1 }}, {>>{ free_PR_0 }}, 
        {>>{ rt_Tnew_out_0 }}, {>>{ rt_Tnew_out_1 }}, {>>{ rt_Told_out_0 }}, 
        {>>{ rt_Told_out_1 }}, {>>{ is_0_br }}, {>>{ recovery_request }}, 
        {>>{ recovery_tail }}, {>>{ free_list_in_0 }}, {>>{ free_list_in_1 }}, 
        {>>{ CDB_in_0 }}, {>>{ CDB_in_1 }}, {>>{ T_old_0 }}, {>>{ T_old_1 }}, 
        {>>{ fetch_PR_0 }}, {>>{ fetch_PR_1 }}, {>>{ id_halt_out_0 }}, 
        {>>{ id_halt_out_1 }}, {>>{ id_wr_mem_out_0 }}, 
        {>>{ id_wr_mem_out_1 }}, {>>{ if_id_NPC_0 }}, {>>{ if_id_NPC_1 }}, 
        {>>{ if_id_IR_0 }}, {>>{ if_id_IR_1 }}, {>>{ if_NPC_out_0 }}, 
        {>>{ if_IR_out_0 }}, {>>{ if_valid_inst_out_0 }}, {>>{ if_NPC_out_1 }}, 
        {>>{ if_IR_out_1 }}, {>>{ if_valid_inst_out_1 }}, 
        {>>{ if_id_valid_inst_0 }}, {>>{ if_id_valid_inst_1 }}, 
        {>>{ id_ex_NPC_0 }}, {>>{ id_ex_IR_0 }}, {>>{ id_ex_valid_inst_0 }}, 
        {>>{ id_ex_NPC_1 }}, {>>{ id_ex_IR_1 }}, {>>{ id_ex_valid_inst_1 }}, 
        {>>{ ex_mem_NPC_0 }}, {>>{ ex_mem_IR_0 }}, {>>{ ex_mem_valid_inst_0 }}, 
        {>>{ ex_mem_NPC_1 }}, {>>{ ex_mem_IR_1 }}, {>>{ ex_mem_valid_inst_1 }}
 );
endmodule
`endif
