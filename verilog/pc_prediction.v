`timescale 1ns/100ps
module DIRP (
	input clock,
	input reset,
	input is_br,
	input [$clog2(`N_ENTRY_BHR)-1:0] pc_idx,

	input ex_br_valid,
	input ex_br,
	input [$clog2(`N_ENTRY_BHR)-1:0] ex_pc_idx,
	
	output logic br_pred
);

  logic [`N_ENTRY_BHR-1:0] bhr;
  logic [1:0][1:0] next_pht,next_pht_inter;
  logic [1:0] pht_mod_entry,pattern;

  logic [`N_ENTRY_BHR-1:0] [1:0][1:0] pht;
  logic current_bhr;
  logic hist;

	always_ff @(posedge clock) begin
		if(reset) begin
			bhr <= `SD 0;
			pht <= `SD  0;
		end
		else begin
			if(ex_br_valid) begin
				bhr[ex_pc_idx] <= `SD ex_br;
				pht[ex_pc_idx] <= `SD next_pht;
			end
		end
	end

	always_comb begin
		if(is_br) begin
			current_bhr = bhr[pc_idx];
			if(pht[pc_idx][current_bhr] <= 2'b01)
				br_pred = 0;
			else	br_pred = 1;
		end
		else	br_pred = 0;	

		hist = bhr[ex_pc_idx];
		next_pht = pht[ex_pc_idx];
		next_pht_inter = pht[ex_pc_idx];
		pht_mod_entry = next_pht_inter[hist];
		if(ex_br_valid) begin
			if(ex_br) begin
				case(pht_mod_entry)
					2'b00:	pattern = 2'b01;
					2'b01:	pattern = 2'b10;
					2'b10:	pattern = 2'b11;
					2'b11:	pattern = 2'b11;
				endcase
			end 
			else begin
				case(pht_mod_entry)
					2'b00:	pattern = 2'b00;
					2'b01:	pattern = 2'b00;
					2'b10:	pattern = 2'b01;
					2'b11:	pattern = 2'b10;
				endcase
			end
			next_pht[hist] =  pattern;	
		end
	end
endmodule






