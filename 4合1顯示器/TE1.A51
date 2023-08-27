/*find R1,R2 */

/*R1=0 ---> 0*/
/*R2=1111 1110 --->@ leftest LED*/
		 ORG 00H
         MOV DPTR,#TABLE			 
START:	 MOV R0,#5  	  
		 MOV R1,#4 		
		 MOV R2,#8		 
		 MOV R4,#7
		 
LLED:	 MOV P0,#11111110B
		 MOV A,R0           ;lighten number
         MOVC A,@A+DPTR
		 MOV P1,A  ;;;	
		 CALL DELAY1
		 
		 MOV P0,#11111101B
		 MOV A,R1           ;lighten number
         MOVC A,@A+DPTR
		 MOV P1,A  ;;;	
		 CALL DELAY1
		 
		 MOV P0,#11111011B
		 MOV A,R2           ;lighten number
         MOVC A,@A+DPTR
		 MOV P1,A  ;;;	
		 CALL DELAY1
		 
		 MOV P0,#11110111B
		 MOV A,R4           ;lighten number
         MOVC A,@A+DPTR
		 MOV P1,A  ;;;	
		 CALL DELAY1
		 
		 JMP LLED
		 
DELAY1:	 MOV R3,#250
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
