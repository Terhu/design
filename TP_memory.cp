#line 1 "C:/Users/biamino/Documents/TP_DESIGN/TP_memory.c"
#line 29 "C:/Users/biamino/Documents/TP_DESIGN/TP_memory.c"
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

char uart_rd;



bit startAndStopButtonFlag;
bit sendButtonFlag;
bit timeButtonFlag;

bit listen;

unsigned int pause;

unsigned int timeDelay;



unsigned int ledStartAndStop;
unsigned int ledTime;



char lattitude[40];
int lattitude_ptr = 0;
int counter;
char affichage[4] ;

unsigned int adresse = 0;

char * str;


void Data_Eeprom_Write(char * donnees)
{
 short indice=0;
 while(donnees[indice] != '\0')
 {
 EEPROM_Write(adresse+indice,donnees[indice]);
 ++indice;
 }
 adresse += indice;
}

void Data_Write(char * lattitude, char * longitude)
{
 Data_Eeprom_Write(lattitude);
 Data_Eeprom_Write(longitude);
}

char * Data_Eeprom_Read(int item)
{
 int indice;
 char donnees[50];
 char address = 0;
 address += (item* 24 );

 for (indice = 0; indice <  24 ; ++indice)
 {
 donnees[indice]=EEPROM_Read(address+indice);
 Delay_ms(250);
 }
 donnees[ 24 ]='\0';

 return donnees;
}



void Data_I2C_EEPROM_Write(char * donnees)
{
 short indice=0;

 while(donnees[indice] != '\0')
 {
 I2C1_Start();
 I2C1_Wr(0xA0);
 I2C1_Wr(adresse+indice);
 I2C1_Wr(donnees[indice]);
 I2C1_Stop();
 Delay_ms(10);
 ++indice;
 }
 adresse += indice;
}

char * Data_I2C_EEPROM_Read(int item)
{
 int indice;
 char donnees[50];
 char address = 0;
 char car;

 address += (item* 24 );

 for (indice = 0; indice <  24 ; ++indice)
 {
 I2C1_Start();
 I2C1_Wr(0xA0);
 I2C1_Wr(address+indice);
 I2C1_Repeated_Start();
 I2C1_Wr(0xA1);
 car = I2C1_Rd(0u);
 I2C1_Stop();
 Delay_ms(10);
 donnees[indice]=car;
 }
 donnees[ 24 ]='\0';

 return donnees;
}



void Data_I2C_24LC32A_EEPROM_Write(char * donnees)
{
 unsigned short indice=0;
 unsigned int address;
 unsigned short low_address;
 unsigned short high_address;

 while(donnees[indice] != '\0')
 {
 address = adresse+indice;

 low_address = address & 0x00FF;
 high_address = (address >> 8) & 0x00FF;

 I2C1_Start();
 I2C1_Wr(0xAE);
 I2C1_Wr(high_address);
 I2C1_Wr(low_address);
 I2C1_Wr(donnees[indice]);
 I2C1_Stop();
 Delay_ms(10);
 ++indice;
 }
 adresse += indice;
}

char * Data_I2C_24LC32A_EEPROM_Read(unsigned int item)
{
 unsigned short indice;
 char donnees[50];
 unsigned int address = 0;
 unsigned short low_address;
 unsigned short high_address;
 char car;

 address += (item* 24 );

 for (indice = 0; indice <  24 ; ++indice)
 {
 low_address = address & 0x00FF;
 high_address = (address >> 8) & 0x00FF;

 I2C1_Start();
 I2C1_Wr(0xAE);
 I2C1_Wr(high_address);
 I2C1_Wr(low_address);
 I2C1_Repeated_Start();
 I2C1_Wr(0xAF);
 car = I2C1_Rd(0u);
 I2C1_Stop();
 Delay_ms(10);
 donnees[indice]=car;

 address += 1;
 }
 donnees[ 24 ]='\0';

 return donnees;
}



void timeButtonAction()
{
 timeButtonFlag =0;
 switch (timeDelay)
 {
 case 5: timeDelay=10;
 ledTime = 0x04;
 break;

 case 10: timeDelay=20;
 ledTime = 0x08;
 break;

 case 20: timeDelay=5;
 ledTime = 0x02;
 break;
 }
 PORTD = ledTime | ledStartAndStop;
 pause = timeDelay;

}

void startAndStopButtonAction()
{
 listen = ~listen;
 ledStartAndStop = listen ? 0x01 : 0x00;
 PORTD = ledTime | ledStartAndStop;
 pause = 0;
 startAndStopButtonFlag = 0;
}

void sendButtonAction()
{
 unsigned int i;
 unsigned int lastItem;
 lastItem = adresse /  24 ;

 for (i = 0 ; i < lastItem ; ++i)
 {
 UART1_Write_Text(Data_I2C_24LC32A_EEPROM_Read(i));
 UART1_Write(13);
 UART1_Write(10);
 }

 sendButtonFlag = 0;
 adresse = 0;
}



void interrupt_configuration()
{
 PORTB=0;
 TRISB = 0xF0;
 PORTD = 0;
 TRISD = 0x00;
 PORTD = 0x01;

 INTCON.RBIE=1;
 INTCON.GIE=1;
 INTCON.RBIF=0;

 startAndStopButtonFlag = 0;
 sendButtonFlag = 0;
 timeButtonFlag = 0;

 ledStartAndStop = 0;
 ledTime = 0x02;
 PORTD = ledTime | ledStartAndStop;
}

void interrupt()
{
 unsigned short portbValue;

 if (intcon.RBIF == 1)
 {
 portbValue = PORTB;

 if (portbValue == 0x80)
 {
 startAndStopButtonFlag = 1;
 }
 else if (portbValue == 0x40)
 {
 timeButtonFlag = 1;
 }
 else if(portbValue == 0x10)
 {
 sendButtonFlag = 1;
 }
 }
 INTCON.RBIF=0;

}



void main()
{
 char good_trame = 0;
 short g_counter = 0;

 UART1_Init(9600);
 Delay_ms(100);
 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 counter = 0;
 pause = 0;
 listen = 0;

 timeDelay=5;


 I2C1_Init(100000);

 interrupt_configuration();

 while (1)
 {
 if (startAndStopButtonFlag) startAndStopButtonAction();
 if (sendButtonFlag) sendButtonAction();
 if (timeButtonFlag) timeButtonAction();

 if (pause > 0)
 {
 delay_ms(1000);
 --pause;
 }

 if (listen && pause == 0)
 {

 if (UART1_Data_Ready())
 {
 uart_rd = UART1_Read();

 if (uart_rd == '$')
 {
 counter = 0;
 lattitude_ptr = 0;
 g_counter = 0;
 good_trame = 0;
 }

 if( uart_rd == 'G')
 {
 ++g_counter;
 }


 if (g_counter == 3)
 {

 if (uart_rd == ',')
 {
 ++counter;
 }

 if (counter != 2 || uart_rd != ',')
 {
 if (counter >= 2 && lattitude_ptr < 24)
 {
 lattitude[lattitude_ptr++] = uart_rd;
 }

 if (counter >= 2 && lattitude_ptr == 24)
 {
 lattitude[lattitude_ptr++] = '\0';
 }
 }

 if (uart_rd == '*')
 {
 Data_I2C_24LC32A_EEPROM_Write(lattitude);
 pause = timeDelay;
 }
 }

 }

 }

 }
}
