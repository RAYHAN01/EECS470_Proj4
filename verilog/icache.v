`timescale 1ns/100ps
module icache(
    input   clock,
    input   reset,
    input   [3:0] Imem2proc_response,   //If Dcache use memory, it will be 0.
    input  [63:0] Imem2proc_data,	//data from memory.(when cache miss)
    input   [3:0] Imem2proc_tag,	//tag from memory about current reply

    input  [63:0] proc2Icache_addr,	//address from PC(PC works as address to fetch)
    input         ex_mem_take_branch,   //recovery_request
    input         br_sol_target,        //if branch
    input  [63:0] ex_mem_target_pc, pre_target_PC,	//PC from outside
    input  [63:0] cachemem_data, //prefetch_data,	//fetched data from icache 
    input         cachemem_valid,prefetch_valid,	//fetched data valid or not from icache
    input 	  structural_hazard,

    output logic  [1:0] proc2Imem_command,//command sent to memory(through pipeline to select)
    output logic [63:0] proc2Imem_addr,	  //address sent to memory(through pipeline to select)

    output logic [63:0] Icache_data_out, //data from icache,send to IF // value is memory[proc2Icache_addr]
    output logic  Icache_valid_out,      //fetched data valid or not from icache, sent to IF //when this is high

    output logic  [3:0] read_index,	//index sent to icache to get data to IF
    output logic  [8:0] read_tag,	//tag sent to icache to judge if data matched for IF ;   to do for pipeline.
    output logic  [3:0] current_index,	//index sent to icache to prefecth
    output logic  [8:0] current_tag,	//tag sent to icache to judge if data matched for prefetch
    output logic  [3:0] write_index,	//index sent to icache to write  to do for pipeline
    output logic  [8:0] write_tag,	//tag sent to icache to write
    output logic  data_write_enable	// write enable for icache
  
  );
  //MSHR table.
  logic [`NUM_MEM_TAGS:1] [3:0] MSHR_index;
  logic [`NUM_MEM_TAGS:1] [8:0] MSHR_tag;
  logic [`NUM_MEM_TAGS:1] 	MSHR_valid;
  //PC value
  logic [63:0] PC_reg, next_PC, PC_plus_8;
  //pass one cycle used for visit memory
  logic	       last_cache_miss;
  logic [3:0]  last_index;
  logic [8:0]  last_tag;
  logic [63:0] last_PC;
  logic [15:0] a,b;


  assign {a,read_tag, read_index}	      = proc2Icache_addr[31:3];					//PC from IF to read value
  assign {b,current_tag, current_index} = PC_reg [31:3]; 						//fetch index
  assign proc2Imem_command	      = (last_cache_miss&&(!structural_hazard))? BUS_LOAD : BUS_NONE;			//Visit memory at next cycle after looking in cache when missed
  assign proc2Imem_addr 	      = {last_PC[63:3], 3'b0};  				//use last PC to visit memory.
  assign Icache_data_out              = cachemem_data;						//sent value to IF
  assign Icache_valid_out 	      = cachemem_valid; 					//sent valid to IF
  wire   cache_miss 	 	      = !prefetch_valid;					//prefetch find miss
  wire   unanswered_miss  	      = last_cache_miss & (Imem2proc_response == 0);		//miss not resolved
  assign PC_plus_8        	      = PC_reg + 8;
  assign data_write_enable	      = (Imem2proc_tag != 0) & MSHR_valid[Imem2proc_tag];
  assign write_index		      = (Imem2proc_tag != 0)?  MSHR_index[Imem2proc_tag] : 0;
  assign write_tag		      = (Imem2proc_tag != 0)?  MSHR_tag  [Imem2proc_tag] : 0;
  assign next_PC   = ex_mem_take_branch ? ex_mem_target_pc : 
					br_sol_target ?   pre_target_PC :
					unanswered_miss||structural_hazard ?  PC_reg : 
					PC_plus_8; 

  // synopsys sync_set_reset "reset"
  always_ff @(posedge clock) begin
    if(reset) begin
      MSHR_index  <= `SD 0;
      MSHR_tag    <= `SD 0;   
     // MSHR_valid  <= `SD 0;  
    end
      
    else if((last_cache_miss & (Imem2proc_response != 0))& !ex_mem_take_branch) begin
      MSHR_index[Imem2proc_response]  <= `SD last_index;
      MSHR_tag[Imem2proc_response]    <= `SD last_tag;
    //  MSHR_valid[Imem2proc_response]  <= `SD 1; 
    end
    if(reset || ex_mem_take_branch ) MSHR_valid  <= `SD 0; 
    else if(last_cache_miss & (Imem2proc_response != 0)) MSHR_valid[Imem2proc_response]  <= `SD  1;
	
    if(data_write_enable) MSHR_valid[Imem2proc_tag] <= `SD 0;
  end     
  // synopsys sync_set_reset "reset" 
  always_ff @(posedge clock) begin
    if(reset)   PC_reg <= `SD 0;
    else 	PC_reg <= `SD next_PC;  
  end    
  // synopsys sync_set_reset "reset"   
  always_ff @(posedge clock) begin
    if(reset||ex_mem_take_branch) begin
      last_index       <= `SD -1;   // These are -1 to get ball rolling when
      last_tag         <= `SD -1;   // reset goes low because addr "changes"            
      last_cache_miss  <= `SD 0;
      last_PC	       <= `SD 0;
    end else if(!unanswered_miss && !structural_hazard) begin
      last_index       <= `SD current_index;
      last_tag         <= `SD current_tag;
      last_cache_miss  <= `SD cache_miss;
      last_PC  	       <= `SD PC_reg;
    end
  end                                                            
endmodule

