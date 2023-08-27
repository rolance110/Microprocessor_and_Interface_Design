			ORG 0000h
			JMP LOOP
			
			ORG 0030h
LOOP:		/*initial sp @ 32H***/
			MOV SP,#32h               ;sp @ 32H
			/********************/
			MOV A,#0xFE
			MOV P2,A
			MOV R0,#8
			/*set switch*********/
			SETB P1.1
			JNB P1.1,MARQUEE
			/********************/
			JMP LOOP			
			
MARQUEE:	/*push , pop*********/
			PUSH 00h        ;save R0 value
			MOV R0,#250D
			CALL DELAY1
			POP 00h         ;read R0 from stack
			/********************/
			RL A
			MOV P2,A
			DJNZ R0,MARQUEE
			JMP LOOP
DELAY1:		PUSH 00h
			MOV R0,#250D
			CALL DELAY2
			POP 00h
			DJNZ R0,DELAY1
			RET
DELAY2:		DJNZ R0,DELAY2
			RET
			END