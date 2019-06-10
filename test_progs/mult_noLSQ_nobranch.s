/*
  This test was hand written by Joel VanLaven to put pressure on ROBs
  It generates and stores in order 64 32-bit pseudo-random numbers in 
  16 passes using 64-bit arithmetic.  (i.e. it actually generates 64-bit
  values and only keeps the more random high-order 32 bits).  The constants
  are from Knuth.  To be effective in testing the ROB the mult must take
  a while to execute and the ROB must be "small enough".  Assuming that
  there is any reasonably working form of branch prediction and that the
  Icache works and is large enough, multiple passes should end up going
  into the ROB at the same time increasing the efficacy of the test.  If
  for some reason the ROB is not filling with this test is should be
  easily modifiable to fill the ROB.

  In order to properly pass this test the pseudo-random numbers must be
  the correct numbers.
  
  $r1 = 8
*/
        lda     $r1,0x8		#0
start:  lda     $r2,0x27bb	#4	
        sll     $r2,16,$r2	#8	
        lda     $r0,0x2ee6	#12	
        bis     $r2,$r0,$r2	#16	
        lda     $r0,0x87b	#20	
        sll     $r2,12,$r2	#24	
        bis     $r2,$r0,$r2	#28	
        lda     $r0,0x0b0	#32	
        sll     $r2,12,$r2	#36	
        bis     $r2,$r0,$r2	#40	
        lda     $r0,0xfd	#44	
        sll     $r2,8,$r2	#48	
        bis     $r2,$r0,$r2	#52	
	lda     $r3,0xb50	#56	
        sll     $r3,12,$r3	#60	
        lda     $r0,0x4f3	#64	
        bis     $r3,$r0,$r3	#68	
        lda     $r0,0x2d	#72	
        sll     $r3,0x4,$r3	#76	
        bis     $r3,$r0,$r3	#80	
        lda     $r4,0		#84	
loop:   addq    $r4,1,$r4	#88	
        cmple   $r4,0xf,$r5	#92	
        mulq    $r1,$r2,$r10	#96	
        addq    $r10,$r3,$r10	#100	
        mulq    $r10,$r2,$r11	#104	
        addq    $r11,$r3,$r11	#108	
        mulq    $r11,$r2,$r12	#112	
        addq    $r12,$r3,$r12	#116	
        mulq    $r12,$r2,$r1	#120	
        addq    $r1,$r3,$r1	#124	
        srl     $r10,32,$r10	#128	
        srl     $r11,32,$r11	#132	
        srl     $r12,32,$r12	#136	
        srl     $r1,32,$r13	#140	
        addq    $r0,32,$r0	#144	
	bne     $r5,loop	#148	
	call_pal        0x555	#152	
