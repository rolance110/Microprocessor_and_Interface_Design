#include "regx51.h"

void init_uart(void);
void delay(int t);
char recivevalue;
char n[9]="E94096110";
char n_1[9]="e94096110";
int check=0;
int retu=1;
void main()
{
	init_uart();
	while(1);
}
void init_uart(void)
{
    SCON=0x50;
    TMOD=0x20;
    TH1=0xe6;
    TR1=1;
    IE=0x90;
}
void UART_Isr(void) interrupt 4
{
    if(RI==1)
    {
                RI=0;
                if((n[check]!=SBUF)&&(n_1[check]!=SBUF))
                    retu=0;
                check++;
                if(check>=9){
                    if(retu==1){
											  SBUF='\n';
                        delay(8000);
                        SBUF='\r';
											  delay(8000);
                        SBUF='C';
                        delay(8000);
                        SBUF='O';
                        delay(8000);
                        SBUF='R';
                        delay(8000);
                        SBUF='R';
                        delay(8000);
                        SBUF='E';
                        delay(8000);
                        SBUF='C';
                        delay(8000);
                        SBUF='T';
                        delay(8000);
                        SBUF='\n';
                        delay(8000);
                        SBUF='\r';
                        check=0;
                    }
                        else{
											      SBUF='\n';
                            delay(8000);
                            SBUF='\r';
											      delay(8000);													
                            SBUF='W';
                            delay(8000);
                            SBUF='R';
                            delay(8000);
                            SBUF='O';
                            delay(8000);
                            SBUF='N';
                            delay(8000);
                            SBUF='G';
                            delay(8000);
                        SBUF='\n';
                        delay(8000);
                        SBUF='\r';
                            check=0;
                            retu=1;
                        }
            }
    }
    if(TI==1)
    {
        TI=0;
    }
	recivevalue=SBUF;
	P2 = recivevalue;
}


void delay(int t)
{
    for (; t>0; t--);
    }