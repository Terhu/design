#line 1 "C:/Users/biamino/Documents/TP_DESIGN/UART.c"
#line 27 "C:/Users/biamino/Documents/TP_DESIGN/UART.c"
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

void main() {


 UART1_Init(9600);
 Delay_ms(100);

 UART1_Write_Text("Start");
 UART1_Write(13);
 UART1_Write(10);

 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 counter = 0;

 while (1)
 {
 if (UART1_Data_Ready())
 {
 uart_rd = UART1_Read();

 if (uart_rd == '$')
 {
 counter = 0;
 UART1_Write(13);
 UART1_Write(10);
 lattitude_ptr = 0;
 longitude_ptr = 0;
 }

 if (uart_rd == ',')
 {
 ++counter;
 if (counter == 4)
 {
 UART1_Write(13);
 UART1_Write(10);
 }
 }

 if (counter == 2 && uart_rd != ',')
 {
 UART1_Write(uart_rd);
 lattitude[lattitude_ptr++] = uart_rd;
 }

 if (counter == 3 && uart_rd != ',')
 {
 UART1_Write(uart_rd);
 lattitude[lattitude_ptr++] = uart_rd;
 lattitude[lattitude_ptr++] = '\0';
 }

 if (counter == 4 && uart_rd != ',')
 {
 UART1_Write(uart_rd);
 longitude[longitude_ptr++] = uart_rd;
 }

 if (counter == 5 && uart_rd != ',')
 {
 UART1_Write(uart_rd);
 longitude[longitude_ptr++] = uart_rd;
 longitude[longitude_ptr++] = '\0';
 }

 if (uart_rd == '*')
 {
 Lcd_Out(2,1,longitude);
 Lcd_Out(1,1,lattitude);
 }

 }

 }
}
