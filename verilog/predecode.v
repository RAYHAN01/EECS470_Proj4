`timescale 1ns/100ps
module predecoder (
	input [31:0] inst,
 	input valid_inst_in,
	output logic is_br,	//is cond_br? decide if it will go into dirp & BTB
	output logic is_ret,	//pop from RAS
	output logic is_call,	//push from RAS
	output logic valid_inst,	//is 
	output logic uncond_branch	//is it uncond_br? only go into BTB
);
  logic illegal,cond_branch;

  assign is_br = cond_branch && valid_inst_in;
  assign valid_inst = valid_inst_in && !illegal;	// is a legal br?

  always_comb begin
	is_ret = 1'b0;
	is_call = 1'b0;
       	illegal = `TRUE;
	uncond_branch = `FALSE;
	cond_branch = `FALSE;
	case({inst[31:29], 3'b0})
	  6'h30, 6'h38: begin
          	case (inst[31:26])
            	  `FBEQ_INST, `FBLT_INST, `FBLE_INST,
            	  `FBNE_INST, `FBGE_INST, `FBGT_INST:
           		begin	// FP conditionals not implemented
				cond_branch = `FALSE; 
              			illegal = `TRUE;
            		end
            	  `BR_INST:	begin 
				uncond_branch = `TRUE;
       				illegal = `FALSE;
			end
            	  `BSR_INST:
            		begin
       				illegal = `FALSE;
              			uncond_branch = `TRUE;
				is_call = 1'b1;
            		end
            	  default:	
			begin
				cond_branch = `TRUE; // all others are conditional
       				illegal = `FALSE;
			end
          	endcase // case(inst[31:26])
	  end
          6'h18: begin
          	case (inst[31:26])
           	  `MISC_GRP:       illegal = `TRUE; // unimplemented
            	  `JSR_GRP:
            		begin	// JMP, JSR, RET, and JSR_CO have identical semantics
       				illegal = `FALSE;
              			uncond_branch = `TRUE;
	      			is_call = (inst[15:14]==`JSR_CO_INST) || (inst[15:14]==`JSR_INST);
				is_ret = (inst[15:14]==`JSR_CO_INST) || (inst[15:14]==`RET_INST);
			end
            	  `FTPI_GRP:       illegal = `TRUE;       // unimplemented
         	 endcase // case(inst[31:26])
	  end
	endcase
  end
endmodule // decoder

