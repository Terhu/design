
_main:

;UART.c,48 :: 		void main() {
;UART.c,51 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;UART.c,52 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;UART.c,54 :: 		UART1_Write_Text("Start");
	MOVLW      ?lstr1_UART+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;UART.c,55 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,56 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,58 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;UART.c,60 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;UART.c,61 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;UART.c,63 :: 		counter = 0;
	CLRF       _counter+0
	CLRF       _counter+1
;UART.c,65 :: 		while (1)
L_main1:
;UART.c,67 :: 		if (UART1_Data_Ready())      // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;UART.c,69 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;UART.c,71 :: 		if (uart_rd == '$')         // if we read a gps frame
	MOVF       R0+0, 0
	XORLW      36
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;UART.c,73 :: 		counter = 0;          // counter initialization
	CLRF       _counter+0
	CLRF       _counter+1
;UART.c,74 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,75 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,76 :: 		lattitude_ptr = 0;
	CLRF       _lattitude_ptr+0
	CLRF       _lattitude_ptr+1
;UART.c,77 :: 		longitude_ptr = 0;
	CLRF       _longitude_ptr+0
	CLRF       _longitude_ptr+1
;UART.c,78 :: 		}
L_main4:
;UART.c,80 :: 		if (uart_rd == ',')        // word separation symbole
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;UART.c,82 :: 		++counter;             // update counter
	INCF       _counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _counter+1, 1
;UART.c,83 :: 		if (counter == 4)        // add space between results
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVLW      4
	XORWF      _counter+0, 0
L__main24:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;UART.c,85 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,86 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,87 :: 		}
L_main6:
;UART.c,88 :: 		}
L_main5:
;UART.c,90 :: 		if (counter == 2 && uart_rd != ',')      // lattitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVLW      2
	XORWF      _counter+0, 0
L__main25:
	BTFSS      STATUS+0, 2
	GOTO       L_main9
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main9
L__main23:
;UART.c,92 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,93 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;UART.c,94 :: 		}
L_main9:
;UART.c,96 :: 		if (counter == 3 && uart_rd != ',')      // lattitude hemisphere indicator (N or S)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main26
	MOVLW      3
	XORWF      _counter+0, 0
L__main26:
	BTFSS      STATUS+0, 2
	GOTO       L_main12
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main12
L__main22:
;UART.c,98 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,99 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;UART.c,100 :: 		lattitude[lattitude_ptr++] = '\0';
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;UART.c,101 :: 		}
L_main12:
;UART.c,103 :: 		if (counter == 4 && uart_rd != ',')      // longitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVLW      4
	XORWF      _counter+0, 0
L__main27:
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main15
L__main21:
;UART.c,105 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,106 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;UART.c,107 :: 		}
L_main15:
;UART.c,109 :: 		if (counter == 5 && uart_rd != ',')      //   longitude hemisphere indicator (E or W)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main28
	MOVLW      5
	XORWF      _counter+0, 0
L__main28:
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main18
L__main20:
;UART.c,111 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;UART.c,112 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;UART.c,113 :: 		longitude[longitude_ptr++] = '\0';
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;UART.c,114 :: 		}
L_main18:
;UART.c,116 :: 		if (uart_rd == '*')
	MOVF       _uart_rd+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;UART.c,118 :: 		Lcd_Out(2,1,longitude);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _longitude+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;UART.c,119 :: 		Lcd_Out(1,1,lattitude);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _lattitude+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;UART.c,120 :: 		}
L_main19:
;UART.c,122 :: 		}
L_main3:
;UART.c,124 :: 		}
	GOTO       L_main1
;UART.c,125 :: 		}
	GOTO       $+0
; end of _main
