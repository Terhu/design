
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
	BTFSC      STATUS+0, 0
	INCF       _adresse+1, 1
	MOVLW      0
	BTFSC      Data_Eeprom_Write_indice_L0+0, 7
	MOVLW      255
	ADDWF      _adresse+1, 1
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
	GOTO       L__Data_Eeprom_Read51
	MOVLW      21
	SUBWF      Data_Eeprom_Read_indice_L0+0, 0
L__Data_Eeprom_Read51:
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

;TP_memory.c,90 :: 		void Data_I2C_EEPROM_Write(char * donnees)
;TP_memory.c,92 :: 		short indice=0;
	CLRF       Data_I2C_EEPROM_Write_indice_L0+0
;TP_memory.c,94 :: 		while(donnees[indice] != '\0')
L_Data_I2C_EEPROM_Write6:
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Data_I2C_EEPROM_Write7
;TP_memory.c,96 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,97 :: 		I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,98 :: 		I2C1_Wr(adresse+indice);          // send byte (address of EEPROM location)
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,99 :: 		I2C1_Wr(donnees[indice]);        // send data (data to be written)
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,100 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,101 :: 		Delay_ms(10);
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
;TP_memory.c,102 :: 		++indice;
	INCF       Data_I2C_EEPROM_Write_indice_L0+0, 1
;TP_memory.c,103 :: 		}
	GOTO       L_Data_I2C_EEPROM_Write6
L_Data_I2C_EEPROM_Write7:
;TP_memory.c,104 :: 		adresse += indice;
	MOVF       Data_I2C_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 1
	BTFSC      STATUS+0, 0
	INCF       _adresse+1, 1
	MOVLW      0
	BTFSC      Data_I2C_EEPROM_Write_indice_L0+0, 7
	MOVLW      255
	ADDWF      _adresse+1, 1
;TP_memory.c,106 :: 		}
	RETURN
; end of _Data_I2C_EEPROM_Write

_I2C_Data_Write:

;TP_memory.c,108 :: 		void I2C_Data_Write(char * lattitude, char * longitude)
;TP_memory.c,110 :: 		Data_I2C_EEPROM_Write(lattitude);
	MOVF       FARG_I2C_Data_Write_lattitude+0, 0
	MOVWF      FARG_Data_I2C_EEPROM_Write_donnees+0
	CALL       _Data_I2C_EEPROM_Write+0
;TP_memory.c,111 :: 		Data_I2C_EEPROM_Write(longitude);
	MOVF       FARG_I2C_Data_Write_longitude+0, 0
	MOVWF      FARG_Data_I2C_EEPROM_Write_donnees+0
	CALL       _Data_I2C_EEPROM_Write+0
;TP_memory.c,112 :: 		}
	RETURN
; end of _I2C_Data_Write

_Data_I2C_EEPROM_Read:

;TP_memory.c,114 :: 		char * Data_I2C_EEPROM_Read(int item)
;TP_memory.c,118 :: 		char address = 0;
	CLRF       Data_I2C_EEPROM_Read_address_L0+0
;TP_memory.c,121 :: 		address += (item*21);
	MOVF       FARG_Data_I2C_EEPROM_Read_item+0, 0
	MOVWF      R0+0
	MOVLW      21
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	ADDWF      Data_I2C_EEPROM_Read_address_L0+0, 1
;TP_memory.c,123 :: 		for (indice = 0; indice < 21; ++indice)
	CLRF       Data_I2C_EEPROM_Read_indice_L0+0
	CLRF       Data_I2C_EEPROM_Read_indice_L0+1
L_Data_I2C_EEPROM_Read9:
	MOVLW      128
	XORWF      Data_I2C_EEPROM_Read_indice_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Data_I2C_EEPROM_Read52
	MOVLW      21
	SUBWF      Data_I2C_EEPROM_Read_indice_L0+0, 0
L__Data_I2C_EEPROM_Read52:
	BTFSC      STATUS+0, 0
	GOTO       L_Data_I2C_EEPROM_Read10
;TP_memory.c,125 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,126 :: 		I2C1_Wr(0xA0);             // send byte via I2C  (device address + W)
	MOVLW      160
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,127 :: 		I2C1_Wr(address+indice);          // send byte (data address)
	MOVF       Data_I2C_EEPROM_Read_indice_L0+0, 0
	ADDWF      Data_I2C_EEPROM_Read_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,128 :: 		I2C1_Repeated_Start();     // issue I2C signal repeated start
	CALL       _I2C1_Repeated_Start+0
;TP_memory.c,129 :: 		I2C1_Wr(0xA1);             // send byte (device address + R)
	MOVLW      161
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,130 :: 		car = I2C1_Rd(0u);         // Read the data (NO acknowledge)
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      Data_I2C_EEPROM_Read_car_L0+0
;TP_memory.c,131 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,132 :: 		Delay_ms(10);
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
;TP_memory.c,133 :: 		donnees[indice]=car;
	MOVF       Data_I2C_EEPROM_Read_indice_L0+0, 0
	ADDLW      Data_I2C_EEPROM_Read_donnees_L0+0
	MOVWF      FSR
	MOVF       Data_I2C_EEPROM_Read_car_L0+0, 0
	MOVWF      INDF+0
;TP_memory.c,123 :: 		for (indice = 0; indice < 21; ++indice)
	INCF       Data_I2C_EEPROM_Read_indice_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Data_I2C_EEPROM_Read_indice_L0+1, 1
;TP_memory.c,134 :: 		}
	GOTO       L_Data_I2C_EEPROM_Read9
L_Data_I2C_EEPROM_Read10:
;TP_memory.c,135 :: 		donnees[21]='\0';
	CLRF       Data_I2C_EEPROM_Read_donnees_L0+21
;TP_memory.c,137 :: 		return donnees;
	MOVLW      Data_I2C_EEPROM_Read_donnees_L0+0
	MOVWF      R0+0
;TP_memory.c,138 :: 		}
	RETURN
; end of _Data_I2C_EEPROM_Read

_Data_I2C_24LC32A_EEPROM_Write:

;TP_memory.c,142 :: 		void Data_I2C_24LC32A_EEPROM_Write(char * donnees)
;TP_memory.c,144 :: 		unsigned short indice=0;
	CLRF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0
;TP_memory.c,149 :: 		while(donnees[indice] != '\0')
L_Data_I2C_24LC32A_EEPROM_Write13:
	MOVF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_24LC32A_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_Data_I2C_24LC32A_EEPROM_Write14
;TP_memory.c,151 :: 		address = adresse+indice;
	MOVF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 0
	MOVWF      R0+0
	MOVF       _adresse+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
;TP_memory.c,153 :: 		low_address = address & 0x00FF;
	MOVLW      255
	ANDWF      R0+0, 0
	MOVWF      Data_I2C_24LC32A_EEPROM_Write_low_address_L0+0
;TP_memory.c,154 :: 		high_address = address & 0x0F00;
	MOVLW      0
	ANDWF      R0+0, 0
	MOVWF      Data_I2C_24LC32A_EEPROM_Write_high_address_L0+0
;TP_memory.c,156 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,157 :: 		I2C1_Wr(0xAE);             // send byte via I2C  (device address + W)
	MOVLW      174
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,158 :: 		I2C1_Wr(high_address);   // send byte (address of EEPROM location)
	MOVF       Data_I2C_24LC32A_EEPROM_Write_high_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,159 :: 		I2C1_Wr(low_address);   // send byte (address of EEPROM location)
	MOVF       Data_I2C_24LC32A_EEPROM_Write_low_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,160 :: 		I2C1_Wr(donnees[indice]);  // send data (data to be written)
	MOVF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0, 0
	ADDWF      FARG_Data_I2C_24LC32A_EEPROM_Write_donnees+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,161 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,162 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Data_I2C_24LC32A_EEPROM_Write15:
	DECFSZ     R13+0, 1
	GOTO       L_Data_I2C_24LC32A_EEPROM_Write15
	DECFSZ     R12+0, 1
	GOTO       L_Data_I2C_24LC32A_EEPROM_Write15
	NOP
;TP_memory.c,163 :: 		++indice;
	INCF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0, 1
;TP_memory.c,164 :: 		}
	GOTO       L_Data_I2C_24LC32A_EEPROM_Write13
L_Data_I2C_24LC32A_EEPROM_Write14:
;TP_memory.c,165 :: 		adresse += indice;
	MOVF       Data_I2C_24LC32A_EEPROM_Write_indice_L0+0, 0
	ADDWF      _adresse+0, 1
	BTFSC      STATUS+0, 0
	INCF       _adresse+1, 1
;TP_memory.c,166 :: 		}
	RETURN
; end of _Data_I2C_24LC32A_EEPROM_Write

_I2C_24LC32A_Data_Write:

;TP_memory.c,168 :: 		void I2C_24LC32A_Data_Write(char * lattitude, char * longitude)
;TP_memory.c,170 :: 		Data_I2C_24LC32A_EEPROM_Write(lattitude);
	MOVF       FARG_I2C_24LC32A_Data_Write_lattitude+0, 0
	MOVWF      FARG_Data_I2C_24LC32A_EEPROM_Write_donnees+0
	CALL       _Data_I2C_24LC32A_EEPROM_Write+0
;TP_memory.c,171 :: 		Data_I2C_24LC32A_EEPROM_Write(longitude);
	MOVF       FARG_I2C_24LC32A_Data_Write_longitude+0, 0
	MOVWF      FARG_Data_I2C_24LC32A_EEPROM_Write_donnees+0
	CALL       _Data_I2C_24LC32A_EEPROM_Write+0
;TP_memory.c,172 :: 		}
	RETURN
; end of _I2C_24LC32A_Data_Write

_Data_I2C_24LC32A_EEPROM_Read:

;TP_memory.c,174 :: 		char * Data_I2C_24LC32A_EEPROM_Read(unsigned int item)
;TP_memory.c,178 :: 		unsigned int address = 0;
	CLRF       Data_I2C_24LC32A_EEPROM_Read_address_L0+0
	CLRF       Data_I2C_24LC32A_EEPROM_Read_address_L0+1
;TP_memory.c,183 :: 		address += (item*21);
	MOVF       FARG_Data_I2C_24LC32A_EEPROM_Read_item+0, 0
	MOVWF      R0+0
	MOVF       FARG_Data_I2C_24LC32A_EEPROM_Read_item+1, 0
	MOVWF      R0+1
	MOVLW      21
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	ADDWF      Data_I2C_24LC32A_EEPROM_Read_address_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      Data_I2C_24LC32A_EEPROM_Read_address_L0+1, 1
;TP_memory.c,185 :: 		for (indice = 0; indice < 21; ++indice)
	CLRF       Data_I2C_24LC32A_EEPROM_Read_indice_L0+0
L_Data_I2C_24LC32A_EEPROM_Read16:
	MOVLW      21
	SUBWF      Data_I2C_24LC32A_EEPROM_Read_indice_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Data_I2C_24LC32A_EEPROM_Read17
;TP_memory.c,187 :: 		low_address = address & 0x00FF;
	MOVLW      255
	ANDWF      Data_I2C_24LC32A_EEPROM_Read_address_L0+0, 0
	MOVWF      Data_I2C_24LC32A_EEPROM_Read_low_address_L0+0
;TP_memory.c,188 :: 		high_address = address & 0x0F00;
	MOVLW      0
	ANDWF      Data_I2C_24LC32A_EEPROM_Read_address_L0+0, 0
	MOVWF      Data_I2C_24LC32A_EEPROM_Read_high_address_L0+0
;TP_memory.c,190 :: 		I2C1_Start();              // issue I2C start signal
	CALL       _I2C1_Start+0
;TP_memory.c,191 :: 		I2C1_Wr(0xAE);             // send byte via I2C  (device address + W)
	MOVLW      174
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,192 :: 		I2C1_Wr(high_address);     // send byte (data address)
	MOVF       Data_I2C_24LC32A_EEPROM_Read_high_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,193 :: 		I2C1_Wr(low_address);      // send byte (data address)
	MOVF       Data_I2C_24LC32A_EEPROM_Read_low_address_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,194 :: 		I2C1_Repeated_Start();     // issue I2C signal repeated start
	CALL       _I2C1_Repeated_Start+0
;TP_memory.c,195 :: 		I2C1_Wr(0xAF);             // send byte (device address + R)
	MOVLW      175
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;TP_memory.c,196 :: 		car = I2C1_Rd(0u);         // Read the data (NO acknowledge)
	CLRF       FARG_I2C1_Rd_ack+0
	CALL       _I2C1_Rd+0
	MOVF       R0+0, 0
	MOVWF      Data_I2C_24LC32A_EEPROM_Read_car_L0+0
;TP_memory.c,197 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL       _I2C1_Stop+0
;TP_memory.c,198 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_Data_I2C_24LC32A_EEPROM_Read19:
	DECFSZ     R13+0, 1
	GOTO       L_Data_I2C_24LC32A_EEPROM_Read19
	DECFSZ     R12+0, 1
	GOTO       L_Data_I2C_24LC32A_EEPROM_Read19
	NOP
;TP_memory.c,199 :: 		donnees[indice]=car;
	MOVF       Data_I2C_24LC32A_EEPROM_Read_indice_L0+0, 0
	ADDLW      Data_I2C_24LC32A_EEPROM_Read_donnees_L0+0
	MOVWF      FSR
	MOVF       Data_I2C_24LC32A_EEPROM_Read_car_L0+0, 0
	MOVWF      INDF+0
;TP_memory.c,201 :: 		address += 1;
	INCF       Data_I2C_24LC32A_EEPROM_Read_address_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Data_I2C_24LC32A_EEPROM_Read_address_L0+1, 1
;TP_memory.c,185 :: 		for (indice = 0; indice < 21; ++indice)
	INCF       Data_I2C_24LC32A_EEPROM_Read_indice_L0+0, 1
;TP_memory.c,202 :: 		}
	GOTO       L_Data_I2C_24LC32A_EEPROM_Read16
L_Data_I2C_24LC32A_EEPROM_Read17:
;TP_memory.c,203 :: 		donnees[21]='\0';
	CLRF       Data_I2C_24LC32A_EEPROM_Read_donnees_L0+21
;TP_memory.c,205 :: 		return donnees;
	MOVLW      Data_I2C_24LC32A_EEPROM_Read_donnees_L0+0
	MOVWF      R0+0
;TP_memory.c,206 :: 		}
	RETURN
; end of _Data_I2C_24LC32A_EEPROM_Read

_main:

;TP_memory.c,210 :: 		void main()
;TP_memory.c,212 :: 		char good_trame = 0;
	CLRF       main_good_trame_L0+0
	CLRF       main_g_counter_L0+0
;TP_memory.c,216 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;TP_memory.c,217 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
;TP_memory.c,227 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;TP_memory.c,229 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,230 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TP_memory.c,232 :: 		counter = 0;
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,240 :: 		I2C1_Init(100000);         // initialize I2C communication
	MOVLW      20
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;TP_memory.c,243 :: 		while (1)
L_main21:
;TP_memory.c,245 :: 		if (UART1_Data_Ready())      // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;TP_memory.c,247 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;TP_memory.c,249 :: 		if (uart_rd == '$')         // if we read a gps frame
	MOVF       R0+0, 0
	XORLW      36
	BTFSS      STATUS+0, 2
	GOTO       L_main24
;TP_memory.c,251 :: 		counter = 0;          // counter initialization
	CLRF       _counter+0
	CLRF       _counter+1
;TP_memory.c,252 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,253 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,254 :: 		lattitude_ptr = 0;
	CLRF       _lattitude_ptr+0
	CLRF       _lattitude_ptr+1
;TP_memory.c,255 :: 		longitude_ptr = 0;
	CLRF       _longitude_ptr+0
	CLRF       _longitude_ptr+1
;TP_memory.c,256 :: 		g_counter = 0;
	CLRF       main_g_counter_L0+0
;TP_memory.c,257 :: 		good_trame = 0;
	CLRF       main_good_trame_L0+0
;TP_memory.c,258 :: 		}
L_main24:
;TP_memory.c,260 :: 		if( uart_rd == 'G')
	MOVF       _uart_rd+0, 0
	XORLW      71
	BTFSS      STATUS+0, 2
	GOTO       L_main25
;TP_memory.c,262 :: 		++g_counter;
	INCF       main_g_counter_L0+0, 1
;TP_memory.c,263 :: 		}
L_main25:
;TP_memory.c,265 :: 		if (g_counter == 3 && counter == 0)
	MOVF       main_g_counter_L0+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main53
	MOVLW      0
	XORWF      _counter+0, 0
L__main53:
	BTFSS      STATUS+0, 2
	GOTO       L_main28
L__main50:
;TP_memory.c,267 :: 		good_trame = 1;
	MOVLW      1
	MOVWF      main_good_trame_L0+0
;TP_memory.c,268 :: 		}
L_main28:
;TP_memory.c,270 :: 		if (uart_rd == ',')        // word separation symbole
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSS      STATUS+0, 2
	GOTO       L_main29
;TP_memory.c,272 :: 		++counter;             // update counter
	INCF       _counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _counter+1, 1
;TP_memory.c,273 :: 		if (counter == 4)        // add space between results
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVLW      4
	XORWF      _counter+0, 0
L__main54:
	BTFSS      STATUS+0, 2
	GOTO       L_main30
;TP_memory.c,275 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,276 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,277 :: 		}
L_main30:
;TP_memory.c,278 :: 		}
L_main29:
;TP_memory.c,280 :: 		if (good_trame)
	MOVF       main_good_trame_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main31
;TP_memory.c,283 :: 		if (counter == 2 && uart_rd != ',')      // lattitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVLW      2
	XORWF      _counter+0, 0
L__main55:
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main34
L__main49:
;TP_memory.c,285 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,286 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,287 :: 		}
L_main34:
;TP_memory.c,289 :: 		if (counter == 3 && uart_rd != ',')      // lattitude hemisphere indicator (N or S)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVLW      3
	XORWF      _counter+0, 0
L__main56:
	BTFSS      STATUS+0, 2
	GOTO       L_main37
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main37
L__main48:
;TP_memory.c,291 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,292 :: 		lattitude[lattitude_ptr++] = uart_rd;
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,293 :: 		lattitude[lattitude_ptr++] = '\0';
	MOVF       _lattitude_ptr+0, 0
	ADDLW      _lattitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _lattitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _lattitude_ptr+1, 1
;TP_memory.c,294 :: 		}
L_main37:
;TP_memory.c,296 :: 		if (counter == 4 && uart_rd != ',')      // longitude data
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVLW      4
	XORWF      _counter+0, 0
L__main57:
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main40
L__main47:
;TP_memory.c,298 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,299 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,300 :: 		}
L_main40:
;TP_memory.c,302 :: 		if (counter == 5 && uart_rd != ',')      //   longitude hemisphere indicator (E or W)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVLW      5
	XORWF      _counter+0, 0
L__main58:
	BTFSS      STATUS+0, 2
	GOTO       L_main43
	MOVF       _uart_rd+0, 0
	XORLW      44
	BTFSC      STATUS+0, 2
	GOTO       L_main43
L__main46:
;TP_memory.c,304 :: 		UART1_Write(uart_rd);
	MOVF       _uart_rd+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;TP_memory.c,305 :: 		longitude[longitude_ptr++] = uart_rd;
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,306 :: 		longitude[longitude_ptr++] = '\0';
	MOVF       _longitude_ptr+0, 0
	ADDLW      _longitude+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       _longitude_ptr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _longitude_ptr+1, 1
;TP_memory.c,307 :: 		}
L_main43:
;TP_memory.c,309 :: 		if (uart_rd == '*')
	MOVF       _uart_rd+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main44
;TP_memory.c,313 :: 		I2C_24LC32A_Data_Write(lattitude,longitude);
	MOVLW      _lattitude+0
	MOVWF      FARG_I2C_24LC32A_Data_Write_lattitude+0
	MOVLW      _longitude+0
	MOVWF      FARG_I2C_24LC32A_Data_Write_longitude+0
	CALL       _I2C_24LC32A_Data_Write+0
;TP_memory.c,314 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	DECFSZ     R11+0, 1
	GOTO       L_main45
	NOP
	NOP
;TP_memory.c,316 :: 		UART1_Write_Text(Data_I2C_24LC32A_EEPROM_Read(0));
	CLRF       FARG_Data_I2C_24LC32A_EEPROM_Read_item+0
	CLRF       FARG_Data_I2C_24LC32A_EEPROM_Read_item+1
	CALL       _Data_I2C_24LC32A_EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;TP_memory.c,328 :: 		}
L_main44:
;TP_memory.c,329 :: 		}
L_main31:
;TP_memory.c,331 :: 		}
L_main23:
;TP_memory.c,333 :: 		}
	GOTO       L_main21
;TP_memory.c,334 :: 		}
	GOTO       $+0
; end of _main
