		ORG	0000h
		MOV	SP,#32H
		MOV R0,#00111100B
		PUSH 00H
		
		JMP	LOOP			;jump into loop
		ORG	0030h	
LOOP: 	MOV	SP,#33H 		;SP ==32H
		MOV	A,#11111100B  		;A ==#0xfe ,11111110
		MOV	P2,A 			;P2=A
		SETB P1.2
		SETB P1.3	
		JMP	RUNLED			;infinite loop

RUNLED: 	JNB	P1.2,PUSHSTATE 	;jump into marquee when p1.0 is low (if put down bottom)
EPU:		JNB	P1.3,POPSTATE 	;jump into marquee when p1.0 is low (if put down bottom)
			
			RL A            ;left rotate
			MOV P2,A        ;set the value of A into P2
			JMP RUNLED        ;end of MARQUEE, back to LOOP

PUSHSTATE:	CALL DEBOUNCE
			MOV R0,A
			PUSH 00h
			JMP EPU
			
			
POPSTATE:	CALL delay
POPSTATE2:	POP 00h
			CJNE R0,#00111100B,GO
			CALL delay
			CALL delay
			JMP FINISH

GO:			MOV P2,R0        ;set the value of A into P2
			CALL delay
			JMP POPSTATE2



DEBOUNCE: 	MOV R4, #50 ; move 50 times into R4
DE_500_us: 	MOV R3, #125 ; move 250 times into R3
			DJNZ R3, $ ; jump to itself R3 times
			DJNZ R4, DE_500_us ; delay 25ms
			RET
			
delay: 		MOV R4, #250 ; move 50 times into R4
delayloop: 	MOV R3, #250 ; move 250 times into R3
			DJNZ R3, $ ; jump to itself R3 times
			DJNZ R4, delayloop ; delay 25ms
			RET
			
FINISH:		MOV	A,#11111111B  		;A ==#0xfe ,11111110
			MOV	P2,A
			
			
			END