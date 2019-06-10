`timescale 1ns/100ps
module Maptable (	
	input	clock,							
	input	reset,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0,		// tag from CDB
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1,		// to update ready bits
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_0,	// tag of physical register
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_1,	// to replace old tags
	input	[4:0] T_old_index_0,				// dest reg from decoder 
	input	[4:0] T_old_index_1,				// the place where old tags will be replaced
	input	[4:0] T1_index_0,				// 1st source reg from decoder
	input	[4:0] T1_index_1,				// the 1st reg that will be read by the RS
	input	[4:0] T2_index_0,				// 2nd source reg from decoder
	input	[4:0] T2_index_1,				// the 1st reg that will be read by the RS	
	input	fetch_PR_0,	//get value from free list or not
	input	fetch_PR_1,	//(= dispatch new value or not)

	//input for branch recovery
	input	is_0_br,						//see if the first instruction is a branch or not
	input	recovery_br,						//see if map table need to be recovery
	input	[31:0] recovery_ready_table,				//the ready table that we snapshot before
	input	[31:0][$clog2(`N_ENTRY_ROB+33)-1:0] recovery_Tag_table, //the tag table that we snapshot before

	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_0,		// T_old for ROB
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_old_1,		// the tag that will be replaced when dispatching new tag
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_out_0,	// T1 tag for RS
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_out_1,	// the source tag send to RS 
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_out_0,	// T2 tag for RS
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_out_1,	// the source tag send to RS 
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T_out,	// the first T tag (for fixing RAW)
	output  logic map_table_T1_ready_in_0,			// + for T1's tag in RS
	output  logic map_table_T1_ready_in_1,			// indicate source 1 is ready or not
	output  logic map_table_T2_ready_in_0,			// + for T2's tag in RS
	output  logic map_table_T2_ready_in_1,			// indicate source 2 is ready or not

	//output for branch recovery
	output	logic [31:0] ready_table_br_next,				//output the ready table when there is a br dispatched
	output	logic [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] Tag_table_br		//output the tag table when there is a br dispatched
);

	logic [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] Tag_table, Tag_table_next;	//table for physical regs
	logic [31:0] ready_table, ready_table_next;				//table ready bits
	logic [31:0] ready_table_next_2;					//ready bits after fetch, avoid WAR
	logic [31:0] ready_table_next_3;					//ready bits after recovery consideration
	logic [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] Tag_table_next_2;		//tag table after recovery consideration

	assign map_table_T1_out_0 = (T1_index_0==`ZERO_REG)? `ZERO_REG : Tag_table[T1_index_0];	//send zero reg if the arch index is 31
	assign map_table_T1_out_1 = (T1_index_1==`ZERO_REG)? `ZERO_REG : Tag_table[T1_index_1];	//
	assign map_table_T2_out_0 = (T2_index_0==`ZERO_REG)? `ZERO_REG : Tag_table[T2_index_0];	//
	assign map_table_T2_out_1 = (T2_index_1==`ZERO_REG)? `ZERO_REG : Tag_table[T2_index_1];	//
	assign map_table_T1_ready_in_0 = (T1_index_0==`ZERO_REG)? 1 : ready_table_next[T1_index_0];	//send 1 for ready bit if the arch index is 31
	assign map_table_T1_ready_in_1 = (T1_index_1==`ZERO_REG)? 1 : ready_table_next[T1_index_1];	//
	assign map_table_T2_ready_in_0 = (T2_index_0==`ZERO_REG)? 1 : ready_table_next[T2_index_0];	//
	assign map_table_T2_ready_in_1 = (T2_index_1==`ZERO_REG)? 1 : ready_table_next[T2_index_1];	//
	assign map_table_T_out = (fetch_PR_0 && fetch_PR_1) ? Tag_table[T_old_index_0] : `ZERO_REG;	//signal to let RS deal with RAW
	assign Tag_table_next_2 = recovery_br ? recovery_Tag_table : Tag_table_next;			//take recovery tag table when requested
	assign ready_table_next_3 = recovery_br ? recovery_ready_table : ready_table_next_2;		//take recovery ready table when requested

	always_comb begin
		Tag_table_next = Tag_table;
		ready_table_next = ready_table;
		Tag_table_br = Tag_table;
		ready_table_br_next = ready_table;
		T_old_0 = `ZERO_REG;
		T_old_1 = `ZERO_REG;
		for (int i = 0; i < 32; i++) begin
			if ((Tag_table[i] == CDB_in_0) || (Tag_table[i] == CDB_in_1)) begin
				ready_table_next[i] = 1;	//update ready bit by CDB

				ready_table_br_next[i] = 1;	//update ready bit for br
			end
		end
		ready_table_next_2 = ready_table_next;
		if (fetch_PR_0 && fetch_PR_1) begin		
	
			if(is_0_br) begin					//if the first insn is a br
				ready_table_br_next[T_old_index_0] = 1;		//is 1 because branch should be ready after recovery
				Tag_table_br[T_old_index_0] = free_list_in_0;	//the snapshot should be taken right after branch
			end else begin
				Tag_table_br[T_old_index_0] = free_list_in_0;	//update the table for snapshot
				Tag_table_br[T_old_index_1] = free_list_in_1;	//the case for the 2nd insn is br
				ready_table_br_next[T_old_index_0] = 0;		//the 1st insn is not br, ready bit should be reset while dispatch
				ready_table_br_next[T_old_index_1] = 1;		//is 1 because branch should be ready after recovery
			end
			
			T_old_0 = Tag_table[T_old_index_0];			//the first old tag that will be sent to ROB
			if (T_old_index_0 == T_old_index_1) begin		//if WAW happens 
				T_old_1 = free_list_in_0;			//the second old tag is the first insn's new tag
				Tag_table_next[T_old_index_0] = free_list_in_1;	//the second new tag will replace the first new tag
				ready_table_next_2[T_old_index_0] = 0;		//ready bit should be reset when dispatching new insn
			end else begin
				T_old_1 = Tag_table[T_old_index_1];		//the second old tag that will be sent to ROB
				Tag_table_next[T_old_index_0] = free_list_in_0;	//update the 1st tag while dispatch
				Tag_table_next[T_old_index_1] = free_list_in_1;	//update the 2nd tag while dispatch
				ready_table_next_2[T_old_index_0] = 0;		//reset the 1st ready bit while dispatch
				ready_table_next_2[T_old_index_1] = 0;		//reset the 2nd ready bit while dispatch
			end
		end else if (fetch_PR_0) begin					//if only the 1st insn is dispatched
			ready_table_br_next[T_old_index_0] = 1;			//is 1 because branch should be ready after recovery
			Tag_table_br[T_old_index_0] = free_list_in_0;		//update the table for snapshot

			T_old_0 = Tag_table[T_old_index_0];			//the only old tag that will be sent to ROB
			Tag_table_next[T_old_index_0] = free_list_in_0;		//update the only tag while dispatch
			ready_table_next_2[T_old_index_0] = 0;			//reset the only ready bit while dispatch
		end else if (fetch_PR_1) begin					//if only the 2nd insn is dispatched
			ready_table_br_next[T_old_index_1] = 1;			//is 1 because branch should be ready after recovery
			Tag_table_br[T_old_index_1] = free_list_in_1;		//update the table for snapshot

			T_old_1 = Tag_table[T_old_index_1];			//the only old tag that will be sent to ROB
			Tag_table_next[T_old_index_1] = free_list_in_1;		//update the only tag while dispatch
			ready_table_next_2[T_old_index_1] = 0;			//reset the only ready bit while dispatch
		end	
	end
	always_ff @(posedge clock) begin
		if (reset) begin
			for (int i = 0; i < 31; i++) begin
				Tag_table[i]	<= `SD i;	//make the tag numb same with the arch reg
				ready_table[i]	<= `SD 1;	//reset all tag to ready		
			end
			Tag_table[31] <= `SD `N_ENTRY_ROB+32;	//let the zero arch reg in map table be renamed into the last tag
			ready_table[31] <= `SD 1;		//reset the ready bit
		end else begin
			Tag_table		<= `SD Tag_table_next_2;	//update the tag table
			ready_table		<= `SD ready_table_next_3;	//update the ready table
		end
	end
endmodule
