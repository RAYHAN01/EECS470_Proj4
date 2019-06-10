`timescale 1ns/100ps
module RAS(
	input clock,
	input reset,
	input is_ret,
	input is_call,
	input [63:0] call_NPC,
	
	output logic [63:0] ret_NPC,
	output logic ras_busy
);

  logic [`N_ENTRY_RAS-1:0][63:0] ras;

  logic [$clog2(`N_ENTRY_RAS)-1:0] pointer,next_pointer; 
  logic empty,next_empty;

  assign ras_busy = (next_pointer == 3'b111)? 1'b1 : 1'b0;
	always_ff @(posedge clock) begin
		if(reset) begin
			pointer <=  `SD 0;
			empty <= `SD 1;
		end
		else if(is_call) begin
			pointer <= `SD next_pointer;
			ras[next_pointer] <= `SD call_NPC;
			empty <= `SD next_empty;
		end
		else if(is_ret) begin
			pointer <= `SD next_pointer;
			empty <= `SD next_empty;
		end
	end

	always_comb begin
		next_empty = empty;
		next_pointer = pointer;
		ret_NPC = 64'b0;
		if(is_call) begin
			if(empty) begin
				next_pointer = 0;
				next_empty = 0;
			end
			else	next_pointer = pointer+1;
		end
		if(is_ret) begin
			ret_NPC = ras[pointer];
			if(pointer==0) begin
				next_pointer = 0;
				next_empty = 1;
			end
			else	next_pointer = pointer-1;	
		end
	end	
endmodule






