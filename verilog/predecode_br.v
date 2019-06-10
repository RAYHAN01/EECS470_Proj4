`timescale 1ns/100ps
module predecode_br(
		input clock,
		input reset,
		input [31:0] insn_0,
		input [31:0] insn_1,
		input valid_inst_in_0,
		input valid_inst_in_1,
		input [63:0] ex_pc_idx,		//NPC for fix mispredict
		input [63:0] if_pc_idx_0,	//NPC from if_0
		input [63:0] if_pc_idx_1,	//NPC from if_1
		input btb_mispred,
		input ex_br_res,		//result of br after ex
		input ex_br_valid,		//is result of ex br?
		input [63:0] target_pc,


		output logic [31:0] insn_out_0,
		output logic [31:0] insn_out_1,		//pipeline get insn from here
		output logic [63:0] target_sol,
		output logic br_sol_0,
		output logic br_sol_1,

		output logic valid_out_0,
		output logic valid_out_1,

		output logic ras_structural_hazard,
		output logic br_sol_target
);

  logic [63:0] br_pc_idx;
  logic uncond_br;
  logic to_br_pred;
  logic is_call, is_ret, is_br;
  logic br_sol;
  logic ras_busy;
  logic is_0_br;
  logic is_1_br;
  logic is_br_0;
  logic is_br_1;
  logic is_call_0, is_call_1;
  logic is_ret_0, is_ret_1;
  logic valid_inst_0, valid_inst_1;
  logic uncond_br_0, uncond_br_1;
  logic [63:0] target_sol_inter,call_NPC;

  predecoder predecoder_0 (
				.inst(insn_0), .valid_inst_in(valid_inst_in_0),
				.is_br(is_br_0), .is_ret(is_ret_0), .is_call(is_call_0),
				.valid_inst(valid_inst_0), .uncond_branch(uncond_br_0)				
			);
  predecoder predecoder_1 (
				.inst(insn_1), .valid_inst_in(valid_inst_in_1),
				.is_br(is_br_1), .is_ret(is_ret_1), .is_call(is_call_1),
				.valid_inst(valid_inst_1), .uncond_branch(uncond_br_1)	
			);

  assign is_br = to_br_pred? is_br_1 : is_br_0;
  assign is_ret = to_br_pred? is_ret_1 : is_ret_0;
  assign is_call = to_br_pred? is_call_1 : is_call_0;
  assign uncond_br = to_br_pred? uncond_br_1 : uncond_br_0;
  assign br_pc_idx = to_br_pred? if_pc_idx_1 : if_pc_idx_0;
  assign insn_out_0 = insn_0;
  assign ras_structural_hazard = ras_busy && (is_call_0 || (!valid_inst_0 && is_call_1));
  assign br_sol_target = br_sol_0 ||br_sol_1 || valid_inst_0 && valid_inst_1;

  always_comb begin
		to_br_pred = 0;
		is_0_br = 0;
		is_1_br = 0;
		insn_out_1 = insn_1;
		valid_out_1 = valid_inst_in_1;
	if(valid_inst_0) begin
			is_0_br = is_br_0 || uncond_br_0;
		if(is_0_br && br_sol) begin
			insn_out_1 = `NOOP_INST;
			is_1_br = 0;
			valid_out_1 = 0;
		end
		else begin
			if(valid_inst_1) begin
				insn_out_1 = `NOOP_INST;
				is_1_br = 0;
				valid_out_1 = 0;				
			end
		end
	end
	else if(valid_inst_1) begin
		to_br_pred = 1;
		is_1_br = is_br_1 || uncond_br_1;
	end
  end

 PC_inst PC_inst_0 (
			.clock(clock), .reset(reset),
			.is_br(is_br), .is_ret(is_ret), .is_call(is_call), .uncond_br(uncond_br),
			.if_pc_idx(br_pc_idx), .target_pc(target_pc), .call_NPC(call_NPC),
			.ex_pc_idx(ex_pc_idx), .ex_br_valid(ex_br_valid), .ex_br(ex_br_res), .wr_btb_en(btb_mispred),
			.br_sol(br_sol), .target_sol(target_sol_inter), .ras_busy(ras_busy)
	);
	assign call_NPC = is_call_0 ? if_pc_idx_0 : if_pc_idx_1;
	assign br_sol_0 = is_0_br ? br_sol : 1'b0;
	assign br_sol_1 = is_1_br ? br_sol : 1'b0;
	assign valid_out_0 = valid_inst_in_0;
	assign target_sol = (valid_inst_0 && valid_inst_1 && !br_sol) ? if_pc_idx_0 : target_sol_inter;

  endmodule
