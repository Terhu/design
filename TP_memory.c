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
char lattitude[15];
int lattitude_ptr = 0;
char longitude[15];
int longitude_ptr = 0;
int counter;
char affichage[4] ;

 char adresse = 0x00;
 
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
      EEPROM_Write(adresse+indice,donnees[indice]);
      ++indice;
     }
     adresse += indice;
}

void main()
{
 char good_trame = 0;
 short g_counter = 0;
 // ADCON1 = 0;                      // Configure AN pins as digital

  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize


/*EEPROM_Write(0x02,'a');
  EEPROM_Write(0x03,'b');
  EEPROM_Write(0x04,'c');*/
  //UART1_Write_Text("Start");
  //UART1_Write(13);
  //UART1_Write(10);

  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

  counter = 0;
  
/*affichage[0]=EEPROM_Read(0x02);
  affichage[1]=EEPROM_Read(0x03);
  affichage[2]=EEPROM_Read(0x04);

   Lcd_Out(1,1,affichage);*/
   
   I2C1_Init(100000);         // initialize I2C communication
   I2C1_Start();              // issue I2C start signal
   I2C1_Wr(0xA2);             // send byte via I2C  (device address + W)
   I2C1_Wr(0x02);             // send byte (address of EEPROM location)
   I2C1_Wr(0x4A);             // send data (data to be written)
   I2C1_Stop();               // issue I2C stop signal
   
   Delay_100ms();
   
   I2C1_Start();              // issue I2C start signal
  I2C1_Wr(0xA2);             // send byte via I2C  (device address + W)
  I2C1_Wr(2);                // send byte (data address)
  I2C1_Repeated_Start();     // issue I2C signal repeated start
  I2C1_Wr(0xA3);             // send byte (device address + R)
  UART1_Write(I2C1_Rd(0u));       // Read the data (NO acknowledge)
  I2C1_Stop();               // issue I2C stop signal



  while (1)
  {                     // Endless loop
    if (UART1_Data_Ready())      // If data is received,
    {
      uart_rd = UART1_Read();     // read the received data,

      if (uart_rd == '$')         // if we read a gps frame
      {
         counter = 0;          // counter initialization
         UART1_Write(13);
         UART1_Write(10);
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
      
      if (uart_rd == ',')        // word separation symbole
      {
           ++counter;             // update counter
           if (counter == 4)        // add space between results
           {
            UART1_Write(13);
            UART1_Write(10);
           }
      }

      if (good_trame)
      {

        if (counter == 2 && uart_rd != ',')      // lattitude data
        {
           UART1_Write(uart_rd);
           lattitude[lattitude_ptr++] = uart_rd;
        }

        if (counter == 3 && uart_rd != ',')      // lattitude hemisphere indicator (N or S)
        {
         UART1_Write(uart_rd);
         lattitude[lattitude_ptr++] = uart_rd;
         lattitude[lattitude_ptr++] = '\0';
         }

        if (counter == 4 && uart_rd != ',')      // longitude data
        {
         UART1_Write(uart_rd);
         longitude[longitude_ptr++] = uart_rd;
         }

        if (counter == 5 && uart_rd != ',')      //   longitude hemisphere indicator (E or W)
        {
         UART1_Write(uart_rd);
         longitude[longitude_ptr++] = uart_rd;
         longitude[longitude_ptr++] = '\0';
         }

        if (uart_rd == '*')
        {
           Data_Write(lattitude,longitude);

           Delay_ms(250);

           UART1_Write(13);
           UART1_Write(10);
           UART1_Write_Text(Data_Eeprom_Read(0));

           //Delay_ms(250);

           //Lcd_Out(2,1,longitude);
           //Lcd_Out(1,1,str);


        }
      }

    }

  }
}