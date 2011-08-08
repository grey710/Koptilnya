
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 7,372800 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 /*****************************************************
;       2 Chip type           : ATmega8
;       3 Program type        : Application
;       4 Clock frequency     : 8,0000 MHz
;       5 Memory model        : Small
;       6 External SRAM size  : 0
;       7 Data Stack size     : 256
;       8 *****************************************************/
;       9 
;      10 #include <mega8.h>
;      11 #include <stdio.h>
;      12 #include <math.h>
;      13 #include <delay.h>
;      14 
;      15 // Alphanumeric LCD Module functions
;      16 #asm
;      17    .equ __lcd_port=0x12 ;PORTD
   .equ __lcd_port=0x12 ;PORTD
;      18 #endasm
;      19 #include <lcd.h>
;      20 
;      21 #define ADC_VREF_TYPE 0x00          
;      22 
;      23 #define	KEY1_DOWN	(PINC.1 == 0)
;      24 #define	KEY2_DOWN	(PINC.2 == 0)
;      25 #define	KEY3_DOWN	(PINC.3 == 0)
;      26 #define	KEY4_DOWN	(PINB.5 == 0)
;      27 #define	KEY5_DOWN	(PINB.4 == 0)
;      28 #define	KEY6_DOWN	(PINB.3 == 0)
;      29 
;      30 #define BEEP            PORTB.0   
;      31 
;      32 unsigned char lcd_buffer1[9] = "        ";
_lcd_buffer1:
	.BYTE 0x9
;      33 unsigned char lcd_buffer2[9] = "        ";
_lcd_buffer2:
	.BYTE 0x9
;      34 volatile unsigned int adc_data = 0, T, ee_tmprSet = 0, T_prev = 0, T_now = 0, T_disp = 0;
_adc_data:
	.BYTE 0x2
_T:
	.BYTE 0x2
_ee_tmprSet:
	.BYTE 0x2
_T_prev:
	.BYTE 0x2
_T_now:
	.BYTE 0x2
_T_disp:
	.BYTE 0x2
;      35 volatile int ReadKey = 0, KeyDelay = 0, Mode = 0, program = 1; 
_ReadKey:
	.BYTE 0x2
_KeyDelay:
	.BYTE 0x2
_Mode:
	.BYTE 0x2
_program:
	.BYTE 0x2
;      36 
;      37 unsigned int i=1, T0 = 3, Kp = 70;  // Коэффициенты нужно подбирать!
;      38 
;      39 volatile int pwm_val = 0; // Для хранения величины ШИМ в 1/1024
_pwm_val:
	.BYTE 0x2
;      40 
;      41 
;      42 eeprom unsigned int T_prog[3] = { 300, 150, 400 };   // Температурные режимы в EEPROM

	.ESEG
_T_prog:
	.DW  0x12C
	.DW  0x96
	.DW  0x190
;      43 unsigned int T_set[3];

	.DSEG
_T_set:
	.BYTE 0x6
;      44 
;      45 static void avr_init();
;      46 void green(void);
;      47 void red(void);
;      48 void my_beep(void); 
;      49 unsigned int read_adc(unsigned char adc_input);
;      50 
;      51 // ADC interrupt service routine
;      52 interrupt [ADC_INT] void adc_isr(void)
;      53 {

	.CSEG
_adc_isr:
	ST   -Y,R30
	ST   -Y,R31
;      54 // Read the AD conversion result
;      55 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RCALL SUBOPT_0x0
;      56 }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;      57 
;      58 // Read the AD conversion result
;      59 // with noise canceling
;      60 unsigned int read_adc(unsigned char adc_input)
;      61 {
_read_adc:
;      62 ADMUX=adc_input|ADC_VREF_TYPE;
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
;      63 #asm
;      64     in   r30,mcucr
    in   r30,mcucr
;      65     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
;      66     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
;      67     out  mcucr,r30
    out  mcucr,r30
;      68     sleep
    sleep
;      69     cbr  r30,__se_bit
    cbr  r30,__se_bit
;      70     out  mcucr,r30
    out  mcucr,r30
;      71 #endasm
;      72 return adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	ADIW R28,1
	RET
;      73 }
;      74 
;      75 
;      76 
;      77 // Timer 0 overflow interrupt service routine
;      78 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      79 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      80         TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;      81         if (ReadKey == 0) {
	RCALL SUBOPT_0x1
	BRNE _0x7
;      82 	        if (KeyDelay == 0) {              // Если KeyDelay == 0, то можно нажимать опять 		
	RCALL SUBOPT_0x2
	SBIW R30,0
	BRNE _0x8
;      83 	                KeyDelay = 0;
	LDI  R30,0
	STS  _KeyDelay,R30
	STS  _KeyDelay+1,R30
;      84 	                if (KEY1_DOWN)	{
	SBIC 0x13,1
	RJMP _0x9
;      85 	                        ReadKey = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x3
;      86 	                        my_beep();
;      87 	                }
;      88 	                if (KEY2_DOWN)	{
_0x9:
	SBIC 0x13,2
	RJMP _0xA
;      89 	                        ReadKey = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x3
;      90 	                        my_beep();
;      91 	                }
;      92 	                if (KEY3_DOWN)	{
_0xA:
	SBIC 0x13,3
	RJMP _0xB
;      93 	                        ReadKey = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x3
;      94 	                        my_beep();
;      95 	                }
;      96 	                if (KEY4_DOWN)	{
_0xB:
	SBIC 0x16,5
	RJMP _0xC
;      97 	                        ReadKey = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x3
;      98 	                        my_beep();
;      99 	                }
;     100 	                if (KEY5_DOWN)	{
_0xC:
	SBIC 0x16,4
	RJMP _0xD
;     101 	                        ReadKey = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x3
;     102 	                        my_beep();
;     103 	                }
;     104 	                if (KEY6_DOWN)	{
_0xD:
	SBIC 0x16,3
	RJMP _0xE
;     105 	                        ReadKey = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x3
;     106 	                        my_beep();
;     107 	                }
;     108 
;     109                         if (ReadKey) {
_0xE:
	RCALL SUBOPT_0x1
	BREQ _0xF
;     110                                 KeyDelay = 10; 
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4
;     111                         }
;     112                 } else {
_0xF:
	RJMP _0x10
_0x8:
;     113 			KeyDelay--;
	RCALL SUBOPT_0x2
	SBIW R30,1
	RCALL SUBOPT_0x4
;     114 		}
_0x10:
;     115 	}    // if  
;     116 	i--;
_0x7:
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
;     117 	    
;     118 	if (i==0) {
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x11
;     119                 T_disp = T;
	LDS  R30,_T
	LDS  R31,_T+1
	STS  _T_disp,R30
	STS  _T_disp+1,R31
;     120 	        i=15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R4,R30
;     121 	}
;     122 }
_0x11:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     123 
;     124 void main(void)
;     125 {
_main:
;     126         avr_init();
	RCALL _avr_init_G1
;     127         
;     128         adc_data=read_adc(0);
	RCALL SUBOPT_0x5
;     129         T_now = (1000 - adc_data) / 2;
;     130         T_prev = T_now;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
;     131 
;     132 while (1)
_0x12:
;     133 {
;     134         adc_data=read_adc(0);
	RCALL SUBOPT_0x5
;     135         T_now = (1000 - adc_data) / 2;
;     136         
;     137         if ((T_now < (T_prev - 3)) || (T_now > (T_prev + 3))) {
	RCALL SUBOPT_0x8
	SBIW R30,3
	RCALL SUBOPT_0x9
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x16
	RCALL SUBOPT_0x8
	ADIW R30,3
	RCALL SUBOPT_0x9
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x15
_0x16:
;     138                 T = T_prev;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xA
;     139         } else {
	RJMP _0x18
_0x15:
;     140                 T = T_now;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
;     141                 T_prev = T_now;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
;     142         }
_0x18:
;     143 	                        
;     144         pwm_val = Kp * (ee_tmprSet - T + T0);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R6
	ADC  R31,R7
	MOVW R26,R8
	RCALL __MULW12U
	RCALL SUBOPT_0xD
;     145         
;     146         if (pwm_val > 1023) pwm_val = 1023;
	RCALL SUBOPT_0xE
	CPI  R26,LOW(0x400)
	LDI  R30,HIGH(0x400)
	CPC  R27,R30
	BRLT _0x19
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RCALL SUBOPT_0xD
;     147         if (pwm_val < 0) pwm_val = 0;
_0x19:
	RCALL SUBOPT_0xE
	SBIW R26,0
	BRGE _0x1A
	LDI  R30,0
	STS  _pwm_val,R30
	STS  _pwm_val+1,R30
;     148         
;     149         if ((T > (ee_tmprSet - 10)) && (T < (ee_tmprSet + 10))) {
_0x1A:
	RCALL SUBOPT_0xC
	SBIW R30,10
	RCALL SUBOPT_0xB
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x1C
	RCALL SUBOPT_0xC
	ADIW R30,10
	RCALL SUBOPT_0xB
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
;     150                 green();
	RCALL _green
;     151         } else {
	RJMP _0x1E
_0x1B:
;     152                 red();
	RCALL _red
;     153         }
_0x1E:
;     154         
;     155         if (ReadKey == 5)
	RCALL SUBOPT_0xF
	SBIW R26,5
	BRNE _0x1F
;     156         {       
;     157                 if (Mode == 1 || Mode == 2 || Mode == 3) {
	RCALL SUBOPT_0x10
	SBIW R26,1
	BREQ _0x21
	RCALL SUBOPT_0x10
	SBIW R26,2
	BREQ _0x21
	RCALL SUBOPT_0x10
	SBIW R26,3
	BRNE _0x20
_0x21:
;     158                         T_set[Mode - 1] = T_set[Mode - 1] + 10; 
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	ADIW R30,10
	RCALL SUBOPT_0x14
;     159                 } else {
	RJMP _0x23
_0x20:
;     160                         ee_tmprSet = ee_tmprSet + 10;
	RCALL SUBOPT_0xC
	ADIW R30,10
	RCALL SUBOPT_0x15
;     161                 }
_0x23:
;     162                 ReadKey = 0;                
	RCALL SUBOPT_0x16
;     163         }
;     164         if (ReadKey == 1)
_0x1F:
	RCALL SUBOPT_0xF
	SBIW R26,1
	BRNE _0x24
;     165         {
;     166                 if (Mode == 1 || Mode == 2 || Mode == 3) {
	RCALL SUBOPT_0x10
	SBIW R26,1
	BREQ _0x26
	RCALL SUBOPT_0x10
	SBIW R26,2
	BREQ _0x26
	RCALL SUBOPT_0x10
	SBIW R26,3
	BRNE _0x25
_0x26:
;     167                         T_set[Mode - 1] = T_set[Mode - 1] - 10; 
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	SBIW R30,10
	RCALL SUBOPT_0x14
;     168                 } else {
	RJMP _0x28
_0x25:
;     169                         ee_tmprSet = ee_tmprSet - 10;
	RCALL SUBOPT_0xC
	SBIW R30,10
	RCALL SUBOPT_0x15
;     170                 }
_0x28:
;     171                 ReadKey = 0;
	RCALL SUBOPT_0x16
;     172         }
;     173         if (ReadKey == 3)
_0x24:
	RCALL SUBOPT_0xF
	SBIW R26,3
	BRNE _0x29
;     174         {
;     175                 Mode++;
	RCALL SUBOPT_0x17
	ADIW R30,1
	STS  _Mode,R30
	STS  _Mode+1,R31
;     176                 if (Mode == 4) { 
	RCALL SUBOPT_0x10
	SBIW R26,4
	BRNE _0x2A
;     177                         #asm("cli")
	cli
;     178                         T_prog[0] = T_set[0];
	RCALL SUBOPT_0x18
	LDI  R26,LOW(_T_prog)
	LDI  R27,HIGH(_T_prog)
	RCALL __EEPROMWRW
;     179                         T_prog[1] = T_set[1];
	__POINTW2MN _T_prog,2
	RCALL SUBOPT_0x19
	RCALL __EEPROMWRW
;     180                         T_prog[2] = T_set[2];
	__POINTW2MN _T_prog,4
	RCALL SUBOPT_0x1A
	RCALL __EEPROMWRW
;     181                         #asm("sei")
	sei
;     182                         Mode = 0;
	LDI  R30,0
	STS  _Mode,R30
	STS  _Mode+1,R30
;     183                 }
;     184                 ReadKey = 0;
_0x2A:
	RCALL SUBOPT_0x16
;     185         }
;     186         
;     187         if (Mode == 1 || Mode == 2 || Mode == 3) {
_0x29:
	RCALL SUBOPT_0x10
	SBIW R26,1
	BREQ _0x2C
	RCALL SUBOPT_0x10
	SBIW R26,2
	BREQ _0x2C
	RCALL SUBOPT_0x10
	SBIW R26,3
	BRNE _0x2B
_0x2C:
;     188                 sprintf(lcd_buffer1, "Tp %i:   ", Mode);
	RCALL SUBOPT_0x1B
	__POINTW1FN _0,9
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x17
	RCALL __CWD1
	RCALL SUBOPT_0x1D
;     189                 sprintf(lcd_buffer2, "%03i     ", T_set[Mode - 1]);        
	RCALL SUBOPT_0x1E
	__POINTW1FN _0,19
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x1D
;     190         }
;     191         
;     192         
;     193         if (ReadKey == 6)
_0x2B:
	RCALL SUBOPT_0xF
	SBIW R26,6
	BRNE _0x2E
;     194         {
;     195                 ee_tmprSet = T_set[0];
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x15
;     196                 program = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x1F
;     197                 ReadKey = 0;
;     198         }
;     199         if (ReadKey == 4)
_0x2E:
	RCALL SUBOPT_0xF
	SBIW R26,4
	BRNE _0x2F
;     200         {
;     201                 ee_tmprSet = T_set[1];
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x15
;     202                 program = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x1F
;     203                 ReadKey = 0;
;     204         }        
;     205         if (ReadKey == 2)
_0x2F:
	RCALL SUBOPT_0xF
	SBIW R26,2
	BRNE _0x30
;     206         {
;     207                 ee_tmprSet = T_set[2];
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x15
;     208                 program = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1F
;     209                 ReadKey = 0;
;     210         }        
;     211         
;     212         if (Mode == 0) {
_0x30:
	RCALL SUBOPT_0x17
	SBIW R30,0
	BRNE _0x31
;     213                 sprintf(lcd_buffer1, "Tc=%03i T", T_disp);
	RCALL SUBOPT_0x1B
	__POINTW1FN _0,29
	RCALL SUBOPT_0x1C
	LDS  R30,_T_disp
	LDS  R31,_T_disp+1
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x1D
;     214                 sprintf(lcd_buffer2, "p=%03i P%i", ee_tmprSet, program);
	RCALL SUBOPT_0x1E
	__POINTW1FN _0,39
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0xC
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_program
	LDS  R31,_program+1
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
;     215                 //sprintf(lcd_buffer2, "p=%04i  ", abs(T_now[1] - T_now[0]));
;     216         }
;     217         
;     218         lcd_gotoxy(0, 0);
_0x31:
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x20
	RCALL _lcd_gotoxy
;     219         lcd_puts(lcd_buffer1);
	RCALL SUBOPT_0x1B
	RCALL _lcd_puts
;     220         lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x20
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;     221         lcd_puts(lcd_buffer2);
	RCALL SUBOPT_0x1E
	RCALL _lcd_puts
;     222         
;     223         
;     224         OCR1AH = (unsigned char)(pwm_val>>8);         
	LDS  R30,_pwm_val
	LDS  R31,_pwm_val+1
	RCALL __ASRW8
	OUT  0x2B,R30
;     225         OCR1AL = (unsigned char)pwm_val; 
	LDS  R30,_pwm_val
	OUT  0x2A,R30
;     226         
;     227       };
	RJMP _0x12
;     228 }
_0x32:
	RJMP _0x32
;     229 
;     230 void green(void) {
_green:
;     231         PORTC.4 = 0;
	CBI  0x15,4
;     232         PORTC.5 = 1;
	SBI  0x15,5
;     233 }
	RET
;     234 
;     235 void red(void) {
_red:
;     236         PORTC.4 = 1;
	SBI  0x15,4
;     237         PORTC.5 = 0;
	CBI  0x15,5
;     238 }
	RET
;     239 void my_beep(void) {
_my_beep:
;     240         BEEP = 1;
	SBI  0x18,0
;     241         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x1C
	RCALL _delay_ms
;     242         BEEP = 0;
	CBI  0x18,0
;     243 }
	RET
;     244 
;     245 static void avr_init() {
_avr_init_G1:
;     246 // Input/Output Ports initialization
;     247 // Port B initialization
;     248 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
;     249 // State7=T State6=T State5=P State4=P State3=P State2=P State1=0 State0=0 
;     250 PORTB=0x3C;
	LDI  R30,LOW(60)
	OUT  0x18,R30
;     251 DDRB=0x03;
	LDI  R30,LOW(3)
	OUT  0x17,R30
;     252 
;     253 // Port C initialization
;     254 // Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
;     255 // State6=T State5=0 State4=1 State3=P State2=P State1=P State0=T 
;     256 PORTC=0x1E;
	LDI  R30,LOW(30)
	OUT  0x15,R30
;     257 DDRC=0x30;
	LDI  R30,LOW(48)
	OUT  0x14,R30
;     258 
;     259 // Port D initialization
;     260 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     261 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     262 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     263 DDRD=0x00;
	OUT  0x11,R30
;     264 
;     265 // Timer/Counter 0 initialization
;     266 // Clock source: System Clock
;     267 // Clock value: 3,600 kHz
;     268 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     269 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     270 
;     271 // Timer/Counter 1 initialization
;     272 // Clock source: System Clock
;     273 // Clock value: 125,000 kHz
;     274 // Mode: Ph. correct PWM top=03FFh
;     275 // OC1A output: Non-Inv.
;     276 // OC1B output: Discon.
;     277 // Noise Canceler: Off
;     278 // Input Capture on Falling Edge
;     279 // Timer 1 Overflow Interrupt: Off
;     280 // Input Capture Interrupt: Off
;     281 // Compare A Match Interrupt: Off
;     282 // Compare B Match Interrupt: Off
;     283 TCCR1A=0x83;
	LDI  R30,LOW(131)
	OUT  0x2F,R30
;     284 TCCR1B=0x03;
	LDI  R30,LOW(3)
	OUT  0x2E,R30
;     285 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     286 TCNT1L=0x00;
	OUT  0x2C,R30
;     287 ICR1H=0x00;
	OUT  0x27,R30
;     288 ICR1L=0x00;
	OUT  0x26,R30
;     289 OCR1AH=0x00;
	OUT  0x2B,R30
;     290 OCR1AL=0x00;
	OUT  0x2A,R30
;     291 OCR1BH=0x00;
	OUT  0x29,R30
;     292 OCR1BL=0x00;
	OUT  0x28,R30
;     293 
;     294 // Timer/Counter 2 initialization
;     295 // Clock source: System Clock
;     296 // Clock value: Timer 2 Stopped
;     297 // Mode: Normal top=FFh
;     298 // OC2 output: Disconnected
;     299 ASSR=0x00;
	OUT  0x22,R30
;     300 TCCR2=0x00;
	OUT  0x25,R30
;     301 TCNT2=0x00;
	OUT  0x24,R30
;     302 OCR2=0x00;
	OUT  0x23,R30
;     303 
;     304 // External Interrupt(s) initialization
;     305 // INT0: Off
;     306 // INT1: Off
;     307 MCUCR=0x00;
	OUT  0x35,R30
;     308 
;     309 // Timer(s)/Counter(s) Interrupt(s) initialization
;     310 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     311 
;     312 // Analog Comparator initialization
;     313 // Analog Comparator: Off
;     314 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     315 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     316 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     317 
;     318 // ADC initialization
;     319 // ADC Clock frequency: 115,200 kHz
;     320 // ADC Voltage Reference: AREF pin
;     321 ADMUX=ADC_VREF_TYPE;
	OUT  0x7,R30
;     322 ADCSRA=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
;     323 
;     324 // LCD module initialization
;     325 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
;     326 
;     327 T_set[0] = T_prog[0];
	LDI  R26,LOW(_T_prog)
	LDI  R27,HIGH(_T_prog)
	RCALL __EEPROMRDW
	STS  _T_set,R30
	STS  _T_set+1,R31
;     328 T_set[1] = T_prog[1];
	__POINTW2MN _T_prog,2
	RCALL __EEPROMRDW
	__PUTW1MN _T_set,2
;     329 T_set[2] = T_prog[2];
	__POINTW2MN _T_prog,4
	RCALL __EEPROMRDW
	__PUTW1MN _T_set,4
;     330 
;     331 ee_tmprSet = T_set[0];
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x15
;     332 
;     333 // Global enable interrupts
;     334 #asm("sei")   
	sei
;     335 
;     336 }
	RET

_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G2:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x33
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0x34
_0x33:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
_0x34:
	ADIW R28,3
	RET
__ftoa_G2:
	SBIW R28,4
	RCALL __SAVELOCR2
	LDD  R26,Y+8
	CPI  R26,LOW(0x6)
	BRLO _0x35
	LDI  R30,LOW(5)
	STD  Y+8,R30
_0x35:
	LDD  R30,Y+8
	LDI  R26,LOW(__fround_G2*2)
	LDI  R27,HIGH(__fround_G2*2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETD1PF
	RCALL SUBOPT_0x21
	RCALL __ADDF12
	RCALL SUBOPT_0x22
	LDI  R16,LOW(0)
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
_0x36:
	RCALL SUBOPT_0x25
	RCALL __CMPF12
	BRLO _0x38
	RCALL SUBOPT_0x26
	RCALL __MULF12
	RCALL SUBOPT_0x24
	SUBI R16,-LOW(1)
	RJMP _0x36
_0x38:
	CPI  R16,0
	BRNE _0x39
	RCALL SUBOPT_0x27
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x3A
_0x39:
_0x3B:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x3D
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL __DIVF21
	RCALL __CFD1
	MOV  R17,R30
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x29
	__GETD2S 2
	RCALL SUBOPT_0x2A
	RCALL __MULF12
	RCALL SUBOPT_0x21
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x22
	RJMP _0x3B
_0x3D:
_0x3A:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x3E
	RCALL SUBOPT_0x2B
	RJMP _0xE8
_0x3E:
	RCALL SUBOPT_0x27
	LDI  R30,LOW(46)
	ST   X,R30
_0x3F:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x41
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x22
	__GETD1S 9
	RCALL __CFD1
	MOV  R17,R30
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x2A
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x22
	RJMP _0x3F
_0x41:
	RCALL SUBOPT_0x2B
_0xE8:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
__ftoe_G2:
	SBIW R28,4
	RCALL __SAVELOCR3
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2D
	LDD  R26,Y+10
	CPI  R26,LOW(0x6)
	BRLO _0x42
	LDI  R30,LOW(5)
	STD  Y+10,R30
_0x42:
	LDD  R16,Y+10
_0x43:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x45
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2D
	RJMP _0x43
_0x45:
	RCALL SUBOPT_0x2F
	RCALL __CPD10
	BRNE _0x46
	LDI  R18,LOW(0)
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2D
	RJMP _0x47
_0x46:
	LDD  R18,Y+10
	RCALL SUBOPT_0x30
	BREQ PC+2
	BRCC PC+2
	RJMP _0x48
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2D
_0x49:
	RCALL SUBOPT_0x30
	BRLO _0x4B
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	RJMP _0x49
_0x4B:
	RJMP _0x4C
_0x48:
_0x4D:
	RCALL SUBOPT_0x30
	BRSH _0x4F
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x33
	SUBI R18,LOW(1)
	RJMP _0x4D
_0x4F:
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2D
_0x4C:
	RCALL SUBOPT_0x2F
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x30
	BRLO _0x50
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
_0x50:
_0x47:
	LDI  R16,LOW(0)
_0x51:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x53
	RCALL SUBOPT_0x34
	__GETD1N 0x41200000
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2D
	__GETD1S 3
	RCALL SUBOPT_0x31
	RCALL __DIVF21
	RCALL __CFD1
	MOV  R17,R30
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x34
	RCALL __MULF12
	RCALL SUBOPT_0x31
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x33
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x51
	RCALL SUBOPT_0x35
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x51
_0x53:
	RCALL SUBOPT_0x36
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x55
	RCALL SUBOPT_0x35
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R18
_0x55:
	CPI  R18,10
	BRLT _0x56
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RCALL __DIVB21
	RCALL SUBOPT_0x38
_0x56:
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RCALL __MODB21
	RCALL SUBOPT_0x38
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL __LOADLOCR3
	ADIW R28,15
	RET
__print_G2:
	SBIW R28,28
	RCALL __SAVELOCR6
	LDI  R16,0
_0x57:
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	ADIW R30,1
	STD  Y+38,R30
	STD  Y+38+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x59
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x5D
	CPI  R19,37
	BRNE _0x5E
	LDI  R16,LOW(1)
	RJMP _0x5F
_0x5E:
	RCALL SUBOPT_0x39
_0x5F:
	RJMP _0x5C
_0x5D:
	CPI  R30,LOW(0x1)
	BRNE _0x60
	CPI  R19,37
	BRNE _0x61
	RCALL SUBOPT_0x39
	RJMP _0xE9
_0x61:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x62
	LDI  R17,LOW(1)
	RJMP _0x5C
_0x62:
	CPI  R19,43
	BRNE _0x63
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x5C
_0x63:
	CPI  R19,32
	BRNE _0x64
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x5C
_0x64:
	RJMP _0x65
_0x60:
	CPI  R30,LOW(0x2)
	BRNE _0x66
_0x65:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x67
	ORI  R17,LOW(128)
	RJMP _0x5C
_0x67:
	RJMP _0x68
_0x66:
	CPI  R30,LOW(0x3)
	BRNE _0x69
_0x68:
	CPI  R19,48
	BRLO _0x6B
	CPI  R19,58
	BRLO _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x5C
_0x6A:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x6D
	LDI  R16,LOW(4)
	RJMP _0x5C
_0x6D:
	RJMP _0x6E
_0x69:
	CPI  R30,LOW(0x4)
	BRNE _0x70
	CPI  R19,48
	BRLO _0x72
	CPI  R19,58
	BRLO _0x73
_0x72:
	RJMP _0x71
_0x73:
	ORI  R17,LOW(32)
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x5C
_0x71:
_0x6E:
	CPI  R19,108
	BRNE _0x74
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x5C
_0x74:
	RJMP _0x75
_0x70:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x5C
_0x75:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x7A
	RCALL SUBOPT_0x3A
	LD   R30,X
	RCALL SUBOPT_0x3B
	RJMP _0x7B
_0x7A:
	CPI  R30,LOW(0x45)
	BREQ _0x7E
	CPI  R30,LOW(0x65)
	BRNE _0x7F
_0x7E:
	RJMP _0x80
_0x7F:
	CPI  R30,LOW(0x66)
	BRNE _0x81
_0x80:
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3A
	RCALL __GETD1P
	RCALL SUBOPT_0x3D
	MOVW R26,R30
	MOVW R24,R22
	RCALL __CPD20
	BRLT _0x82
	LDD  R26,Y+17
	CPI  R26,LOW(0x2B)
	BREQ _0x84
	RJMP _0x85
_0x82:
	RCALL SUBOPT_0x3E
	RCALL __ANEGF1
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x84:
	SBRS R17,7
	RJMP _0x86
	LDD  R30,Y+17
	RCALL SUBOPT_0x3B
	RJMP _0x87
_0x86:
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	LDD  R26,Y+17
	STD  Z+0,R26
_0x87:
_0x85:
	SBRS R17,5
	LDI  R21,LOW(5)
	CPI  R19,102
	BRNE _0x89
	RCALL SUBOPT_0x3E
	RCALL __PUTPARD1
	ST   -Y,R21
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x1C
	RCALL __ftoa_G2
	RJMP _0x8A
_0x89:
	RCALL SUBOPT_0x3E
	RCALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RCALL SUBOPT_0x1C
	RCALL __ftoe_G2
_0x8A:
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x41
	RJMP _0x8B
_0x81:
	CPI  R30,LOW(0x73)
	BRNE _0x8D
	RCALL SUBOPT_0x3A
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RCALL SUBOPT_0x41
	RJMP _0x8E
_0x8D:
	CPI  R30,LOW(0x70)
	BRNE _0x90
	RCALL SUBOPT_0x3A
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x1C
	RCALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x8E:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x92
	CP   R21,R16
	BRLO _0x93
_0x92:
	RJMP _0x91
_0x93:
	MOV  R16,R21
_0x91:
_0x8B:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x94
_0x90:
	CPI  R30,LOW(0x64)
	BREQ _0x97
	CPI  R30,LOW(0x69)
	BRNE _0x98
_0x97:
	ORI  R17,LOW(4)
	RJMP _0x99
_0x98:
	CPI  R30,LOW(0x75)
	BRNE _0x9A
_0x99:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x9B
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x42
	LDI  R16,LOW(10)
	RJMP _0x9C
_0x9B:
	__GETD1N 0x2710
	RCALL SUBOPT_0x42
	LDI  R16,LOW(5)
	RJMP _0x9C
_0x9A:
	CPI  R30,LOW(0x58)
	BRNE _0x9E
	ORI  R17,LOW(8)
	RJMP _0x9F
_0x9E:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0xDD
_0x9F:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0xA1
	__GETD1N 0x10000000
	RCALL SUBOPT_0x42
	LDI  R16,LOW(8)
	RJMP _0x9C
_0xA1:
	__GETD1N 0x1000
	RCALL SUBOPT_0x42
	LDI  R16,LOW(4)
_0x9C:
	CPI  R21,0
	BREQ _0xA2
	ANDI R17,LOW(127)
	RJMP _0xA3
_0xA2:
	LDI  R21,LOW(1)
_0xA3:
	SBRS R17,1
	RJMP _0xA4
	RCALL SUBOPT_0x3A
	RCALL __GETD1P
	RJMP _0xEA
_0xA4:
	SBRS R17,2
	RJMP _0xA6
	RCALL SUBOPT_0x3A
	RCALL __GETW1P
	RCALL __CWD1
	RJMP _0xEA
_0xA6:
	RCALL SUBOPT_0x3A
	RCALL __GETW1P
	CLR  R22
	CLR  R23
_0xEA:
	__PUTD1S 6
	SBRS R17,2
	RJMP _0xA8
	RCALL SUBOPT_0x43
	RCALL __CPD20
	BRGE _0xA9
	RCALL SUBOPT_0x3E
	RCALL __ANEGD1
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0xA9:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0xAA
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0xAB
_0xAA:
	ANDI R17,LOW(251)
_0xAB:
_0xA8:
	MOV  R18,R21
_0x94:
	SBRC R17,0
	RJMP _0xAC
_0xAD:
	CP   R16,R20
	BRSH _0xB0
	CP   R18,R20
	BRLO _0xB1
_0xB0:
	RJMP _0xAF
_0xB1:
	SBRS R17,7
	RJMP _0xB2
	SBRS R17,2
	RJMP _0xB3
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0xB4
_0xB3:
	LDI  R19,LOW(48)
_0xB4:
	RJMP _0xB5
_0xB2:
	LDI  R19,LOW(32)
_0xB5:
	RCALL SUBOPT_0x39
	SUBI R20,LOW(1)
	RJMP _0xAD
_0xAF:
_0xAC:
_0xB6:
	CP   R16,R21
	BRSH _0xB8
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0xB9
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	RCALL SUBOPT_0x3B
	CPI  R20,0
	BREQ _0xBA
	SUBI R20,LOW(1)
_0xBA:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0xB9:
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x3B
	CPI  R20,0
	BREQ _0xBB
	SUBI R20,LOW(1)
_0xBB:
	SUBI R21,LOW(1)
	RJMP _0xB6
_0xB8:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xBC
_0xBD:
	CPI  R18,0
	BREQ _0xBF
	SBRS R17,3
	RJMP _0xC0
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	LPM  R30,Z
	RJMP _0xEB
_0xC0:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0xEB:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	RCALL SUBOPT_0x1C
	RCALL __put_G2
	CPI  R20,0
	BREQ _0xC2
	SUBI R20,LOW(1)
_0xC2:
	SUBI R18,LOW(1)
	RJMP _0xBD
_0xBF:
	RJMP _0xC3
_0xBC:
_0xC5:
	RCALL SUBOPT_0x44
	RCALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0xC7
	SBRS R17,3
	RJMP _0xC8
	SUBI R19,-LOW(55)
	RJMP _0xC9
_0xC8:
	SUBI R19,-LOW(87)
_0xC9:
	RJMP _0xCA
_0xC7:
	SUBI R19,-LOW(48)
_0xCA:
	SBRC R17,4
	RJMP _0xCC
	CPI  R19,49
	BRSH _0xCE
	RCALL SUBOPT_0x45
	__CPD2N 0x1
	BRNE _0xCD
_0xCE:
	RJMP _0xD0
_0xCD:
	CP   R21,R18
	BRLO _0xD1
	RJMP _0xEC
_0xD1:
	CP   R20,R18
	BRLO _0xD3
	SBRS R17,0
	RJMP _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0xD5
_0xEC:
	LDI  R19,LOW(48)
_0xD0:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0xD6
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	RCALL SUBOPT_0x3B
	CPI  R20,0
	BREQ _0xD7
	SUBI R20,LOW(1)
_0xD7:
_0xD6:
_0xD5:
_0xCC:
	RCALL SUBOPT_0x39
	CPI  R20,0
	BREQ _0xD8
	SUBI R20,LOW(1)
_0xD8:
_0xD2:
	SUBI R18,LOW(1)
	RCALL SUBOPT_0x44
	RCALL __MODD21U
	RCALL SUBOPT_0x3D
	LDD  R30,Y+16
	RCALL SUBOPT_0x45
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x42
	__GETD1S 12
	RCALL __CPD10
	BREQ _0xC6
	RJMP _0xC5
_0xC6:
_0xC3:
	SBRS R17,0
	RJMP _0xD9
_0xDA:
	CPI  R20,0
	BREQ _0xDC
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x3B
	RJMP _0xDA
_0xDC:
_0xD9:
_0xDD:
_0x7B:
_0xE9:
	LDI  R16,LOW(0)
_0x5C:
	RJMP _0x57
_0x59:
	RCALL __LOADLOCR6
	ADIW R28,40
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	RCALL __SAVELOCR2
	MOVW R26,R28
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	RCALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x1C
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x1C
	RCALL __print_G2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL __LOADLOCR2
	ADIW R28,4
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G4:
	.BYTE 0x4

	.CSEG
__lcd_delay_G4:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G4
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G4
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G4
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G4
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G4:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G4
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G4
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G4
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G4
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G4:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G4
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G4
    andi  r30,0xf0
	RET
_lcd_read_byte0_G4:
	RCALL __lcd_delay_G4
	RCALL __lcd_read_nibble_G4
    mov   r26,r30
	RCALL __lcd_read_nibble_G4
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G4)
	SBCI R31,HIGH(-__base_y_G4)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x46
	LDD  R10,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x46
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x46
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x46
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R10,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R10
	CP   R12,R10
	BRSH _0xDF
	__lcd_putchar1:
	INC  R11
	RCALL SUBOPT_0x20
	ST   -Y,R11
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0xDF:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_puts:
	ST   -Y,R16
_0xE0:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R16,R30
	CPI  R30,0
	BREQ _0xE2
	ST   -Y,R16
	RCALL _lcd_putchar
	RJMP _0xE0
_0xE2:
	LDD  R16,Y+0
	ADIW R28,3
	RET
__long_delay_G4:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G4:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G4
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G4,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G4,3
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x47
	RCALL __long_delay_G4
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G4
	RCALL __long_delay_G4
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x46
	RCALL __long_delay_G4
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x46
	RCALL __long_delay_G4
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x46
	RCALL __long_delay_G4
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G4
	CPI  R30,LOW(0x5)
	BREQ _0xE6
	LDI  R30,LOW(0)
	RJMP _0xE7
_0xE6:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x46
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0xE7:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	STS  _adc_data,R30
	STS  _adc_data+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R30,_ReadKey
	LDS  R31,_ReadKey+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R30,_KeyDelay
	LDS  R31,_KeyDelay+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3:
	STS  _ReadKey,R30
	STS  _ReadKey+1,R31
	RJMP _my_beep

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	STS  _KeyDelay,R30
	STS  _KeyDelay+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	RCALL SUBOPT_0x0
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	SUB  R30,R26
	SBC  R31,R27
	LSR  R31
	ROR  R30
	STS  _T_now,R30
	STS  _T_now+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDS  R30,_T_now
	LDS  R31,_T_now+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	STS  _T_prev,R30
	STS  _T_prev+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDS  R30,_T_prev
	LDS  R31,_T_prev+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R26,_T_now
	LDS  R27,_T_now+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	STS  _T,R30
	STS  _T+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDS  R26,_T
	LDS  R27,_T+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	LDS  R30,_ee_tmprSet
	LDS  R31,_ee_tmprSet+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	STS  _pwm_val,R30
	STS  _pwm_val+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R26,_pwm_val
	LDS  R27,_pwm_val+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	LDS  R26,_ReadKey
	LDS  R27,_ReadKey+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x10:
	LDS  R26,_Mode
	LDS  R27,_Mode+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x11:
	LDS  R30,_Mode
	LDS  R31,_Mode+1
	SBIW R30,1
	LDI  R26,LOW(_T_set)
	LDI  R27,HIGH(_T_set)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	STS  _ee_tmprSet,R30
	STS  _ee_tmprSet+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x16:
	LDI  R30,0
	STS  _ReadKey,R30
	STS  _ReadKey+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDS  R30,_Mode
	LDS  R31,_Mode+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDS  R30,_T_set
	LDS  R31,_T_set+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__GETW1MN _T_set,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETW1MN _T_set,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(_lcd_buffer1)
	LDI  R31,HIGH(_lcd_buffer1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1C:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(_lcd_buffer2)
	LDI  R31,HIGH(_lcd_buffer2)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	STS  _program,R30
	STS  _program+1,R31
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	__GETD1S 2
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD2S 2
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x27:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	RCALL __DIVF21
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RCALL __PUTPARD1
	RJMP _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2C:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2D:
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	__GETD2S 3
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	__GETD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x30:
	__GETD1S 3
	__GETD2S 11
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x31:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	__GETD1N 0x41200000
	RCALL __DIVF21
	__PUTD1S 11
	SUBI R18,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD2S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x35:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x39:
	ST   -Y,R19
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	RCALL SUBOPT_0x1C
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	SBIW R26,4
	STD  Y+36,R26
	STD  Y+36+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3B:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	RCALL SUBOPT_0x1C
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	MOVW R30,R28
	ADIW R30,18
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x1C
	RCALL _strlen
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x42:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x44:
	__GETD1S 12
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x47:
	RCALL __long_delay_G4
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G4

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x733
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R19
	CLR  R20
	LDI  R21,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R19
	ROL  R20
	SUB  R0,R30
	SBC  R1,R31
	SBC  R19,R22
	SBC  R20,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R19,R22
	ADC  R20,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R21
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOV  R24,R19
	MOV  R25,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __MAXRES
	RJMP __MINRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	LSR  R22
	ROR  R31
	ROR  R30
	LSR  R24
	ROR  R27
	ROR  R26
	PUSH R20
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R25,24
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R1
	ROL  R20
	ROL  R21
	ROL  R26
	ROL  R27
	ROL  R24
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R1
	MOV  R31,R20
	MOV  R22,R21
	LSR  R26
	ADC  R30,R25
	ADC  R31,R25
	ADC  R22,R25
	POP  R20
	TST  R22
	BRMI __DIVF215
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
