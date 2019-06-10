 
****************************************
Report : resources
Design : pipeline
Version: O-2018.06
Date   : Sun Apr 21 15:47:43 2019
****************************************

Resource Sharing Report for design pipeline in file
        /afs/umich.edu/user/l/i/liqiz/Documents/passed/verilog/pipeline.v

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r8731    | DW01_cmp2    | width=8    |               | ex_stage_0/alu_0/gte_71 |
        |              |            |               | ex_stage_0/mult_0/mstage[0]/gte_71 |
            |            |               |                      |
|          |              |            |               | gte_1005 gte_1005_I2 |
|          |              |            |               | gte_1005_I3          |
|          |              |            |               | gte_1005_I4          |
|          |              |            |               | gte_1005_I5          |
|          |              |            |               | gte_1005_I6          |
|          |              |            |               | gte_1005_I7          |
|          |              |            |               | gte_1005_I8          |
| r8732    | DW01_cmp2    | width=8    |               | ex_stage_0/alu_1/gte_71 |
        |              |            |               | ex_stage_0/mult_1/mstage[0]/gte_71 |
            |            |               |                      |
|          |              |            |               | gte_1008 gte_1008_I2 |
|          |              |            |               | gte_1008_I3          |
|          |              |            |               | gte_1008_I4          |
|          |              |            |               | gte_1008_I5          |
|          |              |            |               | gte_1008_I6          |
|          |              |            |               | gte_1008_I7          |
|          |              |            |               | gte_1008_I8          |
| r8740    | DW01_sub     | width=6    |               | Freelist_0/sub_80    |
|          |              |            |               | Freelist_0/sub_82    |
| r8741    | DW01_dec     | width=6    |               | Freelist_0/sub_81    |
|          |              |            |               | Freelist_0/sub_91    |
| r8743    | DW01_inc     | width=5    |               | Freelist_0/add_120   |
|          |              |            |               | Freelist_0/add_133   |
| r8808    | DW01_sub     | width=6    |               | recovery_0/sub_109   |
|          |              |            |               | recovery_0/sub_111   |
| r8809    | DW01_dec     | width=6    |               | recovery_0/sub_110   |
|          |              |            |               | recovery_0/sub_120   |
| r8874    | DW01_sub     | width=6    |               | recovery_0/sub_109_I2 |
          |              |            |               | recovery_0/sub_111_I2 |
| r8875    | DW01_dec     | width=6    |               | recovery_0/sub_110_I2 |
          |              |            |               | recovery_0/sub_120_I2 |
| r8940    | DW01_sub     | width=6    |               | recovery_0/sub_109_I3 |
          |              |            |               | recovery_0/sub_111_I3 |
| r8941    | DW01_dec     | width=6    |               | recovery_0/sub_110_I3 |
          |              |            |               | recovery_0/sub_120_I3 |
| r9006    | DW01_sub     | width=6    |               | recovery_0/sub_109_I4 |
          |              |            |               | recovery_0/sub_111_I4 |
| r9007    | DW01_dec     | width=6    |               | recovery_0/sub_110_I4 |
          |              |            |               | recovery_0/sub_120_I4 |
| r9072    | DW01_sub     | width=6    |               | recovery_0/sub_109_I5 |
          |              |            |               | recovery_0/sub_111_I5 |
| r9073    | DW01_dec     | width=6    |               | recovery_0/sub_110_I5 |
          |              |            |               | recovery_0/sub_120_I5 |
| r9138    | DW01_sub     | width=6    |               | recovery_0/sub_109_I6 |
          |              |            |               | recovery_0/sub_111_I6 |
| r9139    | DW01_dec     | width=6    |               | recovery_0/sub_110_I6 |
          |              |            |               | recovery_0/sub_120_I6 |
| r9204    | DW01_sub     | width=6    |               | recovery_0/sub_109_I7 |
          |              |            |               | recovery_0/sub_111_I7 |
| r9205    | DW01_dec     | width=6    |               | recovery_0/sub_110_I7 |
          |              |            |               | recovery_0/sub_120_I7 |
| r9270    | DW01_sub     | width=6    |               | recovery_0/sub_109_I8 |
          |              |            |               | recovery_0/sub_111_I8 |
| r9271    | DW01_dec     | width=6    |               | recovery_0/sub_110_I8 |
          |              |            |               | recovery_0/sub_120_I8 |
| r9520    | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365    |
|          |              |            |               | LSQ_0/SQ_0/eq_128    |
| r9521    | DW01_inc     | width=3    |               | LSQ_0/LQ_0/add_362_I2 |
          |              |            |               | LSQ_0/LQ_0/add_475_I2_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I2_I8 |
       |              |            |               | LSQ_0/SQ_0/add_62    |
| r9523    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I3 |
          |              |            |               | LSQ_0/LQ_0/add_475_I3_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I3_I8 |
| r9525    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I4 |
          |              |            |               | LSQ_0/LQ_0/add_475_I4_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I4_I8 |
| r9527    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I5 |
          |              |            |               | LSQ_0/LQ_0/add_475_I5_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I5_I8 |
| r9529    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I6 |
          |              |            |               | LSQ_0/LQ_0/add_475_I6_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I6_I8 |
| r9531    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I7 |
          |              |            |               | LSQ_0/LQ_0/add_475_I7_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I7_I8 |
| r9533    | DW01_add     | width=3    |               | LSQ_0/LQ_0/add_362_I8 |
          |              |            |               | LSQ_0/LQ_0/add_475_I8_I1 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I2 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I3 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I4 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I5 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I6 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I7 |
       |              |            |               | LSQ_0/LQ_0/add_475_I8_I8 |
| r9702    | DW01_cmp6    | width=3    |               | LSQ_0/SQ_0/eq_100    |
|          |              |            |               | LSQ_0/SQ_0/eq_111    |
| r9704    | DW01_cmp6    | width=3    |               | LSQ_0/SQ_0/eq_201    |
|          |              |            |               | LSQ_0/SQ_0/eq_202    |
| r9705    | DW01_cmp6    | width=3    |               | LSQ_0/SQ_0/eq_201_2  |
|          |              |            |               | LSQ_0/SQ_0/eq_202_2  |
| r9706    | DW01_cmp6    | width=64   |               | ex_stage_0/eq_354_3  |
|          |              |            |               | ex_stage_0/ne_358    |
| r9707    | DW01_cmp6    | width=64   |               | ex_stage_0/eq_366_3  |
|          |              |            |               | ex_stage_0/ne_374    |
| r9710    | DW_rash      | A_width=64 |               | ex_stage_0/alu_0/srl_54 |
        |              | SH_width=6 |               | ex_stage_0/alu_0/srl_56 |
| r9714    | DW01_cmp6    | width=64   |               | ex_stage_0/alu_0/eq_60 |
         |              |            |               | ex_stage_0/alu_0/lt_39_C62 |
     |              |            |               | ex_stage_0/alu_0/lt_39_C63 |
     |              |            |               | ex_stage_0/alu_0/lt_59 |
         |              |            |               | ex_stage_0/alu_0/lte_61 |
| r9718    | DW_rash      | A_width=64 |               | ex_stage_0/alu_1/srl_54 |
        |              | SH_width=6 |               | ex_stage_0/alu_1/srl_56 |
| r9722    | DW01_cmp6    | width=64   |               | ex_stage_0/alu_1/eq_60 |
         |              |            |               | ex_stage_0/alu_1/lt_39_C62 |
     |              |            |               | ex_stage_0/alu_1/lt_39_C63 |
     |              |            |               | ex_stage_0/alu_1/lt_59 |
         |              |            |               | ex_stage_0/alu_1/lte_61 |
| r9810    | DW01_cmp6    | width=9    |               | dcache_0/eq_114      |
|          |              |            |               | dcache_0/eq_34       |
| r9811    | DW01_cmp6    | width=9    |               | dcache_0/eq_118      |
|          |              |            |               | dcache_0/eq_34_2     |
| r9812    | DW01_cmp6    | width=9    |               | dcache_0/eq_36       |
|          |              |            |               | dcache_0/eq_39       |
|          |              |            |               | dcache_0/eq_85       |
| r9813    | DW01_cmp6    | width=9    |               | dcache_0/eq_37       |
|          |              |            |               | dcache_0/eq_40       |
|          |              |            |               | dcache_0/eq_91       |
| r9814    | DW01_cmp6    | width=9    |               | dcache_0/eq_39_2     |
|          |              |            |               | dcache_0/eq_87       |
| r9815    | DW01_cmp6    | width=9    |               | dcache_0/eq_40_2     |
|          |              |            |               | dcache_0/eq_93       |
| r10870   | DW01_add     | width=64   |               | icache_0/add_54      |
| r10872   | DW01_add     | width=64   |               | if_stage_0/add_47    |
| r10874   | DW01_add     | width=64   |               | if_stage_0/add_48    |
| r10876   | DW01_cmp2    | width=2    |               | predecode_br_0/PC_inst_0/dirp_0/lte_39 |
| r10878   | DW01_cmp6    | width=8    |               | predecode_br_0/PC_inst_0/btb_0/eq_28 |
| r10880   | DW01_inc     | width=3    |               | predecode_br_0/PC_inst_0/ras_0/add_44 |
| r10882   | DW01_dec     | width=3    |               | predecode_br_0/PC_inst_0/ras_0/sub_52 |
| r10884   | DW01_add     | width=5    |               | Freelist_0/add_116   |
| r10886   | DW01_cmp6    | width=7    |               | recovery_0/eq_96     |
| r10888   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2   |
| r10890   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I1 |
| r10892   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I1 |
| r10894   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I1 |
| r10896   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I1 |
| r10898   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I1 |
| r10900   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I1 |
| r10902   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I1 |
| r10904   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I1 |
| r10906   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I1 |
| r10908   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I1 |
| r10910   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I1 |
| r10912   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I1 |
| r10914   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I1 |
| r10916   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I1 |
| r10918   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I1 |
| r10920   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I1 |
| r10922   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I1 |
| r10924   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I1 |
| r10926   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I1 |
| r10928   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I1 |
| r10930   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I1 |
| r10932   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I1 |
| r10934   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I1 |
| r10936   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I1 |
| r10938   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I1 |
| r10940   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I1 |
| r10942   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I1 |
| r10944   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I1 |
| r10946   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I1 |
| r10948   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I1 |
| r10950   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I1 |
| r10952   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I1 |
| r10954   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I1 |
| r10956   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I1 |
| r10958   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I1 |
| r10960   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I1 |
| r10962   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I1 |
| r10964   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I1 |
| r10966   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I1 |
| r10968   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I1 |
| r10970   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I1 |
| r10972   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I1 |
| r10974   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I1 |
| r10976   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I1 |
| r10978   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I1 |
| r10980   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I1 |
| r10982   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I1 |
| r10984   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I1 |
| r10986   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I1 |
| r10988   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I1 |
| r10990   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I1 |
| r10992   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I1 |
| r10994   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I1 |
| r10996   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I1 |
| r10998   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I1 |
| r11000   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I1 |
| r11002   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I1 |
| r11004   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I1 |
| r11006   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I1 |
| r11008   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I1 |
| r11010   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I1 |
| r11012   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I1 |
| r11014   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2  |
| r11016   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2 |
| r11018   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I2 |
| r11020   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I2 |
| r11022   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I2 |
| r11024   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I2 |
| r11026   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I2 |
| r11028   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I2 |
| r11030   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I2 |
| r11032   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I2 |
| r11034   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I2 |
| r11036   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I2 |
| r11038   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I2 |
| r11040   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I2 |
| r11042   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I2 |
| r11044   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I2 |
| r11046   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I2 |
| r11048   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I2 |
| r11050   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I2 |
| r11052   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I2 |
| r11054   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I2 |
| r11056   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I2 |
| r11058   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I2 |
| r11060   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I2 |
| r11062   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I2 |
| r11064   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I2 |
| r11066   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I2 |
| r11068   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I2 |
| r11070   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I2 |
| r11072   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I2 |
| r11074   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I2 |
| r11076   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I2 |
| r11078   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I2 |
| r11080   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I2 |
| r11082   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I2 |
| r11084   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I2 |
| r11086   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I2 |
| r11088   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I2 |
| r11090   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I2 |
| r11092   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I2 |
| r11094   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I2 |
| r11096   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I2 |
| r11098   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I2 |
| r11100   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I2 |
| r11102   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I2 |
| r11104   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I2 |
| r11106   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I2 |
| r11108   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I2 |
| r11110   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I2 |
| r11112   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I2 |
| r11114   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I2 |
| r11116   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I2 |
| r11118   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I2 |
| r11120   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I2 |
| r11122   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I2 |
| r11124   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I2 |
| r11126   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I2 |
| r11128   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I2 |
| r11130   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I2 |
| r11132   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I2 |
| r11134   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I2 |
| r11136   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I2 |
| r11138   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I2 |
| r11140   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I2 |
| r11142   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3  |
| r11144   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3 |
| r11146   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I3 |
| r11148   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I3 |
| r11150   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I3 |
| r11152   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I3 |
| r11154   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I3 |
| r11156   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I3 |
| r11158   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I3 |
| r11160   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I3 |
| r11162   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I3 |
| r11164   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I3 |
| r11166   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I3 |
| r11168   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I3 |
| r11170   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I3 |
| r11172   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I3 |
| r11174   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I3 |
| r11176   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I3 |
| r11178   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I3 |
| r11180   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I3 |
| r11182   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I3 |
| r11184   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I3 |
| r11186   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I3 |
| r11188   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I3 |
| r11190   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I3 |
| r11192   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I3 |
| r11194   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I3 |
| r11196   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I3 |
| r11198   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I3 |
| r11200   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I3 |
| r11202   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I3 |
| r11204   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I3 |
| r11206   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I3 |
| r11208   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I3 |
| r11210   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I3 |
| r11212   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I3 |
| r11214   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I3 |
| r11216   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I3 |
| r11218   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I3 |
| r11220   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I3 |
| r11222   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I3 |
| r11224   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I3 |
| r11226   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I3 |
| r11228   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I3 |
| r11230   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I3 |
| r11232   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I3 |
| r11234   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I3 |
| r11236   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I3 |
| r11238   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I3 |
| r11240   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I3 |
| r11242   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I3 |
| r11244   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I3 |
| r11246   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I3 |
| r11248   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I3 |
| r11250   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I3 |
| r11252   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I3 |
| r11254   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I3 |
| r11256   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I3 |
| r11258   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I3 |
| r11260   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I3 |
| r11262   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I3 |
| r11264   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I3 |
| r11266   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I3 |
| r11268   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I3 |
| r11270   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4  |
| r11272   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4 |
| r11274   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I4 |
| r11276   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I4 |
| r11278   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I4 |
| r11280   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I4 |
| r11282   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I4 |
| r11284   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I4 |
| r11286   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I4 |
| r11288   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I4 |
| r11290   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I4 |
| r11292   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I4 |
| r11294   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I4 |
| r11296   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I4 |
| r11298   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I4 |
| r11300   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I4 |
| r11302   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I4 |
| r11304   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I4 |
| r11306   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I4 |
| r11308   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I4 |
| r11310   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I4 |
| r11312   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I4 |
| r11314   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I4 |
| r11316   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I4 |
| r11318   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I4 |
| r11320   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I4 |
| r11322   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I4 |
| r11324   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I4 |
| r11326   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I4 |
| r11328   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I4 |
| r11330   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I4 |
| r11332   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I4 |
| r11334   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I4 |
| r11336   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I4 |
| r11338   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I4 |
| r11340   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I4 |
| r11342   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I4 |
| r11344   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I4 |
| r11346   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I4 |
| r11348   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I4 |
| r11350   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I4 |
| r11352   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I4 |
| r11354   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I4 |
| r11356   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I4 |
| r11358   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I4 |
| r11360   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I4 |
| r11362   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I4 |
| r11364   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I4 |
| r11366   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I4 |
| r11368   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I4 |
| r11370   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I4 |
| r11372   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I4 |
| r11374   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I4 |
| r11376   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I4 |
| r11378   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I4 |
| r11380   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I4 |
| r11382   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I4 |
| r11384   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I4 |
| r11386   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I4 |
| r11388   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I4 |
| r11390   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I4 |
| r11392   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I4 |
| r11394   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I4 |
| r11396   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I4 |
| r11398   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5  |
| r11400   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5 |
| r11402   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I5 |
| r11404   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I5 |
| r11406   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I5 |
| r11408   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I5 |
| r11410   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I5 |
| r11412   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I5 |
| r11414   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I5 |
| r11416   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I5 |
| r11418   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I5 |
| r11420   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I5 |
| r11422   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I5 |
| r11424   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I5 |
| r11426   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I5 |
| r11428   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I5 |
| r11430   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I5 |
| r11432   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I5 |
| r11434   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I5 |
| r11436   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I5 |
| r11438   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I5 |
| r11440   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I5 |
| r11442   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I5 |
| r11444   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I5 |
| r11446   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I5 |
| r11448   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I5 |
| r11450   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I5 |
| r11452   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I5 |
| r11454   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I5 |
| r11456   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I5 |
| r11458   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I5 |
| r11460   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I5 |
| r11462   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I5 |
| r11464   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I5 |
| r11466   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I5 |
| r11468   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I5 |
| r11470   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I5 |
| r11472   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I5 |
| r11474   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I5 |
| r11476   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I5 |
| r11478   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I5 |
| r11480   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I5 |
| r11482   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I5 |
| r11484   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I5 |
| r11486   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I5 |
| r11488   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I5 |
| r11490   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I5 |
| r11492   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I5 |
| r11494   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I5 |
| r11496   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I5 |
| r11498   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I5 |
| r11500   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I5 |
| r11502   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I5 |
| r11504   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I5 |
| r11506   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I5 |
| r11508   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I5 |
| r11510   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I5 |
| r11512   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I5 |
| r11514   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I5 |
| r11516   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I5 |
| r11518   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I5 |
| r11520   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I5 |
| r11522   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I5 |
| r11524   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I5 |
| r11526   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6  |
| r11528   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6 |
| r11530   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I6 |
| r11532   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I6 |
| r11534   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I6 |
| r11536   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I6 |
| r11538   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I6 |
| r11540   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I6 |
| r11542   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I6 |
| r11544   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I6 |
| r11546   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I6 |
| r11548   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I6 |
| r11550   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I6 |
| r11552   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I6 |
| r11554   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I6 |
| r11556   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I6 |
| r11558   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I6 |
| r11560   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I6 |
| r11562   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I6 |
| r11564   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I6 |
| r11566   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I6 |
| r11568   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I6 |
| r11570   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I6 |
| r11572   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I6 |
| r11574   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I6 |
| r11576   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I6 |
| r11578   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I6 |
| r11580   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I6 |
| r11582   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I6 |
| r11584   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I6 |
| r11586   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I6 |
| r11588   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I6 |
| r11590   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I6 |
| r11592   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I6 |
| r11594   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I6 |
| r11596   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I6 |
| r11598   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I6 |
| r11600   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I6 |
| r11602   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I6 |
| r11604   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I6 |
| r11606   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I6 |
| r11608   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I6 |
| r11610   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I6 |
| r11612   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I6 |
| r11614   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I6 |
| r11616   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I6 |
| r11618   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I6 |
| r11620   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I6 |
| r11622   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I6 |
| r11624   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I6 |
| r11626   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I6 |
| r11628   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I6 |
| r11630   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I6 |
| r11632   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I6 |
| r11634   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I6 |
| r11636   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I6 |
| r11638   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I6 |
| r11640   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I6 |
| r11642   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I6 |
| r11644   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I6 |
| r11646   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I6 |
| r11648   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I6 |
| r11650   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I6 |
| r11652   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I6 |
| r11654   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7  |
| r11656   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7 |
| r11658   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I7 |
| r11660   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I7 |
| r11662   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I7 |
| r11664   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I7 |
| r11666   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I7 |
| r11668   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I7 |
| r11670   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I7 |
| r11672   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I7 |
| r11674   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I7 |
| r11676   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I7 |
| r11678   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I7 |
| r11680   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I7 |
| r11682   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I7 |
| r11684   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I7 |
| r11686   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I7 |
| r11688   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I7 |
| r11690   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I7 |
| r11692   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I7 |
| r11694   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I7 |
| r11696   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I7 |
| r11698   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I7 |
| r11700   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I7 |
| r11702   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I7 |
| r11704   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I7 |
| r11706   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I7 |
| r11708   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I7 |
| r11710   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I7 |
| r11712   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I7 |
| r11714   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I7 |
| r11716   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I7 |
| r11718   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I7 |
| r11720   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I7 |
| r11722   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I7 |
| r11724   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I7 |
| r11726   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I7 |
| r11728   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I7 |
| r11730   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I7 |
| r11732   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I7 |
| r11734   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I7 |
| r11736   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I7 |
| r11738   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I7 |
| r11740   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I7 |
| r11742   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I7 |
| r11744   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I7 |
| r11746   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I7 |
| r11748   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I7 |
| r11750   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I7 |
| r11752   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I7 |
| r11754   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I7 |
| r11756   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I7 |
| r11758   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I7 |
| r11760   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I7 |
| r11762   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I7 |
| r11764   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I7 |
| r11766   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I7 |
| r11768   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I7 |
| r11770   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I7 |
| r11772   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I7 |
| r11774   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I7 |
| r11776   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I7 |
| r11778   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I7 |
| r11780   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I7 |
| r11782   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8  |
| r11784   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8 |
| r11786   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I2_I8 |
| r11788   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I2_I8 |
| r11790   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I3_I8 |
| r11792   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I3_I8 |
| r11794   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I4_I8 |
| r11796   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I4_I8 |
| r11798   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I5_I8 |
| r11800   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I5_I8 |
| r11802   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I6_I8 |
| r11804   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I6_I8 |
| r11806   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I7_I8 |
| r11808   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I7_I8 |
| r11810   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I8_I8 |
| r11812   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I8_I8 |
| r11814   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I9_I8 |
| r11816   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I9_I8 |
| r11818   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I10_I8 |
| r11820   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I10_I8 |
| r11822   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I11_I8 |
| r11824   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I11_I8 |
| r11826   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I12_I8 |
| r11828   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I12_I8 |
| r11830   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I13_I8 |
| r11832   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I13_I8 |
| r11834   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I14_I8 |
| r11836   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I14_I8 |
| r11838   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I15_I8 |
| r11840   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I15_I8 |
| r11842   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I16_I8 |
| r11844   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I16_I8 |
| r11846   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I17_I8 |
| r11848   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I17_I8 |
| r11850   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I18_I8 |
| r11852   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I18_I8 |
| r11854   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I19_I8 |
| r11856   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I19_I8 |
| r11858   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I20_I8 |
| r11860   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I20_I8 |
| r11862   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I21_I8 |
| r11864   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I21_I8 |
| r11866   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I22_I8 |
| r11868   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I22_I8 |
| r11870   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I23_I8 |
| r11872   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I23_I8 |
| r11874   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I24_I8 |
| r11876   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I24_I8 |
| r11878   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I25_I8 |
| r11880   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I25_I8 |
| r11882   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I26_I8 |
| r11884   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I26_I8 |
| r11886   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I27_I8 |
| r11888   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I27_I8 |
| r11890   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I28_I8 |
| r11892   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I28_I8 |
| r11894   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I29_I8 |
| r11896   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I29_I8 |
| r11898   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I30_I8 |
| r11900   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I30_I8 |
| r11902   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I31_I8 |
| r11904   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I31_I8 |
| r11906   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_I32_I8 |
| r11908   | DW01_cmp6    | width=7    |               | recovery_0/eq_96_2_I32_I8 |
| r11910   | DW01_cmp6    | width=7    |               | recovery_0/eq_131    |
| r11912   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2  |
| r11914   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I2 |
| r11916   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I2 |
| r11918   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I3 |
| r11920   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I3 |
| r11922   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I4 |
| r11924   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I4 |
| r11926   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I5 |
| r11928   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I5 |
| r11930   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I6 |
| r11932   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I6 |
| r11934   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I7 |
| r11936   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I7 |
| r11938   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_I8 |
| r11940   | DW01_cmp6    | width=7    |               | recovery_0/eq_131_2_I8 |
| r11942   | DW01_cmp2    | width=3    |               | recovery_0/lte_169   |
| r11944   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I2 |
| r11946   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I3 |
| r11948   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I4 |
| r11950   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I5 |
| r11952   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I6 |
| r11954   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I7 |
| r11956   | DW01_cmp2    | width=3    |               | recovery_0/lte_169_I8 |
| r11958   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67     |
| r11960   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2   |
| r11962   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I2  |
| r11964   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I2 |
| r11966   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I3  |
| r11968   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I3 |
| r11970   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I4  |
| r11972   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I4 |
| r11974   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I5  |
| r11976   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I5 |
| r11978   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I6  |
| r11980   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I6 |
| r11982   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I7  |
| r11984   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I7 |
| r11986   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I8  |
| r11988   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I8 |
| r11990   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I9  |
| r11992   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I9 |
| r11994   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I10 |
| r11996   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I10 |
| r11998   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I11 |
| r12000   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I11 |
| r12002   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I12 |
| r12004   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I12 |
| r12006   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I13 |
| r12008   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I13 |
| r12010   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I14 |
| r12012   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I14 |
| r12014   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I15 |
| r12016   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I15 |
| r12018   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I16 |
| r12020   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I16 |
| r12022   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I17 |
| r12024   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I17 |
| r12026   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I18 |
| r12028   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I18 |
| r12030   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I19 |
| r12032   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I19 |
| r12034   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I20 |
| r12036   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I20 |
| r12038   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I21 |
| r12040   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I21 |
| r12042   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I22 |
| r12044   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I22 |
| r12046   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I23 |
| r12048   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I23 |
| r12050   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I24 |
| r12052   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I24 |
| r12054   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I25 |
| r12056   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I25 |
| r12058   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I26 |
| r12060   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I26 |
| r12062   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I27 |
| r12064   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I27 |
| r12066   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I28 |
| r12068   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I28 |
| r12070   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I29 |
| r12072   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I29 |
| r12074   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I30 |
| r12076   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I30 |
| r12078   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I31 |
| r12080   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I31 |
| r12082   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_I32 |
| r12084   | DW01_cmp6    | width=7    |               | Maptable_0/eq_67_2_I32 |
| r12086   | DW01_cmp6    | width=5    |               | Maptable_0/eq_87     |
| r12088   | DW01_cmp6    | width=7    |               | RS_0/eq_194          |
| r12090   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2        |
| r12092   | DW01_cmp6    | width=7    |               | RS_0/eq_197          |
| r12094   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2        |
| r12096   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I2       |
| r12098   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I2     |
| r12100   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I2       |
| r12102   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I2     |
| r12104   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I3       |
| r12106   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I3     |
| r12108   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I3       |
| r12110   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I3     |
| r12112   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I4       |
| r12114   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I4     |
| r12116   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I4       |
| r12118   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I4     |
| r12120   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I5       |
| r12122   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I5     |
| r12124   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I5       |
| r12126   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I5     |
| r12128   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I6       |
| r12130   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I6     |
| r12132   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I6       |
| r12134   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I6     |
| r12136   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I7       |
| r12138   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I7     |
| r12140   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I7       |
| r12142   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I7     |
| r12144   | DW01_cmp6    | width=7    |               | RS_0/eq_194_I8       |
| r12146   | DW01_cmp6    | width=7    |               | RS_0/eq_194_2_I8     |
| r12148   | DW01_cmp6    | width=7    |               | RS_0/eq_197_I8       |
| r12150   | DW01_cmp6    | width=7    |               | RS_0/eq_197_2_I8     |
| r12152   | DW01_cmp2    | width=8    |               | RS_0/gte_204         |
| r12154   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I2      |
| r12156   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I3      |
| r12158   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I4      |
| r12160   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I5      |
| r12162   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I6      |
| r12164   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I7      |
| r12166   | DW01_cmp2    | width=8    |               | RS_0/gte_204_I8      |
| r12168   | DW01_cmp6    | width=7    |               | RS_0/eq_270          |
| r12170   | DW01_cmp6    | width=7    |               | RS_0/eq_278          |
| r12172   | DW01_dec     | width=5    |               | ROB_0/sub_45         |
| r12174   | DW01_dec     | width=5    |               | ROB_0/sub_46         |
| r12176   | DW01_inc     | width=5    |               | ROB_0/add_47         |
| r12178   | DW01_sub     | width=5    |               | ROB_0/sub_48         |
| r12180   | DW01_add     | width=5    |               | ROB_0/add_49         |
| r12182   | DW01_inc     | width=5    |               | ROB_0/add_50         |
| r12184   | DW01_add     | width=5    |               | ROB_0/add_51         |
| r12186   | DW01_dec     | width=5    |               | ROB_0/sub_52         |
| r12188   | DW01_cmp6    | width=5    |               | ROB_0/eq_53          |
| r12190   | DW01_cmp6    | width=5    |               | ROB_0/eq_53_2        |
| r12192   | DW01_cmp6    | width=7    |               | ROB_0/eq_116         |
| r12194   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2       |
| r12196   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2       |
| r12198   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I2      |
| r12200   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I2    |
| r12202   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I2    |
| r12204   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I3      |
| r12206   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I3    |
| r12208   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I3    |
| r12210   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I4      |
| r12212   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I4    |
| r12214   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I4    |
| r12216   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I5      |
| r12218   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I5    |
| r12220   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I5    |
| r12222   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I6      |
| r12224   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I6    |
| r12226   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I6    |
| r12228   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I7      |
| r12230   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I7    |
| r12232   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I7    |
| r12234   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I8      |
| r12236   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I8    |
| r12238   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I8    |
| r12240   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I9      |
| r12242   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I9    |
| r12244   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I9    |
| r12246   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I10     |
| r12248   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I10   |
| r12250   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I10   |
| r12252   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I11     |
| r12254   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I11   |
| r12256   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I11   |
| r12258   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I12     |
| r12260   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I12   |
| r12262   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I12   |
| r12264   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I13     |
| r12266   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I13   |
| r12268   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I13   |
| r12270   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I14     |
| r12272   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I14   |
| r12274   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I14   |
| r12276   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I15     |
| r12278   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I15   |
| r12280   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I15   |
| r12282   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I16     |
| r12284   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I16   |
| r12286   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I16   |
| r12288   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I17     |
| r12290   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I17   |
| r12292   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I17   |
| r12294   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I18     |
| r12296   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I18   |
| r12298   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I18   |
| r12300   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I19     |
| r12302   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I19   |
| r12304   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I19   |
| r12306   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I20     |
| r12308   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I20   |
| r12310   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I20   |
| r12312   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I21     |
| r12314   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I21   |
| r12316   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I21   |
| r12318   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I22     |
| r12320   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I22   |
| r12322   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I22   |
| r12324   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I23     |
| r12326   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I23   |
| r12328   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I23   |
| r12330   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I24     |
| r12332   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I24   |
| r12334   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I24   |
| r12336   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I25     |
| r12338   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I25   |
| r12340   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I25   |
| r12342   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I26     |
| r12344   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I26   |
| r12346   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I26   |
| r12348   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I27     |
| r12350   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I27   |
| r12352   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I27   |
| r12354   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I28     |
| r12356   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I28   |
| r12358   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I28   |
| r12360   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I29     |
| r12362   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I29   |
| r12364   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I29   |
| r12366   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I30     |
| r12368   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I30   |
| r12370   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I30   |
| r12372   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I31     |
| r12374   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I31   |
| r12376   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I31   |
| r12378   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_I32     |
| r12380   | DW01_cmp6    | width=7    |               | ROB_0/eq_116_2_I32   |
| r12382   | DW01_cmp6    | width=5    |               | ROB_0/eq_118_2_I32   |
| r12384   | DW01_cmp6    | width=5    |               | ROB_0/eq_132         |
| r12386   | DW01_cmp6    | width=5    |               | ROB_0/eq_144         |
| r12388   | DW01_cmp6    | width=5    |               | ROB_0/eq_157         |
| r12390   | DW01_cmp6    | width=7    |               | RF_0/eq_37           |
| r12392   | DW01_cmp6    | width=7    |               | RF_0/eq_38           |
| r12394   | DW01_cmp6    | width=7    |               | RF_0/eq_49           |
| r12396   | DW01_cmp6    | width=7    |               | RF_0/eq_50           |
| r12398   | DW01_cmp6    | width=7    |               | RF_0/eq_62           |
| r12400   | DW01_cmp6    | width=7    |               | RF_0/eq_63           |
| r12402   | DW01_cmp6    | width=7    |               | RF_0/eq_73           |
| r12404   | DW01_cmp6    | width=7    |               | RF_0/eq_74           |
| r12406   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I2 |
| r12408   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I3 |
| r12410   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I4 |
| r12412   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I5 |
| r12414   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I6 |
| r12416   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_365_I7 |
| r12418   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398   |
| r12420   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I2 |
| r12422   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I3 |
| r12424   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I4 |
| r12426   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I5 |
| r12428   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I6 |
| r12430   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I7 |
| r12432   | DW01_cmp2    | width=8    |               | LSQ_0/LQ_0/gte_398_I8 |
| r12434   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421    |
| r12436   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I1 |
| r12438   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2 |
| r12440   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I2 |
| r12442   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I3 |
| r12444   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I3 |
| r12446   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I4 |
| r12448   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I4 |
| r12450   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I5 |
| r12452   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I5 |
| r12454   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I6 |
| r12456   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I6 |
| r12458   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I7 |
| r12460   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I7 |
| r12462   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I8 |
| r12464   | DW01_cmp6    | width=7    |               | LSQ_0/LQ_0/eq_421_I2_I8 |
| r12466   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476    |
| r12468   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481    |
| r12470   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I1 |
| r12472   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I1 |
| r12474   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I1 |
| r12476   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I1 |
| r12478   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I1 |
| r12480   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I1 |
| r12482   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I1 |
| r12484   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I1 |
| r12486   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I1 |
| r12488   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I1 |
| r12490   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I1 |
| r12492   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I1 |
| r12494   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I1 |
| r12496   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2 |
| r12498   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2 |
| r12500   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I2 |
| r12502   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I2 |
| r12504   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I2 |
| r12506   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I2 |
| r12508   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I2 |
| r12510   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I2 |
| r12512   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I2 |
| r12514   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I2 |
| r12516   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I2 |
| r12518   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I2 |
| r12520   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I2 |
| r12522   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I2 |
| r12524   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I2 |
| r12526   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3 |
| r12528   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3 |
| r12530   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I3 |
| r12532   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I3 |
| r12534   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I3 |
| r12536   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I3 |
| r12538   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I3 |
| r12540   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I3 |
| r12542   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I3 |
| r12544   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I3 |
| r12546   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I3 |
| r12548   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I3 |
| r12550   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I3 |
| r12552   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I3 |
| r12554   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I3 |
| r12556   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4 |
| r12558   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4 |
| r12560   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I4 |
| r12562   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I4 |
| r12564   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I4 |
| r12566   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I4 |
| r12568   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I4 |
| r12570   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I4 |
| r12572   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I4 |
| r12574   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I4 |
| r12576   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I4 |
| r12578   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I4 |
| r12580   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I4 |
| r12582   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I4 |
| r12584   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I4 |
| r12586   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5 |
| r12588   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5 |
| r12590   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I5 |
| r12592   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I5 |
| r12594   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I5 |
| r12596   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I5 |
| r12598   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I5 |
| r12600   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I5 |
| r12602   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I5 |
| r12604   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I5 |
| r12606   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I5 |
| r12608   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I5 |
| r12610   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I5 |
| r12612   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I5 |
| r12614   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I5 |
| r12616   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6 |
| r12618   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6 |
| r12620   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I6 |
| r12622   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I6 |
| r12624   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I6 |
| r12626   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I6 |
| r12628   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I6 |
| r12630   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I6 |
| r12632   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I6 |
| r12634   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I6 |
| r12636   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I6 |
| r12638   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I6 |
| r12640   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I6 |
| r12642   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I6 |
| r12644   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I6 |
| r12646   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7 |
| r12648   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7 |
| r12650   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I7 |
| r12652   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I7 |
| r12654   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I7 |
| r12656   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I7 |
| r12658   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I7 |
| r12660   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I7 |
| r12662   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I7 |
| r12664   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I7 |
| r12666   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I7 |
| r12668   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I7 |
| r12670   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I7 |
| r12672   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I7 |
| r12674   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I7 |
| r12676   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8 |
| r12678   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I8 |
| r12680   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I2_I8 |
| r12682   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I2_I8 |
| r12684   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I3_I8 |
| r12686   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I3_I8 |
| r12688   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I4_I8 |
| r12690   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I4_I8 |
| r12692   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I5_I8 |
| r12694   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I5_I8 |
| r12696   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I6_I8 |
| r12698   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I6_I8 |
| r12700   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I7_I8 |
| r12702   | DW01_cmp6    | width=3    |               | LSQ_0/LQ_0/eq_481_I7_I8 |
| r12704   | DW01_cmp6    | width=64   |               | LSQ_0/LQ_0/eq_476_I8_I8 |
| r12706   | DW01_inc     | width=3    |               | LSQ_0/SQ_0/add_60    |
| r12708   | DW01_cmp6    | width=3    |               | LSQ_0/SQ_0/eq_61     |
| r12710   | DW01_cmp6    | width=3    |               | LSQ_0/SQ_0/eq_61_2   |
| r12712   | DW01_dec     | width=3    |               | LSQ_0/SQ_0/sub_63    |
| r12714   | DW01_sub     | width=3    |               | LSQ_0/SQ_0/sub_64    |
| r12716   | DW01_inc     | width=3    |               | LSQ_0/SQ_0/add_66    |
| r12718   | DW01_add     | width=3    |               | LSQ_0/SQ_0/add_67    |
| r12720   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80     |
| r12722   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85     |
| r12724   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I2  |
| r12726   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I2  |
| r12728   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I3  |
| r12730   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I3  |
| r12732   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I4  |
| r12734   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I4  |
| r12736   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I5  |
| r12738   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I5  |
| r12740   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I6  |
| r12742   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I6  |
| r12744   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I7  |
| r12746   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I7  |
| r12748   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_80_I8  |
| r12750   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_85_I8  |
| r12752   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_95     |
| r12754   | DW01_cmp6    | width=7    |               | LSQ_0/SQ_0/eq_106    |
| r12756   | DW01_add     | width=64   |               | ex_stage_0/alu_0/add_46 |
| r12758   | DW01_sub     | width=64   |               | ex_stage_0/alu_0/sub_47 |
| r12760   | DW01_ash     | A_width=64 |               | ex_stage_0/alu_0/sll_55 |
        |              | SH_width=6 |               |                      |
| r12762   | DW01_sub     | width=8    |               | ex_stage_0/alu_0/sub_56 |
| r12764   | DW01_ash     | A_width=64 |               | ex_stage_0/alu_0/sll_56 |
        |              | SH_width=32 |              |                      |
| r12766   | DW01_cmp6    | width=64   |               | ex_stage_0/alu_0/eq_63 |
| r12768   | DW01_add     | width=64   |               | ex_stage_0/alu_1/add_46 |
| r12770   | DW01_sub     | width=64   |               | ex_stage_0/alu_1/sub_47 |
| r12772   | DW01_ash     | A_width=64 |               | ex_stage_0/alu_1/sll_55 |
        |              | SH_width=6 |               |                      |
| r12774   | DW01_sub     | width=8    |               | ex_stage_0/alu_1/sub_56 |
| r12776   | DW01_ash     | A_width=64 |               | ex_stage_0/alu_1/sll_56 |
        |              | SH_width=32 |              |                      |
| r12778   | DW01_cmp6    | width=64   |               | ex_stage_0/alu_1/eq_63 |
| r12780   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[0]/add_35 |
| r12784   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[1]/add_35 |
| r12788   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[1]/gte_71 |
| r12790   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[2]/add_35 |
| r12794   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[2]/gte_71 |
| r12796   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[3]/add_35 |
| r12800   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[3]/gte_71 |
| r12802   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[4]/add_35 |
| r12806   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[4]/gte_71 |
| r12808   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[5]/add_35 |
| r12812   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[5]/gte_71 |
| r12814   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[6]/add_35 |
| r12818   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[6]/gte_71 |
| r12820   | DW01_add     | width=64   |               | ex_stage_0/mult_0/mstage[7]/add_35 |
| r12824   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_0/mstage[7]/gte_71 |
| r12826   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[0]/add_35 |
| r12830   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[1]/add_35 |
| r12834   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[1]/gte_71 |
| r12836   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[2]/add_35 |
| r12840   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[2]/gte_71 |
| r12842   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[3]/add_35 |
| r12846   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[3]/gte_71 |
| r12848   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[4]/add_35 |
| r12852   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[4]/gte_71 |
| r12854   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[5]/add_35 |
| r12858   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[5]/gte_71 |
| r12860   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[6]/add_35 |
| r12864   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[6]/gte_71 |
| r12866   | DW01_add     | width=64   |               | ex_stage_0/mult_1/mstage[7]/add_35 |
| r12870   | DW01_cmp2    | width=8    |               | ex_stage_0/mult_1/mstage[7]/gte_71 |
| r12872   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99 |
| r12874   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I2 |
| r12876   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I3 |
| r12878   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I4 |
| r12880   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I5 |
| r12882   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I6 |
| r12884   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I7 |
| r12886   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_99_I8 |
| r12888   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108 |
| r12890   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I2 |
| r12892   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I3 |
| r12894   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I4 |
| r12896   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I5 |
| r12898   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I6 |
| r12900   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I7 |
| r12902   | DW01_cmp6    | width=3    |               | dcache_control_0/eq_108_I8 |
| r12904   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120 |
| r12906   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I2 |
| r12908   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I3 |
| r12910   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I4 |
| r12912   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I5 |
| r12914   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I6 |
| r12916   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I7 |
| r12918   | DW01_cmp2    | width=8    |               | dcache_control_0/gte_120_I8 |
| r12920   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166 |
| r12922   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I2 |
| r12924   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I3 |
| r12926   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I4 |
| r12928   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I5 |
| r12930   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I6 |
| r12932   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I7 |
| r12934   | DW01_cmp6    | width=64   |               | dcache_control_0/eq_166_I8 |
| r12936   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189 |
| r12938   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I2 |
| r12940   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I3 |
| r12942   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I4 |
| r12944   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I5 |
| r12946   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I6 |
| r12948   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I7 |
| r12950   | DW01_cmp6    | width=4    |               | dcache_control_0/eq_189_I8 |
| r12952   | DW01_cmp6    | width=4    |               | dcache_0/eq_46       |
| r12954   | DW01_cmp6    | width=9    |               | dcache_0/eq_46_2     |
| r12956   | DW01_cmp6    | width=4    |               | dcache_0/eq_49       |
| r12958   | DW01_cmp6    | width=9    |               | dcache_0/eq_49_2     |
| r12960   | DW01_cmp6    | width=9    |               | dcache_0/eq_99       |
| r12962   | DW01_cmp6    | width=9    |               | dcache_0/eq_103      |
| r13064   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[7]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13166   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[6]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13268   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[5]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13370   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[4]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13472   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[3]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13574   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[2]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13676   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[1]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13778   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[7]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13880   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[6]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r13982   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[5]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14084   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[4]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14186   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[3]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14288   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[2]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14390   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[1]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14492   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_1/mstage[0]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
| r14594   | DW02_mult    | A_width=8  |               | ex_stage_0/mult_0/mstage[0]/mult_37 |
           |            |               |                      |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| LSQ_0/LQ_0/eq_476_I6_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476  | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I8                  |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I2_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I6_I8               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I5               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I6               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I3_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I5_I7               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I2            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I3            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I4            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I5            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I6            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I7            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| dcache_control_0/eq_166_I8            |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| r9706              | DW01_cmp6        | rpl                |                |
| r9707              | DW01_cmp6        | rpl                |                |
| r9714              | DW01_cmp6        | rpl                |                |
| r9722              | DW01_cmp6        | rpl                |                |
| icache_0/add_54    | DW01_add         | cla                |                |
| if_stage_0/add_47  | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[1]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[2]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[3]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[4]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[5]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[6]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[1]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[2]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[3]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[4]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[5]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[6]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| if_stage_0/add_48  | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[7]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_0/mstage[7]/add_35    |                    |                |
|                    | DW01_add         | cla                |                |
| LSQ_0/LQ_0/eq_476_I7_I1               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I3               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I7_I4               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| LSQ_0/LQ_0/eq_476_I4_I2               |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| ex_stage_0/alu_0/add_46               |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/alu_1/sub_47               |                    |                |
|                    | DW01_sub         | cla                |                |
| ex_stage_0/alu_0/sub_47               |                    |                |
|                    | DW01_sub         | cla                |                |
| ex_stage_0/alu_1/add_46               |                    |                |
|                    | DW01_add         | cla                |                |
| ex_stage_0/mult_1/mstage[7]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[6]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[5]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[4]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[3]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[2]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[1]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[7]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[6]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[5]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[4]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[3]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[2]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[1]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_1/mstage[0]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| ex_stage_0/mult_0/mstage[0]/mult_37   |                    |                |
|                    | DW02_mult        | csa                |                |
| r9718              | DW_rash          | mx2                |                |
| ex_stage_0/alu_1/sll_55               |                    |                |
|                    | DW01_ash         | mx2                |                |
| ex_stage_0/alu_1/eq_63                |                    |                |
|                    | DW01_cmp6        | rpl                |                |
| r9710              | DW_rash          | mx2                |                |
| ex_stage_0/alu_0/sll_55               |                    |                |
|                    | DW01_ash         | mx2                |                |
| ex_stage_0/alu_0/eq_63                |                    |                |
|                    | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_1
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_2
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_3
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_4
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_5
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_6
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_7
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_8
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_9
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_10
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_11
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_12
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_13
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_14
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : pipeline_DW02_mult_15
****************************************

Resource Sharing Report for design DW02_mult_A_width8_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=70   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : cache
****************************************

Resource Sharing Report for design cache in file
        /afs/umich.edu/user/l/i/liqiz/Documents/passed/verilog/cache/cachemem.v

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r162     | DW01_cmp6    | width=9    |               | eq_23 eq_54 eq_65    |
| r163     | DW01_cmp6    | width=9    |               | eq_27 eq_57 eq_68    |
| r171     | DW01_cmp6    | width=9    |               | eq_40                |
| r173     | DW01_cmp6    | width=9    |               | eq_44                |
| r175     | DW01_cmp6    | width=4    |               | eq_60                |
===============================================================================


No implementations to report
1
