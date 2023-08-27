#include<regx51.h>
void delay(unsigned int);

void main()
{
	while(1){
		P2_1=0;
		delay(50000);
		P2_1=1;
		delay(50000);
	}
}
void delay(unsigned int t){
	while(t--);
}