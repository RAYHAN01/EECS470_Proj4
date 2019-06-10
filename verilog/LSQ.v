`timescale 1ns/100ps
module SQ(
	input clock,
	input reset,
	input SQ_empty_recovery,
	input [$clog2(`N_ENTRY_ROB+33)-1:0] ROB_dest_0,
	input [$clog2(`N_ENTRY_ROB+33)-1:0] ROB_dest_1,// compare tag to find which store in SQ can retire .
	input [$clog2(`N_ENTRY_ROB+33)-1:0] freelist_pr_in_0, 
	input [$clog2(`N_ENTRY_ROB+33)-1:0] freelist_pr_in_1, //renamed tag from freelist.
	input [$clog2(`N_ENTRY_ROB+33)-1:0] EX_pr_in_0, 
	input [$clog2(`N_ENTRY_ROB+33)-1:0] EX_pr_in_1, //renamed tag from freelist.
	input [63:0] Data_in_0,
	input [63:0] Data_in_1,// data from ALU at ex stage.
	input [63:0] address_in_0,
	input [63:0] address_in_1,//address from ALU at ex stage.
	input dispatch_enable_0,
	input dispatch_enable_1,
	input wr_mem_in_0, wr_mem_in_1, //detect store instruction for dispatch
	input rd_mem_in_0, //detect load before stores
	//input valid_tail_in_0, valid_tail_in_1,
	input rt_ready_0, rt_ready_1,// detect if store retire in the ROB and move head.
	input EX_wr_mem_0, EX_wr_mem_1,//detect if store execute

	input	is_0_br_SQ,
	input	recovery_br_SQ,
	input	[$clog2(`N_ENTRY_SQ)-1:0] recovery_tail_SQ,

	output logic [$clog2(`N_ENTRY_SQ)-1:0] tail_pointer_SQ,
	output logic is_0_st,

	output logic busy,
	output logic [63:0] Data_out,// output store data for Dcache
	output logic Data_out_en,
	output logic [63:0] address_out,//output store address for Dcache.
	output logic [$clog2(`N_ENTRY_SQ)-1:0] store_position_out,// load position to RS.
	output logic all_empty_inter,
	output logic [`N_ENTRY_SQ-1:0] ST_ready,// ready table for LQ.=
	output logic [$clog2(`N_ENTRY_SQ)-1:0]	head,// For LQ.
	output logic [`N_ENTRY_SQ-1:0][63:0] store_Data_table,
	output logic [`N_ENTRY_SQ-1:0][63:0] store_address_table,
	output logic empty_shot_SQ,
	output logic [$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_tail_shot,
	output logic [$clog2(`N_ENTRY_SQ)-1:0] tail
);

	logic	[$clog2(`N_ENTRY_SQ)-1:0] next_tail_sol;
	logic	[$clog2(`N_ENTRY_SQ)-1:0] next_head_sol;
	logic	all_empty_sol;

	logic [$clog2(`N_ENTRY_SQ)-1:0] next_tail, tail_minus_one, tail_plus_one, tail_plus_two,recovery_tail_plus_one;
	logic [$clog2(`N_ENTRY_SQ)-1:0] next_head;
	logic [$clog2(`N_ENTRY_SQ)-1:0] head_plus_one, head_minus_one, head_minus_two;
	logic [`N_ENTRY_SQ-1:0] ST_ready_table, ST_ready_table_inter; 
	logic [`N_ENTRY_SQ-1:0][$clog2(`N_ENTRY_ROB+33)-1:0] store_T_table;
	logic [`N_ENTRY_SQ-1:0][$clog2(`N_ENTRY_ROB+33)-1:0] store_T_table_next;
	logic [`N_ENTRY_SQ-1:0][63:0] store_Data_table_next; // data table for LQ.
	logic [`N_ENTRY_SQ-1:0][63:0] store_address_table_next;// address table for LQ.
	logic able_to_dispatch_0, able_to_dispatch_1;
	logic  next_all_empty, all_empty;
	assign recovery_tail_plus_one = recovery_tail_SQ + 1;
	assign busy = ((tail == head_minus_two)||(tail == head_minus_one))? 1'b1 : 1'b0;// calculate busy bit.
	assign head_plus_one	= head + 1;
	assign head_minus_one	= head - 1;
	assign head_minus_two	= head - 2;
	assign tail_minus_one	= tail - 1;
	assign tail_plus_one	= tail + 1;
	assign tail_plus_two	= tail + 2;
	assign able_to_dispatch_0 = wr_mem_in_0 && dispatch_enable_0;
	assign able_to_dispatch_1 = wr_mem_in_1 && dispatch_enable_1;
	assign is_0_st = able_to_dispatch_0;
	always_comb begin
//First Check Ex-value:
//////////////////////////////////////////
		ST_ready_table = ST_ready;
		store_Data_table_next = store_Data_table;
		store_address_table_next = store_address_table;
		all_empty       = next_all_empty;
		all_empty_inter = next_all_empty;
		for (int i=0; i < `N_ENTRY_SQ; i++) begin/////////////////////////////if store is executed, the entry in SQ will be ready.  
			if (store_T_table[i] == EX_pr_in_0 && EX_wr_mem_0) begin
				ST_ready_table [i]		= 1'b1;
				store_Data_table_next[i]	= Data_in_0;
				store_address_table_next[i]	= address_in_0;
			end
			if (store_T_table[i] == EX_pr_in_1 && EX_wr_mem_1) begin
				ST_ready_table [i]		= 1'b1;
				store_Data_table_next[i]	= Data_in_1;
				store_address_table_next[i]	= address_in_1;
			end
		end

//Second Check Retire:
///////////////////////////////////////////////////////////////////////////////// when retire, move head and send data and address to Dcache 
		//next_head = head;
		if((store_T_table[head] == ROB_dest_0) && !next_all_empty && rt_ready_0) begin // TO DO explain
				Data_out    		= store_Data_table_next[head];
				Data_out_en		= 1'b1;
				address_out 		= store_address_table_next[head];
				next_head 		= head_plus_one;
				if(head == tail) begin
					next_head	= head;

					all_empty_inter  = 1'b1;
				end		
			end
		else if ((store_T_table[head] == ROB_dest_1) && rt_ready_1 && !next_all_empty) begin
				Data_out    		= store_Data_table_next[head];
				Data_out_en		= 1'b1;
				address_out 		= store_address_table_next[head];
				next_head 		= head_plus_one;
				if(head == tail) begin
					next_head	= head;

					all_empty_inter  = 1'b1;
				end
		end
		else begin
				next_head = head;		
				Data_out_en		= 1'b0;
				address_out		= 64'h0;
				Data_out		= 64'h0;
			end	

//Dispatch into STQ
///////////////////////////////////////// calculate tail position and update ready table if new store  are dispatch. If busy the SQ stall.
		ST_ready_table_inter	= ST_ready_table;
		store_T_table_next 	= store_T_table;
		if(head == tail && all_empty_inter) begin
			case ({able_to_dispatch_1, able_to_dispatch_0})
				2'b11:  begin
					next_tail			= tail_plus_one;
					store_position_out 		= next_tail;
					ST_ready_table_inter[tail]	= 1'b0;
					ST_ready_table_inter[tail_plus_one] = 1'b0;
					store_T_table_next[tail]	= freelist_pr_in_0;
					store_T_table_next[tail_plus_one] = freelist_pr_in_1;
					all_empty			= 1'b0;

				end
				2'b01: begin	
					next_tail 			= tail;
					ST_ready_table_inter[tail] 	= 1'b0;
					store_T_table_next[tail]	= freelist_pr_in_0;
					store_position_out		= tail;
					all_empty			= 1'b0;
				end
				2'b10: begin
					next_tail 			= tail;
					ST_ready_table_inter[tail] 	= 1'b0;
					store_T_table_next[tail]	= freelist_pr_in_1;
					store_position_out 		= tail;
					all_empty			= 0;
				end
				2'b00:  begin
					next_tail 			= tail;
					store_position_out 		= tail;
					all_empty			= all_empty_inter;
				end
			endcase
		end else begin
			case ({able_to_dispatch_1, able_to_dispatch_0})
				2'b11:  begin
					next_tail 				= tail_plus_two;
					ST_ready_table_inter[tail_plus_two] 	= 1'b0;
					ST_ready_table_inter[tail_plus_one]	= 1'b0;
					store_T_table_next[tail_plus_one]	= freelist_pr_in_0;
					store_T_table_next[tail_plus_two]	= freelist_pr_in_1;
					store_position_out 			= tail_plus_two;
					all_empty				= 1'b0;
				end
				2'b01:  begin			
					next_tail 				= tail_plus_one;
					ST_ready_table_inter[tail_plus_one] 	= 1'b0;	
					store_T_table_next[tail_plus_one]	= freelist_pr_in_0;
					store_position_out 			= tail_plus_one;
					all_empty				= 1'b0;
				end
				2'b10:  begin
					next_tail 				= tail_plus_one;
					ST_ready_table_inter [tail_plus_one] 	= 1'b0;	
					store_T_table_next[tail_plus_one]	= freelist_pr_in_1;
					all_empty				= 0;
					if (rd_mem_in_0) begin
						store_position_out	= tail;
					end else begin
						store_position_out	= tail_plus_one;
					end
				end
				2'b00: begin
					next_tail 				= tail;
					store_position_out 			= tail;
					all_empty				= all_empty_inter;
				end
			endcase
		end
	end
	assign dest_reg_tail_shot = (is_0_br_SQ && dispatch_enable_0 && dispatch_enable_1)? store_T_table[tail] : store_T_table_next[next_tail];
	assign empty_shot_SQ = is_0_br_SQ ? next_all_empty : all_empty;
	assign next_tail_sol = recovery_br_SQ? recovery_tail_SQ : next_tail;		   // When recovery, refresh tail
	assign tail_pointer_SQ = (is_0_br_SQ && dispatch_enable_0 && dispatch_enable_1)? tail : next_tail;
	assign next_head_sol = (recovery_br_SQ && (head == recovery_tail_plus_one) && !(recovery_tail_SQ == tail))? recovery_tail_SQ : next_head;
	assign all_empty_sol = (recovery_br_SQ && (((head == recovery_tail_plus_one) && !(recovery_tail_SQ == tail)) || SQ_empty_recovery))? 1'b1 : all_empty;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// reset 	
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset) begin
			head 			<= `SD 0;
			tail 			<= `SD 0;
			for (int i = 0; i<`N_ENTRY_SQ; i++) begin
				ST_ready [i] 		<= `SD 0;
				store_Data_table[i] 	<= `SD 0;
				store_address_table[i] 	<= `SD 0;
				store_T_table[i]	<= `SD `ZERO_REG;
				next_all_empty		<= `SD 1;
			end
		end

//////////////////////////////////////////////////// find the entry  and get renamed Tag, data and address from execute stage.
		else begin
			head  <= `SD next_head_sol;
			tail  <= `SD next_tail_sol;
			next_all_empty <= `SD all_empty_sol;
			for (int i = 0 ; i < `N_ENTRY_SQ ; i++) begin
				ST_ready [i] <= `SD ST_ready_table_inter[i];
			end
			store_Data_table		<= `SD store_Data_table_next;
			store_address_table		<= `SD store_address_table_next;
			store_T_table			<= `SD store_T_table_next;
		end
	end		
endmodule		

module LQ (
	input	clock,							
	input	reset,							
	// Dispatch inputs
	input	[1:0] id_LQ_rd_mem_in,
	input	[1:0] dispatch_en_in,
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] freelist_pr_in,

	// EX address, data inputs
	input	[1:0][63:0] LQ_addr_in,
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] LQ_dest_reg_in,
	input	[1:0] ex_LQ_mem_rd_valid_in,
	// SQ inputs
	input	[`N_ENTRY_SQ-1:0] ready_bit_in,
	input	[$clog2(`N_ENTRY_SQ)-1:0] SQ_head_old_in,SQ_tail_old_in,
	input	[`N_ENTRY_SQ-1:0][63:0] SQ_addr_table_in, SQ_data_table_in,
	input	[$clog2(`N_ENTRY_SQ)-1:0] store_position_in, // store_position_in should be comb
	input 	SQ_all_empty_inter,

	// Dcache 3-Way inputs
	input	[2:0] dcache_data_ready_in,
	input	[$clog2(`N_ENTRY_LQ)-1:0] dcache_load_index_in, // Check Width
	input	[2:0][63:0] dcache_data_in,

	// Branch flash inputs
	input	[`STACK_NUM-1:0] b_mask_in_0_LQ,
	input	[`STACK_NUM-1:0] b_mask_in_1_LQ,
	input	recovery_request_LQ,
	input	br_correct_LQ,
	input	[$clog2(`STACK_NUM)-1:0]br_correct_address_LQ,
	input	[`STACK_NUM-1:0] recovery_b_mask_LQ,
	input	is_0_st,

	// Multiplyer inputs
	input	[1:0] Mult_issue_enable,

	// LQ outputs to pipeline
	output logic [1:0][63:0] LQ_data_out,
	output logic [1:0][$clog2(`N_ENTRY_ROB+33)-1:0] LQ_dest_reg_out,


	// LQ outputs to dcache
	output logic [1:0][63:0] LQ_dcache_fetch_address_out,
	output logic [1:0][$clog2(`N_ENTRY_LQ)-1:0]	LQ_dcache_fetch_index_out,
	output logic [1:0]		 LQ_dcache_fetch_en,
	output logic [1:0] issued,
	output logic busy_out,
	output logic [1:0][`STACK_NUM-1:0] LQ_b_mask_out,
	output logic  [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_0,
	output logic  [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_1
);
	parameter N_ENTRY_LQ_BIT_SIZE = $clog2(`N_ENTRY_LQ);
	parameter N_ENTRY_SQ_BIT_SIZE = $clog2(`N_ENTRY_SQ);

	logic [`N_ENTRY_SQ-1:0] head_sel;

	logic [`N_ENTRY_LQ-1:0][63:0] load_addr_table;
	logic [`N_ENTRY_LQ-1:0][63:0] load_dcache_value_table;
	logic [`N_ENTRY_LQ-1:0][63:0] load_forwarding_value_table;

	logic [`N_ENTRY_LQ-1:0][$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_table;
	logic [`N_ENTRY_LQ-1:0][N_ENTRY_SQ_BIT_SIZE-1:0] store_position_table;
	logic [`N_ENTRY_LQ-1:0] busy_table;
	logic [`N_ENTRY_LQ-1:0] addr_available_table;
	logic [`N_ENTRY_LQ-1:0] dcache_data_ready_table;
	DATA_LOCATION data_location_table [`N_ENTRY_LQ-1:0];
	DATA_LOCATION data_location_table_n0 [`N_ENTRY_LQ-1:0];
	DATA_LOCATION data_location_table_n1 [`N_ENTRY_LQ-1:0];
	DATA_LOCATION data_location_temp [`N_ENTRY_LQ-1:0];
	logic [`N_ENTRY_LQ-1:0] issue_dcache_ready;
	logic [`N_ENTRY_LQ-1:0] issue_forwarding_ready;
		// ADD branch recovery tag table here
	logic [`N_ENTRY_LQ-1:0] [`STACK_NUM-1:0] b_mask_table;
	logic [`N_ENTRY_LQ-1:0] [`STACK_NUM-1:0] b_mask_table_next;
//	logic [$clog2(`STACK_NUM)-1:0] correct_address;
	logic found_correct_bit;
	
	logic [`N_ENTRY_LQ-1:0][63:0] load_addr_table_n0;
	logic [`N_ENTRY_LQ-1:0][63:0] load_dcache_value_table_n0;
	logic [`N_ENTRY_LQ-1:0][63:0] load_forwarding_value_table_n0;

	logic [`N_ENTRY_LQ-1:0][$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_table_n0;
	logic [`N_ENTRY_LQ-1:0] busy_table_n0;
	logic [`N_ENTRY_LQ-1:0] busy_table_n1;
	logic [`N_ENTRY_LQ-1:0] busy_table_n2;
	logic [`N_ENTRY_LQ-1:0] busy_table_n3;
	logic [`N_ENTRY_LQ-1:0] busy_table_n4;
	logic [`N_ENTRY_LQ-1:0] addr_available_table_n0;
	logic [`N_ENTRY_LQ-1:0] addr_available_table_n1;
	logic [`N_ENTRY_LQ-1:0] dcache_data_ready_table_n0;
	logic [`N_ENTRY_LQ-1:0] dcache_data_ready_table_n1;
	logic [`N_ENTRY_LQ-1:0] has_accu_ready_table;
	
	//logic [N_ENTRY_LQ_BIT_SIZE:0] available_entries, available_entries_n0, available_entries_n1;
	logic [`N_ENTRY_SQ-1:0] accumulated_ready_inter, accumulated_ready;

	logic [N_ENTRY_SQ_BIT_SIZE-1:0] check_forwarding_index;

	logic [1:0][$clog2(`N_ENTRY_LQ)-1:0] LQ_dispatch_index;
	logic found, reach_store_position;
	logic [1:0] dispatched;
	logic [1:0] able_to_dispatch;
	logic [`N_ENTRY_SQ-1:0] bit_table;
	logic stop;
	logic [$clog2(`N_ENTRY_SQ)-1:0] scan_position;
	logic  [`N_ENTRY_SQ-1:0] [$clog2(`N_ENTRY_SQ)-1:0] sp_minus_one;

	assign able_to_dispatch = dispatch_en_in & id_LQ_rd_mem_in;
	//assign busy_out = (available_entries >= 2) ? 1'b0 : 1'b1; //not busy only if there are still N empty entries

	always_comb begin
		for (int i = 0; i < `N_ENTRY_LQ ; i++) begin
			issue_dcache_ready[i] = dcache_data_ready_table[i] && (data_location_table[i] == DATA_FROM_DCACHE);
			issue_forwarding_ready[i] =  (data_location_table[i] == DATA_FROM_FORWARDING);
		end
	end
///
	always_comb begin
		for (int i = 0; i < `N_ENTRY_SQ; i++) begin
			head_sel[i] = (SQ_head_old_in == i) ? 1'b1: 1'b0;
		end
	end

	always_comb begin
		bit_table = 0;
		stop = 0;
		scan_position = 0;
	   if(!SQ_all_empty_inter) begin
		for (int i = 0; i < `N_ENTRY_SQ; i++) begin
			scan_position = SQ_head_old_in + i;
			if (!stop) begin
				bit_table[scan_position] = 1'b1;
				if (scan_position==SQ_tail_old_in) begin
					stop = 1'b1;
				end
			end
		end
	   end
	end
			

	always_comb begin
		for (int i = 0; i < `N_ENTRY_SQ; i++) begin
			sp_minus_one[i] = i -1;
			casex({head_sel[i], accumulated_ready[sp_minus_one[i]]})
				2'b1?:accumulated_ready_inter[i] = ready_bit_in[i];
				2'b01:accumulated_ready_inter[i] = 1'b1;
				default:accumulated_ready_inter[i] = 1'b0;
			endcase	
		end
		
	end
	
	always_comb begin
		for (int i = 0; i < `N_ENTRY_SQ; i++) begin
			accumulated_ready[i] = accumulated_ready_inter[i] & ready_bit_in[i];
		end
	end
	// end of calculate accumulate ready

	// n0
	always_comb begin //Check if branch flush
		busy_table_n0		= busy_table;
		if (recovery_request_LQ) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if ((b_mask_table[i] >= recovery_b_mask_LQ) && busy_table[i]) begin
					busy_table_n0[i] = 1'b0;
				end
			end
		end
	end	

	// send to D$
	always_comb begin // EX stage outputs address, dest-reg are ready as input (2-Way 0 <= j < 2)
		// DO CAM
		addr_available_table_n0		= addr_available_table;
		load_addr_table_n0		= load_addr_table;
		LQ_dcache_fetch_index_out[0]	= 0;
		LQ_dcache_fetch_index_out[1]	= 0;
		LQ_dcache_fetch_address_out[0]	= 0;
		LQ_dcache_fetch_address_out[1]	= 0;
		LQ_b_mask_out[0]		= 0;
		LQ_b_mask_out[1]		= 0;
		LQ_dcache_fetch_en		= 2'b00;
		for (int i = 0; i < `N_ENTRY_LQ; i++) begin
			if (busy_table_n0[i]) begin
				for (int j = 0; j < 2; j++) begin
					// For 2-Way
					if (ex_LQ_mem_rd_valid_in[j] && (LQ_dest_reg_in[j] == dest_reg_table[i])) begin
						addr_available_table_n0[i]	= 1'b1;
						load_addr_table_n0[i]		= LQ_addr_in[j];
						LQ_dcache_fetch_index_out[j]	= i;
						LQ_dcache_fetch_address_out[j]	= LQ_addr_in[j];
						LQ_dcache_fetch_en[j]		= 1'b1;	
						LQ_b_mask_out[j]		= b_mask_table[i];
					end
				end
			end
		end
	end

	// get value from d$
	always_comb begin // update D-cache speculation value (3-Way total)
		load_dcache_value_table_n0	= load_dcache_value_table;
		dcache_data_ready_table_n0	= dcache_data_ready_table;
		// cache_data
		for (int j = 0; j < 2; j++) begin
			if (dcache_data_ready_in[j] && addr_available_table_n0[LQ_dcache_fetch_index_out[j]]
			&& busy_table_n0[LQ_dcache_fetch_index_out[j]]) begin
				load_dcache_value_table_n0[LQ_dcache_fetch_index_out[j]]	= dcache_data_in[j];
				dcache_data_ready_table_n0[LQ_dcache_fetch_index_out[j]]	= 1'b1;
			end
		end
		// mem_data
		if (dcache_data_ready_in[2] && addr_available_table_n0[dcache_load_index_in]
			&& busy_table_n0[dcache_load_index_in]) begin
			load_dcache_value_table_n0[dcache_load_index_in]	= dcache_data_in[2];
			dcache_data_ready_table_n0[dcache_load_index_in]	= 1'b1;
		end
	end

	// decide location
	always_comb begin //Forwarding Check 
		load_forwarding_value_table_n0	= load_forwarding_value_table;
		data_location_table_n0		= data_location_table;
		check_forwarding_index		= 0;
		if (SQ_all_empty_inter) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if (busy_table_n0[i] && (data_location_table[i] == DATA_FROM_NOWHERE)) begin
					data_location_table_n0[i] = DATA_FROM_DCACHE;
				end
				else if(busy_table_n0[i] && (data_location_table[i] == DATA_FROM_FORWARDING_PENDING)) begin
					data_location_table_n0[i]= DATA_FROM_FORWARDING;
				end
			end
		end else begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if (addr_available_table_n0[i] && busy_table_n0[i]
				&& (data_location_table[i] != DATA_FROM_DCACHE)) begin
					reach_store_position = 1'b0;
					data_location_temp[i]   = data_location_table[i]; //only valid in this scope
					for (int j = 0; j < `N_ENTRY_SQ; j++) begin
						check_forwarding_index = SQ_head_old_in + j;
						if ((!reach_store_position) && (SQ_addr_table_in[check_forwarding_index] == load_addr_table_n0[i])&&ready_bit_in[check_forwarding_index]) begin
							//Found forwarding repeatedly
							load_forwarding_value_table_n0[i]	= SQ_data_table_in[check_forwarding_index];
							data_location_temp[i]			= DATA_FROM_FORWARDING_PENDING;
						end
						if (check_forwarding_index == store_position_table[i]) begin
							reach_store_position	= 1'b1;
						end
					end
					case ({accumulated_ready[store_position_table[i]]||!bit_table[store_position_table[i]], data_location_temp[i]})
						{1'b1, DATA_FROM_FORWARDING_PENDING}:	data_location_table_n0[i]= DATA_FROM_FORWARDING;
						{1'b1, DATA_FROM_NOWHERE}:		data_location_table_n0[i]= DATA_FROM_DCACHE;
						default:				data_location_table_n0[i]= data_location_temp[i];
					endcase // {accumulated_ready[store_position_table[i]], data_location_table_n0[i]}
				end // if 
			end
		end
	end

	// n1
	always_comb begin //check issue to CDB MUX 
		busy_table_n1			= busy_table_n0;
		LQ_data_out[0]			= 64'b0;
		LQ_data_out[1]			= 64'b0;
		LQ_dest_reg_out[0]		= `ZERO_REG;
		LQ_dest_reg_out[1]		= `ZERO_REG;
		issued				= 2'b00;
		LQ_issue_pos_0			= 0;
		LQ_issue_pos_1			= 0;
		if (Mult_issue_enable[0]) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if ((!issued[0]) && busy_table_n0[i]) begin
					if (issue_dcache_ready[i]) begin
						busy_table_n1[i] 	= 1'b0;
						LQ_data_out[0]		= load_dcache_value_table_n0[i];
						LQ_dest_reg_out[0]	= dest_reg_table[i];
						issued[0]		= 1'b1;
						LQ_issue_pos_0		= i;
					end else if (issue_forwarding_ready[i]) begin
						busy_table_n1[i] 	= 1'b0;
						LQ_data_out[0]		= load_forwarding_value_table_n0[i];
						LQ_dest_reg_out[0]	= dest_reg_table[i];
						issued[0]		= 1'b1;
						LQ_issue_pos_0		= i;
					end	// First search if dcache data can be fetched
				end 
			end
		end
		busy_table_n2			= busy_table_n1;
		if (Mult_issue_enable[1]) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if ((!issued[1]) && busy_table_n1[i]) begin
					if (issue_dcache_ready[i]) begin
						busy_table_n2[i] 	= 1'b0;
						LQ_data_out[1]		= load_dcache_value_table_n0[i];
						LQ_dest_reg_out[1]	= dest_reg_table[i];
						issued[1]		= 1'b1;
						LQ_issue_pos_1		= i;
					end else if (issue_forwarding_ready[i]) begin
						busy_table_n2[i] 	= 1'b0;
						LQ_data_out[1]		= load_forwarding_value_table_n0[i];
						LQ_dest_reg_out[1]	= dest_reg_table[i];
						issued[1]		= 1'b1;	
						LQ_issue_pos_1		= i;
					end // First search if dcache data can be fetched
				end 
			end
		end
	end

	always_comb begin
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
	end

	// Dispatch_in[1:0] 2-WAY
	always_comb begin
		LQ_dispatch_index[0]		= 0;
		LQ_dispatch_index[1]		= 0;
		dispatched			= 2'b00;
		busy_table_n3 			= busy_table_n2;
		addr_available_table_n1		= addr_available_table_n0;
		dcache_data_ready_table_n1	= dcache_data_ready_table_n0;
		data_location_table_n1		= data_location_table_n0;
		dest_reg_table_n0		= dest_reg_table;
		b_mask_table_next 		= b_mask_table;
		if (able_to_dispatch[0]) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if ((!dispatched[0]) && (!busy_table_n2[i])) begin
					LQ_dispatch_index[0]		= i;
					addr_available_table_n1[i]	= 1'b0;
					dcache_data_ready_table_n1[i]	= 1'b0;
					data_location_table_n1[i]	= SQ_all_empty_inter? DATA_FROM_DCACHE :DATA_FROM_NOWHERE;
					busy_table_n3[i]		= 1'b1;
					dispatched[0]			= 1'b1;
					dest_reg_table_n0[i]		= freelist_pr_in[0];
					b_mask_table_next[i]		= b_mask_in_0_LQ;
				end
			end
		end
		busy_table_n4 = busy_table_n3;
		if (able_to_dispatch[1]) begin
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				if ((!dispatched[1]) && (!busy_table_n3[i])) begin
					LQ_dispatch_index[1]		= i;
					addr_available_table_n1[i]	= 1'b0;
					dcache_data_ready_table_n1[i]	= 1'b0;
					data_location_table_n1[i]	= (SQ_all_empty_inter&&!is_0_st)? DATA_FROM_DCACHE :DATA_FROM_NOWHERE;
					busy_table_n4[i]		= 1'b1;
					dispatched[1] 			= 1'b1;
					dest_reg_table_n0[i]		= freelist_pr_in[1];
					b_mask_table_next[i]		= b_mask_in_1_LQ;
				end
			end
		end
//		correct_address = 0;
//		found_correct_bit = 0;
		if (br_correct_LQ) begin
			/*for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_correct_bit == 0 && recovery_b_mask_LQ[i]==1) begin
					found_correct_bit = 1;
					correct_address   = i;
				end
			end*/
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				b_mask_table_next[i][br_correct_address_LQ] = 0;
			end
		end
	end

	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if (reset) begin
			//available_entries <= `SD `N_ENTRY_LQ;
			for (int i = 0; i < `N_ENTRY_LQ; i++) begin
				load_addr_table[i]			<= `SD 64'h0;
				load_dcache_value_table[i]		<= `SD 64'h0;
				load_forwarding_value_table[i]		<= `SD 64'h0;
				dest_reg_table[i]  			<= `SD `ZERO_REG;
				store_position_table[i]			<= `SD 0;
				addr_available_table[i]			<= `SD 1'b0;
				busy_table[i]				<= `SD 1'b0;
				dcache_data_ready_table[i]		<= `SD 1'b0;
				data_location_table[i]			<= `SD DATA_FROM_NOWHERE;
				b_mask_table[i]				<= `SD 0;
			end
		end else begin
			//available_entries		<= `SD available_entries_n1;
			load_addr_table			<= `SD load_addr_table_n0;
			load_dcache_value_table		<= `SD load_dcache_value_table_n0;
			load_forwarding_value_table	<= `SD load_forwarding_value_table_n0;
			dest_reg_table			<= `SD dest_reg_table_n0;
			for (int i = 0; i < 2; i++) begin
				if (dispatched[i]) begin
					store_position_table[LQ_dispatch_index[i]]<= `SD store_position_in;
				end
			end
			addr_available_table		<= `SD addr_available_table_n1;	
			busy_table			<= `SD busy_table_n4;
			dcache_data_ready_table		<= `SD dcache_data_ready_table_n1;
			data_location_table		<= `SD data_location_table_n1;
			b_mask_table			<= `SD b_mask_table_next;
		end
	end
endmodule // LQ

module LSQ(
	input	clock, reset,
	// For Branch
	input	is_0_br,
	input	[$clog2(`N_ENTRY_SQ)-1:0] recovery_tail,
	input	[`STACK_NUM-1:0] b_mask_in_0,
	input	[`STACK_NUM-1:0] b_mask_in_1,
	input	recovery_request,
	input	br_correct,
	input	[$clog2(`STACK_NUM)-1:0]br_correct_address,
	input	[`STACK_NUM-1:0] recovery_b_mask,
	input	SQ_empty_recovery,
	//input	clear,// clear for branch.// Branch flash inputs
	//input rd_mem_in_0, //detect load before store == id_LQ_rd_mem_in[0].
	//input valid_tail_in_0, valid_tail_in_1,
				
	// Dispatch inputs
	input	[1:0] id_wr_mem_in,
	input	[1:0] id_rd_mem_in,
	input	[1:0] dispatch_en_in,
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] freelist_pr_in,

	// EX address, data inputs
	input	[1:0][63:0] EX_data_in,// data from ALU at ex stage.
	input	[1:0][63:0] EX_SQ_addr_in,
	input	[1:0][63:0] EX_LQ_addr_in,
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] EX_SQ_dest_reg_in,
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] EX_LQ_dest_reg_in,
	input	[1:0] EX_mem_rd_valid_in,
	input	[1:0] EX_mem_wr_valid_in, //detect if store execute
	
	// ROB inputs
	input	[1:0][$clog2(`N_ENTRY_ROB+33)-1:0] ROB_dest_in,// compare tag to find which store in SQ can retire .
	input	[1:0] rt_ready,// detect if store retire in the ROB and move head.

	// Dcache 3-Way inputs
	input	[2:0] dcache_data_ready_in,
	input	[$clog2(`N_ENTRY_LQ)-1:0] dcache_load_index_in,
	input	[2:0][63:0] dcache_data_in,

	// Multiplyer inputs
	input	[1:0] Mult_issue_enable,

	output logic [$clog2(`N_ENTRY_SQ)-1:0] tail_pointer,

	// Busy
	output logic SQ_busy_out,
	output logic LQ_busy_out,

	// Dcache Write // TO DO : enable signal for writing to dcache
	output logic [63:0] SQ_dcache_Data_out,
	output logic 	 SQ_dcache_Data_en_out,
	output logic [63:0] SQ_dcache_address_out,//output store address for Dcache.
	// Dcache Read
	output logic [1:0][63:0] LQ_dcache_fetch_address_out,
	output logic [1:0][$clog2(`N_ENTRY_LQ)-1:0]	LQ_dcache_fetch_index_out,
	output logic [1:0]	LQ_dcache_fetch_en,

	// LQ outputs to pipeline
	output logic [1:0][63:0] LQ_data_out,
	output logic [1:0][$clog2(`N_ENTRY_ROB+33)-1:0] LQ_dest_reg_out,
	output logic [1:0] LQ_issued_out,
	output logic [1:0][`STACK_NUM-1:0] b_mask_to_dcache,
	output logic empty_shot,
	output logic [$clog2(`N_ENTRY_ROB+33)-1:0] dest_reg_tail_shot,
	output logic  [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_0,
	output logic  [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_1
); 
	//SQ LQ communication
	logic [`N_ENTRY_SQ-1:0] ST_ready_table;// ready table for LQ.
	logic [$clog2(`N_ENTRY_SQ)-1:0]	head, tail;// For LQ.
	logic [`N_ENTRY_SQ-1:0][63:0] store_Data_table;
	logic [`N_ENTRY_SQ-1:0][63:0] store_address_table;
	logic [$clog2(`N_ENTRY_SQ)-1:0] store_position;
	logic all_empty,is_0_st;
	LQ LQ_0 (
	//inputs
	.clock(clock),.reset(reset), .id_LQ_rd_mem_in(id_rd_mem_in),.dispatch_en_in(dispatch_en_in),
	.LQ_addr_in(EX_LQ_addr_in),.LQ_dest_reg_in(EX_LQ_dest_reg_in),.freelist_pr_in(freelist_pr_in),
	.ex_LQ_mem_rd_valid_in(EX_mem_rd_valid_in),.ready_bit_in(ST_ready_table),.SQ_head_old_in(head),
	.SQ_addr_table_in(store_address_table),.SQ_data_table_in(store_Data_table),
	.store_position_in(store_position),.dcache_data_ready_in(dcache_data_ready_in),.dcache_load_index_in(dcache_load_index_in),
	.dcache_data_in(dcache_data_in),.Mult_issue_enable(Mult_issue_enable),.SQ_all_empty_inter(all_empty),.is_0_st(is_0_st),
	.b_mask_in_0_LQ(b_mask_in_0),.b_mask_in_1_LQ(b_mask_in_1),.recovery_request_LQ(recovery_request),.br_correct_LQ(br_correct),
	.recovery_b_mask_LQ(recovery_b_mask),.br_correct_address_LQ(br_correct_address),.SQ_tail_old_in(tail),
	//outputs
	.LQ_data_out(LQ_data_out),.LQ_dest_reg_out(LQ_dest_reg_out),.busy_out(LQ_busy_out),
	.LQ_dcache_fetch_address_out(LQ_dcache_fetch_address_out), .LQ_dcache_fetch_index_out(LQ_dcache_fetch_index_out),
	.LQ_dcache_fetch_en(LQ_dcache_fetch_en),.issued(LQ_issued_out),.LQ_b_mask_out(b_mask_to_dcache),
	.LQ_issue_pos_0(LQ_issue_pos_0),
	.LQ_issue_pos_1(LQ_issue_pos_1));

	SQ SQ_0(
	//inputs
	.clock(clock),.reset(reset),.ROB_dest_0(ROB_dest_in[0]),.ROB_dest_1(ROB_dest_in[1]),.EX_pr_in_0(EX_SQ_dest_reg_in[0]),
	.EX_pr_in_1(EX_SQ_dest_reg_in[1]),.freelist_pr_in_0(freelist_pr_in[0]),.freelist_pr_in_1(freelist_pr_in[1]),
	.Data_in_0(EX_data_in[0]), .Data_in_1(EX_data_in[1]),.address_in_0(EX_SQ_addr_in[0]),.address_in_1(EX_SQ_addr_in[1]),
	.EX_wr_mem_0(EX_mem_wr_valid_in[0]),.EX_wr_mem_1(EX_mem_wr_valid_in[1]),.is_0_st(is_0_st),
	.dispatch_enable_0(dispatch_en_in[0]),.dispatch_enable_1(dispatch_en_in[1]),
	.wr_mem_in_0(id_wr_mem_in[0]),.wr_mem_in_1(id_wr_mem_in[1]),.rd_mem_in_0(id_rd_mem_in[0]),
	.rt_ready_0(rt_ready[0]),.rt_ready_1(rt_ready[1]),
	.is_0_br_SQ(is_0_br),.recovery_br_SQ(recovery_request),.recovery_tail_SQ(recovery_tail),.SQ_empty_recovery(SQ_empty_recovery),
	//outputs
	.busy(SQ_busy_out),.Data_out(SQ_dcache_Data_out),
	.Data_out_en(SQ_dcache_Data_en_out),
	.address_out(SQ_dcache_address_out),
	.store_position_out(store_position),.all_empty_inter(all_empty),
	.ST_ready(ST_ready_table),.head(head),
	.store_Data_table(store_Data_table),.tail(tail),
	.store_address_table(store_address_table),.tail_pointer_SQ(tail_pointer),.empty_shot_SQ(empty_shot),.dest_reg_tail_shot(dest_reg_tail_shot));
endmodule








