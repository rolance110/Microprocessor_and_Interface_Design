#include <regx51.h>
void main( )
{
	 while(1)
 {
	 P2_0=(P1>28)?0:1;
	 P2_1=(P1>28*2)?0:1;
	 P2_2=(P1>28*3)?0:1;
	 P2_3=(P1>28*4)?0:1;
	 P2_4=(P1>28*5)?0:1;
	 P2_5=(P1>28*6)?0:1;
	 P2_6=(P1>28*7)?0:1;
	 P2_7=(P1>28*8)?0:1;
 }
}