// cachemem32x64

`timescale 1ns/100ps

module dcache(
        input clock, reset,
	input wr_mem_en,	//get from mem, for load
	input wr_store_en,	//when store hit
        input  [3:0] wr_mem_idx,wr_store_idx,rd0_idx_hit,rd1_idx_hit,//,rd_idx_miss,
        input  [8:0] wr_mem_tag,wr_store_tag,rd0_tag_hit,rd1_tag_hit,//,rd_tag_miss,
        input [63:0] wr_mem_data,wr_store_data, 
	input ld_valid_0, ld_valid_1,

        output logic [63:0] rd0_data_hit,
        output logic [63:0] rd1_data_hit,
        //output [63:0] rd_data_miss,
        output rd0_valid_hit,
        output rd1_valid_hit,
        //output rd_valid_miss
	output wr_store_hit
        
      );

  logic [63:0] rd0_data_hit_inter;
  logic [63:0] rd1_data_hit_inter;

  logic [1:0] [15:0] [63:0] data ;
  logic [1:0] [15:0]  [8:0] tags; 
  logic [1:0] [15:0]        valids;
  logic [15:0] LRU_table, next_LRU_table;
  logic current_wr_mem_way, current_wr_store_way;


  assign wr_store_hit = wr_store_en && ((valids[0][wr_store_idx] && (tags[0][wr_store_idx] == wr_store_tag)) || (valids[1][wr_store_idx] && (tags[1][wr_store_idx] == wr_store_tag)));

  assign rd1_data_hit_inter = ((valids[0][rd1_idx_hit] && (tags[0][rd1_idx_hit] == rd1_tag_hit))) ? data[0][rd1_idx_hit] : data[1][rd1_idx_hit];
  assign rd0_data_hit_inter = ((valids[0][rd0_idx_hit] && (tags[0][rd0_idx_hit] == rd0_tag_hit))) ? data[0][rd0_idx_hit] : data[1][rd0_idx_hit];

  assign rd1_valid_hit = (valids[0][rd1_idx_hit] && (tags[0][rd1_idx_hit] == rd1_tag_hit)) || (valids[1][rd1_idx_hit] && (tags[1][rd1_idx_hit] == rd1_tag_hit));
  assign rd0_valid_hit = (valids[0][rd0_idx_hit] && (tags[0][rd0_idx_hit] == rd0_tag_hit)) || (valids[1][rd0_idx_hit] && (tags[1][rd0_idx_hit] == rd0_tag_hit));

	always_comb begin
		rd1_data_hit=rd1_data_hit_inter;
		rd0_data_hit=rd0_data_hit_inter;
		if(wr_store_hit) begin
			if((rd1_idx_hit==wr_store_idx)&&(wr_store_tag==rd1_tag_hit)) begin
				rd1_data_hit=wr_store_data;
			end
			if((rd0_idx_hit==wr_store_idx)&&(wr_store_tag==rd0_tag_hit)) begin
				rd0_data_hit=wr_store_data;
			end			
		end
	end

  always_ff @(posedge clock) begin
    if(reset) begin
      valids <= `SD 31'b0;
      LRU_table <= `SD 16'b0;
    end else if(wr_mem_en) begin 
      valids[current_wr_mem_way][wr_mem_idx] <= `SD 1;	
      LRU_table <= `SD next_LRU_table;
    end else if(wr_store_hit) begin 
      valids[current_wr_store_way][wr_store_idx] <= `SD 1;	
      LRU_table <= `SD next_LRU_table;
    end else if(ld_valid_0 || ld_valid_0) begin
      LRU_table <= `SD next_LRU_table;
    end
  end
 
  always_ff @(posedge clock) begin
    if(wr_mem_en) begin
      data[current_wr_mem_way][wr_mem_idx] <= `SD wr_mem_data;
      tags[current_wr_mem_way][wr_mem_idx] <= `SD wr_mem_tag;
    end else if(wr_store_hit) begin
      data[current_wr_store_way][wr_store_idx] <= `SD wr_store_data;
      tags[current_wr_store_way][wr_store_idx] <= `SD wr_store_tag;
    end
  end

  always_comb begin
	current_wr_mem_way = 0;
	current_wr_store_way = 0;

	next_LRU_table = LRU_table;
	if(valids[0][rd1_idx_hit] && (tags[0][rd1_idx_hit] == rd1_tag_hit) && ld_valid_0)
		next_LRU_table[rd1_idx_hit] = 1'b1;
	else if (valids[1][rd1_idx_hit] && (tags[1][rd1_idx_hit] == rd1_tag_hit) && ld_valid_0)
		next_LRU_table[rd1_idx_hit] = 1'b0;


	if(valids[0][rd0_idx_hit] && (tags[0][rd0_idx_hit] == rd0_tag_hit) && ld_valid_1)
		next_LRU_table[rd0_idx_hit] = 1'b1;
	else if (valids[1][rd0_idx_hit] && (tags[1][rd0_idx_hit] == rd0_tag_hit) && ld_valid_1)
		next_LRU_table[rd0_idx_hit] = 1'b0;		



	if(wr_mem_en) begin
		if(valids[0][wr_mem_idx] && (tags[0][wr_mem_idx] == wr_mem_tag)) begin
			next_LRU_table[wr_mem_idx] = 1'b1;
			current_wr_mem_way = 0;
		end
		else if (valids[1][wr_mem_idx] && (tags[1][wr_mem_idx] == wr_mem_tag)) begin
			next_LRU_table[wr_mem_idx] = 1'b0;	
			current_wr_mem_way = 1;
		end
		else begin
			current_wr_mem_way = LRU_table[wr_mem_idx];
			next_LRU_table[wr_mem_idx] = !LRU_table[wr_mem_idx];
		end	
	end

	if(wr_store_en) begin
		if(valids[0][wr_store_idx] && (tags[0][wr_store_idx] == wr_store_tag)) begin
			next_LRU_table[wr_store_idx] = 1'b1;
			current_wr_store_way = 0;
		end
		else if (valids[1][wr_store_idx] && (tags[1][wr_store_idx] == wr_store_tag)) begin
			next_LRU_table[wr_store_idx] = 1'b1;	
			current_wr_store_way = 1;
		end
		else begin
			current_wr_store_way = LRU_table[wr_store_idx];
			next_LRU_table[wr_store_idx] = !LRU_table[wr_store_idx];
		end	
	end


	//if(valids[0][rd_idx_miss] && (tags[0][rd_idx_miss] == rd_tag_miss))
	//	next_LRU_table[rd0_idx_hit] = 1'b1;
	//else if (valids[1][rd_idx_miss] && (tags[1][rd_idx_miss] == rd_tag_miss))
	//	next_LRU_table[rd_idx_miss] = 1'b0;		

  end

endmodule
