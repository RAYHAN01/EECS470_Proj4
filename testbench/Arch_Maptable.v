`timescale 1ns/100ps
module ArchMap (
	input   		clock,
	input   		reset,
	input   		[$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_0,
	input			[$clog2(`N_ENTRY_ROB+33)-1:0] Told_out_1,
	input			[$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_0,
	input   		[$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_1,
	input   		valid_1,
	input   		valid_0,

	output logic	[4:0]	wr_idx_0,	//modified for test
	output logic	[4:0]	wr_idx_1,	//modified for test
	output logic	[31:0][$clog2(`N_ENTRY_ROB+33)-1:0] tag
 );
	logic	[31:0][$clog2(`N_ENTRY_ROB+33)-1:0] next_tag;


  // synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if (reset) begin
			for (int i=0; i<32; i++) begin
				tag[i] <= `SD i;
			end
		end
		else begin
			for (int i=0; i<31; i++) begin
				tag[i] <= `SD next_tag[i];
			end		
		end
	end

	always_comb begin
		wr_idx_0 = `ZERO_REG; //Latch ADD
		wr_idx_1 = `ZERO_REG; //Latch ADD
		for (int i=0; i<32; i++) begin
			if ((tag[i]==Told_out_0)&&valid_0) begin
				if (Tnew_out_0 == Told_out_1) begin
					next_tag[i] = Tnew_out_1;
					wr_idx_0 = i;	//modified for test
					wr_idx_1 = i;	//modified for test
				end
				else begin
					next_tag[i] = Tnew_out_0;
					wr_idx_0 = i;	//modified for test
				end
			end
			else if ((tag[i]==Told_out_1)&&valid_1) begin
				next_tag[i] = Tnew_out_1;
				wr_idx_1 = i;	//modified for test
			end
			else 
				next_tag[i] = tag[i];

		end
	end
endmodule
