`timescale 1ns/100ps
module PC_inst(
	input clock,
	input reset,
	input is_br,
	input is_ret,
	input is_call,
	input uncond_br,
	input [63:0] target_pc,

	input [63:0] if_pc_idx,
	input [63:0] ex_pc_idx,
	input ex_br_valid, 	//is ex br ?
	input wr_btb_en, 
	input ex_br, 		//result of br from ex T/NT
  	input [63:0] call_NPC,	


	output logic br_sol,		// result from dirp T/NT
	output logic [63:0] target_sol,	//target_pc
	output logic ras_busy
);
  logic [$clog2(`N_ENTRY_BHR)-1:0] pc_idx_dirp;
  logic [$clog2(`N_ENTRY_BHR)-1:0] ex_pc_idx_dirp;
  logic	[`target_bits-1:0] ex_target;
  logic [$clog2(`ENTRY_PC)+`cam_bits-1:0] ex_pc_idx_btb;
  logic br_pred;
  logic [63:0] PC_after_BTB;
  logic [63:0] ret_NPC;

  assign pc_idx_dirp = if_pc_idx[$clog2(`N_ENTRY_BHR)+1:2];
  assign ex_pc_idx_dirp = ex_pc_idx[$clog2(`N_ENTRY_BHR)+1:2];
  assign ex_pc_idx_btb = ex_pc_idx[$clog2(`ENTRY_PC)+`cam_bits+1:2]; // ?
  assign ex_target = target_pc[`target_bits+1:2];

  DIRP dirp_0 (
		.clock(clock), .reset(reset), 
		.is_br(is_br), .pc_idx(pc_idx_dirp),
		.ex_br_valid(ex_br_valid), .ex_br(ex_br), .ex_pc_idx(ex_pc_idx_dirp), 
		.br_pred(br_pred)
	);
  BTB btb_0 (
		.clock(clock), .reset(reset),
		.PC_to_cam(if_pc_idx), .en_btb(br_sol),
		.exe_pc_valid(wr_btb_en), .PC_from_exe(ex_pc_idx_btb), .ex_target(ex_target),
		.PC_after_BTB(PC_after_BTB)
	);
  RAS ras_0 (
		.clock(clock), .reset(reset), 
		.is_call(is_call), .is_ret(is_ret),
		.call_NPC(call_NPC),
		.ret_NPC(ret_NPC), .ras_busy(ras_busy)
	);

 assign target_sol = is_ret? ret_NPC : PC_after_BTB;
 assign br_sol = uncond_br || br_pred ;


endmodule





