/*
 * Project name:
     UART (Simple usage of UART module library functions)
 * Copyright:
     (c) Mikroelektronika, 2009.
 * Revision History:
     20080930:
       - initial release;
       - 20090720 - modified by Slavisa Zlatanovic;
 * Description:
     This code demonstrates how to use uart library routines. Upon receiving
     data via RS232, MCU immediately sends it back to the sender.
 * Test configuration:
     MCU:             PIC16F877A
                      http://ww1.microchip.com/downloads/en/DeviceDoc/39582b.pdf
     dev.board:       easypic5 -
                      http://www.mikroe.com/eng/products/view/1/easypic5-development-system/
     Oscillator:      HS, 08.0000 MHz
     Ext. Modules:    -
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * Notes:
     - RX and TX UART switches on EasyPIC5 should be turned ON (SW7.1 and SW8.1).
*/

#define TRAME_LG 24

// LCD module connections
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

/** Button **/

bit startAndStopButtonFlag;
bit sendButtonFlag;
bit timeButtonFlag;

bit listen;

unsigned int pause;

unsigned int  timeDelay;

/** String **/

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
  address += (item*TRAME_LG);
  
  for (indice = 0; indice < TRAME_LG; ++indice)
  {
      donnees[indice]=EEPROM_Read(address+indice);
      Delay_ms(250);
  }
  donnees[TRAME_LG]='\0';
  
  return donnees;
}

/** Memoire 24LC02B **/

void Data_I2C_EEPROM_Write(char * donnees)
{
     short indice=0;
     
     while(donnees[indice] != '\0')
     {
       I2C1_Start();              // issue I2C start signal
       I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
       I2C1_Wr(adresse+indice);          // send byte (address of EEPROM location)
       I2C1_Wr(donnees[indice]);        // send data (data to be written)
       I2C1_Stop();               // issue I2C stop signal
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
  
  address += (item*TRAME_LG);
  
  for (indice = 0; indice < TRAME_LG; ++indice)
  {
    I2C1_Start();              // issue I2C start signal
    I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
    I2C1_Wr(address+indice);          // send byte (data address)
    I2C1_Repeated_Start();     // issue I2C signal repeated start
    I2C1_Wr(0xA1);             // send byte (device address + R)
    car = I2C1_Rd(0u);         // Read the data (NO acknowledge)
    I2C1_Stop();               // issue I2C stop signal
    Delay_ms(10);
    donnees[indice]=car;
  }
  donnees[TRAME_LG]='\0';

  return donnees;
}

/** Memoire 24LC32A **/

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

       I2C1_Start();              // issue I2C start signal
       I2C1_Wr(0xAE);             // send byte via I2C  (device address + W)
       I2C1_Wr(high_address);   // send byte (address of EEPROM location)
       I2C1_Wr(low_address);   // send byte (address of EEPROM location)
       I2C1_Wr(donnees[indice]);  // send data (data to be written)
       I2C1_Stop();               // issue I2C stop signal
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

  address += (item*TRAME_LG);

  for (indice = 0; indice < TRAME_LG; ++indice)
  {
       low_address = address & 0x00FF;
       high_address = (address >> 8) & 0x00FF;
       
       I2C1_Start();              // issue I2C start signal
       I2C1_Wr(0xAE);             // send byte via I2C  (device address + W)
       I2C1_Wr(high_address);     // send byte (data address)
       I2C1_Wr(low_address);      // send byte (data address)
       I2C1_Repeated_Start();     // issue I2C signal repeated start
       I2C1_Wr(0xAF);             // send byte (device address + R)
       car = I2C1_Rd(0u);         // Read the data (NO acknowledge)
       I2C1_Stop();               // issue I2C stop signal
       Delay_ms(10);
       donnees[indice]=car;
       
       address += 1;
  }
  donnees[TRAME_LG]='\0';

  return donnees;
}

/** Button **/

void timeButtonAction()
{
     timeButtonFlag =0;
     switch (timeDelay)
     {
      case 5:  timeDelay=10;
      break;
      
      case 10:  timeDelay=20;
      break;
      
      case 20: timeDelay=5;
      break;
     }
     
     pause = timeDelay;

}

void startAndStopButtonAction()
{
     listen = ~listen;
     pause = 0;
     startAndStopButtonFlag = 0;
}

void sendButtonAction()
{
     unsigned int i;
     unsigned int lastItem;
     lastItem = adresse / TRAME_LG;
     
     for (i = 0 ; i < lastItem ; ++i)
     {
         UART1_Write_Text(Data_I2C_24LC32A_EEPROM_Read(i));
         UART1_Write(13);
         UART1_Write(10);
     }
     
     sendButtonFlag = 0;
     adresse = 0;
}

/** Interrupt **/

void interrupt_configuration()
{
     PORTB=0;
     TRISB = 0xF0; // Initialisation du port B en entree pour RB7, RB6, RB5 et RB4
     
     INTCON.RBIE=1;     // Autorise l'IT du RB
     INTCON.GIE=1;      // Autorisation generale des IT
     INTCON.RBIF=0; 	   // Efface le flag d'IT sur RB cf p20 datasheet du 16F877A
     
     startAndStopButtonFlag = 0;
     sendButtonFlag = 0;
     timeButtonFlag = 0;
}

void interrupt()
{
     unsigned short portbValue;

     if (intcon.RBIF == 1)  //Au moins une des entrées RB7 à RB4 a changé d'état
     {
        portbValue = PORTB;

        if (portbValue == 0x80)    // RB7 appuyé
        {
            startAndStopButtonFlag = 1;
        } 
        else if (portbValue == 0x40)     // RB6 appuyé
        {
            timeButtonFlag  = 1;
        }
        else if(portbValue == 0x10)  //RB4 appuyé
        {
             sendButtonFlag = 1;
        }
      }
      INTCON.RBIF=0; // Efface le flag d'IT sur RB
                      //sinon on reste dans la fonction d'interruption
}

/** Main **/

void main()
{
 char good_trame = 0;
 short g_counter = 0;
 // ADCON1 = 0;                      // Configure AN pins as digital

  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

  counter = 0;
  pause = 0;
  listen = 0;
  
  timeDelay=5;
   
   I2C1_Init(100000);         // initialize I2C communication

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
  
    if (UART1_Data_Ready())      // If data is received,
    {
      uart_rd = UART1_Read();     // read the received data,

      if (uart_rd == '$')         // if we read a gps frame
      {
         counter = 0;          // counter initialization
         lattitude_ptr = 0;
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
      
      if (uart_rd == ',')        // word separation symbole
      {
           ++counter;
      }

      if (good_trame)
      {
      
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
           UART1_Write_Text("coucou \n");
        }
      }

    }
    
    }

  }
}