/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  wb_stage.v                                          //
//                                                                     //
//  Description :   writeback (WB) stage of the pipeline;              //
//                  determine the destination register of the          //
//                  instruction and write the result to the register   //
//                  file (if not to the zero register), also reset the //
//                  NPC in the fetch stage to the correct next PC      //
//                  address.                                           // 
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps


module wb_stage_0 (
    input         clock,                // system clock
    input         reset,                // system reset
    input  [63:0] ex_mem_NPC_0,            // incoming instruction PC+4
    input  [63:0] ex_mem_alu_result_0,        // incoming instruction result
    input         ex_mem_take_branch_0, 
    input  [$clog2(`N_ENTRY_ROB+33)-1:0] ex_mem_dest_reg_idx_0,  // dest index (ZERO_REG if no writeback)
    input  [63:0] ex_mem_NPC_1,            // incoming instruction PC+4
    input  [63:0] ex_mem_alu_result_1,        // incoming instruction result
    input         ex_mem_take_branch_1, 
    input  [$clog2(`N_ENTRY_ROB+33)-1:0] ex_mem_dest_reg_idx_1,  // dest index (ZERO_REG if no writeback)
    //input         mem_wb_valid_inst,

    output logic [63:0] reg_wr_data_out_0,reg_wr_data_out_1,      // register writeback data
    output logic [$clog2(`N_ENTRY_ROB+33)-1:0] reg_wr_idx_out_0, reg_wr_idx_out_1,       // register writeback index
    output logic reg_wr_en_out_0, reg_wr_en_out_1,          // register writeback enable
    output logic [$clog2(`N_ENTRY_ROB+33)-1:0] CDB_0, CDB_1
    // Always enabled if valid inst
  );


  wire   [63:0] result_mux_0, result_mux_1;

  // Mux to select register writeback data:
  // ALU/MEM result, unless taken branch, in which case we write
  // back the old NPC as the return address.  Note that ALL branches
  // and jumps write back the 'link' value, but those that don't
  // want it specify ZERO_REG as the destination.
  assign result_mux_0 = (ex_mem_take_branch_0) ? ex_mem_NPC_0 : ex_mem_alu_result_0;
  assign result_mux_1 = (ex_mem_take_branch_1) ? ex_mem_NPC_1 : ex_mem_alu_result_1;

  // Generate signals for write-back to register file
  // reg_wr_en_out computation is sort of overkill since the reg file
  // has a special way of handling `ZERO_REG but there is no harm 
  // in putting this here.  Hopefully it illustrates how the pipeline works.
  assign reg_wr_en_out_0  = ex_mem_dest_reg_idx_0 != `ZERO_REG;
  assign reg_wr_idx_out_0 = ex_mem_dest_reg_idx_0;
  assign reg_wr_data_out_0 = result_mux_0;
  assign reg_wr_en_out_1  = ex_mem_dest_reg_idx_1 != `ZERO_REG;
  assign reg_wr_idx_out_1 = ex_mem_dest_reg_idx_1;
  assign reg_wr_data_out_1 = result_mux_1;
  assign CDB_0 = reg_wr_idx_out_0;
  assign CDB_1 = reg_wr_idx_out_1;

endmodule // module wb_stage

