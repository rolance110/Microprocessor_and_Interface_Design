			ORG 00H ;code start from 00H
			SJMP MAIN ;jump to MAIN
			ORG 03H ;vector address for INT0
			SJMP INT0_ISR ;jump to INT0_ISR
			ORG 030H ;after vector table space
MAIN: 		MOV IE, 00000001B ;enable EA and EX0
			SETB IE.7
			MOV SP,30H ;stack start from #30H
			SETB IT0 ;falling edge triggered
			MOV A,11110101B ;set ACC as 0000000B
LOOP: 		MOV P2,A ;P1 A (LED output)
			CALL DELAY ;call delay function
			CPL A ;reverse A
			SJMP LOOP ;infinite loop
		
INT0_ISR:   PUSH PSW ;push PSW into stack
			PUSH ACC ;push ACC into stack
			SETB RS0 ;switch to RB1
			MOV A,#11111110B ;set ACC as 11111110B
			MOV	R0,#24 			;loop counter 24 (8*3)
			
ROTATE_L:   MOV P2,A 			;P2 A (LED output)
			CALL DELAY 			;call delay function
			RL A 				;rotate left
			DJNZ R0,ROTATE_L 	;loop until R0 is 0
			POP ACC				;pop out ACC from stac
			POP PSW 			;pop out PSW from stack
			RETI 				;return from ISR
			
DELAY: 		MOV R7,#200
D1: 		MOV R6,#250
			DJNZ R6,$
			DJNZ R7,D1
			RET
			
			END
			
