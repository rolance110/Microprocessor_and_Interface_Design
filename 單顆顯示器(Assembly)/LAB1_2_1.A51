/*find R1,R2 */

/*R1=0 ---> 0*/
/*R2=1111 1110 --->@ leftest LED*/
		 ORG 00H  			
		 MOV DPTR,#TABLE 	
START:	 MOV R0,#4  	    ;4 
		 MOV R1,#0 			;start at which number 
		 MOV R2,#0FEH		;1111_1110(**leftest** 1/4 light)
		 
LOOP:	 /************///decide which 1/4 LED
		 MOV P0,R2 ;;;
		 /************/
		 
		 /*******************************///decide number(R1)
		 MOV A,R1           ;lighten number
         MOVC A,@A+DPTR
		 MOV P1,A  ;;;
		 INC R1             ;R1=R1+1 -> decide next number;;;;;;;;;;;;;
		 /*******************************/
		 
		 /************///decide which 1/4
		 MOV A,R2           
		 RL A ;move next right light 
		 MOV R2,A
		 /************/
		 CALL DELAY
		 DJNZ R0,LOOP
		 SJMP START
		 
DELAY:	 MOV R3,#250
		 DJNZ R3,$
		 RET

TABLE:   DB 11000000B //0
		 DB 11111001B //1
		 DB 10100100B //2
		 DB 10110000B //3
		 DB 10011001B //4
		 DB 10010010B //5
		 DB 10000010B //6
		 DB 11011000B //7
		 DB 10000000B //8
		 DB 10011000B //9
		 END
