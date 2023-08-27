#include <regx51.h>
void print_msg(char*);
void write(char,int);
void delay(unsigned int);
void init_uart();

int value;


int x,y,z;
int i,j,b,h,n,a,m,l;
void setup();
int check,check2;
char charValue[3]={0};
char out[]="Final exam      ";
char out1[]="Final exam      ";
char save;

void main()
{
	init_uart();
	write(0x38,0);// set 8bit 2row 5x7font
	write(0x0F,0);// display:on/off cursor:on/off flashing:on/off
	write(0x06,0);// input cursor:increase/dencrease scren move:on/off
	write(0x01,0);// cursor reset
	delay(300);
	setup();
	while(1)
  {
		
		if(check2==5 && a==0){//----------------4 is initial
			value = P1;
			if(value<81){
				write(0x80,0);//position
				print_msg("LOW              "); 
			}
			else if(80<value&&value<171){
				write(0x80,0);//position
				print_msg("MIDDLE           "); 
			}
			else{
				write(0x80,0);//position
				print_msg("HIGH             "); 
			}
		
			switch(value/16){ 
       case 0: 
            write(0xC0,0);//position
						print_msg("=               "); 
            break;     
       case 1: 
            write(0xC0,0);//position
						print_msg("==              "); 
            break;     
       case 2: 
            write(0xC0,0);//position
						print_msg("===             "); 
            break;     
       case 3: 
            write(0xC0,0);//position
						print_msg("====            "); 
            break;     
			case 4: 
            write(0xC0,0);//position
						print_msg("=====           "); 
            break;     
			case 5: 
            write(0xC0,0);//position
						print_msg("======          "); 
            break;     
			case 6: 
            write(0xC0,0);//position
						print_msg("=======         "); 
            break;
			case 7: 
            write(0xC0,0);//position
						print_msg("========        "); 
            break;
			case 8: 
            write(0xC0,0);//position
						print_msg("=========       "); 
            break;
			case 9: 
            write(0xC0,0);//position
						print_msg("==========      "); 
            break;
			case 10: 
            write(0xC0,0);//position
						print_msg("===========     "); 
            break;
			case 11: 
            write(0xC0,0);//position
						print_msg("============    "); 
            break;
			case 12: 
            write(0xC0,0);//position
						print_msg("=============   "); 
            break;
				case 13: 
            write(0xC0,0);//position
						print_msg("==============  "); 
            break;
				case 14: 
            write(0xC0,0);//position
						print_msg("=============== "); 
            break;
				case 15: 
            write(0xC0,0);//position
						print_msg("================"); 
            break;
		 }
   } 
		//--------------------------
		else if(check2==1&&b==0)//mode 1 stop
		{
			write(0x01,0);
			write(0x80,0);
			print_msg(out);       
			b=1;
		}
		else if(check2==2)
		{
			write(0x01,0);
			while(check2==2)      //mode 2 run right
			{
				/*run goat****************/
				write(0x80,0);
				save=out[15];
				print_msg(out);
				for(i=15;i>0;i--)
				{
					out[i]=out[i-1];
				}
				out[0]=save;
				delay(10000);
				/*run goat****************/
			}
		}
		else if(check2==3 )    //mode 3 run left
		{
			write(0x01,0);
			while(check2==3) //2
			{
				/*run goat****************/
				write(0x80,0);
				
				print_msg(out);
				for(n=0;n<16;n++)
				{
					out[n]=out[n+1];
				}
				for(n=0;n<16;n++)
				{
					out[n]=out[n+1];
				}
				l++;
				if(l==16){
					for(m=15;m>-1;m--){
						out[m]=out1[m-15];
					}
					delay(100);
					l=0;
				}
				delay(20000);
				/*run goat****************/
			}
		}

		}
	}


void setup(void)
{
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
}
void init_uart(void)
{
	SCON=0x50;//mode 1
	TMOD=0x20;// mode 2
	TR1=1;
	IE=0x95;
	check=0;
	check2=5;//  initial is 5
	x=0;
	y=0;
	z=0;
	b=1;
	a=0;
	l=0 ;
}




void int1_interrupt(void) interrupt 2   //check2+1
{
	b=0;
	check2++;
	if(check2==4)
		check2=1;
	while(P3_3==0);
	delay(10000);
}








void int0_interrupt(void) interrupt 0   
{
	b=1;
	a=1;
	if (check==0)               //touch first
	{ /*screen off---------*/
		write(0x01,0);
		write(0x0C,0);
		/*-------------------*/
		
		check=1;
		while(P3_2==0);
		delay(30000);
	}
	else if(check==1){
		write(0x80,0);//position
		print_msg("E94096110");
				
		write(0x8E,0);//position
		delay(300);
		write(0x00,1);
				
		write(0x8F,0);//position
		write(0x01,1);
		check=3;
		while(P3_2==0);
		delay(10000);
	}
	
	else  //touch again again
	{
		write(0x0F,0);
		
		write(0x80,0);
		print_msg("                ");
		write(0xC0,0);
		print_msg("                ");
		
		write(0x80,0);
		print_msg("Best(4)");
		write(0xC0,0);
		print_msg("Worst(2)");
		
		check=0;
		check2=0;       // don't initial
		while(P3_2==0);
		delay(10000);
	}
}












void delay(unsigned int d)
{
	while(d--);
}
void write(char cmd,int rs_value)
{
	P2=cmd;
	P3_6=rs_value;
	P3_7=1;
	delay(300);
	P3_7=0;
}
void print_msg(char *msg)
{
	for(;*msg!='\0';msg++)
	{
		write(*msg,1);
	}
}
