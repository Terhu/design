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

bit start_button;
bit stop_button;
bit send_button;

char uart_rd;
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
  donnees[21]='\0';

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
  donnees[21]='\0';

  return donnees;
}

/** Button **/

void initButton()
{
 TRISB = 0x07;
}

void startButtonAction()
{
     UART1_Write_Text("start\n");
}

void startButton()
{
    if (Button(&PORTB, 0, 1, 1))
    {
      start_button = 1;
    }
    if (start_button && Button(&PORTB, 0, 1, 0))
    {
      start_button = 0;
      startButtonAction();
    }
}

void stopButtonAction()
{
     UART1_Write_Text("stop\n");
}

void stopButton()
{
    if (Button(&PORTB, 1, 1, 1))
    {
      stop_button = 1;
    }
    if (stop_button && Button(&PORTB, 1, 1, 0))
    {
      stop_button = 0;
      stopButtonAction();
    }

}

void sendButtonAction()
{
     UART1_Write_Text("send\n");
}

void sendButton()
{
    if (Button(&PORTB, 2, 1, 1))
    {
      send_button = 1;
    }
    if (send_button && Button(&PORTB, 2, 1, 0))
    {
      send_button = 0;
      sendButtonAction();
    }

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
   
   I2C1_Init(100000);         // initialize I2C communication

   initButton();

  while (1)
  {
   startButton();
   stopButton();
  sendButton();
  
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
          // Data_Write(lattitude,longitude);

           I2C_24LC32A_Data_Write(lattitude,longitude);
           Delay_ms(250);
           
           UART1_Write_Text(Data_I2C_24LC32A_EEPROM_Read(0));
           
           Delay_ms(250);

           UART1_Write_Text(Data_I2C_24LC32A_EEPROM_Read(15));

          // UART1_Write(13);
           //UART1_Write(10);
           //UART1_Write_Text(Data_Eeprom_Read(0));

           //Delay_ms(250);

           //Lcd_Out(2,1,longitude);
           //Lcd_Out(1,1,str);


        }
      }

    }

  }
}