#include <regx51.h>
void init_uart(void); //??UART?????
char recivevalue; //???????

void main(){
	init_uart(); //??UART
	while(1);
}

void init_uart(void){
 SCON=0x50; //??SCON????????mode1
 TMOD=0x20; //??TIMER1?Mode2
 TH1=0xe6; //baud??? 1200
 TR1=1; //TCON?Timer1????? TR1?1
 IE=0x90; //??UART???? EA?ES???1
}

void init_uart1(void)interrupt 4
{
	while(RI == 0); //??????
  RI=0;
	recivevalue=SBUF; //????SBUF????recivevalue?
	P2 = recivevalue; //??????LED????
	
	if(recivevalue == 'q'){
		SBUF= recivevalue; //???????
		while(TI==0); //??????
		TI=0; //?TI????0
	}
}