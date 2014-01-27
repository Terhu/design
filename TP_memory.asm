
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
	GOTO       L__Data_Eeprom_Read44
	MOVLW      21
	SUBWF      Data_Eeprom_Read_indice_L0+0, 0
L__Data_Eeprom_Read44:
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
;TP_memory.c,92 :: 		while(donnees[indice] != '\0')
L_Data_I2C_EEPROM_Write6:
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Data_I2C_EEPROM_Write7
;TP_memory.c,94 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,95 :: 		I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,96 :: 		I2C1_Wr(adresse+indice);          // send byte (address of EEPROM location)
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,97 :: 		I2C1_Wr(donnees[indice]);        // send data (data to be written)
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,98 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,99 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Data_I2C_EEPROM_Write8:
	DECFSZ     R13+0, 1
	GOTO       L_Data_I2C_EEPROM_Write8
	DECFSZ     R12+0, 1
	GOTO       L_Data_I2C_EEPROM_Write8
	NOP
;TP_memory.c,100 :: 		++indice;
	INCF       Data_I2C_EEPROM_Write_indice_L0+0, 1
;TP_memory.c,101 :: 		}
	GOTO       L_Data_I2C_EEPROM_Write6
L_Data_I2C_EEPROM_Write7:
;TP_memory.c,102 :: 		adresse += indice;
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 1
;TP_memory.c,104 :: 		}
	RETURN
; end of _Data_I2C_EEPROM_Write

_I2C_Data_Write:

;TP_memory.c,106 :: 		void I2C_Data_Write(char * lattitude, char * longitude)
;TP_memory.c,108 :: 		Data_I2C_EEPROM_Write(lattitude);
	MOVF       FARG_I2C_Data_Write_lattitude+0, 0
	MOVWF      FARG_Data_I2C_EEPROM_Write_donnees+0
	CALL       _Data_I2C_EEPROM_Write+0
;TP_memory.c,109 :: 		Data_I2C_EEPROM_Write(longitude);
	MOVF       FARG_I2C_Data_Write_longitude+0, 0
	MOVWF      FARG_Data_I2C_EEPROM_Write_donnees+0
	CALL       _Data_I2C_EEPROM_Write+0
;TP_memory.c,110 :: 		}
	RETURN
; end of _I2C_Data_Write

_Data_I2C_EEPROM_Read:

;TP_memory.c,112 :: 		char * Data_I2C_EEPROM_Read(int item)
;TP_memory.c,116 :: 		char address = 0;
	CLRF       Data_I2C_EEPROM_Read_address_L0+0
;TP_memory.c,119 :: 		address += (item*21);
	MOVF       FARG_Data_I2C_EEPROM_Read_item+0, 0
	MOVWF      R0+0
	MOVLW      21
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	ADDWF      Data_I2C_EEPROM_Read_address_L0+0, 1
;TP_memory.c,121 :: 		for (indice = 0; indice < 21; ++indice)
	CLRF       Data_I2C_EEPROM_Read_indice_L0+0
	CLRF       Data_I2C_EEPROM_Read_indice_L0+1
L_Data_I2C_EEPROM_Read9:
	MOVLW      128
	XORWF      Data_I2C_EEPROM_Read_indice_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Data_I2C_EEPROM_Read45
	MOVLW      21
	SUBWF      Data_I2C_EEPROM_Read_indice_L0+0, 0
L__Data_I2C_EEPROM_Read45:
	BTFSC      STATUS+0, 0
	GOTO       L_Data_I2C_EEPROM_Read10
;TP_memory.c,123 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,124 :: 		I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,125 :: 		I2C1_Wr(address+indice);          // send byte (data address)
	MOVF       Data_I2C_EEPROM_Read_indice_L0+0, 0
	ADDWF      Data_I2C_EEPROM_Read_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,126 :: 		I2C1_Repeated_Start();     // issue I2C signal repeated start
	CALL       _I2C1_Repeated_Start+0
;TP_memory.c,127 :: 		I2C1_Wr(0xA1);             // send byte (device address + R)
	MOVLW      161
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,128 :: 		car = I2C1_Rd(0u);         // Read the data (NO acknowledge)
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      Data_I2C_EEPROM_Read_car_L0+0
;TP_memory.c,129 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,130 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Data_I2C_EEPROM_Read12:
	DECFSZ     R13+0, 1
	GOTO       L_Data_I2C_EEPROM_Read12
	DECFSZ     R12+0, 1
	GOTO       L_Data_I2C_EEPROM_Read12
	NOP
;TP_memory.c,131 :: 		donnees[indice]=car;
	MOVF       Data_I2C_EEPROM_Read_indice_L0+0, 0
	ADDLW      Data_I2C_EEPROM_Read_donnees_L0+0
	MOVWF      FSR
	MOVF       Data_I2C_EEPROM_Read_car_L0+0, 0
	MOVWF      INDF+0
;TP_memory.c,121 :: 		for (indice = 0; indice < 21; ++indice)
	INCF       Data_I2C_EEPROM_Read_indice_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Data_I2C_EEPROM_Read_indice_L0+1, 1
;TP_memory.c,132 :: 		}
	GOTO       L_Data_I2C_EEPROM_Read9
L_Data_I2C_EEPROM_Read10:
;TP_memory.c,133 :: 		donnees[21]='\0';
	CLRF       Data_I2C_EEPROM_Read_donnees_L0+21
;TP_memory.c,135 :: 		return donnees;
	MOVLW      Data_I2C_EEPROM_Read_donnees_L0+0
	MOVWF      R0+0
;TP_memory.c,136 :: 		}
	RETURN
; end of _Data_I2C_EEPROM_Read

_main:

;TP_memory.c,138 :: 		void main()
;TP_memory.c,140 :: 		char good_trame = 0;
	CLRF       main_good_trame_L0+0
	CLRF       main_g_counter_L0+0
;TP_memory.c,144 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;TP_memory.c,145 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
;TP_memory.c,155 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;TP_memory.c,157 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,158 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,160 :: 		counter = 0;
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,168 :: 		I2C1_Init(100000);         // initialize I2C communication
	MOVLW      20
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;TP_memory.c,171 :: 		while (1)
L_main14:
;TP_memory.c,173 :: 		if (UART1_Data_Ready())      // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main16
;TP_memory.c,175 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;TP_memory.c,177 :: 		if (uart_rd == '$')         // if we read a gps frame
	MOVF       R0+0, 0
	XORLW      36
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;TP_memory.c,179 :: 		counter = 0;          // counter initialization
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,180 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,181 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,182 :: 		lattitude_ptr = 0;
	CLRF       _lattitude_ptr+0
	CLRF       _lattitude_ptr+1
;TP_memory.c,183 :: 		longitude_ptr = 0;
	CLRF       _longitude_ptr+0
	CLRF       _longitude_ptr+1
;TP_memory.c,184 :: 		g_counter = 0;
	CLRF       main_g_counter_L0+0
;TP_memory.c,185 :: 		good_trame = 0;
	CLRF       main_good_trame_L0+0
;TP_memory.c,186 :: 		}
L_main17:
;TP_memory.c,188 :: 		if( uart_rd == 'G')
	MOVF       _uart_rd+0, 0
	XORLW      71
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;TP_memory.c,190 :: 		++g_counter;
	INCF       main_g_counter_L0+0, 1
;TP_memory.c,191 :: 		}
L_main18:
;TP_memory.c,193 :: 		if (g_counter == 3 && counter == 0)
	MOVF       main_g_counter_L0+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main46
	MOVLW      0
	XORWF      _counter+0, 0
L__main46:
	BTFSS      STATUS+0, 2
	GOTO       L_main21
L__main43:
;TP_memory.c,195 :: 		good_trame = 1;
	MOVLW      1
	MOVWF      main_good_trame_L0+0
;TP_memory.c,196 :: 		}
L_main21:
;TP_memory.c,198 :: 		if (uart_rd == ',')        // word separation symbole
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;TP_memory.c,200 :: 		++counter;             // update counter
	INCF       _counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _counter+1, 1
;TP_memory.c,201 :: 		if (counter == 4)        // add space between results
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main47
	MOVLW      4
	XORWF      _counter+0, 0
L__main47:
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;TP_memory.c,203 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,204 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,205 :: 		}
L_main23:
;TP_memory.c,206 :: 		}
L_main22:
;TP_memory.c,208 :: 		if (good_trame)
	MOVF       main_good_trame_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;TP_memory.c,211 :: 		if (counter == 2 && uart_rd != ',')      // lattitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVLW      2
	XORWF      _counter+0, 0
L__main48:
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main27
L__main42:
;TP_memory.c,213 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,214 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,215 :: 		}
L_main27:
;TP_memory.c,217 :: 		if (counter == 3 && uart_rd != ',')      // lattitude hemisphere indicator (N or S)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVLW      3
	XORWF      _counter+0, 0
L__main49:
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main30
L__main41:
;TP_memory.c,219 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,220 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,221 :: 		lattitude[lattitude_ptr++] = '\0';
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,222 :: 		}
L_main30:
;TP_memory.c,224 :: 		if (counter == 4 && uart_rd != ',')      // longitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVLW      4
	XORWF      _counter+0, 0
L__main50:
	BTFSS      STATUS+0, 2
	GOTO       L_main33
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main33
L__main40:
;TP_memory.c,226 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,227 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,228 :: 		}
L_main33:
;TP_memory.c,230 :: 		if (counter == 5 && uart_rd != ',')      //   longitude hemisphere indicator (E or W)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main51
	MOVLW      5
	XORWF      _counter+0, 0
L__main51:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main36
L__main39:
;TP_memory.c,232 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,233 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,234 :: 		longitude[longitude_ptr++] = '\0';
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,235 :: 		}
L_main36:
;TP_memory.c,237 :: 		if (uart_rd == '*')
	MOVF       _uart_rd+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;TP_memory.c,241 :: 		I2C_Data_Write(lattitude,longitude);
	MOVLW      _lattitude+0
	MOVWF      FARG_I2C_Data_Write_lattitude+0
	MOVLW      _longitude+0
	MOVWF      FARG_I2C_Data_Write_longitude+0
	CALL       _I2C_Data_Write+0
;TP_memory.c,242 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;TP_memory.c,244 :: 		UART1_Write_Text(Data_I2C_EEPROM_Read(0));
	CLRF       FARG_Data_I2C_EEPROM_Read_item+0
	CLRF       FARG_Data_I2C_EEPROM_Read_item+1
	CALL       _Data_I2C_EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;TP_memory.c,256 :: 		}
L_main37:
;TP_memory.c,257 :: 		}
L_main24:
;TP_memory.c,259 :: 		}
L_main16:
;TP_memory.c,261 :: 		}
	GOTO       L_main14
;TP_memory.c,262 :: 		}
	GOTO       $+0
; end of _main
