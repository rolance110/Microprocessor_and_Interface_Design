#include <regx51.h>
void print_msg(char *);
void write(char, int);
void delay(unsigned int);
void main()
{
write(0x38, 0);
write(0x0F, 0);
write(0x06, 0);
write(0x01, 0);

	
//print string--------------
write(0xC0, 0);
print_msg("E94096110");
//--------------------------
	
//skull-----------------------------------
write(0x40,0);
	
write(0x00,1);
write(0x0E,1);
write(0x1F,1);
write(0x15,1);
	
write(0x0E,1);
write(0x0E,1);
write(0x00,1);
write(0x00,1); //CURSOR
//-----------------------------------------	
	
//SMELL------------------------------------
write(0x48,0); //RAM POSITION
	
write(0x00,1);
write(0x0A,1);
write(0x0A,1);
write(0x00,1);

write(0x11,1);
write(0x0E,1);
write(0x00,1);	
write(0x00,1);	//CURSOR
//-----------------------------------------	


write(0x80,0);//PRINT POSITION
write(0x00,1);

write(0x8F,0);//PRINT POSITION
write(0x01,1);


while (1);

}



void print_msg(char*msg)
{
 for(;*msg!='\0';msg++)
	write(*msg,1);
}
void write(char cmd, int rs_value)
{
	P1=cmd;
	P3_0=rs_value;
	P3_1=1;
	delay(500);
	P3_1=0;
	delay(500);
}
void delay(unsigned int i)
{
	while (i--);
}