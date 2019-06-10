module test_reg (
	input	clk, rst,
	input   [31:0][$clog2(`N_ENTRY_ROB+33)-1:0] tag,
	input	[`N_ENTRY_ROB+32:0][63:0] value_RF,
	input	[4:0]	wr_idx_0,	//modified for test
	input	[4:0]	wr_idx_1,	//modified for test
	input   valid_1,
	input   valid_0,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_0,
	input	[$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_1,
	input   [63:0] retire_NPC_0_in,
	input   [63:0] retire_NPC_1_in,

	output logic	[31:0][63:0] test_rf_value,
	output logic	[4:0] wr_idx_0_out,
	output logic	[4:0] wr_idx_1_out,
	output logic	[63:0] wr_value_0_out,
	output logic	[63:0] wr_value_1_out,

	output logic	retire_valid_0_out,
	output logic	retire_valid_1_out,
	output logic	[63:0] retire_NPC_0_out,
	output logic	[63:0] retire_NPC_1_out
);
//tag is modified when retire stage end. Then, test_reg use the tag of ARCH_MAP to read value from Physical reg combinationally.
	logic [4:0] wr_idx_0_reg;
	logic [4:0] wr_idx_1_reg;
	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_0_reg;
	logic [$clog2(`N_ENTRY_ROB+33)-1:0] Tnew_out_1_reg;

	assign wr_idx_0_out = retire_valid_0_out? wr_idx_0_reg : `ZERO_REG;
	assign wr_idx_1_out = retire_valid_1_out? wr_idx_1_reg : `ZERO_REG;
	assign wr_value_0_out = retire_valid_0_out? value_RF[Tnew_out_0_reg] : 0;
	assign wr_value_1_out = retire_valid_1_out? value_RF[Tnew_out_1_reg] : 0;
	always_ff @ (posedge clk) begin
		if (rst) begin
			retire_valid_0_out	<= `SD `FALSE;
			retire_valid_1_out	<= `SD `FALSE;
			wr_idx_0_reg		<= `SD `ZERO_REG;
			wr_idx_1_reg		<= `SD `ZERO_REG;
			Tnew_out_0_reg		<= `SD `ZERO_REG;
			Tnew_out_1_reg		<= `SD `ZERO_REG;
			retire_NPC_0_out	<= `SD 0;
			retire_NPC_1_out	<= `SD 0;	
		end else begin
			retire_valid_0_out	<= `SD valid_0;
			retire_valid_1_out	<= `SD valid_1;
			wr_idx_0_reg		<= `SD wr_idx_0;
			wr_idx_1_reg		<= `SD wr_idx_1;
			Tnew_out_0_reg		<= `SD Tnew_out_0;
			Tnew_out_1_reg		<= `SD Tnew_out_1;
			retire_NPC_0_out	<= `SD retire_NPC_0_in;
			retire_NPC_1_out	<= `SD retire_NPC_1_in;		
		end
	end
  // synopsys sync_set_reset "reset"
	always_comb begin
		for (int i=0; i<32 ; i++) begin
			if(tag[i]==`ZERO_REG)
				test_rf_value[i] = 64'h0;
			else	
				test_rf_value[i] = value_RF[tag[i]];
		end
	end

endmodule

