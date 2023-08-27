			ORG 0 ; start from 0000H
			MOV DPTR, #TABLE ; DPTR point to TABLE
			MOV R5, #2 ; run two times
			
START: 		MOV R0, #1 ; R0 current at which number
			MOV R1, #4 ; total 4 row(R1)
			MOV R2, #11110111B ; set first row
			
SCAN: 		MOV A, R2 ;R2 current at which row
			MOV P2, A
			
			JNB P2.7, NUMBERIN ; scan column 1
			INC R0
			JNB P2.6, NUMBERIN ; scan column 2
			INC R0 
			JNB P2.5, NUMBERIN ; scan column 3
			INC R0
			
			JNB P2.4, KEYIN    ; scan column 4*****
			
			RR A               ; next row
			MOV R2, A          ; change R2 (to next row)
			
			DJNZ R1, SCAN      ; run above four times (scan 4 rows)
			
			SJMP START ; 
			
			
NUMBERIN:	CALL DEBOUNCE ; call debounce function
			MOV A, R0 ; (R0) at which number?
			
			DJNZ R5,NUM_ONE
			MOV R6,A                ;R6 = number 2
			SJMP START 
NUM_ONE:	MOV B,A					;B = number 1
			SJMP START 
			
KEYIN: 		CALL DEBOUNCE 
			JNB P2.3, PLUS
			JNB P2.2, MINUS
			JNB P2.1, MULTIPUL
			JNB P2.0, DIVIDE


/*compute*********************************************************/
PLUS:		MOV  A,R6
			ADD	 A,B
			
			MOV	 B,#10 ;solve ten 
			DIV AB     ;solve ten
			
			/*print A,B*/
			MOVC A, @A+DPTR
			MOV P1, A 
			CALL delay
			MOV  A,B
			MOVC A, @A+DPTR
			MOV P1, A 
			/***********/
			
			CALL delay;
			MOV R5,#2
			SJMP START
MINUS:		MOV  A,R6
			SUBB A,B
			CALL delay
			
			/*print A*/
			MOVC A, @A+DPTR 
			MOV P1, A 
			/*********/
			
			MOV R5,#2
			SJMP START
MULTIPUL: 	MOV  A,R6
			MUL  AB
			CALL delay
			
			MOV	 B,#10
			DIV AB
			
			MOVC A, @A+DPTR ;
			MOV P1, A
			CALL delay
			
			MOV  A,B
			MOVC A, @A+DPTR 
			MOV P1, A     
			CALL delay
			MOV R5,#2;
			SJMP START
DIVIDE:		MOV  A,R6
			DIV  AB
			;CALL delay------
			MOVC A, @A+DPTR
			MOV P1, A 
			CALL delay
			CALL delay;+++++
			MOV  A,B
			MOVC A, @A+DPTR 
			MOV P1, A 
			;----CALL delay
			MOV R5,#2
			LJMP START			
			
DEBOUNCE: 	MOV R4, #50 ; move 50 times into R4
DE_500_us: 	MOV R3, #250 ; move 250 times into R3
			DJNZ R3, $ ; jump to itself R3 times
			DJNZ R4, DE_500_us ; delay 25ms
			RET
			
delay: 		MOV R4, #250 ; move 50 times into R4
delayloop: 	MOV R3, #250 ; move 250 times into R3
			DJNZ R3, $ ; jump to itself R3 times
			DJNZ R4, delayloop ; delay 25ms
			RET
			
TABLE: 		DB 00000011B ; display 0
			DB 10011111B ; display 1
			DB 00100101B ; display 2
			DB 00001101B ; display 3
			DB 10011001B ; display 4
			DB 01001001B ; display 5
			DB 01000001B ; display 6
			DB 00011011B ; display 7
			DB 00000001B ; display 8
			DB 00001001B ; display 9
			END