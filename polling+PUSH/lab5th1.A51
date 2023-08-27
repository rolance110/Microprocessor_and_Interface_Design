ORG	0000h
		JMP	LOOP			;jump into loop
		ORG	0030h
			
LOOP: 	MOV	SP,#32H 		;SP ==32H
		MOV	A,#11111100B  		;A ==#0xfe ,11111110
		MOV	P2,A 			;P2=A
		SETB P1.1		;set p1.0 to high
		MOV R0,#8D 			;set the execution times of marquee (eight LED)
		
		JNB	P1.1,MARQUEE 	;jump into marquee when p1.0 is low (if put down bottom)
		JMP	LOOP			;infinite loop

MARQUEE:	PUSH 00h
			MOV R0,#250D
			CALL DELAY1
			POP 00h
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