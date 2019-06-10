`timescale 1ns/100ps
module Freelist (
	input   clock,
	input   reset,
	input   [$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_0,		// TAG to free, we have `N_ENTRY_ROB (freelist) + 32 (default_reg) + 1(R31 reserved)
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_1,
	
	input   free_PR_0,						// free signal == rt_valid
	input   fetch_PR_0,	 					// fetch signal == dispatch this
	input   free_PR_1,
	input   fetch_PR_1,

	input	is_0_br,						// is 0 way br? from decoder = uncond_br || cond_br
	input	recovery_br,						// recovery_request from ex/mem (prediction wrong either target or direction == mispred_dir || mispred_target)
	input	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] recovery_tag_table,	// recovery_tag_table from Branch Stack
	input	[$clog2(`N_ENTRY_ROB)-1:0] recovery_pointer,				// recovery_pointer from Branch Stack
	input	recovery_empty,								// recovery_empty from Branch Stack

	output	logic [`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] tag_table_br,  	// to Branch stack
	output	logic empty_br,								// to Branch stack
	output	logic [$clog2(`N_ENTRY_ROB)-1:0] pointer_br,				// to Branch stack

	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_0,				// new tag to rename
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_1
);

	logic [$clog2(`N_ENTRY_ROB)-1:0] next_pointer;		// after free and fetch, final state of pointer
	logic [$clog2(`N_ENTRY_ROB)-1:0] pointer_free;		// after free, inter state of pointer
	logic [$clog2(`N_ENTRY_ROB)-1:0] pointer;		// pointer reg save the state from last cycle
	logic [$clog2(`N_ENTRY_ROB)-1:0] pointer_br_0; 		// pointer for branch stack, represent the 1st is branch

	logic [`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] tag;		// tag reg save the state from last cycle
	logic [`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] next_tag;	// after free and fetch, final state of tag
	logic empty_br_0;		// empty for branch stack, represent the 1st is branch
	logic next_empty;		// after free and fetch, final state of empty
	logic next_empty_free;		// after free, inter state of empty
	logic empty;			// empty reg save the state from last cycle
	logic free_PR_0_sol,free_PR_1_sol;


  // synopsys sync_set_reset "reset"
	always_ff@(posedge clock) begin
		if(reset) begin
			for(int i=0; i<`N_ENTRY_ROB; i++) begin
				tag[i] <= `SD 32+i;
			end
			pointer <= `SD 0;
			empty   <= `SD 0;
		end
		else begin
			if(recovery_br) begin
				tag     <= `SD recovery_tag_table;								// 4
				pointer <= `SD recovery_pointer;								// 5  up = minus
				empty   <= `SD recovery_empty;									// 6  down = add
			end	// if recovery_request write the recovery state							// 7
			else begin
				tag     <= `SD next_tag;
				pointer <= `SD next_pointer;
				empty   <= `SD next_empty;
			end	// else work as normal
		end
	end

  assign free_PR_0_sol = free_PR_0 && !(Told_out_0 == `ZERO_REG);
  assign free_PR_1_sol = free_PR_1 && !(Told_out_1 == `ZERO_REG);		// free PR when it is not `ZERO_REG
  assign pointer_br    = is_0_br ? pointer_br_0 : next_pointer;			// if first is branch, output snapshot after first inst fetch; else output the final state
  assign empty_br      = is_0_br ? empty_br_0   : next_empty;
  assign tag_table_br  = next_tag;						// tag table is not that important, only needs to be the state after free, pointer will tell the right state

	always_comb begin
		next_tag = tag;							// avoid next_tag latch
		if(free_PR_0_sol && free_PR_1_sol) begin			// Case with two PR free
			next_empty_free = 1'b0;					    // set not free after free 2 PR
			if(empty) begin						    // Case if last cycle is empty
				pointer_free = `N_ENTRY_ROB-2;				// after free, pointer pointer points to `N_ENTRY_ROB-2 (up 1 pos)
				next_tag[`N_ENTRY_ROB-1] = Told_out_0;			// first write Told_out_0 into position `N_ENTRY_ROB-1
				next_tag[`N_ENTRY_ROB-2] = Told_out_1;			// then write Told_out_1 into position `N_ENTRY_ROB-2
			end 
			else begin						    // Case if last cycle is not empty
				pointer_free = pointer-2;				// after free, pointer points to pointer-2 (up 2 pos)
				next_tag[pointer-1] = Told_out_0;			// first write Told_out_0 into position pointer-1
				next_tag[pointer-2] = Told_out_1;			// then write Told_out_1 into position pointer-2
			end
		end
		else if(free_PR_0_sol || free_PR_1_sol) begin			// Case if only one PR free
			next_empty_free = 1'b0;					    // set not free after free 1 PR
			if(empty) begin						    // Case if last cycle is empty
				pointer_free = `N_ENTRY_ROB-1;				// after free, pointer still points to `N_ENTRY_ROB-1 (no move just not empty now)
			end
			else begin						    // Case if last cycle is not empty
				pointer_free = pointer-1;				// after free, pointer points to pointer-1 (up 1 pos)
			end
			if(free_PR_0_sol) next_tag[pointer_free] = Told_out_0;	    // write the free tag into pointer_free pos
			else              next_tag[pointer_free] = Told_out_1;

		end
		else begin							// Case if nothing free
				next_empty_free = empty;			// empty no change
				pointer_free    = pointer;			// pointer no change
		end	// after free, use pointer_free and next_empty_free ; next_tag


		
		if(fetch_PR_0 && fetch_PR_1) begin					// Case with two fetch (no need to deal with structural hazard with # of freelist = # of entry in ROB)
			if(pointer_free == `N_ENTRY_ROB-2) begin		   	// Case if after free and fetch it will become empty
				next_empty   = 1'b1;					// set next_empty to be 1
				next_pointer = `N_ENTRY_ROB-1;				// pointer pointes to the bottom
				Tnew_out_0   = next_tag[`N_ENTRY_ROB-2];		// read tag from next_tag pos `N_ENTRY_ROB-2 & `N_ENTRY_ROB-1
				Tnew_out_1   = next_tag[`N_ENTRY_ROB-1];
			// if first is br, snapshot just get the state after first fetch
				pointer_br_0 = `N_ENTRY_ROB-1;				// after first fetch, pointer points to the bottom but not empty
				empty_br_0   =1'b0;
			end
			else begin						   // Case if after free and fetch it won't empty
				next_empty = 1'b0;					// set next_empty to be 0
				next_pointer = pointer_free+2;				// pointer move to pointer_free+2 (down 2 pos)
				Tnew_out_0   = next_tag[pointer_free];			// read Tnew_out from next_tag pos pointer_free and pointer_free+1
				Tnew_out_1   = next_tag[pointer_free+1];
			// if first is br, snapshot just get the state after first fetch
				pointer_br_0 = pointer_free+1;				// after first fetch, pointer points to pointer_free+1 (down 1 pos) and won't empty
				empty_br_0   =1'b0;
			end


		end
		else if(fetch_PR_0 || fetch_PR_1) begin				// Case with only one fetch
			if(pointer_free == `N_ENTRY_ROB-1) begin		    // Case if after free and fetch it will become empty
				next_empty   = 1'b1;					// set next_empty to be 1
				next_pointer = `N_ENTRY_ROB-1;				// pointer pointes to the bottom
			end
			else begin						   // Case if after free and fetch it won't empty
				next_empty   = 1'b0;					// set next_empty to be 0		
				next_pointer = pointer_free+1;				// pointer move to pointer_free+1 (down 1 pos)
			end
			
			if(fetch_PR_0) begin					   // read Tnew from next_tag pos pointer_free
				Tnew_out_0   = next_tag[pointer_free];
				Tnew_out_1   = `ZERO_REG;
			end
			else begin
				Tnew_out_1   = next_tag[pointer_free];
				Tnew_out_0   = `ZERO_REG;
			end
			// if first is br, snapshot just get the state after first fetch, but only one fetch, output is just the final state
			pointer_br_0 = next_pointer;
			empty_br_0   = next_empty;
		end   
		else begin							// Case if nothing to fetch
			Tnew_out_0   = `ZERO_REG;					    // output both `ZERO_REG
			Tnew_out_1   = `ZERO_REG;
			next_empty   = next_empty_free;				    // state is just it is after free
			next_pointer = pointer_free;
			// if first is br, snapshot just get the state after first fetch, but nothing fetch, output is just the final state
			pointer_br_0 = next_pointer;
			empty_br_0   = next_empty;
		end

	end	

endmodule
