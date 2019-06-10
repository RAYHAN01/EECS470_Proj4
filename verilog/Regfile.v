/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v                                           //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  // 
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps


module Regfile (
        input  [$clog2(`N_ENTRY_ROB+33)-1:0] rda_idx_0, rdb_idx_0, wr_idx_0, rda_idx_1, rdb_idx_1, wr_idx_1, // read/write index
        input  [63:0] wr_data_0, wr_data_1,            // write data
        input         wr_en_0, wr_en_1, wr_clk,
        output logic [`N_ENTRY_ROB+32:0][63:0] value_RF,		//output for test delete finally
        output logic [63:0] rda_out_0, rdb_out_0, rda_out_1, rdb_out_1    // read data
          
);
  
  logic    [32+`N_ENTRY_ROB:0] [63:0] registers;   // 32, 64-bit Registers

  wire   [63:0] rda_reg_0 = registers[rda_idx_0];
  wire   [63:0] rdb_reg_0 = registers[rdb_idx_0];
  wire   [63:0] rda_reg_1 = registers[rda_idx_1];
  wire   [63:0] rdb_reg_1 = registers[rdb_idx_1];

  assign value_RF = registers;
  //
  // Read port A0
  //
  always_comb begin
    if (rda_idx_0 == `ZERO_REG)
      rda_out_0 = 0;
    else if (wr_en_0 && (wr_idx_0 == rda_idx_0)) rda_out_0 = wr_data_0;
    else if (wr_en_1 && (wr_idx_1 == rda_idx_0)) rda_out_0 = wr_data_1;
        // internal forwarding
    else rda_out_0 = rda_reg_0;
  end

  //
  // Read port B0
  //
  always_comb begin
    if (rdb_idx_0 == `ZERO_REG)
      rdb_out_0 = 0;
    else if (wr_en_0 && (wr_idx_0 == rdb_idx_0)) rdb_out_0 = wr_data_0;
    else if (wr_en_1 && (wr_idx_1 == rdb_idx_0)) rdb_out_0 = wr_data_1;
    else rdb_out_0 = rdb_reg_0;
  end

  //

  //
  // Read port A1
  //
  always_comb begin
    if (rda_idx_1 == `ZERO_REG)
      rda_out_1 = 0;
    else if (wr_en_0 && (wr_idx_0 == rda_idx_1)) rda_out_1 = wr_data_0;
    else if (wr_en_1 && (wr_idx_1 == rda_idx_1)) rda_out_1 = wr_data_1;
    else rda_out_1 = rda_reg_1;
  end

  //
  // Read port B1
  //
  always_comb begin
    if (rdb_idx_1 == `ZERO_REG)
      rdb_out_1 = 0;
    else if (wr_en_0 && (wr_idx_0 == rdb_idx_1)) rdb_out_1 = wr_data_0;
    else if (wr_en_1 && (wr_idx_1 == rdb_idx_1)) rdb_out_1 = wr_data_1;
    else rdb_out_1 = rdb_reg_1;
  end

  //
  // Write port
  //
  always_ff @(posedge wr_clk) begin
	if (wr_en_0) begin
      		registers[wr_idx_0] <= `SD wr_data_0;
  	end
    	if (wr_en_1) begin
      		registers[wr_idx_1] <= `SD wr_data_1;
   	end
  end
endmodule // regfile
