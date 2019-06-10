`timescale 1ns/100ps
module recovery(
	input	clock,
	input	reset,
	//renre shot
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_0,		// tag from CDB
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] CDB_in_1,		//
	input	free_PR_0,
	input	free_PR_1,
	input   [$clog2(`N_ENTRY_ROB+33)-1:0] Told_free_0,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] Told_free_1,
	//taking snapshot
	input	empty_shot,
	input	snapshot_enable,
	input	[31:0][$clog2(`N_ENTRY_ROB+33)-1:0] map_tag_table,
	input	[31:0] map_ready_table,
	//input	[63:0] recovery_PC,
	input	[$clog2(`N_ENTRY_ROB)-1:0] ROB_tail,
	input	[$clog2(`N_ENTRY_SQ)-1:0] SQ_tail,
	input	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] freelist_tag,
	input	[$clog2(`N_ENTRY_ROB)-1:0] freelist_pointer,
	input	freelist_empty,
	//recoverying
	input	br_correct,
	input	recovery_request,
	input	[`STACK_NUM-1:0] recovery_mask,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_tail_shot,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out0,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] rt_Tnew_out1,
	input	rt_valid_0,
	input	rt_valid_1,


	output	logic	[31:0][$clog2(`N_ENTRY_ROB+33)-1:0] map_tag_table_out,
	output	logic	[31:0] map_ready_table_out,
	//output	logic	[63:0] recovery_PC_out,
	output	logic	[$clog2(`N_ENTRY_ROB)-1:0] ROB_tail_out,
	output	logic	[$clog2(`N_ENTRY_SQ)-1:0] SQ_tail_out,
	output	logic	[`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] freelist_tag_out,
	output	logic	[$clog2(`N_ENTRY_ROB)-1:0] freelist_pointer_out,
	output	logic	freelist_empty_out,
	output	logic	[`STACK_NUM-1:0] b_mask_out,
	output	logic	[$clog2(`STACK_NUM)-1:0] space_address,
	output	logic	recovery_busy,
	output	logic	SQ_empty_recovery,
	output	logic	[$clog2(`STACK_NUM)-1:0]br_correct_address
	
);
	logic	[`STACK_NUM-1:0][31:0][$clog2(`N_ENTRY_ROB+33)-1:0] map_tag_table_stack, map_tag_table_stack_next;
	logic	[`STACK_NUM-1:0][31:0] map_ready_table_stack, map_ready_table_stack_next;
	//logic	[`STACK_NUM-1:0][63:0] recovery_PC_stack, recovery_PC_stack_next;
	logic	[`STACK_NUM-1:0][$clog2(`N_ENTRY_ROB)-1:0] ROB_tail_stack, ROB_tail_stack_next;
	logic	[`STACK_NUM-1:0][$clog2(`N_ENTRY_ROB)-1:0] SQ_tail_stack, SQ_tail_stack_next;
	logic	[`STACK_NUM-1:0][`N_ENTRY_ROB-1:0] [$clog2(`N_ENTRY_ROB+33)-1:0] freelist_tag_stack, freelist_tag_stack_next;
	logic	[`STACK_NUM-1:0][$clog2(`N_ENTRY_ROB)-1:0] freelist_pointer_stack, freelist_pointer_stack_next;
	logic	[`STACK_NUM-1:0] freelist_empty_stack, freelist_empty_stack_next;
	logic	[`STACK_NUM-1:0] b_mask_reg, b_mask_reg_next;
	logic	[`STACK_NUM-1:0] SQ_empty_stack, SQ_empty_stack_next;
	logic	free_PR_0_sol;
	logic	free_PR_1_sol;
	logic	[$clog2(`STACK_NUM)-1:0] recovery_address;
	logic	found_correct_bit,found_recovery_bit;
	logic	found_first_1;
	logic	[`STACK_NUM-1:0][$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_tail_stack, dest_reg_tail_stack_next;



	assign 	b_mask_out = b_mask_reg_next;

	assign	free_PR_0_sol = free_PR_0 && !(Told_free_0 == `ZERO_REG);
	assign	free_PR_1_sol = free_PR_1 && !(Told_free_1 == `ZERO_REG);
	//assign	busy_mask = 0-1;
	assign	recovery_busy = b_mask_reg[0];

	
	always_comb begin
		dest_reg_tail_stack_next = dest_reg_tail_stack;
		map_tag_table_stack_next = map_tag_table_stack;
		map_ready_table_stack_next = map_ready_table_stack;
		//recovery_PC_stack_next = recovery_PC_stack;
		ROB_tail_stack_next = ROB_tail_stack;
		SQ_tail_stack_next = SQ_tail_stack;
		freelist_tag_stack_next = freelist_tag_stack;	//tag default here
		freelist_pointer_stack_next = freelist_pointer_stack;
		freelist_empty_stack_next = freelist_empty_stack;
		b_mask_reg_next = b_mask_reg;
		SQ_empty_stack_next = SQ_empty_stack;
		space_address = 0;
		recovery_address = 0;
		found_correct_bit = 0;
		found_recovery_bit = 0;
		br_correct_address = 0;

	for (int i = 0 ; i < `STACK_NUM ; i++) begin
		for (int j = 0 ; j < 32 ; j++) begin
			if ((map_tag_table_stack[i][j] == CDB_in_0 || map_tag_table_stack[i][j] == CDB_in_1) && b_mask_reg[i] == 1'b1) begin
				map_ready_table_stack_next[i][j] = 1'b1;
			end
		end

		if(free_PR_0_sol && free_PR_1_sol) begin
			freelist_empty_stack_next[i] = 1'b0;
			if(freelist_empty_stack[i]) begin
				freelist_pointer_stack_next[i] = `N_ENTRY_ROB-2;
				freelist_tag_stack_next[i][`N_ENTRY_ROB-1] = Told_free_0;
				freelist_tag_stack_next[i][`N_ENTRY_ROB-2] = Told_free_1;
			end
			else begin
				freelist_pointer_stack_next[i] = freelist_pointer_stack[i]-2;
				freelist_tag_stack_next[i][freelist_pointer_stack[i]-1] = Told_free_0;
				freelist_tag_stack_next[i][freelist_pointer_stack[i]-2] = Told_free_1;
			end
		end
		else if(free_PR_0_sol || free_PR_1_sol) begin
			freelist_empty_stack_next[i] = 1'b0;
			if(freelist_empty_stack[i]) begin
				freelist_pointer_stack_next[i] = `N_ENTRY_ROB-1;
			end
			else begin
				freelist_pointer_stack_next[i] = freelist_pointer_stack[i]-1;
			end
			if(free_PR_0_sol)  freelist_tag_stack_next[i][freelist_pointer_stack_next[i]] = Told_free_0;
			else freelist_tag_stack_next[i][freelist_pointer_stack_next[i]] = Told_free_1;
		end
		else begin
			freelist_empty_stack_next[i] = freelist_empty_stack[i];
			freelist_pointer_stack_next[i] = freelist_pointer_stack[i];
		end
	end
	for (int i = 0 ; i < `STACK_NUM ; i++) begin
		if((rt_valid_0 && (rt_Tnew_out0 == dest_reg_tail_stack[i]))||(rt_valid_1 && (rt_Tnew_out1 == dest_reg_tail_stack[i])))
			SQ_empty_stack_next[i] = 1;
	end
		

		if (snapshot_enable) begin
			if (b_mask_reg==0) begin
				b_mask_reg_next[`STACK_NUM-1]	= 1;
				space_address 			= `STACK_NUM-1;
			end else begin

			found_first_1 = 0;
			for (int i = 1; i<`STACK_NUM; i++) begin
				if (found_first_1 == 0 && b_mask_reg[i]==1) begin
					b_mask_reg_next[i-1]	= 1;
					found_first_1 		= 1;
					space_address 		= i-1;
				end
			end
			end
			map_tag_table_stack_next[space_address]		= map_tag_table;
			map_ready_table_stack_next[space_address]	= map_ready_table;
			//recovery_PC_stack_next[space_address]		= recovery_PC;
			ROB_tail_stack_next[space_address]		= ROB_tail;
			SQ_tail_stack_next[space_address]		= SQ_tail;
			freelist_tag_stack_next[space_address]		= freelist_tag;
			freelist_pointer_stack_next[space_address]	= freelist_pointer;
			freelist_empty_stack_next[space_address]	= freelist_empty;
			SQ_empty_stack_next[space_address]		= empty_shot;
			dest_reg_tail_stack_next[space_address]		= dest_reg_tail_shot;
		end
		if (recovery_request) begin
			for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_recovery_bit == 0 && recovery_mask[i]==1) begin
					found_recovery_bit 	= 1;
					recovery_address 	= i;
				end
			end
			for (int i = 0; i<=recovery_address; i++) begin
				b_mask_reg_next[i]=0;
			end
			map_tag_table_out 	= map_tag_table_stack[recovery_address];
			map_ready_table_out	= map_ready_table_stack_next[recovery_address];
			ROB_tail_out		= ROB_tail_stack[recovery_address];
			SQ_tail_out		= SQ_tail_stack[recovery_address];
			freelist_tag_out	= freelist_tag_stack_next[recovery_address];
			freelist_pointer_out	= freelist_pointer_stack_next[recovery_address];
			freelist_empty_out	= freelist_empty_stack_next[recovery_address];
			SQ_empty_recovery	= SQ_empty_stack_next[recovery_address];
		end else begin
			map_tag_table_out 	= 0;
			map_ready_table_out	= 0;
			ROB_tail_out		= 0;
			SQ_tail_out		= 0;
			freelist_tag_out	= 0;
			freelist_pointer_out	= 0;
			freelist_empty_out	= 0;
			SQ_empty_recovery	= 0;
			
		end
		if (br_correct) begin
			for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_correct_bit == 0 && recovery_mask[i]==1) begin
					found_correct_bit 	= 1;
					br_correct_address	= i;
					b_mask_reg_next[i]=0;
				end
			end

		end
		
	end

  // synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if (reset) begin
			map_tag_table_stack	<= `SD	0;
			map_ready_table_stack	<= `SD	0;
			//recovery_PC_stack	<= `SD	0;
			ROB_tail_stack		<= `SD	0;
			SQ_tail_stack		<= `SD	0;
			freelist_tag_stack	<= `SD	0;
			freelist_pointer_stack	<= `SD	0;
			freelist_empty_stack	<= `SD	0;
			b_mask_reg		<= `SD	0;
			SQ_empty_stack		<= `SD	0;
			dest_reg_tail_stack 	<= `SD	0;

		end else begin
			map_tag_table_stack	<= `SD	map_tag_table_stack_next;
			map_ready_table_stack	<= `SD	map_ready_table_stack_next;
			//recovery_PC_stack	<= `SD	recovery_PC_stack_next;
			ROB_tail_stack		<= `SD	ROB_tail_stack_next;
			SQ_tail_stack		<= `SD	SQ_tail_stack_next;
			freelist_tag_stack	<= `SD	freelist_tag_stack_next;
			freelist_pointer_stack	<= `SD	freelist_pointer_stack_next;
			freelist_empty_stack	<= `SD	freelist_empty_stack_next;
			b_mask_reg		<= `SD	b_mask_reg_next;
			SQ_empty_stack		<= `SD	SQ_empty_stack_next;
			dest_reg_tail_stack 	<= `SD	dest_reg_tail_stack_next;
		end
	end
endmodule
