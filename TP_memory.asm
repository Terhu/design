
_Data_Eeprom_Write:

;TP_memory.c,54 :: 		void Data_Eeprom_Write(char * donnees)
;TP_memory.c,56 :: 		short indice=0;
	CLRF       Data_Eeprom_Write_indice_L0+0
;TP_memory.c,57 :: 		while(donnees[indice] != '\0')
L_Data_Eeprom_Write0:
	MOVF       Data_Eeprom_Write_indice_L0+0, 0
	ADDWF      FARG_Data_Eeprom_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Data_Eeprom_Write1
;TP_memory.c,59 :: 		EEPROM_Write(adresse+indice,donnees[indice]);
	MOVF       Data_Eeprom_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       Data_Eeprom_Write_indice_L0+0, 0
	ADDWF      FARG_Data_Eeprom_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;TP_memory.c,60 :: 		++indice;
	INCF       Data_Eeprom_Write_indice_L0+0, 1
;TP_memory.c,61 :: 		}
	GOTO       L_Data_Eeprom_Write0
L_Data_Eeprom_Write1:
;TP_memory.c,62 :: 		adresse += indice;
	MOVF       Data_Eeprom_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 1
;TP_memory.c,63 :: 		}
	RETURN
; end of _Data_Eeprom_Write

_Data_Write:

;TP_memory.c,65 :: 		void Data_Write(char * lattitude, char * longitude)
;TP_memory.c,67 :: 		Data_Eeprom_Write(lattitude);
	MOVF       FARG_Data_Write_lattitude+0, 0
	MOVWF      FARG_Data_Eeprom_Write_donnees+0
	CALL       _Data_Eeprom_Write+0
;TP_memory.c,68 :: 		Data_Eeprom_Write(longitude);
	MOVF       FARG_Data_Write_longitude+0, 0
	MOVWF      FARG_Data_Eeprom_Write_donnees+0
	CALL       _Data_Eeprom_Write+0
;TP_memory.c,69 :: 		}
	RETURN
; end of _Data_Write

_Data_Eeprom_Read:

;TP_memory.c,71 :: 		char * Data_Eeprom_Read(int item)
;TP_memory.c,75 :: 		char address = 0;
	CLRF       Data_Eeprom_Read_address_L0+0
;TP_memory.c,76 :: 		address += (item*21);
	MOVF       FARG_Data_Eeprom_Read_item+0, 0
	MOVWF      R0+0
	MOVLW      21
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	ADDWF      Data_Eeprom_Read_address_L0+0, 1
;TP_memory.c,78 :: 		for (indice = 0; indice < 21; ++indice)
	CLRF       Data_Eeprom_Read_indice_L0+0
	CLRF       Data_Eeprom_Read_indice_L0+1
L_Data_Eeprom_Read2:
	MOVLW      128
	XORWF      Data_Eeprom_Read_indice_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Data_Eeprom_Read39
	MOVLW      21
	SUBWF      Data_Eeprom_Read_indice_L0+0, 0
L__Data_Eeprom_Read39:
	BTFSC      STATUS+0, 0
	GOTO       L_Data_Eeprom_Read3
;TP_memory.c,80 :: 		donnees[indice]=EEPROM_Read(address+indice);
	MOVF       Data_Eeprom_Read_indice_L0+0, 0
	ADDLW      Data_Eeprom_Read_donnees_L0+0
	MOVWF      FLOC__Data_Eeprom_Read+0
	MOVF       Data_Eeprom_Read_indice_L0+0, 0
	ADDWF      Data_Eeprom_Read_address_L0+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       FLOC__Data_Eeprom_Read+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;TP_memory.c,81 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_Data_Eeprom_Read5:
	DECFSZ     R13+0, 1
	GOTO       L_Data_Eeprom_Read5
	DECFSZ     R12+0, 1
	GOTO       L_Data_Eeprom_Read5
	DECFSZ     R11+0, 1
	GOTO       L_Data_Eeprom_Read5
	NOP
	NOP
;TP_memory.c,78 :: 		for (indice = 0; indice < 21; ++indice)
	INCF       Data_Eeprom_Read_indice_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Data_Eeprom_Read_indice_L0+1, 1
;TP_memory.c,82 :: 		}
	GOTO       L_Data_Eeprom_Read2
L_Data_Eeprom_Read3:
;TP_memory.c,83 :: 		donnees[21]='\0';
	CLRF       Data_Eeprom_Read_donnees_L0+21
;TP_memory.c,85 :: 		return donnees;
	MOVLW      Data_Eeprom_Read_donnees_L0+0
	MOVWF      R0+0
;TP_memory.c,86 :: 		}
	RETURN
; end of _Data_Eeprom_Read

_Data_I2C_EEPROM_Write:

;TP_memory.c,88 :: 		void Data_I2C_EEPROM_Write(char * donnees)
;TP_memory.c,90 :: 		short indice=0;
	CLRF       Data_I2C_EEPROM_Write_indice_L0+0
;TP_memory.c,91 :: 		while(donnees[indice] != '\0')
L_Data_I2C_EEPROM_Write6:
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Data_I2C_EEPROM_Write7
;TP_memory.c,93 :: 		EEPROM_Write(adresse+indice,donnees[indice]);
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;TP_memory.c,94 :: 		++indice;
	INCF       Data_I2C_EEPROM_Write_indice_L0+0, 1
;TP_memory.c,95 :: 		}
	GOTO       L_Data_I2C_EEPROM_Write6
L_Data_I2C_EEPROM_Write7:
;TP_memory.c,96 :: 		adresse += indice;
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 1
;TP_memory.c,97 :: 		}
	RETURN
; end of _Data_I2C_EEPROM_Write

_main:

;TP_memory.c,99 :: 		void main()
;TP_memory.c,101 :: 		char good_trame = 0;
	CLRF       main_good_trame_L0+0
	CLRF       main_g_counter_L0+0
;TP_memory.c,105 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;TP_memory.c,106 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
;TP_memory.c,116 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;TP_memory.c,118 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,119 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,121 :: 		counter = 0;
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,129 :: 		I2C1_Init(100000);         // initialize I2C communication
	MOVLW      20
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;TP_memory.c,130 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,131 :: 		I2C1_Wr(0xA2);             // send byte via I2C  (device address + W)
	MOVLW      162
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,132 :: 		I2C1_Wr(0x02);             // send byte (address of EEPROM location)
	MOVLW      2
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,133 :: 		I2C1_Wr(0x4A);             // send data (data to be written)
	MOVLW      74
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,134 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,136 :: 		Delay_100ms();
	CALL       _Delay_100ms+0
;TP_memory.c,138 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,139 :: 		I2C1_Wr(0xA2);             // send byte via I2C  (device address + W)
	MOVLW      162
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,140 :: 		I2C1_Wr(2);                // send byte (data address)
	MOVLW      2
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,141 :: 		I2C1_Repeated_Start();     // issue I2C signal repeated start
	CALL       _I2C1_Repeated_Start+0
;TP_memory.c,142 :: 		I2C1_Wr(0xA3);             // send byte (device address + R)
	MOVLW      163
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,143 :: 		UART1_Write(I2C1_Rd(0u));       // Read the data (NO acknowledge)
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,144 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,148 :: 		while (1)
L_main9:
;TP_memory.c,150 :: 		if (UART1_Data_Ready())      // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main11
;TP_memory.c,152 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;TP_memory.c,154 :: 		if (uart_rd == '$')         // if we read a gps frame
	MOVF       R0+0, 0
	XORLW      36
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;TP_memory.c,156 :: 		counter = 0;          // counter initialization
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,157 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,158 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,159 :: 		lattitude_ptr = 0;
	CLRF       _lattitude_ptr+0
	CLRF       _lattitude_ptr+1
;TP_memory.c,160 :: 		longitude_ptr = 0;
	CLRF       _longitude_ptr+0
	CLRF       _longitude_ptr+1
;TP_memory.c,161 :: 		g_counter = 0;
	CLRF       main_g_counter_L0+0
;TP_memory.c,162 :: 		good_trame = 0;
	CLRF       main_good_trame_L0+0
;TP_memory.c,163 :: 		}
L_main12:
;TP_memory.c,165 :: 		if( uart_rd == 'G')
	MOVF       _uart_rd+0, 0
	XORLW      71
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;TP_memory.c,167 :: 		++g_counter;
	INCF       main_g_counter_L0+0, 1
;TP_memory.c,168 :: 		}
L_main13:
;TP_memory.c,170 :: 		if (g_counter == 3 && counter == 0)
	MOVF       main_g_counter_L0+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      0
	XORWF      _counter+0, 0
L__main40:
	BTFSS      STATUS+0, 2
	GOTO       L_main16
L__main38:
;TP_memory.c,172 :: 		good_trame = 1;
	MOVLW      1
	MOVWF      main_good_trame_L0+0
;TP_memory.c,173 :: 		}
L_main16:
;TP_memory.c,175 :: 		if (uart_rd == ',')        // word separation symbole
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;TP_memory.c,177 :: 		++counter;             // update counter
	INCF       _counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _counter+1, 1
;TP_memory.c,178 :: 		if (counter == 4)        // add space between results
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVLW      4
	XORWF      _counter+0, 0
L__main41:
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;TP_memory.c,180 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,181 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,182 :: 		}
L_main18:
;TP_memory.c,183 :: 		}
L_main17:
;TP_memory.c,185 :: 		if (good_trame)
	MOVF       main_good_trame_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main19
;TP_memory.c,188 :: 		if (counter == 2 && uart_rd != ',')      // lattitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main42
	MOVLW      2
	XORWF      _counter+0, 0
L__main42:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main22
L__main37:
;TP_memory.c,190 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,191 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,192 :: 		}
L_main22:
;TP_memory.c,194 :: 		if (counter == 3 && uart_rd != ',')      // lattitude hemisphere indicator (N or S)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main43
	MOVLW      3
	XORWF      _counter+0, 0
L__main43:
	BTFSS      STATUS+0, 2
	GOTO       L_main25
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main25
L__main36:
;TP_memory.c,196 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,197 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,198 :: 		lattitude[lattitude_ptr++] = '\0';
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,199 :: 		}
L_main25:
;TP_memory.c,201 :: 		if (counter == 4 && uart_rd != ',')      // longitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main44
	MOVLW      4
	XORWF      _counter+0, 0
L__main44:
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main28
L__main35:
;TP_memory.c,203 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,204 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,205 :: 		}
L_main28:
;TP_memory.c,207 :: 		if (counter == 5 && uart_rd != ',')      //   longitude hemisphere indicator (E or W)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVLW      5
	XORWF      _counter+0, 0
L__main45:
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main31
L__main34:
;TP_memory.c,209 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,210 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,211 :: 		longitude[longitude_ptr++] = '\0';
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,212 :: 		}
L_main31:
;TP_memory.c,214 :: 		if (uart_rd == '*')
	MOVF       _uart_rd+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main32
;TP_memory.c,216 :: 		Data_Write(lattitude,longitude);
	MOVLW      _lattitude+0
	MOVWF      FARG_Data_Write_lattitude+0
	MOVLW      _longitude+0
	MOVWF      FARG_Data_Write_longitude+0
	CALL       _Data_Write+0
;TP_memory.c,218 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
	NOP
;TP_memory.c,220 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,221 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,222 :: 		UART1_Write_Text(Data_Eeprom_Read(0));
	CLRF       FARG_Data_Eeprom_Read_item+0
	CLRF       FARG_Data_Eeprom_Read_item+1
	CALL       _Data_Eeprom_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;TP_memory.c,230 :: 		}
L_main32:
;TP_memory.c,231 :: 		}
L_main19:
;TP_memory.c,233 :: 		}
L_main11:
;TP_memory.c,235 :: 		}
	GOTO       L_main9
;TP_memory.c,236 :: 		}
	GOTO       $+0
; end of _main
