#include <regx51.h>
void main( )
{
IT0 = 0; //enable a low-level signal on external interrupt
EX0 = 1; //enable INT0
EA = 1; //enable interrupt
P3_4 = 0; //WR=0,clean the data
P3_4 = 1; //WR=1,analog convert to digital
while(1); //infinite loop
}
void int_0(void)interrupt 0 //INT0 interrupt function
{
P3_5 = 0; //RD=0,read the digital data
if (P1 >256 / 2)
{
P2 = 0; //LED on
}
else{
P2 = 255; //LED off
}
P3_5 = 1; //RD=1
P3_4 = 0; //WR=0,clean the data
P3_4 = 1; //WR=1,analog convert to digital
}