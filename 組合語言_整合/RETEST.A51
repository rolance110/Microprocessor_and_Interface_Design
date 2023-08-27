ORG 0x00
    JMP INIT
    ORG 0x03
    JMP INT0_ISR
    ORG 0x30
INIT:   MOV IE, #0x81   
    MOV SP, #0x31
    CLR IT0     
    SETB RS0    
    MOV R0, #0
    MOV R1, #0
    MOV R2, #0
    MOV R3, #0
    CLR RS0     
    SETB 0x00   
    
MAIN:   CLR RS0     
    MOV R0, #0    
    MOV R1, #4    
    MOV R2, #0xF7   ; 1111 0111
SCAN:   SETB P0.0   
    MOV A, R2    
    MOV P2, A    
    JNB P0.0, EQUAL0   
    JNB P2.7, KEY_IN  
    INC R0     
    JNB P2.6, KEY_IN  
    INC R0     
    JNB P2.5, KEY_IN  
    INC R0     
    JNB P2.4, KEY_IN  
    INC R0     
    RR A     
    MOV R2, A    
    DJNZ R1, SCAN  
KEY_OUT:  
   CALL DISPLAY   
   SJMP MAIN
EQUAL0: JMP EQUAL    
	
KEY_IN:   CALL DEBOUNCE  
    MOV DPTR, #KB_table  
    MOV A, R0    
    MOVC A, @A+DPTR 


	CJNE A, #0x0A, NEXT1 
    SJMP OP_IN   
NEXT1:   CJNE A, #0x0B, NEXT2 
    SJMP OP_IN   
NEXT2:   CJNE A, #0x0C, NEXT3 
    SJMP OP_IN   
NEXT3:   CJNE A, #0x0D, NEXT4 
    SJMP OP_IN


NEXT4:   CJNE A, #0x0F, NEXT5 
    SJMP COUNT_DOWN  
NEXT5:   CJNE A, #0x0E, NEXT6 
    SJMP SHOW_123  
NEXT6:   JMP SAVE_IN   



COUNT_DOWN:  
	PUSH PSW    ; push PSW
    SETB RS0    ; switch to RB1   
DECREASE_LOOP:  
    MOV 13H, #250        ; just a counter   
SHOW_LOOP: 
    CALL DISPLAY      
    DJNZ 13H, SHOW_LOOP  

    MOV A, R2           ; first for R2 (decimal value)
    JZ  DECREASE_R1     ; if R2 == 0, jump to DECREASE_R1 (JZ jump if A == 0)
    DEC R2              ; R2 != 0, decrease
    JMP DECREASE_LOOP   ; back to decrease loop
DECREASE_R1:
    MOV A, R1           ; for R1 (units value)
    JZ  DECREASE_R0     ; if R1 == 0, jump to DECREASE_R0 (JZ jump if A == 0)
    DEC R1              ; R1 != 0, decrease
    MOV R2, #9          ; set R2 = 9
    JMP DECREASE_LOOP   ; back to decrease loop
DECREASE_R0:
    MOV A, R0           ; for R0 (tens value)
    JZ ALL_ZERO         ; if R0 == 0, finish down count
    DEC R0              ; R0 != 0, decrease
    MOV R1, #9          ; set R1 = 9
    MOV R2, #9          ; set R2 = 9
    JMP DECREASE_LOOP   ; back to decrease loop
; ------------- decrease seven seg value ------------
ALL_ZERO:
    MOV A, 14H   ; --- show value that saved by PSW (default 00.0) ---
    MOV R0, A   ; R4 -> R0
    MOV A, 15H   ;
    MOV R1, A   ; R5 -> R1
    MOV A, 16H   ;
    MOV R2, A   ; R6 -> R2
    POP PSW
    JMP KEY_OUT
SHOW_123:
	SETB RS0
    MOV R0, #7   
    MOV R1, #5   
    MOV R2, #9
	CALL DISPLAY
    ;JMP SHOW_123   
	JMP MAIN
OP_IN:   
	SETB RS0   
    PUSH 0xE0 ;ACC 
    CLR 0x00   
    MOV R0, #0   
    MOV R1, #0   
    MOV R2, #0   
    JMP KEY_OUT   

;EQUAL==================================================================
EQUAL:   
	CALL DEBOUNCE   
    SETB RS0     
    MOV A, SP     
    CJNE A, #0x31, POP_CAL 
    POP 0x0B     
    CALL SET_DEGITS
//==============	
	PUSH PSW    ; push PSW
	MOV 19 H,#3  ;;14 -> 19
    SETB RS0    ; switch to RB1
	
	MOV A,R2
	MOV 20H,A  ;;18==R2
	MOV R0,#10
	MOV R1,#10
	MOV R2,#10
	
	MOV 21H, #250
SHOWLOOP1:	
	CALL SHOW_SEG0
	DJNZ 21H, SHOWLOOP1 
	
LOOP3:	
	MOV A,R1     ;;
 	MOV R2,A
	
	MOV A,R0       ;;R0->R1
	MOV R1,A
	
	MOV  A,20H
	MOV R0,A       ;;20->R0
	
	MOV 20H,#10  //R2->10 
	
	
    MOV 21H, #250        
SHOW_LOOP0: 
    CALL SHOW_SEG0       
    DJNZ 21H, SHOW_LOOP0 
	DJNZ 19H, LOOP3  ; 
	
	CLR RS0
	
	POP PSW     ; pop PSW
	JMP MAIN	
	
//==============	    

SAVE_IN:  SETB RS0    
    MOV R7, A    
    MOV A, R1    
    MOV R0, A    
    MOV A, R2    
    MOV R1, A    
    MOV A, R7    
    MOV R2, A    
    MOV A, R0    
    MOV B, #100    
    MUL AB     
    MOV R3, A    
    MOV A, R1    
    MOV B, #10     
    MUL AB     
    MOV B, R3    
    ADD A, B    
    MOV B, R2    
    ADD A, B    
    MOV R3, A    
    JNB 0x00, SKIP_REFRESH 
    MOV A, SP    
    SUBB A, #0x01  
    MOV SP, A    
SKIP_REFRESH: PUSH 0x0B  ;   
    SETB 0x00   
    JMP KEY_OUT    

POP_CAL:  
	POP 0x0E   
    POP 0x0D   
    POP 0x0C   
    CALL CAL   
    PUSH 0x0B  
    JMP KEY_OUT   

CAL:   MOV A, R4     
    MOV B, R6     
    CJNE R5, #0x0A, SUB_CAL 
    ADD A, B     
    MOV R3, A     
    CALL SET_DEGITS   
    RET             
SUB_CAL:  CJNE R5, #0x0B, MUL_CAL 
    SUBB A, B    
    MOV R3, A     
    CALL SET_DEGITS   
    RET       
MUL_CAL:  CJNE R5, #0x0C, DIV_CAL 
    MUL AB      
    MOV R3, A     
    CALL SET_DEGITS   
    RET       
DIV_CAL:  DIV AB      
    MOV R3, A     
    CALL SET_DEGITS   
    RET       

DEBOUNCE:  MOV R5, #3     
DEL_100_MS:  MOV R6, #200    
DEL_500_US:  MOV R7, #250    
    DJNZ R7, $    
    DJNZ  R6, DEL_500_US   
    DJNZ  R5, DEL_100_MS   
    RET       

SHOW_SEG0:
    MOV DPTR, #DP_table ; move to seven seg table
    SETB RS0            ; switch to RB1
	
	CLR P3.4           
    MOV A,20H           ;;;
    MOVC A, @A+DPTR    
    MOV P1, A           
    CALL DEL_300_US    
    SETB P3.4  
	
    CLR P3.5            ; ======== tens digit ===================| 
    MOV A, R0           ; get value from R0                      |
    MOVC A, @A+DPTR     ; and get seven seg's display signal     |
    MOV P1, A           ; from SHOW_TBL table.                   |
    CALL DEL_300_US     ; delay 330 us, and stop display.        |
    CALL DEL_300_US
	SETB P3.5           ; =======================================|
	
    CLR P3.6            ; ======== units digit ==================| 
    MOV A, R1           ; set P3.6 to low, get value from R1,    |
    MOVC A, @A+DPTR     ; and get seven seg's display signal     |
    MOV P1, A           ; from SHOW_TBL table.                   |
    CALL DEL_300_US     ; delay 330 us, and stop display.        |
    CALL DEL_300_US
	SETB P3.6           ; =======================================|
	
    CLR P3.7            ; ======== decimal ======================|
    MOV A, R2           ; set P3.6 to low, get value from R1,    |
    MOVC A, @A+DPTR     ; and get seven seg's display signal     |
    MOV P1, A           ; from SHOW_TBL table.                   |
    CALL DEL_300_US     ; delay 330 us, and stop display.        |
	CALL DEL_300_US
    SETB P3.7           ; ======== decimal ======================|









DISPLAY:  
	MOV DPTR, #DP_table  
    SETB RS0    
    CLR P3.5    
    MOV A, R0    
    MOVC A, @A+DPTR  
    MOV P1, A    
    CALL DEL_300_US  
    SETB P3.5   
    CLR P3.6    
    MOV A, R1    
    MOVC A, @A+DPTR  
    MOV P1, A    
    CALL DEL_300_US  
    SETB P3.6   
    CLR P3.7   
    MOV A, R2    
    MOVC A, @A+DPTR  
    MOV P1, A    
    CALL DEL_300_US  
    SETB P3.7   
    
    RET      

DEL_300_US:  MOV R7, #150   ; Delay 300 us 
   DJNZ R7, $
   RET

INT0_ISR:  
	PUSH    PSW
    PUSH    ACC
    SETB    RS0     ; switch to RB1
    MOV     A, R0   ; save R0 to R4
    MOV     14H, A   
    MOV     A, R1   ; save R1 to R5
    MOV     15H, A
    MOV     A, R2   ; save R2 to R6
    MOV     16H, A   
    POP     ACC
    POP     PSW
    RETI     

SET_DEGITS:  MOV A, R3   
    MOV B, #10   
    DIV AB    
    MOV R2, B   
    MOV B, #10   
    DIV AB    
    MOV R1, B   
    MOV R0, A   
    RET /////---------------------------------------    

SHOW:   MOV R6, #100  
SHOW1:   CALL DISPLAY
   DJNZ R6, SHOW1
   DJNZ R5, SHOW
   RET

KB_table:  DB  01H  ; 
    DB  02H  ; 
    DB  03H  ; 
    DB  0AH  ; 
    DB  04H  ; 
    DB  05H  ; 
    DB  06H  ; 
    DB  0BH  ; 
    DB  07H  ; 
    DB  08H  ; 
    DB  09H  ; 
    DB  0CH  ; 
    DB  0FH  ; 
    DB  00H  ; 
    DB  0EH  ; 
    DB  0DH  ; 
       //.gfedcba
DP_table:  DB  11000000B    ; 0
    DB  11111001B   ; 1
    DB  10100100B   ; 2
    DB  10110000B   ; 3
    DB  10011001B     ; 4
    DB  10010010B     ; 5
    DB  10000010B   ; 6
    DB  11011000B   ; 7
    DB  10000000B   ; 8
    DB  10010000B   ; 9
	DB  11111111B   ; 10
    END