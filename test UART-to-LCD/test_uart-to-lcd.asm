
;CodeVisionAVR C Compiler V1.25.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
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
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
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

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
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

	.INCLUDE "test_uart-to-lcd.vec"
	.INCLUDE "test_uart-to-lcd.inc"

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
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
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
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xE0)
	LDI  R29,HIGH(0xE0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0
;       1 /*****************************************************
;       2 CodeWizardAVR V2.05.0 Professional
;       3 Project : Koptilnya
;       4 Version : 1
;       5 Date    : 14.07.2011
;       6 
;       7 Chip type               : ATmega8535
;       8 AVR Core Clock frequency: 7,813000 MHz
;       9 *****************************************************/
;      10 // Standard Input/Output functions
;      11 #include <mega8535.h>
;      12 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      13 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      14 	.EQU __se_bit=0x40
	.EQU __se_bit=0x40
;      15 	.EQU __sm_mask=0xB0
	.EQU __sm_mask=0xB0
;      16 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      17 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      18 	.EQU __sm_standby=0xA0
	.EQU __sm_standby=0xA0
;      19 	.EQU __sm_ext_standby=0xB0
	.EQU __sm_ext_standby=0xB0
;      20 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      21 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      22 	#endif
	#endif
;      23 #include <stdio.h>
;      24 #include <delay.h>
;      25 
;      26 // Alphanumeric LCD Module functions
;      27 //Инициализация экрана
;      28 #asm
;      29   .equ __lcd_port=0x18 ;PORTB
  .equ __lcd_port=0x18 ;PORTB
;      30 #endasm
;      31 #include <lcd.h>
;      32 
;      33 //=================================
;      34 #ifndef RXB8
;      35 #define RXB8 1
;      36 #endif
;      37 
;      38 #ifndef TXB8
;      39 #define TXB8 0
;      40 #endif
;      41 
;      42 #ifndef UPE
;      43 #define UPE 2
;      44 #endif
;      45 
;      46 #ifndef DOR
;      47 #define DOR 3
;      48 #endif
;      49 
;      50 #ifndef FE
;      51 #define FE 4
;      52 #endif
;      53 
;      54 #ifndef UDRE
;      55 #define UDRE 5
;      56 #endif
;      57 
;      58 #ifndef RXC
;      59 #define RXC 7
;      60 #endif
;      61 
;      62 #define FRAMING_ERROR       (1<<FE)
;      63 #define PARITY_ERROR        (1<<UPE)
;      64 #define DATA_OVERRUN        (1<<DOR)
;      65 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      66 #define RX_COMPLETE         (1<<RXC)
;      67 
;      68 // USART Receiver buffer
;      69 #define RX_BUFFER_SIZE 8
;      70 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      71 
;      72 unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      73 
;      74 // This flag is set on USART Receiver buffer overflow
;      75 bit rx_buffer_overflow;
;      76 
;      77 //===================================================================
;      78 // USART Receiver interrupt service routine
;      79 interrupt [USART_RXC] void usart_rx_isr(void)
;      80 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      81 char status,data;
;      82 
;      83 #asm("cli")
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	cli
;      84 
;      85 status=UCSRA;
	IN   R17,11
;      86 data=UDR;
	IN   R16,12
;      87 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;      88     {
;      89         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;      90 
;      91         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;      92         if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
;      93         {
;      94             rx_counter=0;
	CLR  R7
;      95             rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      96         }
;      97     }
_0x5:
;      98 #asm("sei")
_0x3:
	sei
;      99 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     100 
;     101 #ifndef _DEBUG_TERMINAL_IO_
;     102 // Get a character from the USART Receiver buffer
;     103 #define _ALTERNATE_GETCHAR_
;     104 
;     105 #pragma used+
;     106 
;     107 char getchar(void)
;     108 {
;     109     char data;
;     110     while (rx_counter==0);
;	data -> R17
;     111     data=rx_buffer[rx_rd_index++];
;     112 
;     113     #asm("cli")
;     114     --rx_counter;
;     115     #asm("sei")
;     116     return data;
;     117 }
;     118 
;     119 #pragma used-
;     120 #endif
;     121 
;     122 //порты обозначения кнопок
;     123 #define kn_vverh            PINC.0
;     124 #define kn_vniz             PINC.1
;     125 #define kn_vpravo           PINC.2
;     126 #define kn_vlevo            PINC.3
;     127 #define kn_ENTER            PINC.4
;     128 #define kn_ESC              PINC.5
;     129 //==========================================================================
;     130 // Глобальные переменные
;     131 //volatile unsigned char t_max_razogrev     = 115;    // максимальная температура разогрева, в градусах Цельсия
;     132 //volatile unsigned char t_max_rabochee     = 75;     // максимальная температура работы, в градусах Цельсия
;     133 //volatile unsigned char t_min_razogrev     = 105;    // минимальная  температура разогрева, в градусах Цельсия
;     134 //volatile unsigned char t_min_rabochee     = 65;     // минимальная температура работы, в градусах Цельсия
;     135 
;     136 volatile unsigned char real_temp;                   // текущая температура

	.DSEG
_real_temp:
	.BYTE 0x1
;     137 
;     138 //volatile unsigned char time_rabota_ch     = 4;      // время работы, измеряется в часах
;     139 //volatile unsigned char time_rabota_min    = 30;     // время работы, измеряется в минутах
;     140 //volatile unsigned char time_smoke_ch      = 0;      // время работы вытяжки, задается в часах
;     141 //volatile unsigned char time_smoke_min     = 10;     // время работы вытяжки, задается в минутах
;     142 
;     143 volatile unsigned char real_time_ch       = 0;      // текущее время работы в часах
_real_time_ch:
	.BYTE 0x1
;     144 volatile unsigned char real_time_min      = 0;      // текущее время работы в минутах
_real_time_min:
	.BYTE 0x1
;     145 volatile unsigned char real_time_sek      = 0;      // текущее время работы в минутах
_real_time_sek:
	.BYTE 0x1
;     146 
;     147 \\volatile unsigned char regim_rabot        = 1;      // состояние режим работы
;     148 \\volatile unsigned char regim_rabot_work   = 1;      // предыдущее состояние режима работы
;     149 
;     150 //unsigned char time_migat                = 100;    // время мигания при выборе значения, задается в мс.
;     151 //unsigned char zadergka_pri_nagatii        = 100;    // задержка при нажатии кнопки
;     152 //unsigned char zadergka_zastavka           = 200;    // время показа заставки
;     153 
;     154 volatile char lcd_str_1[16];
_lcd_str_1:
	.BYTE 0x10
;     155 volatile char lcd_str_2[16];
_lcd_str_2:
	.BYTE 0x10
;     156 
;     157 //=============================================================================
;     158 // Объявление без задания функций. (для обеспечения компиляции)
;     159 \\void video(void);
;     160 
;     161 \\unsigned char read_temp();
;     162 
;     163 //=============================================================================
;     164 // прерывание ежесекундного (или 0,2 секундного таймера)
;     165 interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;     166 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     167     #asm("cli")
	cli
;     168 
;     169     TCNT1H=0;
	RCALL SUBOPT_0x1
;     170     TCNT1L=0;
;     171 
;     172     real_time_sek++;
	LDS  R30,_real_time_sek
	SUBI R30,-LOW(1)
	STS  _real_time_sek,R30
;     173   	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	LDS  R26,_real_time_sek
	CPI  R26,LOW(0x3C)
	BRNE _0x9
	LDS  R30,_real_time_min
	SUBI R30,-LOW(1)
	STS  _real_time_min,R30
	LDI  R30,LOW(0)
	STS  _real_time_sek,R30
;     174 	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
_0x9:
	LDS  R26,_real_time_min
	CPI  R26,LOW(0x3C)
	BRNE _0xA
	LDS  R30,_real_time_ch
	SUBI R30,-LOW(1)
	STS  _real_time_ch,R30
	LDI  R30,LOW(0)
	STS  _real_time_min,R30
;     175 	if (real_time_ch  == 24) real_time_ch=0;
_0xA:
	LDS  R26,_real_time_ch
	CPI  R26,LOW(0x18)
	BRNE _0xB
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
;     176 
;     177     #asm("sei")
_0xB:
	sei
;     178 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     179 
;     180 //=================================================
;     181 /*
;     182 unsigned char read_temp()
;     183 {
;     184     unsigned char n,t;
;     185 
;     186     for (n=0; n<5 ; n++)
;     187     {
;     188         if (getchar()=='#')
;     189         {
;     190 
;     191             t=0;
;     192 
;     193             t = getchar()*100;
;     194             t = real_temp + getchar()*10;
;     195             t = real_temp + getchar();
;     196 
;     197             return t;
;     198 
;     199         };
;     200     };
;     201     return 0;
;     202 }
;     203 */
;     204 
;     205 void main(void)
;     206 {
_main:
;     207 //=================================================
;     208 // Input/Output Ports initialization
;     209 // Port A initialization
;     210     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     211     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
;     212 // Port B initialization
;     213     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     214     DDRB=0x00;
	OUT  0x17,R30
;     215 // Инициализация порта клавиатуры.
;     216 // Port C initialization
;     217     PORTC=0xFF;         // вкл. подтягивающие резисторы
	LDI  R30,LOW(255)
	OUT  0x15,R30
;     218     DDRC=0x00;          // весь порт как вход
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     219 
;     220 // Timer/Counter 1 initialization
;     221 // Clock source: System Clock
;     222 // Clock value: 7,813 kHz
;     223 // Mode: Normal top=FFFFh
;     224 // OC1A output: Discon.
;     225 // OC1B output: Discon.
;     226 // Noise Canceler: Off
;     227 // Input Capture on Falling Edge
;     228 // Timer 1 Overflow Interrupt: Off
;     229 // Input Capture Interrupt: Off
;     230 // Compare A Match Interrupt: On
;     231 // Compare B Match Interrupt: Off
;     232     TCCR1A=0x00;
	OUT  0x2F,R30
;     233     TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     234     TCNT1H=0x00;
	RCALL SUBOPT_0x1
;     235     TCNT1L=0x00;
;     236     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
;     237     ICR1L=0x00;
	OUT  0x26,R30
;     238     OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
;     239     OCR1AL=0x85;
	LDI  R30,LOW(133)
	OUT  0x2A,R30
;     240     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;     241     OCR1BL=0x00;
	OUT  0x28,R30
;     242 
;     243 // Timer(s)/Counter(s) Interrupt(s) initialization
;     244     TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
;     245 
;     246 //=================================================
;     247 // USART initialization
;     248 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     249 // USART Receiver: On
;     250 // USART Transmitter: On
;     251 // USART Mode: Asynchronous
;     252 // USART Baud Rate: 38400
;     253     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     254     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     255     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     256     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     257     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     258 
;     259 //=================================================
;     260 // LCD module initialization
;     261     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
;     262 
;     263 //=================================================
;     264 
;     265 // Разрешение прерываний
;     266     #asm("sei")
	sei
;     267 // Вечный цикл
;     268     while(1)
_0xC:
;     269     {
;     270 
;     271         //read_temp();
;     272 //        if (getchar()=='#') real_temp = getchar()*100;
;     273 
;     274 //        real_temp = real_temp + getchar()*10;
;     275 //        real_temp = getchar();
;     276 
;     277         real_temp++;
	LDS  R30,_real_temp
	SUBI R30,-LOW(1)
	STS  _real_temp,R30
;     278 
;     279         delay_ms(5);
	RCALL SUBOPT_0x2
;     280 
;     281 //===============================================================
;     282         sprintf(lcd_str_1,"RAZOGREV");
	RCALL SUBOPT_0x3
	__POINTW1FN _0,0
	RCALL SUBOPT_0x4
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
;     283 
;     284             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     285             (real_time_ch/10)%10	+0x30,
;     286             real_time_ch%10		    +0x30,
;     287             (real_time_min/10)%10	+0x30,
;     288             real_time_min%10		+0x30,
;     289             (real_time_sek/10)%10	+0x30,
;     290             real_time_sek%10		+0x30,
;     291 
;     292             (real_temp/100)%10	    +0x30,
;     293             (real_temp/10)%10	    +0x30,
;     294             real_temp%10	    +0x30
;     295 //            getchar()		    +0x30
;     296             );
	LDI  R30,LOW(_lcd_str_2)
	LDI  R31,HIGH(_lcd_str_2)
	RCALL SUBOPT_0x4
	__POINTW1FN _0,9
	RCALL SUBOPT_0x4
	LDS  R26,_real_time_ch
	RCALL SUBOPT_0x5
	LDS  R26,_real_time_ch
	RCALL SUBOPT_0x6
	LDS  R26,_real_time_min
	RCALL SUBOPT_0x5
	LDS  R26,_real_time_min
	RCALL SUBOPT_0x6
	LDS  R26,_real_time_sek
	RCALL SUBOPT_0x5
	LDS  R26,_real_time_sek
	RCALL SUBOPT_0x6
	LDS  R26,_real_temp
	LDI  R30,LOW(100)
	RCALL __DIVB21U
	MOV  R26,R30
	RCALL SUBOPT_0x6
	LDS  R26,_real_temp
	RCALL SUBOPT_0x5
	LDS  R26,_real_temp
	RCALL SUBOPT_0x6
	LDI  R24,36
	RCALL _sprintf
	ADIW R28,40
;     297 
;     298 
;     299 //========================================================
;     300     lcd_clear();          	// очистка ЛСД
	RCALL _lcd_clear
;     301 
;     302     lcd_gotoxy(0,0);      	// установка курсора на 0,0
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL _lcd_gotoxy
;     303     lcd_puts(lcd_str_1);
	RCALL SUBOPT_0x3
	RCALL _lcd_puts
;     304 
;     305     lcd_gotoxy(0,1);      	// установка курсора на начало второй строки
	RCALL SUBOPT_0x7
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;     306     lcd_puts(lcd_str_2);
	LDI  R30,LOW(_lcd_str_2)
	LDI  R31,HIGH(_lcd_str_2)
	RCALL SUBOPT_0x4
	RCALL _lcd_puts
;     307 
;     308     delay_ms(5);
	RCALL SUBOPT_0x2
;     309 
;     310     }
	RJMP _0xC
;     311 }
_0xF:
	RJMP _0xF
;     312 

	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G2:
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x1D
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x1F
	__CPWRN 16,17,2
	BRLO _0x20
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x1F:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x20:
	RJMP _0x21
_0x1D:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x21:
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
_0x22:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x24
	MOV  R30,R17
	RCALL SUBOPT_0x0
	SBIW R30,0
	BRNE _0x28
	CPI  R18,37
	BRNE _0x29
	LDI  R17,LOW(1)
	RJMP _0x2A
_0x29:
	RCALL SUBOPT_0x8
_0x2A:
	RJMP _0x27
_0x28:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
	CPI  R18,37
	BRNE _0x2C
	RCALL SUBOPT_0x8
	RJMP _0xD8
_0x2C:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2D
	LDI  R16,LOW(1)
	RJMP _0x27
_0x2D:
	CPI  R18,43
	BRNE _0x2E
	LDI  R20,LOW(43)
	RJMP _0x27
_0x2E:
	CPI  R18,32
	BRNE _0x2F
	LDI  R20,LOW(32)
	RJMP _0x27
_0x2F:
	RJMP _0x30
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x31
_0x30:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x32
	ORI  R16,LOW(128)
	RJMP _0x27
_0x32:
	RJMP _0x33
_0x31:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x27
_0x33:
	CPI  R18,48
	BRLO _0x36
	CPI  R18,58
	BRLO _0x37
_0x36:
	RJMP _0x35
_0x37:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	RCALL SUBOPT_0x0
	ADD  R21,R30
	RJMP _0x27
_0x35:
	MOV  R30,R18
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x3B
	RCALL SUBOPT_0x9
	LD   R30,X
	RCALL SUBOPT_0xA
	RJMP _0x3C
_0x3B:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x3E
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xB
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x3F
_0x3E:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x41
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xB
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x3F:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x42
_0x41:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x45
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x46
_0x45:
	ORI  R16,LOW(4)
	RJMP _0x47
_0x46:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x48
_0x47:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	RCALL SUBOPT_0xC
	LDI  R17,LOW(5)
	RJMP _0x49
_0x48:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x4B
	ORI  R16,LOW(8)
	RJMP _0x4C
_0x4B:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x7D
_0x4C:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	RCALL SUBOPT_0xC
	LDI  R17,LOW(4)
_0x49:
	SBRS R16,2
	RJMP _0x4E
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	RCALL SUBOPT_0xD
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x4F
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0xD
	LDI  R20,LOW(45)
_0x4F:
	CPI  R20,0
	BREQ _0x50
	SUBI R17,-LOW(1)
	RJMP _0x51
_0x50:
	ANDI R16,LOW(251)
_0x51:
	RJMP _0x52
_0x4E:
	RCALL SUBOPT_0x9
	RCALL __GETW1P
	RCALL SUBOPT_0xD
_0x52:
_0x42:
	SBRC R16,0
	RJMP _0x53
_0x54:
	CP   R17,R21
	BRSH _0x56
	SBRS R16,7
	RJMP _0x57
	SBRS R16,2
	RJMP _0x58
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x59
_0x58:
	LDI  R18,LOW(48)
_0x59:
	RJMP _0x5A
_0x57:
	LDI  R18,LOW(32)
_0x5A:
	RCALL SUBOPT_0x8
	SUBI R21,LOW(1)
	RJMP _0x54
_0x56:
_0x53:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x5B
_0x5C:
	CPI  R19,0
	BREQ _0x5E
	SBRS R16,3
	RJMP _0x5F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	RCALL SUBOPT_0xC
	SBIW R30,1
	LPM  R30,Z
	RJMP _0xD9
_0x5F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0xD9:
	ST   -Y,R30
	RCALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x61
	SUBI R21,LOW(1)
_0x61:
	SUBI R19,LOW(1)
	RJMP _0x5C
_0x5E:
	RJMP _0x62
_0x5B:
_0x64:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0xC
	SBIW R30,2
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x66:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x68
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0xD
	RJMP _0x66
_0x68:
	CPI  R18,58
	BRLO _0x69
	SBRS R16,3
	RJMP _0x6A
	SUBI R18,-LOW(7)
	RJMP _0x6B
_0x6A:
	SUBI R18,-LOW(39)
_0x6B:
_0x69:
	SBRC R16,4
	RJMP _0x6D
	CPI  R18,49
	BRSH _0x6F
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x6E
_0x6F:
	RJMP _0xDA
_0x6E:
	CP   R21,R19
	BRLO _0x73
	SBRS R16,0
	RJMP _0x74
_0x73:
	RJMP _0x72
_0x74:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x75
	LDI  R18,LOW(48)
_0xDA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x76
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x77
	SUBI R21,LOW(1)
_0x77:
_0x76:
_0x75:
_0x6D:
	RCALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x78
	SUBI R21,LOW(1)
_0x78:
_0x72:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x65
	RJMP _0x64
_0x65:
_0x62:
	SBRS R16,0
	RJMP _0x79
_0x7A:
	CPI  R21,0
	BREQ _0x7C
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xA
	RJMP _0x7A
_0x7C:
_0x79:
_0x7D:
_0x3C:
_0xD8:
	LDI  R17,LOW(0)
_0x27:
	RJMP _0x22
_0x24:
	RCALL __LOADLOCR6
	ADIW R28,20
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
	RCALL SUBOPT_0x4
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x4
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
__base_y_G3:
	.BYTE 0x4

	.CSEG
__lcd_delay_G3:
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
	RCALL __lcd_delay_G3
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G3
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G3
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G3
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G3:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G3
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G3
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G3
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G3
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G3:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G3
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G3
    andi  r30,0xf0
	RET
_lcd_read_byte0_G3:
	RCALL __lcd_delay_G3
	RCALL __lcd_read_nibble_G3
    mov   r26,r30
	RCALL __lcd_read_nibble_G3
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G3)
	SBCI R31,HIGH(-__base_y_G3)
	LD   R30,Z
	MOV  R26,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x0
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0xF
	LDD  R6,Y+1
	LDD  R9,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xF
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xF
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xF
	LDI  R30,LOW(0)
	MOV  R9,R30
	MOV  R6,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R6
	CP   R8,R6
	BRSH _0xCA
	__lcd_putchar1:
	INC  R9
	RCALL SUBOPT_0x7
	ST   -Y,R9
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0xCA:
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
	ST   -Y,R17
_0xCB:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0xCD
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0xCB
_0xCD:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G3:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G3:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G3
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R8,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G3,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G3,3
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	RCALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G3
	RCALL __long_delay_G3
	LDI  R30,LOW(40)
	RCALL SUBOPT_0xF
	RCALL __long_delay_G3
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xF
	RCALL __long_delay_G3
	LDI  R30,LOW(133)
	RCALL SUBOPT_0xF
	RCALL __long_delay_G3
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0xD1
	LDI  R30,LOW(0)
	RJMP _0xD7
_0xD1:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xF
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0xD7:
	ADIW R28,1
	RET
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_p_S56:
	.BYTE 0x2

	.CSEG

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(_lcd_str_1)
	LDI  R31,HIGH(_lcd_str_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	RCALL __DIVB21U
	MOV  R26,R30
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x8:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x4
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x4
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x4
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	RCALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G3

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
