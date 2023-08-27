#include <regx51.h>      //include header file for 8051
#define TH0_init 0x06 //TH 0 _ 256 250
#define TL0_init 0x06 //TL 0 _init 256 250
void delay(unsigned char);

void main(){
	TMOD=0x09; //set timer 0 to mode 2 8 bits and auto reload)
	IP=0x02;   //timer 0interrupt has high priority
	IE=0x82; //enable timer 0interrupt
	TCON=0x10; //enable timer 0
	
	P2=0xfe;

	while(1){ 
		delay(1);
	}

}
void timer0_interrupt(void)interrupt 1{ ////‘iinterrupt 1 is int vector of INT 0
		if(P2 == 0x7f){
			P2 = 0xfe;
		}
		else{
		  P2=P2<<1;
			P2_0=1;
		}
	  delay(5);
}

//delay function
void delay(unsigned char a){
	unsigned char i,j;
	for(;a>0;a--)
		for(i=0;i<151;i++)
			for(j=0;j<59;j++);
}
