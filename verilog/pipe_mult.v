// This is an 8 stage (9 depending on how you look at it) pipelined 
// multiplier that multiplies 2 64-bit integers and returns the low 64 bits 
// of the result.  This is not an ideal multiplier but is sufficient to 
// allow a faster clock period than straight *
// This module instantiates 8 pipeline stages as an array of submodules.
`timescale 1ns/100ps
module mult (
	input clock, reset,
	input [63:0] mcand, mplier,
	input start,
	input [63:0] id_ex_NPC,
	input [31:0] id_ex_IR,
	input [$clog2(`N_ENTRY_ROB+33)-1:0]  id_ex_dest_reg_idx,
	input [`STACK_NUM-1:0] b_mask,
	input recovery_request_mult,
	input br_correct_mult,
	input [$clog2(`STACK_NUM)-1:0]br_correct_address_mult,
	input [`STACK_NUM-1:0] recovery_b_mask_mult,
				
	output [63:0] product,
	output done,
	output [63:0] id_ex_NPC_next,
	output [31:0] id_ex_IR_next,
	output [$clog2(`N_ENTRY_ROB+33)-1:0]  id_ex_dest_reg_idx_next
			);
  logic [`STACK_NUM-1:0] b_mask_next;
  logic [63:0] mcand_out, mplier_out;
  logic [(`NUM_MULT_STAGES-1)*64-1:0] internal_products, internal_mcands, internal_mpliers;
  logic [`NUM_MULT_STAGES-2:0] internal_dones;
  logic [(`NUM_MULT_STAGES-1)*64-1:0]  internal_id_ex_NPC;
  logic [(`NUM_MULT_STAGES-1)*32-1:0] internal_id_ex_IR;
  logic [(`NUM_MULT_STAGES-1)*($clog2(`N_ENTRY_ROB+33))-1:0]  internal_id_ex_dest_reg_idx;
  logic [(`NUM_MULT_STAGES-1)*(`STACK_NUM)-1:0] internal_b_mask;

	mult_stage mstage [`NUM_MULT_STAGES-1:0]  (
		.clock(clock),
		.reset(reset),
		.br_correct_mult(br_correct_mult),
		.br_correct_address_mult(br_correct_address_mult),
		.recovery_request_mult(recovery_request_mult),
		.recovery_b_mask_mult(recovery_b_mask_mult),
		.product_in({internal_products,64'h0}),
		.mplier_in({internal_mpliers,mplier}),
		.mcand_in({internal_mcands,mcand}),
		.start({internal_dones,start}),
		.id_ex_NPC({internal_id_ex_NPC,id_ex_NPC}),
		.id_ex_IR({internal_id_ex_IR, id_ex_IR}),
		.id_ex_dest_reg_idx({internal_id_ex_dest_reg_idx,id_ex_dest_reg_idx}),
		.b_mask({internal_b_mask, b_mask}),

		.product_out({product,internal_products}),
		.mplier_out({mplier_out,internal_mpliers}),
		.mcand_out({mcand_out,internal_mcands}),
		.done({done,internal_dones}),
		.id_ex_NPC_next({id_ex_NPC_next,internal_id_ex_NPC}),
		.id_ex_IR_next({id_ex_IR_next,internal_id_ex_IR}),
		.id_ex_dest_reg_idx_next({id_ex_dest_reg_idx_next,internal_id_ex_dest_reg_idx}),
		.b_mask_next({b_mask_next, internal_b_mask}) 
	);

endmodule
