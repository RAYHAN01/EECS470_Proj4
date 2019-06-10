`timescale 1ns/100ps
module BTB(
	input		clock,							
	input		reset,
	input		en_btb,
	input	[63:0]	PC_to_cam,
	input		exe_pc_valid,
	input	[$clog2(`ENTRY_PC)+`cam_bits-1:0]	PC_from_exe,	//idx needed for cam and entry
	input	[`target_bits-1:0]	ex_target,


	output	logic	[63:0]	PC_after_BTB
);

	logic [`ENTRY_PC-1:0][`cam_bits-1:0] cam_table, next_cam_table;
	logic [`ENTRY_PC-1:0][`target_bits-1:0] target_table, next_target_table;

	always_comb begin
		next_cam_table = cam_table;
		next_target_table = target_table;
		PC_after_BTB = PC_to_cam;
		if (exe_pc_valid) begin
			next_cam_table[PC_from_exe[$clog2(`ENTRY_PC)-1:0]] = PC_from_exe[$clog2(`ENTRY_PC)+`cam_bits-1:$clog2(`ENTRY_PC)];
			next_target_table[PC_from_exe[$clog2(`ENTRY_PC)-1:0]] = ex_target;
		end

		if (en_btb) begin
			if (PC_to_cam[$clog2(`ENTRY_PC)+2+`cam_bits-1:$clog2(`ENTRY_PC)+2] == next_cam_table[PC_to_cam[$clog2(`ENTRY_PC)+2-1:2]]) begin
 				PC_after_BTB[`target_bits+2-1:2] = next_target_table[PC_to_cam[$clog2(`ENTRY_PC)+2-1:2]];
			end		
		end
	end

	always_ff @(posedge clock) begin
		if (reset) begin
			cam_table	<= `SD	0;
			target_table	<= `SD	0;
		end else begin
			cam_table	<= `SD	next_cam_table;
			target_table	<= `SD	next_target_table;
		end	
	end

endmodule
