//////////////////////////////////////////////////////////////////////////
//                                                                      //
//   Modulename :  ex_stage.v                                           //
//                                                                      //
//  Description :  instruction execute (EX) stage of the pipeline;      //
//                 given the instruction command code CMD, select the   //
//                 proper input A and B for the ALU, compute the result,// 
//                 and compute the condition for branches, and pass all //
//                 the results down the pipeline. MWB                   // 
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

//
// The ALU
//
// given the command code CMD and proper operands A and B, compute the
// result of the instruction
//
// This module is purely combinational
//
module alu(
    input [63:0] opa,
    input [63:0] opb,
    ALU_FUNC     func,
    input [`STACK_NUM-1:0] b_mask,
    input recovery_request_ALU,
    input [`STACK_NUM-1:0] recovery_b_mask_ALU,

    output logic [63:0] result,
    output logic alu_flush
  );
  // This function computes a signed less-than operation
  function signed_lt;
    input [63:0] a, b;
    if (a[63] == b[63]) 
      signed_lt = (a < b); // signs match: signed compare same as unsigned
    else
      signed_lt = a[63];   // signs differ: a is smaller if neg, larger if pos
  endfunction

  always_comb begin
    case (func)
      ALU_ADDQ:      result = opa + opb;
      ALU_SUBQ:      result = opa - opb;
      ALU_AND:      result = opa & opb;
      ALU_BIC:      result = opa & ~opb;
      ALU_BIS:      result = opa | opb;
      ALU_ORNOT:    result = opa | ~opb;
      ALU_XOR:      result = opa ^ opb;
      ALU_EQV:      result = opa ^ ~opb;
      ALU_SRL:      result = opa >> opb[5:0];
      ALU_SLL:      result = opa << opb[5:0];
      ALU_SRA:      result = (opa >> opb[5:0]) | ({64{opa[63]}} << (64 -
                              opb[5:0])); // arithmetic from logical shift
      //ALU_MULQ:      result = opa * opb;
      ALU_CMPULT:    result = { 63'd0, (opa < opb) };
      ALU_CMPEQ:    result = { 63'd0, (opa == opb) };
      ALU_CMPULE:    result = { 63'd0, (opa <= opb) };
      ALU_CMPLT:    result = { 63'd0, signed_lt(opa, opb) };
      ALU_CMPLE:    result = { 63'd0, (signed_lt(opa, opb) || (opa == opb)) };
      default:      result = 64'hdeadbeefbaadbeef;  // here only to force
                              // a combinational solution
                              // a casex would be better
    endcase
    //adding mask for functions other than mult
    alu_flush=0;
    if (recovery_request_ALU==1) begin
	if (b_mask>=recovery_b_mask_ALU) begin
		alu_flush=1;
	end
    end
  end
endmodule // alu

//
// BrCond module
//
// Given the instruction code, compute the proper condition for the
// instruction; for branches this condition will indicate whether the
// target is taken.
//
// This module is purely combinational
//
module brcond(// Inputs
    input [63:0] opa,    // Value to check against condition
    input  [2:0] func,  // Specifies which condition to check

    output logic cond    // 0/1 condition result (False/True)
  );
  always_comb begin
  case (func[1:0])                              // 'full-case'  All cases covered, no need for a default
    2'b00: cond = (opa[0] == 0);                // LBC: (lsb(opa) == 0) ?
    2'b01: cond = (opa == 0);                    // EQ: (opa == 0) ?
    2'b10: cond = (opa[63] == 1);                // LT: (signed(opa) < 0) : check sign bit
    2'b11: cond = (opa[63] == 1) || (opa == 0);  // LE: (signed(opa) <= 0)
  endcase 
  // negate cond if func[2] is set
  if (func[2])
      cond = ~cond;
  end
endmodule // brcond


module ex_stage (
    input          		clock,               // system clock
    input         		reset,               // system reset
    //adding masks for instructions in FU
    input [63:0]   		id_ex_pre_target_PC_0,
    input [63:0]   		id_ex_pre_target_PC_1,
    input          		id_ex_br_sol_out_0,
    input          		id_ex_br_sol_out_1,
    input         		recovery_request,
    input          		br_correct,
    input [$clog2(`STACK_NUM)-1:0]br_correct_address,
    input [`STACK_NUM-1:0] 	id_ex_b_mask_out_0,
    input [`STACK_NUM-1:0] 	id_ex_b_mask_out_1,
    input [`STACK_NUM-1:0] 	recovery_b_mask,
    input  [63:0]  		id_ex_NPC_0, id_ex_NPC_1,           	     // incoming instruction PC+4
    input  [31:0]  		id_ex_IR_0, id_ex_IR_1,           	     // incoming instruction
    input  [63:0]  		id_ex_rega_0, id_ex_rega_1,         	     // register A value from reg file
    input  [63:0]  		id_ex_regb_0, id_ex_regb_1,         	     // register B value from reg file
    ALU_OPA_SELECT 		id_ex_opa_select_0, id_ex_opa_select_1,      // opA mux select from decoder
    ALU_OPB_SELECT 		id_ex_opb_select_0, id_ex_opb_select_1,      // opB mux select from decoder
    ALU_FUNC      		id_ex_alu_func_0, id_ex_alu_func_1,          // ALU function select from decoder
    input          		id_ex_cond_branch_0, id_ex_cond_branch_1,    // is this a cond br? from decoder
    input          		id_ex_uncond_branch_0, id_ex_uncond_branch_1,// is this an uncond br? from decoder
    input  [$clog2(`N_ENTRY_ROB+33)-1:0]   id_ex_dest_reg_idx_0, id_ex_dest_reg_idx_1,

    output logic [$clog2(`N_ENTRY_ROB+33)-1:0] id_ex_dest_reg_idx_next_0, id_ex_dest_reg_idx_next_1,
    output logic 	done_0, done_1, mult_enable_0, mult_enable_1, ex_stall_0, ex_stall_1,
    output logic [63:0] id_ex_NPC_next_0, id_ex_NPC_next_1,
    output logic [31:0]	id_ex_IR_next_0, id_ex_IR_next_1,
    output logic [63:0] ex_alu_result_out_0, ex_alu_result_out_1,  // ALU result
    output logic        ex_NPC_branch_enable_0,ex_NPC_branch_enable_1,
    output logic	ex_take_branch_out_0,ex_take_branch_out_1,// is this a taken branch?
    //adding masks for instructions in FU
    output logic alu_flush_0,
    output logic alu_flush_1,

    output logic 	br_correct_to_com_0, br_correct_to_com_1,//a result of br is calculated
    output logic [`STACK_NUM-1:0] recovery_b_mask_to_com,
    output logic [63:0] ex_target_result_0, ex_target_result_1,
    output logic	btb_mispred_0, btb_mispred_1,
    output logic [63:0] ex_LQ_addr_0, ex_LQ_addr_1
  );

  logic [63:0] opa_mux_out_0, opb_mux_out_0, opa_mux_out_1, opb_mux_out_1;
  logic        brcond_result_0, brcond_result_1;
  logic [63:0] ex_mult_result_1, ex_mult_result_0, ex_alu_result_0, ex_alu_result_1;
  logic	       recovery_request_to_com;
//  logic found_correct_bit;

  // set up possible immediates:
  //   mem_disp: sign-extended 16-bit immediate for memory format
  //   br_disp: sign-extended 21-bit immediate * 4 for branch displacement
  //   alu_imm: zero-extended 8-bit immediate for ALU ops
  wire [63:0] mem_disp_0 = { {48{id_ex_IR_0[15]}}, id_ex_IR_0[15:0] };
  wire [63:0] br_disp_0  = { {41{id_ex_IR_0[20]}}, id_ex_IR_0[20:0], 2'b00 };
  wire [63:0] alu_imm_0  = { 56'b0, id_ex_IR_0[20:13] };
  wire [63:0] mem_disp_1 = { {48{id_ex_IR_1[15]}}, id_ex_IR_1[15:0] };
  wire [63:0] br_disp_1  = { {41{id_ex_IR_1[20]}}, id_ex_IR_1[20:0], 2'b00 };
  wire [63:0] alu_imm_1  = { 56'b0, id_ex_IR_1[20:13] };
  assign ex_LQ_addr_0 = ex_alu_result_0;
  assign ex_LQ_addr_1 = ex_alu_result_1;
   //
   // ALU opA mux
   //
  always_comb begin
    case (id_ex_opa_select_0)
      ALU_OPA_IS_REGA:     opa_mux_out_0 = id_ex_rega_0;
      ALU_OPA_IS_MEM_DISP: opa_mux_out_0 = mem_disp_0;
      ALU_OPA_IS_NPC:      opa_mux_out_0 = id_ex_NPC_0;
      ALU_OPA_IS_NOT3:     opa_mux_out_0 = ~64'h3;
    endcase
  end
  always_comb begin
    case (id_ex_opa_select_1)
      ALU_OPA_IS_REGA:     opa_mux_out_1 = id_ex_rega_1;
      ALU_OPA_IS_MEM_DISP: opa_mux_out_1 = mem_disp_1;
      ALU_OPA_IS_NPC:      opa_mux_out_1 = id_ex_NPC_1;
      ALU_OPA_IS_NOT3:     opa_mux_out_1 = ~64'h3;
    endcase
  end

   //
   // ALU opB mux
   //
  always_comb begin
    // Default value, Set only because the case isnt full.  If you see this
    // value on the output of the mux you have an invalid opb_select
    case (id_ex_opb_select_0)
      ALU_OPB_IS_REGB:    opb_mux_out_0 = id_ex_regb_0;
      ALU_OPB_IS_ALU_IMM: opb_mux_out_0 = alu_imm_0;
      ALU_OPB_IS_BR_DISP: opb_mux_out_0 = br_disp_0;
      default: opb_mux_out_0 = 64'hbaadbeefdeadbeef;
    endcase 
  end
  always_comb begin
    // Default value, Set only because the case isnt full.  If you see this
    // value on the output of the mux you have an invalid opb_select
    case (id_ex_opb_select_1)
      ALU_OPB_IS_REGB:    opb_mux_out_1 = id_ex_regb_1;
      ALU_OPB_IS_ALU_IMM: opb_mux_out_1 = alu_imm_1;
      ALU_OPB_IS_BR_DISP: opb_mux_out_1 = br_disp_1;
      default: opb_mux_out_1 = 64'hbaadbeefdeadbeef;
    endcase 
  end
  //select alu or mult
  always_comb begin
    if(id_ex_alu_func_0==ALU_MULQ) mult_enable_0 = 1'b1;
    else 			   mult_enable_0 = 1'b0;
  end
  always_comb begin
    if(id_ex_alu_func_1==ALU_MULQ) mult_enable_1 = 1'b1;
    else 			   mult_enable_1 = 1'b0;
  end
  //
  // instantiate the ALU
  //
  alu alu_0 (// Inputs
    .recovery_request_ALU(recovery_request),
    .recovery_b_mask_ALU(recovery_b_mask),
    .b_mask(id_ex_b_mask_out_0),
    .opa(opa_mux_out_0),
    .opb(opb_mux_out_0),
    .func(id_ex_alu_func_0),

    // Output
    .result(ex_alu_result_0),
    .alu_flush(alu_flush_0)
  );

  alu alu_1 (// Inputs
    .recovery_request_ALU(recovery_request),
    .recovery_b_mask_ALU(recovery_b_mask),
    .b_mask(id_ex_b_mask_out_1),
    .opa(opa_mux_out_1),
    .opb(opb_mux_out_1),
    .func(id_ex_alu_func_1),

    // Output
    .result(ex_alu_result_1),
    .alu_flush(alu_flush_1)
  );
   //
   // instantiate the Multiplier
  mult mult_0(
	.br_correct_mult(br_correct),
	.br_correct_address_mult(br_correct_address),
	.recovery_request_mult(recovery_request),
	.recovery_b_mask_mult(recovery_b_mask),
	.b_mask(id_ex_b_mask_out_0),
	.clock(clock),
	.reset(reset),
	.mcand(opa_mux_out_0),
	.mplier(opb_mux_out_0),
	.start(mult_enable_0),
	.id_ex_NPC(id_ex_NPC_0), 	
	.id_ex_IR(id_ex_IR_0),
	.id_ex_dest_reg_idx(id_ex_dest_reg_idx_0),


	.product(ex_mult_result_0),
	.done(done_0),
	.id_ex_NPC_next(id_ex_NPC_next_0),
	.id_ex_IR_next(id_ex_IR_next_0),
	.id_ex_dest_reg_idx_next(id_ex_dest_reg_idx_next_0)
  );
  mult mult_1(
	.br_correct_mult(br_correct),
	.br_correct_address_mult(br_correct_address),
	.recovery_request_mult(recovery_request),
	.recovery_b_mask_mult(recovery_b_mask),
	.b_mask(id_ex_b_mask_out_1),
	.clock(clock),
	.reset(reset),
	.mcand(opa_mux_out_1),
	.mplier(opb_mux_out_1),
	.start(mult_enable_1),
	.id_ex_NPC(id_ex_NPC_1),
	.id_ex_IR(id_ex_IR_1),
	.id_ex_dest_reg_idx(id_ex_dest_reg_idx_1),

	.product(ex_mult_result_1),
	.done(done_1),
	.id_ex_NPC_next(id_ex_NPC_next_1),
	.id_ex_IR_next(id_ex_IR_next_1),
	.id_ex_dest_reg_idx_next(id_ex_dest_reg_idx_next_1)
  );
  always_comb begin
    ex_stall_0 = 1'b0;
    if(done_0) begin
	ex_alu_result_out_0 = ex_mult_result_0;
	if(!mult_enable_0) ex_stall_0 = 1'b1;		   
    end
    else ex_alu_result_out_0 = ex_alu_result_0;//ex_alu_result_0;

    ex_stall_1 = 1'b0;
    if(done_1) begin
	ex_alu_result_out_1 = ex_mult_result_1;
	if(!mult_enable_1) ex_stall_1 = 1'b1;		   
    end
    else ex_alu_result_out_1 = ex_alu_result_1;//ex_alu_result_1;
  end
   // instantiate the branch condition tester
   //
  brcond brcond_0 (// Inputs
    .opa(id_ex_rega_0),       // always check regA value
    .func(id_ex_IR_0[28:26]), // inst bits to determine check

    // Output
    .cond(brcond_result_0)
  );
  brcond brcond_1 (// Inputs
    .opa(id_ex_rega_1),       // always check regA value
    .func(id_ex_IR_1[28:26]), // inst bits to determine check

    // Output
    .cond(brcond_result_1)
  );

   // ultimate "take branch" signal:
   //    unconditional, or conditional and the condition is true
  assign ex_NPC_branch_enable_0 = done_0 ? 1'b0 : (id_ex_cond_branch_0 || id_ex_uncond_branch_0) ? recovery_request_to_com : 1'b0;
  assign ex_NPC_branch_enable_1 = done_1 ? 1'b0 : (id_ex_cond_branch_1 || id_ex_uncond_branch_1) ? recovery_request_to_com : 1'b0;
  assign ex_take_branch_out_0   = done_0 ? 1'b0 : (id_ex_uncond_branch_0 || (id_ex_cond_branch_0 & brcond_result_0));
  assign ex_take_branch_out_1   = done_1 ? 1'b0 : (id_ex_uncond_branch_1 || (id_ex_cond_branch_1 & brcond_result_1));
  always_comb begin
	btb_mispred_0              = 0;
	btb_mispred_1              = 0;
	br_correct_to_com_0 	   = 0;
	br_correct_to_com_1 	   = 0;
	recovery_request_to_com    = 0;
	recovery_b_mask_to_com 	   = 8'b0;
//	found_correct_bit = 0;
	if(ex_take_branch_out_0) begin
		ex_target_result_0 = ex_alu_result_out_0;
	end else begin	
		ex_target_result_0 = id_ex_NPC_0;
	end
	if(ex_take_branch_out_1) begin
		ex_target_result_1 = ex_alu_result_out_1;
	end else begin	
		ex_target_result_1 = id_ex_NPC_1;
	end
	
	if (id_ex_cond_branch_0 || id_ex_uncond_branch_0) begin
		recovery_b_mask_to_com = id_ex_b_mask_out_0;
		if ((id_ex_br_sol_out_0==0) && (ex_take_branch_out_0==0))
			br_correct_to_com_0 	= 1;
		else if (((id_ex_br_sol_out_0==1) && (ex_take_branch_out_0==1)) && (id_ex_pre_target_PC_0 == ex_target_result_0))
			br_correct_to_com_0 	= 1;
		else	recovery_request_to_com = 1;

		if (ex_take_branch_out_0 && (id_ex_pre_target_PC_0 != ex_target_result_0)) begin
			btb_mispred_0 = 1;
		end
	end
	if (id_ex_cond_branch_1 || id_ex_uncond_branch_1) begin //avoid two branch complete at the same time
		recovery_b_mask_to_com = id_ex_b_mask_out_1;
		if ((id_ex_br_sol_out_1==0) && (ex_take_branch_out_1==0))
			br_correct_to_com_1 	= 1;
		else if (((id_ex_br_sol_out_1==1) && (ex_take_branch_out_1==1)) && (id_ex_pre_target_PC_1 == ex_target_result_1))
			br_correct_to_com_1 	= 1;
		else	recovery_request_to_com = 1;
			
		//else if ((id_ex_br_sol_out_1==0) && (ex_take_branch_out_1==1)||(id_ex_br_sol_out_1==1) && (ex_take_branch_out_1==0))
		//	recovery_request_to_com = 1;
		//else if (((id_ex_br_sol_out_1==1) && (ex_take_branch_out_1==1)) && (id_ex_pre_target_PC_0 != ex_target_result_0))
		//	recovery_request_to_com = 1;
		if (ex_take_branch_out_1 && (id_ex_pre_target_PC_1 != ex_target_result_1)) begin
			btb_mispred_1 		= 1;
		end
	end
	if (br_correct) begin
			recovery_b_mask_to_com[br_correct_address]=0;
			/*for (int i = 0; i<`STACK_NUM; i++) begin
				if (found_correct_bit == 0 && recovery_b_mask[i]==1) begin
					found_correct_bit 	= 1;
					recovery_b_mask_to_com[i]=0;
				end
			end*/

	end
	
  end

endmodule // module ex_stage
