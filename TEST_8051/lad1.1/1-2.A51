		 ORG 00H  			;start address is 0
		 MOV DPTR,#TABLE 	;DPTR point to TABLE
START:	 MOV R0,#4  			;4 LED
		 MOV R1,#0 			;table index
		 MOV R2,#0FEH		;LED DRIVE PIN
LOOP:	 MOV P2,R2
		 MOV A,R1
		 MOVC A,@A+DPTR
		 MOV P1,A
		 CALL DELAY
		 INC R1
		 MOV A,R2
		 RL A
		 MOV R2,A
		 DJNZ R0,LOOP
		 SJMP START
DELAY:	 MOV R3,#250
		 DJNZ R3,$
		 RET
TABLE:   DB 0C0H
		 DB 0F9H
		 DB 0A4H
		 DB 0B0H
		 END
