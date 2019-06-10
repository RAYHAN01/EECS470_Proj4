// This is one stage of an 8 stage (9 depending on how you look at it)
// pipelined multiplier that multiplies 2 64-bit integers and returns
// the low 64 bits of the result.  This is not an ideal multiplier but
// is sufficient to allow a faster clock period than straight *
`timescale 1ns/100ps
module mult_stage (
		input clock, reset, start,
		input [63:0] product_in, mplier_in, mcand_in,
		input [63:0] id_ex_NPC,
		input [31:0] id_ex_IR,
		input [`STACK_NUM-1:0] b_mask,
		input recovery_request_mult,
		input br_correct_mult,
		input [$clog2(`STACK_NUM)-1:0]br_correct_address_mult,
		input	[`STACK_NUM-1:0] recovery_b_mask_mult,
		input [$clog2(`N_ENTRY_ROB+33)-1:0]  id_ex_dest_reg_idx,

		output logic done,
		output logic [63:0] product_out, mplier_out, mcand_out,
		output logic [63:0] id_ex_NPC_next,
		output logic [31:0] id_ex_IR_next,
		output logic [$clog2(`N_ENTRY_ROB+33)-1:0]  id_ex_dest_reg_idx_next,
		output logic [`STACK_NUM-1:0] b_mask_next

);


	parameter BITS_PER_STAGE = 64/`NUM_MULT_STAGES;
	logic [63:0] prod_in_reg, partial_prod_reg;
	logic [63:0] partial_product, next_mplier, next_mcand;
//	logic found_correct_bit;
	logic [`STACK_NUM-1:0] b_mask_a;


	assign product_out     = prod_in_reg + partial_prod_reg;

	assign partial_product = mplier_in[BITS_PER_STAGE-1:0] * mcand_in;

	assign next_mplier     = {{(BITS_PER_STAGE){1'b0}},mplier_in[63:(BITS_PER_STAGE)]};
	assign next_mcand      = {mcand_in[(63-BITS_PER_STAGE):0],{(BITS_PER_STAGE){1'b0}}};


	//synopsys sync_set_reset "reset"

	always_comb begin
		b_mask_a = b_mask;
		if (br_correct_mult) begin
			b_mask_a[br_correct_address_mult]  = 0;
			/*found_correct_bit = 0;
			for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_correct_bit == 0 && recovery_b_mask_mult[i]==1) begin
					found_correct_bit = 1;
					b_mask_a[i] 	  = 0;
				end
			end*/
		end
	end
	always_ff @(posedge clock) begin
		prod_in_reg      	<= `SD product_in;
		partial_prod_reg 	<= `SD partial_product;
		mplier_out       	<= `SD next_mplier;
		mcand_out        	<= `SD next_mcand;
		id_ex_NPC_next   	<= `SD id_ex_NPC;
		id_ex_IR_next	 	<= `SD id_ex_IR;
		id_ex_dest_reg_idx_next <= `SD id_ex_dest_reg_idx;
		b_mask_next	 	<= `SD b_mask_a;
	end

	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset||(recovery_request_mult && (b_mask>=recovery_b_mask_mult)))
			done <= `SD 1'b0;
		else
			done <= `SD start;
	end

endmodule

