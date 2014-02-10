#line 1 "C:/Users/biamino/Documents/TP_DESIGN/TP_memory.c"
#line 27 "C:/Users/biamino/Documents/TP_DESIGN/TP_memory.c"
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



bit startButtonFlag;
bit stopButtonFlag;
bit sendButtonFlag;

bit listen;

unsigned int pause;



char lattitude[15];
int lattitude_ptr = 0;
char longitude[15];
int longitude_ptr = 0;
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
 char donnees[22];
 char address = 0;
 address += (item*21);

 for (indice = 0; indice < 21; ++indice)
 {
 donnees[indice]=EEPROM_Read(address+indice);
 Delay_ms(250);
 }
 donnees[21]='\0';

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

void I2C_Data_Write(char * lattitude, char * longitude)
{
 Data_I2C_EEPROM_Write(lattitude);
 Data_I2C_EEPROM_Write(longitude);
}

char * Data_I2C_EEPROM_Read(int item)
{
 int indice;
 char donnees[22];
 char address = 0;
 char car;

 address += (item*21);

 for (indice = 0; indice < 21; ++indice)
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
 donnees[21]='\0';

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

void I2C_24LC32A_Data_Write(char * lattitude, char * longitude)
{
 Data_I2C_24LC32A_EEPROM_Write(lattitude);
 Data_I2C_24LC32A_EEPROM_Write(longitude);
}

char * Data_I2C_24LC32A_EEPROM_Read(unsigned int item)
{
 unsigned short indice;
 char donnees[22];
 unsigned int address = 0;
 unsigned short low_address;
 unsigned short high_address;
 char car;

 address += (item*21);

 for (indice = 0; indice < 21; ++indice)
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
 donnees[21]='\0';

 return donnees;
}



void startButtonAction()
{
 UART1_Write_Text("Start\n");
 listen = 1;
 startButtonFlag = 0;
}

void stopButtonAction()
{
 UART1_Write_Text("Stop\n");
 listen = 0;
 stopButtonFlag = 0;
}

void sendButtonAction()
{
 UART1_Write_Text("Send\n");
 sendButtonFlag = 0;
}



void interrupt_configuration()
{
 PORTB=0;
 TRISB = 0xF0;

 INTCON.RBIE=1;
 INTCON.GIE=1;
 INTCON.RBIF=0;

 startButtonFlag = 0;
 stopButtonFlag = 0;
 sendButtonFlag = 0;
}

void interrupt()
{
 unsigned short portbValue;

 if (intcon.RBIF == 1)
 {
 portbValue = PORTB;

 if (portbValue == 0x80)
 {
 startButtonFlag = 1;
 }
 else if (portbValue == 0x40)
 {
 stopButtonFlag = 1;
 }
 else if (portbValue == 0x20)
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

 I2C1_Init(100000);

 interrupt_configuration();

 UART1_Write_Text("Start\n");



 while (1)
 {

 if (startButtonFlag) startButtonAction();
 if (stopButtonFlag) stopButtonAction();
 if (sendButtonFlag) sendButtonAction();

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
 longitude_ptr = 0;
 g_counter = 0;
 good_trame = 0;
 }

 if( uart_rd == 'G')
 {
 ++g_counter;
 }

 if (g_counter == 3 && counter == 0)
 {
 good_trame = 1;
 }

 if (uart_rd == ',')
 {
 ++counter;
 }

 if (good_trame)
 {

 if (counter == 2 && uart_rd != ',')
 {
 lattitude[lattitude_ptr++] = uart_rd;
 }

 if (counter == 3 && uart_rd != ',')
 {
 lattitude[lattitude_ptr++] = uart_rd;
 lattitude[lattitude_ptr++] = '\0';
 }

 if (counter == 4 && uart_rd != ',')
 {
 longitude[longitude_ptr++] = uart_rd;
 }

 if (counter == 5 && uart_rd != ',')
 {
 longitude[longitude_ptr++] = uart_rd;
 longitude[longitude_ptr++] = '\0';
 }

 if (uart_rd == '*')
 {


 I2C_24LC32A_Data_Write(lattitude,longitude);
 UART1_Write_Text(lattitude);
 pause = 5;









 }
 }

 }

 }

 }
}
