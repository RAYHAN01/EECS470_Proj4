// cachemem32x64

`timescale 1ns/100ps

module cache(
        input clock, reset, wr1_en,
        input  [3:0] wr1_idx, rd1_idx,prefetch_rd_idx,	//prefetch_rd_idx--current_index; rd1_idx--read_index.
        input  [8:0] wr1_tag, rd1_tag,prefetch_rd_tag,
        input [63:0] wr1_data, 

        output logic [63:0] rd1_data, //prefetch_rd_data, //prefetch_rd_valid--prefetch_valid
        output logic      rd1_valid, prefetch_rd_valid
        
      );

  logic [1:0]  [15:0] [63:0] data ;//associativity,set, data length
  logic [1:0]  [15:0] [8:0]  tags; 
  logic [1:0]  [15:0]  	     valids;
  logic [15:0]		     LRU, next_LRU;
  logic LRU_hist;

  always_comb begin
    if(valids[0] [prefetch_rd_idx] && (tags[0] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      //prefetch_rd_data  = data[0] [prefetch_rd_idx];
      prefetch_rd_valid = 1;
    end
    else if(valids[1] [prefetch_rd_idx] && (tags[1] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      //prefetch_rd_data  = data[1] [prefetch_rd_idx];
      prefetch_rd_valid = 1;
    end
    else begin
      //prefetch_rd_data  = 0;
      prefetch_rd_valid = 0;
    end
  end

  always_comb begin
    next_LRU  = LRU;
    LRU_hist = LRU[wr1_idx];
    if(valids[0] [rd1_idx] && (tags[0] [rd1_idx] == rd1_tag)) begin
      		rd1_data  = data[0] [rd1_idx];
      		rd1_valid = 1;
    end
    else if(valids[1] [rd1_idx] && (tags[1] [rd1_idx] == rd1_tag)) begin
      		rd1_data  = data[1] [rd1_idx];
      		rd1_valid = 1;
    end 
    else begin
      		rd1_data  = 0;
      		rd1_valid = 0;
    end
    if(wr1_en) begin
	next_LRU[wr1_idx] = !LRU[wr1_idx];
	if(valids[0] [prefetch_rd_idx] && (tags[0] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      		next_LRU[prefetch_rd_idx] = 1;
    	end
    	else if(valids[1] [prefetch_rd_idx] && (tags[1] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      		next_LRU[prefetch_rd_idx] = 0;
    	end
	if(wr1_idx==prefetch_rd_idx) begin
	LRU_hist = next_LRU[wr1_idx];
	end
    end
    else begin
    	if(valids[0] [prefetch_rd_idx] && (tags[0] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      		next_LRU[prefetch_rd_idx] = 1;
    	end
    	else if(valids[1] [prefetch_rd_idx] && (tags[1] [prefetch_rd_idx] == prefetch_rd_tag)) begin
      		next_LRU[prefetch_rd_idx] = 0;
    	end 
    end
  end

  always_ff @(posedge clock) begin
    if(reset)
      valids <= `SD 31'b0;
    else if(wr1_en) 
      valids[LRU_hist] [wr1_idx] <= `SD 1;
  end
  
  always_ff @(posedge clock) begin
    if(wr1_en) begin
      data[LRU_hist] [wr1_idx] <= `SD wr1_data;
      tags[LRU_hist] [wr1_idx] <= `SD wr1_tag;
    end
  end

  always_ff @(posedge clock) begin
    if(reset)
      LRU <= `SD 31'b0;
    else 
      LRU <= `SD next_LRU;
  end

endmodule
