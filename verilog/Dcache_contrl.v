`timescale 1ns/100ps
module dcache_control(
    input   clock,
    input   reset,
    input   [3:0] Dmem2proc_response,	//given by mem while sending command to mem
    //input  [63:0] Dmem2proc_data,	//
    input   [3:0] Dmem2proc_tag,	//given by mem while data from mem is back (to cam)
    input   alu_flush_0,
    input   alu_flush_1,

    input   load_0_valid,		//if there is a ld in way_0
    input   load_1_valid,		//if there is a ld in way_1

    input   [1:0][`STACK_NUM-1:0]b_mask_to_dcache,
    input   recovery_request,
    input   br_correct,
    input   [$clog2(`STACK_NUM)-1:0]br_correct_address,
    input   [`STACK_NUM-1:0]recovery_b_mask,

    input   store_valid,		//if there is a store retired (need to write to )
    input  [63:0] proc2Dcache_addr_st, 	//to search address in D$ (to cam) for store
    input  [63:0] proc2Dcache_addr_0, 	//to search address in D$ (to cam) for load_0
    input  [63:0] proc2Dcache_addr_1, 	//to search address in D$ (to cam) for load_1
    input [$clog2(`N_ENTRY_LQ)-1:0] MSHR_ld_position_in_0,	//the position in LQ
    input [$clog2(`N_ENTRY_LQ)-1:0] MSHR_ld_position_in_1,	//the position in LQ
    
    //input  [63:0] cachemem_data_0,	//to found data in D$, will be sent to pipeline
    //input  [63:0] cachemem_data_1,	//to found data in D$, will be sent to pipeline
    input   cachemem_valid_0,		//the data found in D$ is correct, connect rd0_valid_hit in D$
    input   cachemem_valid_1,		//the data found in D$ is correct, connect rd1_valid_hit in D$
    input   cachemem_valid_st,		//the address is found in D cache, actually not used now
    input   LQ_issued_0,
    input   LQ_issued_1,
    input   [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_0,
    input   [$clog2(`N_ENTRY_LQ)-1:0] LQ_issue_pos_1,

    output logic  [1:0] proc2Dmem_command,	//need data from mem
    output logic [63:0] proc2Dmem_addr,		//address that would be cam in mem

/*    //output logic [63:0] Dcache_data0_hit_out, 	   // value is memory[proc2Icache_addr]
    output logic  Dcache_data0_hit_valid_out,      // when this is high
    //output logic [63:0] Dcache_data1_hit_out, 	   // value is memory[proc2Icache_addr]
    output logic  Dcache_data1_hit_valid_out,      // when this is high
    //output logic [63:0] Dcache_data_miss_out, 	   // value is memory[proc2Icache_addr]
    output logic  Dcache_data_miss_valid_out,      // when this is high
*/
    output logic  [3:0] load_index_0,	//the entry it belongs in D$, connect rd0_idx_hit in D$
    output logic  [8:0] load_tag_0,	//the tag to cam with the entry chosen above, connect rd0_tag_hit in D$
    output logic  [3:0] load_index_1,	//the entry it belongs in D$, connect rd1_idx_hit in D$
    output logic  [8:0] load_tag_1,	//the tag to cam with the entry chosen above, connect rd1_tag_hit in D$
    output logic  [3:0] store_index,	//the entry it belongs in D$, connect wr_store_idx in D$
    output logic  [8:0] store_tag,	//the tag to cam with the entry chosen above, connect wr_store_tag in D$
    output logic  [3:0] mem_ld_index,	//the entry it belongs in D$, connect wr_mem_idx in D$
    output logic  [8:0] mem_ld_tag,	//the tag to cam with the entry chosen above, connect wr_mem_tag in D$

    output logic  data_write_mem_enable,	// connect wr_mem_en in D$

    output logic [$clog2(`N_ENTRY_LQ)-1:0] MSHR_ld_position_out	// the position the data from mem should go to in LSQ
  );
	logic [`MSHR_ENTRY-1:0][63:0] MSHR_address_table, MSHR_address_table_next;
	logic [`MSHR_ENTRY-1:0][$clog2(`N_ENTRY_LQ)-1:0] MSHR_ld_position_table, MSHR_ld_position_table_next;
	logic [`MSHR_ENTRY-1:0] MSHR_busy_table, MSHR_busy_table_next1, MSHR_busy_table_next2,MSHR_busy_table_next3,MSHR_busy_table_next4;
	logic [`MSHR_ENTRY-1:0] MSHR_resp_ready_table, MSHR_resp_ready_table_next;
	logic [`MSHR_ENTRY-1:0][3:0] MSHR_response_table, MSHR_response_table_next;
	logic MSHR_empty_entry_found_0, MSHR_empty_entry_found_1, found_command_require;
	logic [63:0] proc2Dcache_addr_mem_ld; 	//to search address in D$ (to cam) for store
//	logic [$clog2(`STACK_NUM)-1:0] correct_address;
//	logic found_correct_bit;
	logic [`MSHR_ENTRY-1:0][`STACK_NUM-1:0] b_mask_table, b_mask_table_next;

	assign {load_tag_0, load_index_0} = proc2Dcache_addr_0[31:3];
	assign {load_tag_1, load_index_1} = proc2Dcache_addr_1[31:3];
	assign { store_tag,  store_index} = proc2Dcache_addr_st[31:3];
	assign {mem_ld_tag, mem_ld_index} = proc2Dcache_addr_mem_ld[31:3];
//	assign Dcache_data0_hit_valid_out = cachemem_valid_0;	//actually not used now
//	assign Dcache_data1_hit_valid_out = cachemem_valid_1;	//actually not used now
//	assign Dcache_data_miss_valid_out = wr_en_from_mem;	//actually not used now

	always_comb begin
		MSHR_address_table_next = MSHR_address_table;
		MSHR_ld_position_table_next = MSHR_ld_position_table;
		MSHR_busy_table_next1 = MSHR_busy_table;
		MSHR_resp_ready_table_next = MSHR_resp_ready_table;
		MSHR_response_table_next = MSHR_response_table;
		b_mask_table_next = b_mask_table;
		proc2Dcache_addr_mem_ld = 0;
		//store the ld insns in MSHR if miss
		MSHR_empty_entry_found_0 = 0;
		MSHR_empty_entry_found_1 = 0;
		found_command_require = 0;
		proc2Dmem_command = BUS_NONE;
		MSHR_ld_position_out = 0;
		proc2Dmem_addr = 0;
		
//		correct_address = 0;
//		found_correct_bit = 0;
		if(LQ_issued_0) begin
			for (int i = 0; i < `MSHR_ENTRY; i++) begin
				if(LQ_issue_pos_0==MSHR_ld_position_table[i]) begin
					MSHR_busy_table_next1[i] = 0;
					MSHR_resp_ready_table_next[i] = 0;
				end
			end
		end

		if(LQ_issued_1) begin
			for (int i = 0; i < `MSHR_ENTRY; i++) begin
				if(LQ_issue_pos_1==MSHR_ld_position_table[i]) begin
					MSHR_busy_table_next1[i] = 0;
					MSHR_resp_ready_table_next[i] = 0;
				end
			end
		end



	
		if (recovery_request) begin
			for (int i = 0; i < `MSHR_ENTRY; i++) begin
				if ((b_mask_table_next[i] >= recovery_b_mask) && MSHR_busy_table[i]) begin
					MSHR_busy_table_next1[i] = 1'b0;
					MSHR_resp_ready_table_next[i] = 0;
				end
			end
		end
		MSHR_busy_table_next2 = MSHR_busy_table_next1;

		if (load_0_valid && !alu_flush_0) begin
			if (!cachemem_valid_0) begin
				for (int i=0 ; i<`MSHR_ENTRY ; i++) begin
					if (!MSHR_empty_entry_found_0 && !MSHR_busy_table_next1[i]) begin
						MSHR_empty_entry_found_0 = 1;
						MSHR_busy_table_next2[i] = 1;
						MSHR_address_table_next[i] = proc2Dcache_addr_0;
						MSHR_ld_position_table_next[i] = MSHR_ld_position_in_0;
						b_mask_table_next[i] = b_mask_to_dcache[0];
					end
				end
			end
		end
		MSHR_busy_table_next3 = MSHR_busy_table_next2;
		if (load_1_valid && !alu_flush_1) begin
			if (!cachemem_valid_1) begin
				for (int i=0 ; i<`MSHR_ENTRY ; i++) begin
					if (!MSHR_empty_entry_found_1 && !MSHR_busy_table_next2[i]) begin
						MSHR_empty_entry_found_1 = 1;
						MSHR_busy_table_next3[i] = 1;
						MSHR_address_table_next[i] = proc2Dcache_addr_1;
						MSHR_ld_position_table_next[i] = MSHR_ld_position_in_1;
						b_mask_table_next[i] = b_mask_to_dcache[1];
					end
				end
			end
		end
		if (br_correct) begin
			for (int i = 0; i < `MSHR_ENTRY; i++) begin
				b_mask_table_next[i][br_correct_address] = 0;
			end
		end
		MSHR_busy_table_next4 = MSHR_busy_table_next3;
		//find one command to send to mem
		if (store_valid) begin
			proc2Dmem_command = BUS_STORE;
			proc2Dmem_addr = proc2Dcache_addr_st;
			for (int i=0 ; i<`MSHR_ENTRY ; i++) begin
				if(proc2Dcache_addr_st==MSHR_address_table_next[i]) begin
					MSHR_busy_table_next4[i] = 0;
					MSHR_resp_ready_table_next[i] = 0;
				end

			end
		end else begin
			for (int i=0 ; i<`MSHR_ENTRY ; i++) begin
				if (!found_command_require && MSHR_busy_table_next1[i] && !MSHR_resp_ready_table[i]) begin
					found_command_require = 1;
					proc2Dmem_command = BUS_LOAD;
					proc2Dmem_addr = MSHR_address_table[i];
					MSHR_response_table_next[i] = Dmem2proc_response;
					if (Dmem2proc_response!=0) begin
						MSHR_resp_ready_table_next[i] = 1;
					end
				end
			end
		end
		//cam the tag from mem (search in the response table)

		data_write_mem_enable = 0;
		for (int i=0 ; i<`MSHR_ENTRY ; i++) begin
			if ((Dmem2proc_tag!=0)&&(MSHR_response_table[i] == Dmem2proc_tag) && MSHR_resp_ready_table[i] && MSHR_busy_table_next1[i]) begin
				MSHR_busy_table_next4[i] = 0;
				MSHR_ld_position_out = MSHR_ld_position_table[i];
				data_write_mem_enable = 1;
				proc2Dcache_addr_mem_ld = MSHR_address_table[i];
				MSHR_resp_ready_table_next[i] = 0;
			end
		end		
	end

	always_ff @(posedge clock) begin
		if(reset) begin
			MSHR_address_table	<= `SD 0;
			MSHR_ld_position_table	<= `SD 0;
			MSHR_busy_table		<= `SD 0;
			MSHR_resp_ready_table	<= `SD 0;
			MSHR_response_table	<= `SD 0;
			b_mask_table		<= `SD 0;
			
		end else begin
			MSHR_address_table	<= `SD MSHR_address_table_next;
			MSHR_ld_position_table	<= `SD MSHR_ld_position_table_next;
			MSHR_busy_table		<= `SD MSHR_busy_table_next4;
			MSHR_resp_ready_table	<= `SD MSHR_resp_ready_table_next;
			MSHR_response_table	<= `SD MSHR_response_table_next;
			b_mask_table		<= `SD b_mask_table_next;
		end
	end
endmodule
















