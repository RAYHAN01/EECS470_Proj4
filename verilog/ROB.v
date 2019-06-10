`timescale 1ns/100ps
module ROB(
	input	clock,							//
	input	reset,							//
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] freelist_1,		
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] freelist_0,		// Tnew write in
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1,			// tag from CDB
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0,			// tag from CDB
	input	fetch_PR_0,fetch_PR_1,					// if dispatch
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_Told_in_0,	// Told write in
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] map_table_Told_in_1,
	input	ROB_halt_in_0, ROB_halt_in_1,

	input	is_0_br,						//if dispatched instruction is branch 					
	input	recovery_br,						//if request recovery
	input	[$clog2(`N_ENTRY_ROB)-1:0] recovery_tail,		//tail used for recovery

	input	is_0_st,
	input	is_1_st,

	output	logic busy,						//tell other blocks if ROB is full right now
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_0,
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_1,		//Told of retiring instruction
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_0,		//Tnew of retiring instruction
	output	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_1,
	output	logic rt_valid_0,			
	output	logic rt_valid_1,					//if retire (to ARCH.map) 
	output	logic ROB_halt_out_0,
	output	logic ROB_halt_out_1,

	output	logic [$clog2(`N_ENTRY_ROB)-1:0] tail_pointer		//output for branch recovery
);

	logic	[$clog2(`N_ENTRY_ROB)-1:0] head, head_minus_1, head_minus_2,head_plus_2, head_plus_1, next_head, next_head_inter, next_head_sol;  //head
	logic	[$clog2(`N_ENTRY_ROB)-1:0] tail, tail_plus_1, tail_plus_2, tail_minus_1, next_tail, next_tail_sol, next_tail_minus_1, recovery_tail_minus_one,recovery_tail_minus_two;    //tail
	logic	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] Told_table;  //Store Told
	logic	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_table;  //Store Tnew
	logic	[`N_ENTRY_ROB-1:0] T_ready, next_T_ready, halt_table;	      //Store if this instruction is ready now
	logic   next_all_empty, all_empty,all_empty_inter,all_empty_sol;
	logic	[`N_ENTRY_ROB-1:0] st_table;
	logic	head_is_st;
	logic	rt_enable,rt_enable_1;


	assign next_tail_minus_1 = next_tail -1;
	assign head_minus_1 = head - 1;
	assign head_plus_1  = head + 1;
	assign head_minus_2 = head - 2;
	assign head_plus_2  = head + 2;
	assign tail_plus_1  = tail + 1;
	assign tail_plus_2  = tail + 2;
	assign tail_minus_1 = tail - 1;
	assign busy = ((tail == head_minus_1)||(tail == head_minus_2))? 1'b1 : 1'b0;	//check if ROB is busy now.  
	assign head_is_st = st_table[head];

  // synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset) begin								//reset head/tail to the start point
			head          <= `SD 0;
			tail          <= `SD 0;
			Told_table    <= `SD 0;						//clear the first row's tags 
			Tnew_table    <= `SD 0;
			halt_table    <= `SD `FALSE;
			next_all_empty<= `SD 1;
			for(int i=0; i<`N_ENTRY_ROB; i++) begin
				T_ready[i]	<= `SD 0;
				st_table[i]	<= `SD 0;					//clear T ready table
			end		
		end
		else begin
			head			<= `SD next_head_sol;
			tail			<= `SD next_tail_sol;
			next_all_empty		<= `SD all_empty_sol;
			for(int i=0; i<`N_ENTRY_ROB ; i++) begin			//pass ready bit
				T_ready[i]	<= `SD next_T_ready[i];					
			end
			case({fetch_PR_0, fetch_PR_1})
				2'b11: begin				
					Tnew_table[next_tail_minus_1]		<= `SD freelist_0;	    	//fetch PR from freelist
					Told_table[next_tail_minus_1]		<= `SD map_table_Told_in_0; 	//fetch Told tag from maptable
					halt_table[next_tail_minus_1]		<= `SD ROB_halt_in_0;	    	//Record halt instruction
					Tnew_table[next_tail]			<= `SD freelist_1;
					Told_table[next_tail]			<= `SD map_table_Told_in_1;
					halt_table[next_tail]			<= `SD ROB_halt_in_1;
					st_table[next_tail_minus_1]		<= `SD is_0_st;
					st_table[next_tail]			<= `SD is_1_st;
				end
				2'b10: begin
					Tnew_table[next_tail]	<= `SD freelist_0;
					Told_table[next_tail]	<= `SD map_table_Told_in_0;
					halt_table[next_tail]	<= `SD ROB_halt_in_0;
					st_table[next_tail]	<= `SD is_0_st;					
				end
				2'b01: begin
					Tnew_table[next_tail]	<= `SD freelist_1;
					Told_table[next_tail]	<= `SD map_table_Told_in_1;
					halt_table[next_tail]   <= `SD ROB_halt_in_1;
					st_table[next_tail]	<= `SD is_1_st;
				end
				2'b00: begin	end
			endcase // {fetch_PR_0, fetch_PR_1}
		end
	end
		
	always_comb begin
		Told_out_0      = `ZERO_REG;							//set tag
		Told_out_1      = `ZERO_REG;
		Tnew_out_0      = `ZERO_REG;
		Tnew_out_1      = `ZERO_REG;
		ROB_halt_out_0  = `FALSE; // Latch ADD
		ROB_halt_out_1  = `FALSE; // Latch ADD
		all_empty       = next_all_empty;
		all_empty_inter = next_all_empty;
		rt_enable_1	= 1;
		for(int i=0;i < `N_ENTRY_ROB; i++) begin			// Search all entries to match CDB for make it ready  
			if(CDB_in_0 == Tnew_table[i]||CDB_in_1 == Tnew_table[i]) begin
				next_T_ready[i] = 1;
				if(st_table[i] && ((head==i)|| (i==head_plus_1))) begin
					rt_enable_1 = 0;		
				end
			end			
			else						//else stay ready state
				next_T_ready[i] = T_ready[i];
		end							//CDB cam & set	
		if(rt_enable_1 && rt_enable && next_T_ready[head] & !next_all_empty) begin				 //Can first instruction retire?
			rt_valid_0      = 1;
			Told_out_0      = Told_table[head];			 //output signal for refreshing arch.map
			Tnew_out_0      = Tnew_table[head];
			ROB_halt_out_0  = halt_table[head];
			next_head       = head_plus_1;
			next_head_inter = head_plus_1;
			if(head==tail) begin					//last instruction to retire
				rt_valid_1       = 0;
				all_empty        = 1;
				all_empty_inter  = 1;
				next_head        = head;
			end
			else if(next_T_ready[next_head_inter] && !(head_is_st && st_table[next_head_inter])) begin		 //Can second instruction retire?
				rt_valid_1     = 1;
				Told_out_1     = Told_table[next_head_inter];    //output signal for refreshing arch.map
				Tnew_out_1     = Tnew_table[next_head_inter];
				ROB_halt_out_1 = halt_table[next_head_inter];
				next_head      = head_plus_2;			 //head goes down two rows
				if(head==tail_minus_1) begin
					all_empty        = 1;
					all_empty_inter  = 1;
					next_head        = head_plus_1;
				end
			end
			else 	rt_valid_1 = 0;
		end
		else begin
			next_head  = head;				//No retire.
			rt_valid_0 = 0;
			rt_valid_1 = 0;
		end						//fetch instructions
		if((next_head==tail) && all_empty_inter) begin	//set head tail when fetch instruction at the beginning
			case({fetch_PR_0, fetch_PR_1})
				2'b11: begin
					next_tail		= tail_plus_1;
					next_T_ready[next_tail]	= 0;
					next_T_ready[tail]	= 0;
					all_empty		= 0;					
				end
				2'b10,2'b01: begin
					next_tail		= tail;
					next_T_ready[tail]	= 0;
					all_empty		= 0;
				end
				2'b00: begin
					next_tail		= tail;
					all_empty		= all_empty_inter;
				end
			endcase
		end else begin
			case({fetch_PR_0, fetch_PR_1})
				2'b11: begin
					next_tail		= tail_plus_2;
					next_T_ready[next_tail]	= 0;
					next_T_ready[tail_plus_1]= 0;
					all_empty		= 0;					
				end
				2'b10,2'b01: begin
					next_tail		= tail_plus_1;
					next_T_ready[next_tail]	= 0;
					all_empty		= 0;
				end
				2'b00: begin
					next_tail		= tail;
					all_empty		= all_empty_inter;
				end
			endcase
		end
	end
	assign rt_enable = recovery_br? 1'b0 : 1'b1;
	assign tail_pointer = (is_0_br && fetch_PR_0 && fetch_PR_1)? next_tail_minus_1 : next_tail;  // Only when dispatch two instructions and the first is branch chooose -1
	assign next_head_sol = next_head;
	assign all_empty_sol = all_empty;
	assign next_tail_sol = recovery_br? recovery_tail : next_tail;		   // When recovery, refresh tail
endmodule
