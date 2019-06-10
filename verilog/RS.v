`timescale 1ns/100ps
module RS (
	input	clock,							
	input	reset,
	input	br_is_on_ex,
	input	dispatch_enable_0, 
	input	dispatch_enable_1,
	input	[63:0] pre_target_PC_in_0,
	input	[63:0] pre_target_PC_in_1,
	input	is_br_0,
	input	is_br_1,
	input	br_sol_0,
	input	br_sol_1,
	input	issue_enable_0, issue_enable_1,
	input	[`STACK_NUM-1:0] b_mask_in_0,
	input	[`STACK_NUM-1:0] b_mask_in_1,
	input	recovery_request,
	input	br_correct,
	input	[$clog2(`STACK_NUM)-1:0]br_correct_address,
	input	[`STACK_NUM-1:0] recovery_b_mask,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_0,	// tag of physical register
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] free_list_in_1,	// 
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0,		// tag from CDB
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1,		// 
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_in_0,	// T1 tag from map table
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T1_in_1,	//
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_in_0,	// T2 tag from map table
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T2_in_1,	//
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_T_in,	// the first T tag (for fixing RAW)
	input	map_table_T1_ready_in_0,			// + for T1's tag in Map Table
	input	map_table_T1_ready_in_1,			//
	input	map_table_T2_ready_in_0,			// + for T2's tag in Map Table
	input	map_table_T2_ready_in_1,			// 

	
	//not touching
	input   [63:0] if_id_NPC_0,
	input   [63:0] if_id_NPC_1,
	input	[31:0] INSTR_in_0,				// the whole Instruction
	input	[31:0] INSTR_in_1,				// 
	input	ALU_FUNC func_in_0,				// function
	input	ALU_FUNC func_in_1,				//
	input	ALU_OPA_SELECT opa_select_in_0,			// OPA select signal 
	input	ALU_OPA_SELECT opa_select_in_1,			// 
	input 	ALU_OPB_SELECT opb_select_in_0,			// OPB select signal
	input 	ALU_OPB_SELECT opb_select_in_1,			//
	input	rd_mem_in_0,
	input	rd_mem_in_1,
	input	wr_mem_in_0,
	input	wr_mem_in_1,
	input	ldl_mem_in_0,
	input	ldl_mem_in_1,
	input	stc_mem_in_0,
	input	stc_mem_in_1,
	input	cond_branch_in_0,
	input	cond_branch_in_1,
	input	uncond_branch_in_0,
	input	uncond_branch_in_1,
	input	halt_in_0,
	input	halt_in_1,
	input	cpuid_in_0,
	input	cpuid_in_1,
	input	illegal_in_0,
	input	illegal_in_1,
	input	valid_inst_in_0,
	input	valid_inst_in_1,

	output	logic [63:0] pre_target_PC_out_0,
	output	logic [63:0] pre_target_PC_out_1,
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T1_out_0,
	output  logic [$clog2(`N_ENTRY_ROB+33)-1:0] T1_out_1,
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T2_out_0,
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T2_out_1,		
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_out_0,
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T_out_1,		
	output	logic [31:0] INSTR_out_0,
	output	logic [31:0] INSTR_out_1,
	output	logic busy_out,					// tell other blocks if RS is full right now
	output	logic [`STACK_NUM-1:0] b_mask_out_0,
	output	logic [`STACK_NUM-1:0] b_mask_out_1,
	output	logic br_sol_out_0,
	output	logic br_sol_out_1,

	//not touching
	output  logic [63:0] id_NPC_out_0,
	output  logic [63:0] id_NPC_out_1,
	output	ALU_FUNC func_out_0,
	output	ALU_FUNC func_out_1,
	output	ALU_OPA_SELECT opa_select_out_0,		// OPA select signal
	output	ALU_OPA_SELECT opa_select_out_1,		//
	output	ALU_OPB_SELECT opb_select_out_0,		// OPB select signal
	output	ALU_OPB_SELECT opb_select_out_1,		// 
	output	logic rd_mem_out_0,
	output	logic rd_mem_out_1,
	output	logic wr_mem_out_0,
	output	logic wr_mem_out_1,
	output	logic ldl_mem_out_0,
	output	logic ldl_mem_out_1,
	output	logic stc_mem_out_0,
	output	logic stc_mem_out_1,
	output	logic cond_branch_out_0,
	output	logic cond_branch_out_1,
	output	logic uncond_branch_out_0,
	output	logic uncond_branch_out_1,
	output	logic halt_out_0,
	output	logic halt_out_1,
	output	logic cpuid_out_0,
	output	logic cpuid_out_1,
	output	logic illegal_out_0,
	output	logic illegal_out_1,
	output	logic valid_inst_out_0,
	output	logic valid_inst_out_1
);

	logic [`N_ENTRY_RS-1:0][63:0] pre_target_PC_table;
	logic [`N_ENTRY_RS-1:0][63:0] pre_target_PC_table_next;
//	logic found_correct_bit;
//	logic [$clog2(`STACK_NUM)-1:0] correct_address;
	logic found_first_branch;
	logic found_issue; //flip bit for searching instructions that are ready to be issued
	logic found_empty; //flip bit for searching empty entry
	logic [1:0][$clog2(`N_ENTRY_RS)-1:0] dispatch_index_table_n; //represent the index(address) where the instruction will be inserted
	logic [1:0][$clog2(`N_ENTRY_RS)-1:0] clear_index_table_n;    //represent the index(address) where the instruction will be clear from the RS table
	logic [`N_ENTRY_RS-1:0]	is_br_table;
	logic [`N_ENTRY_RS-1:0]	is_br_table_n;
	logic [`N_ENTRY_RS-1:0]	busy_table;  //to see if these is content in specific entry
	logic [`N_ENTRY_RS-1:0]	busy_table_n;
	logic [`N_ENTRY_RS-1:0]	busy_table_n1;
	logic [`N_ENTRY_RS-1:0]	busy_table_n2;
	logic [`N_ENTRY_RS-1:0]	busy_table_n3;
	logic [`N_ENTRY_RS-1:0]	busy_table_n4;
	logic [`N_ENTRY_RS-1:0]	T1_ready_table;	//represent the plus sign in RS table
	logic [`N_ENTRY_RS-1:0]	T2_ready_table;
	logic [`N_ENTRY_RS-1:0]	T1_ready_table_n;	//represent the next plus sign in RS table
	logic [`N_ENTRY_RS-1:0]	T2_ready_table_n;
	logic [`N_ENTRY_RS-1:0]	T1_ready_table_n1;	//represent the next plus sign in RS table
	logic [`N_ENTRY_RS-1:0]	T2_ready_table_n1;
//	logic [`N_ENTRY_RS-1:0]	T1_ready_table_n_inter2;	//represent the next plus sign in RS table
//	logic [`N_ENTRY_RS-1:0]	T2_ready_table_n_inter2;
	//logic [$clog2(`N_ENTRY_RS):0] available_entries_n, available_entries_n_inter; //
	//logic [$clog2(`N_ENTRY_RS):0] available_entries;      // number of empty entries
	logic [`N_ENTRY_RS-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] T_table;	//tages which comes from the map table (without plus sign)
	logic [`N_ENTRY_RS-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] T1_table;	// 
	logic [`N_ENTRY_RS-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] T2_table;	//
	logic [`N_ENTRY_RS-1:0] [`STACK_NUM-1:0] b_mask_table;
	logic [`N_ENTRY_RS-1:0] [`STACK_NUM-1:0] b_mask_table_next;
	logic [`N_ENTRY_RS-1:0] br_sol_table;
	logic [`N_ENTRY_RS-1:0] br_sol_table_next;
	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T1_table_n_nohazard;
	logic [$clog2(`N_ENTRY_ROB+33)-1:0] T2_table_n_nohazard;
	logic T1_ready_table_n_nohazard;
	logic T2_ready_table_n_nohazard;

	logic [`N_ENTRY_RS-1:0] [31:0] INSTR_table;
	logic	[`N_ENTRY_RS-1:0] rd_mem_table;
	logic	[`N_ENTRY_RS-1:0] wr_mem_table;
	logic	[`N_ENTRY_RS-1:0] ldl_mem_table;
	logic	[`N_ENTRY_RS-1:0] stc_mem_table;
	logic	[`N_ENTRY_RS-1:0] cond_branch_table;
	logic	[`N_ENTRY_RS-1:0] uncond_branch_table;
	logic	[`N_ENTRY_RS-1:0] halt_table;
	logic	[`N_ENTRY_RS-1:0] cpuid_table;
	logic	[`N_ENTRY_RS-1:0] illegal_table;
	logic	[`N_ENTRY_RS-1:0] valid_inst_table;

	//not touching 
	logic	[`N_ENTRY_RS-1:0][63:0] NPC_table;
	ALU_FUNC func_table		[`N_ENTRY_RS-1:0];
	ALU_OPA_SELECT opa_select_table	[`N_ENTRY_RS-1:0];
	ALU_OPB_SELECT opb_select_table	[`N_ENTRY_RS-1:0];

	logic 	[`N_ENTRY_RS-1:0] T1_ready_table_n_sol,T2_ready_table_n_sol;

	logic issue_is_0,issue_is_1,dispatch_is_0,dispatch_is_1;

	always_comb begin
		pre_target_PC_table_next		= pre_target_PC_table;
		br_sol_table_next 			= br_sol_table;
		b_mask_table_next 			= b_mask_table;
		is_br_table_n				= is_br_table;
		busy_table_n				= busy_table;
		clear_index_table_n[0]			= 0;	//reset the table
		clear_index_table_n[1]			= 0; 
		dispatch_index_table_n[0]		= 0;
		dispatch_index_table_n[1]		= 0;
		issue_is_0				= 1'b0;
		issue_is_1				= 1'b0;
		dispatch_is_0				= 1'b0;
		dispatch_is_1				= 1'b0;

		T1_ready_table_n			= T1_ready_table;
		T2_ready_table_n			= T2_ready_table; //reset the T1/T2ready_table before CDB BUS broadcast to RS
		for (int i=0; i < `N_ENTRY_RS; i++) begin
			if ((T1_table[i] == CDB_in_0 || T1_table[i] == CDB_in_1) && busy_table[i] == 1'b1) begin
				T1_ready_table_n[i] = 1'b1; //plus sign will be updated in the next cycle
			end
			if ((T2_table[i] == CDB_in_0 || T2_table[i] == CDB_in_1) && busy_table[i] == 1'b1) begin
				T2_ready_table_n[i] = 1'b1; //
			end
		end
	
		if (recovery_request) begin
			for (int i = 0; i < `N_ENTRY_RS; i++) begin
				if ((b_mask_table[i] >= recovery_b_mask) && busy_table[i]) begin
					busy_table_n[i] = 1'b0;
				end
			end
		end

		busy_table_n1 = busy_table_n;

		//free the RS entries (issue)
		T1_ready_table_n1 = T1_ready_table_n;
		T2_ready_table_n1 = T2_ready_table_n;
		found_first_branch = 1'b0;
		if (issue_enable_0) begin // check to issue out if RS bus0 is able to issue out data.
			found_issue = 1'b0;
			for (int i = 0 ; i < `N_ENTRY_RS ; i++) begin
				if ((!found_issue) && T2_ready_table_n[i] && T1_ready_table_n[i] && busy_table_n[i]&&!br_is_on_ex) begin
					if (is_br_table[i]) begin
						found_first_branch = 1'b1;
					end
					clear_index_table_n[0] = i; //record clear_index[0] for the first possible
					found_issue = 1'b1;
					busy_table_n1[i] = 1'b0; // flip busy_table to 0 (empty)
					T1_ready_table_n1[i] = 1'b0; // flip ready_table to 0 (non ready)
					T2_ready_table_n1[i] = 1'b0;
					issue_is_0 = 1'b1; // set to 1 if a valid issuable entry is found, will set to Bus_0
				end
			end
		end

		busy_table_n2 = busy_table_n1;

//		T1_ready_table_n_inter2 = T1_ready_table_n_inter1;
//		T2_ready_table_n_inter2 = T2_ready_table_n_inter1; // set intermedia values
		if (issue_enable_1) begin // check to issue out if RS bus1 is able to issue out data.
			found_issue = 1'b0;
			for (int i = 0 ; i < `N_ENTRY_RS ; i++) begin
				if ((!found_issue) && T2_ready_table_n[i] && T1_ready_table_n[i] && busy_table_n1[i] 
						&& !(found_first_branch&&is_br_table[i])&&!br_is_on_ex) begin
					clear_index_table_n[1] = i; 
					found_issue = 1'b1;
					busy_table_n2[i] = 1'b0; // flip busy_table to 0 (empty)
					T1_ready_table_n1[i] = 1'b0; // flip ready_table to 0 (non ready)
					T2_ready_table_n1[i] = 1'b0;
					issue_is_1 = 1'b1; // set to 1 if a valid issuable entry is found, will set to Bus_1
				end
			end
		end

		case(busy_table_n2)			
			8'hf_f,
			8'b1111_1110,
			8'b1111_1101,
			8'b1111_1011,
			8'b1111_0111,
			8'b1110_1111,
			8'b1101_1111,
			8'b1011_1111,
			8'b0111_1111:	busy_out = 1;
			default:	busy_out = 0;
		endcase
		

		T1_ready_table_n_sol	= T1_ready_table_n1;
		T2_ready_table_n_sol	= T2_ready_table_n1;

		//Pre_evaluation RAW
		if (map_table_T_in == map_table_T1_in_1) begin
			T1_table_n_nohazard=free_list_in_0;
			T1_ready_table_n_nohazard = 1'b0; //There won't be a plus sign for reg in T1, since it depends on a previous instruction which is dispatched at the same time
		end else begin
			T1_table_n_nohazard = map_table_T1_in_1;
			T1_ready_table_n_nohazard = map_table_T1_ready_in_1;
		end

		if (map_table_T_in == map_table_T2_in_1) begin
			T2_table_n_nohazard=free_list_in_0;
			T2_ready_table_n_nohazard = 1'b0;
		end else begin
			T2_table_n_nohazard = map_table_T2_in_1;
			T2_ready_table_n_nohazard = map_table_T2_ready_in_1;			
		end		

		busy_table_n3 = busy_table_n2;

		if (dispatch_enable_0) begin
			found_empty = 1'b0;
			for (int i = 0; i < `N_ENTRY_RS; i++) begin
				//check for empty space;
				if ((!found_empty) && (busy_table_n2[i] == 1'b0)) begin
					dispatch_index_table_n[0] = i; // found a dispatch entry available
					found_empty = 1'b1;		// flip the found_emtpy bit and jump out from the rest of search
					busy_table_n3[i] = 1'b1;	// set the busy_table to full 1'b1
					dispatch_is_0 = 1;
					T1_ready_table_n_sol[i] = map_table_T1_ready_in_0;
					T2_ready_table_n_sol[i] = map_table_T2_ready_in_0;
				end
			end
		end
		busy_table_n4 = busy_table_n3;
		if (dispatch_enable_1) begin
			found_empty = 1'b0;
			for (int i = 0; i < `N_ENTRY_RS; i++) begin
				//check for empty space;
				if ((!found_empty) && (busy_table_n3[i] == 1'b0)) begin
					dispatch_index_table_n[1] = i; // same as above
					found_empty = 1'b1;
					busy_table_n4[i] = 1'b1;
					dispatch_is_1 = 1;
					T1_ready_table_n_sol[i] = T1_ready_table_n_nohazard;
					T2_ready_table_n_sol[i] = T2_ready_table_n_nohazard;
				end
			end
		end


		//correct_address = 0;
		if (br_correct) begin
			/*found_correct_bit = 0;	
			for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_correct_bit == 0 && recovery_b_mask[i]==1) begin
					found_correct_bit = 1;
					correct_address   = i;
				end
			end*/
			for (int i = 0; i < `N_ENTRY_RS; i++) begin
				b_mask_table_next[i][br_correct_address] = 0;
			end
		end
			
	end

	always_comb begin		
		if (issue_is_0) begin
			br_sol_out_0		= br_sol_table[clear_index_table_n[0]];
			b_mask_out_0		= b_mask_table[clear_index_table_n[0]];
			if (br_correct) begin
				b_mask_out_0[br_correct_address] = 0;
			end
			pre_target_PC_out_0	= pre_target_PC_table[clear_index_table_n[0]];
			id_NPC_out_0		= NPC_table[clear_index_table_n[0]];
			opa_select_out_0 	= opa_select_table[clear_index_table_n[0]];
			opb_select_out_0 	= opb_select_table[clear_index_table_n[0]];
			T1_out_0 		= T1_table[clear_index_table_n[0]];
			T2_out_0 		= T2_table[clear_index_table_n[0]];
			T_out_0  		= T_table[clear_index_table_n[0]];
			INSTR_out_0		= INSTR_table[clear_index_table_n[0]];
			rd_mem_out_0		= rd_mem_table[clear_index_table_n[0]];
			wr_mem_out_0		= wr_mem_table[clear_index_table_n[0]];
			ldl_mem_out_0		= ldl_mem_table[clear_index_table_n[0]];
			stc_mem_out_0		= stc_mem_table[clear_index_table_n[0]];
			cond_branch_out_0	= cond_branch_table[clear_index_table_n[0]];
			uncond_branch_out_0	= uncond_branch_table[clear_index_table_n[0]];
			halt_out_0		= halt_table[clear_index_table_n[0]];
			cpuid_out_0		= cpuid_table[clear_index_table_n[0]];
			illegal_out_0		= illegal_table[clear_index_table_n[0]];
			valid_inst_out_0	= valid_inst_table[clear_index_table_n[0]];
			func_out_0		= func_table[clear_index_table_n[0]];
		end else begin
			br_sol_out_0		= 0;
			b_mask_out_0		= 0;
			pre_target_PC_out_0	= 0;
			id_NPC_out_0		= 0;
			opa_select_out_0 	= ALU_OPA_IS_REGA;
			opb_select_out_0 	= ALU_OPB_IS_REGB;
			T1_out_0 		= `ZERO_REG;
			T2_out_0 		= `ZERO_REG;
			T_out_0			= `ZERO_REG;
			INSTR_out_0		= `NOOP_INST;
			rd_mem_out_0		= `FALSE;
			wr_mem_out_0		= `FALSE;
			ldl_mem_out_0		= `FALSE;
			stc_mem_out_0		= `FALSE;
			cond_branch_out_0	= `FALSE;
			uncond_branch_out_0	= `FALSE;
			halt_out_0		= `FALSE;
			cpuid_out_0		= `FALSE;
			illegal_out_0		= `FALSE;
			valid_inst_out_0	= `FALSE;
			func_out_0		= ALU_ADDQ;
		end
	end

	always_comb begin
		if (issue_is_1) begin
			br_sol_out_1		= br_sol_table[clear_index_table_n[1]];
			b_mask_out_1		= b_mask_table[clear_index_table_n[1]];
			if (br_correct) begin
				b_mask_out_1[br_correct_address] = 0;
			end
			pre_target_PC_out_1	= pre_target_PC_table[clear_index_table_n[1]];
			id_NPC_out_1		= NPC_table[clear_index_table_n[1]];
			opa_select_out_1 	= opa_select_table[clear_index_table_n[1]];
			opb_select_out_1 	= opb_select_table[clear_index_table_n[1]];
			T1_out_1 		= T1_table[clear_index_table_n[1]];
			T2_out_1 		= T2_table[clear_index_table_n[1]];
			T_out_1  		= T_table[clear_index_table_n[1]];
			INSTR_out_1		= INSTR_table[clear_index_table_n[1]];
			rd_mem_out_1		= rd_mem_table[clear_index_table_n[1]];
			wr_mem_out_1		= wr_mem_table[clear_index_table_n[1]];
			ldl_mem_out_1		= ldl_mem_table[clear_index_table_n[1]];
			stc_mem_out_1		= stc_mem_table[clear_index_table_n[1]];
			cond_branch_out_1	= cond_branch_table[clear_index_table_n[1]];
			uncond_branch_out_1	= uncond_branch_table[clear_index_table_n[1]];
			halt_out_1		= halt_table[clear_index_table_n[1]];
			cpuid_out_1		= cpuid_table[clear_index_table_n[1]];
			illegal_out_1		= illegal_table[clear_index_table_n[1]];
			valid_inst_out_1	= valid_inst_table[clear_index_table_n[1]];
			func_out_1		= func_table[clear_index_table_n[1]];
		end else begin
			br_sol_out_1		= 0;
			b_mask_out_1		= 0;
			id_NPC_out_1		= 0;
			pre_target_PC_out_1	= 0;
			opa_select_out_1 	= ALU_OPA_IS_REGA;
			opb_select_out_1 	= ALU_OPB_IS_REGB;
			T1_out_1 		= `ZERO_REG;
			T2_out_1 		= `ZERO_REG;
			T_out_1			= `ZERO_REG;
			INSTR_out_1		= `NOOP_INST;
			rd_mem_out_1		= `FALSE;
			wr_mem_out_1		= `FALSE;
			ldl_mem_out_1		= `FALSE;
			stc_mem_out_1		= `FALSE;
			cond_branch_out_1	= `FALSE;
			uncond_branch_out_1	= `FALSE;
			halt_out_1		= `FALSE;
			cpuid_out_1		= `FALSE;
			illegal_out_1		= `FALSE;
			valid_inst_out_1	= `FALSE;
			func_out_1		= ALU_ADDQ;
		end
	end

	/*always_comb begin
		case ({issue_is_1, issue_is_0})
			2'b11: 		available_entries_n_inter = available_entries+2;
			2'b10,2'b01:	available_entries_n_inter = available_entries+1;
			2'b00:		available_entries_n_inter = available_entries;
		endcase // {issue_is_1, issue_is_0}
		case ({dispatch_is_1, dispatch_is_0})
			2'b11:		available_entries_n = available_entries_n_inter-2;
			2'b01,2'b10:	available_entries_n = available_entries_n_inter-1;
			2'b00:		available_entries_n = available_entries_n_inter;
		endcase // {dispatch_is_1, dispatch_is_0}
	end*/

	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if (reset) begin
			//available_entries <= `SD `N_ENTRY_RS; //to represent [`N_ENTRY_RS:1] available entry lines in RS
			for (int i = 0; i < `N_ENTRY_RS; i++) begin
				pre_target_PC_table[i]	<= `SD 0;
				br_sol_table[i]		<= `SD 0;
				b_mask_table[i]		<= `SD 0;
				is_br_table[i]		<= `SD 1'b0;
				busy_table[i]		<= `SD 1'b0;
				INSTR_table[i]		<= `SD `NOOP_INST;
				T1_ready_table[i]	<= `SD 1'b0; //map_table_T1_table?
				T2_ready_table[i]	<= `SD 1'b0; //represent the plus sign in RS table
				T_table[i]		<= `SD `ZERO_REG;
				T1_table[i]		<= `SD `ZERO_REG; //
				T2_table[i]		<= `SD `ZERO_REG; //31, represent no tag is needed
				opa_select_table[i]	<= `SD ALU_OPA_IS_REGA; //DEFAULT value
				opb_select_table[i]	<= `SD ALU_OPB_IS_REGB; //DEFAULT value
				func_table[i]		<= `SD ALU_ADDQ; 	//DEFAULT value				
				rd_mem_table[i] 	<= `SD `FALSE; //DONT TOUCH MEM
				wr_mem_table[i] 	<= `SD `FALSE; //DONT TOUCH MEM
				ldl_mem_table[i] 	<= `SD `FALSE; //DEFAULT value
				stc_mem_table[i] 	<= `SD `FALSE; //DEFAULT value
				cond_branch_table[i]	<= `SD `FALSE; //DEFAULT value
				uncond_branch_table[i]	<= `SD `FALSE; //DEFAULT value
				halt_table[i]		<= `SD `FALSE; //DEFAULT value
				cpuid_table[i] 		<= `SD `FALSE; //DEFAULT value
				illegal_table[i] 	<= `SD `FALSE; //DEFAULT value
				valid_inst_table[i] 	<= `SD `FALSE; //DEFAULT value
				NPC_table[i]		<= `SD 0;
			end
		end else begin
			//available_entries	<= `SD available_entries_n; //update the number of empty entries
			pre_target_PC_table	<= `SD pre_target_PC_table_next;
			br_sol_table		<= `SD br_sol_table_next;
			b_mask_table		<= `SD b_mask_table_next;
			is_br_table		<= `SD is_br_table_n;
			busy_table 		<= `SD busy_table_n4;
			if (dispatch_enable_0) begin
				pre_target_PC_table[dispatch_index_table_n[0]]	<= `SD pre_target_PC_in_0;
				br_sol_table[dispatch_index_table_n[0]]		<= `SD br_sol_0;
				is_br_table[dispatch_index_table_n[0]]		<= `SD is_br_0;
				b_mask_table[dispatch_index_table_n[0]]		<= `SD b_mask_in_0;
				NPC_table[dispatch_index_table_n[0]]		<= `SD if_id_NPC_0;
				T1_table[dispatch_index_table_n[0]]		<= `SD map_table_T1_in_0;
				T2_table[dispatch_index_table_n[0]]		<= `SD map_table_T2_in_0;
				func_table[dispatch_index_table_n[0]]		<= `SD func_in_0;
				opa_select_table[dispatch_index_table_n[0]]	<= `SD opa_select_in_0;
				opb_select_table[dispatch_index_table_n[0]]	<= `SD opb_select_in_0;
				T_table[dispatch_index_table_n[0]]		<= `SD free_list_in_0; 	
				INSTR_table[dispatch_index_table_n[0]]		<= `SD INSTR_in_0;
				rd_mem_table[dispatch_index_table_n[0]]		<= `SD rd_mem_in_0;
				wr_mem_table[dispatch_index_table_n[0]]		<= `SD wr_mem_in_0;
				ldl_mem_table[dispatch_index_table_n[0]]	<= `SD ldl_mem_in_0;
				stc_mem_table[dispatch_index_table_n[0]]	<= `SD stc_mem_in_0;
				cond_branch_table[dispatch_index_table_n[0]]	<= `SD cond_branch_in_0;
				uncond_branch_table[dispatch_index_table_n[0]]	<= `SD uncond_branch_in_0;
				halt_table[dispatch_index_table_n[0]]		<= `SD halt_in_0;
				cpuid_table[dispatch_index_table_n[0]]		<= `SD cpuid_in_0;
				illegal_table[dispatch_index_table_n[0]]	<= `SD illegal_in_0;
				valid_inst_table[dispatch_index_table_n[0]]	<= `SD valid_inst_in_0;
			end

			if (dispatch_enable_1) begin
				pre_target_PC_table[dispatch_index_table_n[1]]	<= `SD pre_target_PC_in_1;
				br_sol_table[dispatch_index_table_n[1]]		<= `SD br_sol_1;
				is_br_table[dispatch_index_table_n[1]]		<= `SD is_br_1;
				b_mask_table[dispatch_index_table_n[1]]		<= `SD b_mask_in_1;
				NPC_table[dispatch_index_table_n[1]]		<= `SD if_id_NPC_1;
				T1_table[dispatch_index_table_n[1]]		<= `SD T1_table_n_nohazard;
				T2_table[dispatch_index_table_n[1]]		<= `SD T2_table_n_nohazard;
				func_table[dispatch_index_table_n[1]]		<= `SD func_in_1;
				opa_select_table[dispatch_index_table_n[1]]	<= `SD opa_select_in_1;
				opb_select_table[dispatch_index_table_n[1]]	<= `SD opb_select_in_1;
				T_table[dispatch_index_table_n[1]]		<= `SD free_list_in_1;	
				INSTR_table[dispatch_index_table_n[1]]		<= `SD INSTR_in_1;
				rd_mem_table[dispatch_index_table_n[1]]		<= `SD rd_mem_in_1;
				wr_mem_table[dispatch_index_table_n[1]]		<= `SD wr_mem_in_1;
				ldl_mem_table[dispatch_index_table_n[1]]	<= `SD ldl_mem_in_1;
				stc_mem_table[dispatch_index_table_n[1]]	<= `SD stc_mem_in_1;
				cond_branch_table[dispatch_index_table_n[1]]	<= `SD cond_branch_in_1;
				uncond_branch_table[dispatch_index_table_n[1]]	<= `SD uncond_branch_in_1;
				halt_table[dispatch_index_table_n[1]]		<= `SD halt_in_1;
				cpuid_table[dispatch_index_table_n[1]]		<= `SD cpuid_in_1;
				illegal_table[dispatch_index_table_n[1]]	<= `SD illegal_in_1;
				valid_inst_table[dispatch_index_table_n[1]]	<= `SD valid_inst_in_1;
			end
			T1_ready_table		<= `SD T1_ready_table_n_sol; //
			T2_ready_table		<= `SD T2_ready_table_n_sol; //update the plus sign in RS table

		end
	end
endmodule
