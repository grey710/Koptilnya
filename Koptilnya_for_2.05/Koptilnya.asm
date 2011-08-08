
;CodeVisionAVR C Compiler V1.25.7 beta 5 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 7,813000 MHz
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

	.INCLUDE "Koptilnya.vec"
	.INCLUDE "Koptilnya.inc"

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
;      32 //#include "lcd_rus\lcd_rus.h"
;      33 //Компилировать в версии 1.25
;      34 #pragma rl+
;      35 //=================================
;      36 #ifndef RXB8
;      37 #define RXB8 1
;      38 #endif
;      39 
;      40 #ifndef TXB8
;      41 #define TXB8 0
;      42 #endif
;      43 
;      44 #ifndef UPE
;      45 #define UPE 2
;      46 #endif
;      47 
;      48 #ifndef DOR
;      49 #define DOR 3
;      50 #endif
;      51 
;      52 #ifndef FE
;      53 #define FE 4
;      54 #endif
;      55 
;      56 #ifndef UDRE
;      57 #define UDRE 5
;      58 #endif
;      59 
;      60 #ifndef RXC
;      61 #define RXC 7
;      62 #endif
;      63 
;      64 #define FRAMING_ERROR       (1<<FE)
;      65 #define PARITY_ERROR        (1<<UPE)
;      66 #define DATA_OVERRUN        (1<<DOR)
;      67 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      68 #define RX_COMPLETE         (1<<RXC)
;      69 
;      70 #define _DEBUG_TERMINAL_IO_
;      71 
;      72 // USART Receiver buffer
;      73 #define RX_BUFFER_SIZE 8
;      74 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      75 
;      76 //unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      77 unsigned char rx_wr_index,rx_counter;
;      78 
;      79 // This flag is set on USART Receiver buffer overflow
;      80 bit rx_buffer_overflow;
;      81 
;      82 //===================================================================
;      83 // USART Receiver interrupt service routine
;      84 interrupt [USART_RXC] void usart_rx_isr(void)
;      85 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      86 char status,data;
;      87 
;      88 #asm("cli")
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	cli
;      89 
;      90 status=UCSRA;
	IN   R17,11
;      91 data=UDR;
	IN   R16,12
;      92 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x3
;      93     {
;      94         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;      95 
;      96         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x4
	CLR  R5
;      97         if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x5
;      98         {
;      99             rx_counter=0;
	CLR  R4
;     100             rx_buffer_overflow=1;
	SET
	BLD  R2,0
;     101         }
;     102     }
_0x5:
;     103 #asm("sei")
_0x3:
	sei
;     104 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     105 
;     106 #ifndef _DEBUG_TERMINAL_IO_
;     107 // Get a character from the USART Receiver buffer
;     108 #define _ALTERNATE_GETCHAR_
;     109 
;     110 #pragma used+
;     111 
;     112 char getchar(void)
;     113 {
;     114     char data;
;     115     while (rx_counter==0);
;     116     data=rx_buffer[rx_rd_index++];
;     117 
;     118     #asm("cli")
;     119     --rx_counter;
;     120     #asm("sei")
;     121     return data;
;     122 }
;     123 
;     124 #pragma used-
;     125 #endif
;     126 
;     127 //=============================================================================
;     128 // управление в режимах
;     129 //порты подключения управляющих реле
;     130 #define blok_lamp_1_ON         PORTA.0 = 1    //Включатель/выключатель первого блока ламп
;     131 #define blok_lamp_2_ON         PORTA.1 = 1    //Включатель/выключатель второго блока ламп
;     132 #define blok_lamp_3_ON         PORTA.2 = 1    //Включатель/выключатель третьего блока ламп
;     133 #define blok_lamp_en_ON        PORTA.3 = 1    //Включатель блока ламп
;     134 #define blok_lamp_dis_ON       PORTA.4 = 1    //Выключатель блока ламп
;     135 #define blok_silovoy_en_ON     PORTA.5 = 1    //Включатель блока электромагнит, дымогенератор, высокое напряжение
;     136 #define blok_silovoy_dis_ON    PORTA.6 = 1    //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;     137 #define blok_rezerv_ON         PORTA.7 = 1    //резерв
;     138 
;     139 #define blok_lamp_1_OFF         PORTA.0 = 0      //Включатель/выключатель первого блока ламп
;     140 #define blok_lamp_2_OFF         PORTA.1 = 0     //Включатель/выключатель второго блока ламп
;     141 #define blok_lamp_3_OFF         PORTA.2 = 0     //Включатель/выключатель третьего блока ламп
;     142 #define blok_lamp_en_OFF        PORTA.3 = 0     //Включатель блока ламп
;     143 #define blok_lamp_dis_OFF       PORTA.4 = 0     //Выключатель блока ламп
;     144 #define blok_silovoy_en_OFF     PORTA.5 = 0     //Включатель блока электромагнит, дымогенератор, высокое напряжение
;     145 #define blok_silovoy_dis_OFF    PORTA.6 = 0     //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;     146 #define blok_rezerv_OFF         PORTA.7 = 0     //резерв
;     147 
;     148 //=============================================================================
;     149 //Режимы работы                                         regim_rabot
;     150 //Инициализация (заставка при включении).               1
;     151 //Корректировка максимальной температуры разогрева. 	11
;     152 //Корректировка минимальной температуры разогрева.      12
;     153 //Корректировка максимальной температуры копчения.  	21
;     154 //Корректировка минимальной температуры копчения.       22
;     155 //Корректировка часов времени работы.	                31
;     156 //Корректировка минут времени работы.                   32
;     157 //Корректировка часов времени работы вытяжки.	        41
;     158 //Корректировка минут времени работы вытяжки.	        42
;     159 //Работа в режиме разогрева.	                        60
;     160 //Работа в режиме копчения.                             70
;     161 //Работа в режиме остывания.	                        80
;     162 //STOP	                                                100
;     163 //===============================================================================
;     164 //порты обозначения кнопок
;     165 #define kn_vverh            PINC.0
;     166 #define kn_vniz             PINC.1
;     167 #define kn_vpravo           PINC.2
;     168 #define kn_vlevo            PINC.3
;     169 #define kn_ENTER            PINC.4
;     170 #define kn_ESC              PINC.5
;     171 
;     172 //==========================================================================
;     173 // Глобальные переменные
;     174 volatile unsigned char t_max_razogrev     = 115;    // максимальная температура разогрева, в градусах Цельсия

	.DSEG
_t_max_razogrev:
	.BYTE 0x1
;     175 volatile unsigned char t_max_rabochee     = 75;     // максимальная температура работы, в градусах Цельсия
_t_max_rabochee:
	.BYTE 0x1
;     176 volatile unsigned char t_min_razogrev     = 105;    // минимальная  температура разогрева, в градусах Цельсия
_t_min_razogrev:
	.BYTE 0x1
;     177 volatile unsigned char t_min_rabochee     = 65;     // минимальная температура работы, в градусах Цельсия
_t_min_rabochee:
	.BYTE 0x1
;     178 
;     179 volatile unsigned char time_rabota_ch     = 4;      // время работы, измеряется в часах
_time_rabota_ch:
	.BYTE 0x1
;     180 volatile unsigned char time_rabota_min    = 30;     // время работы, измеряется в минутах
_time_rabota_min:
	.BYTE 0x1
;     181 volatile unsigned char time_smoke_ch      = 0;      // время работы вытяжки, задается в часах
_time_smoke_ch:
	.BYTE 0x1
;     182 volatile unsigned char time_smoke_min     = 10;     // время работы вытяжки, задается в минутах
_time_smoke_min:
	.BYTE 0x1
;     183 
;     184 volatile unsigned char real_time_ch       = 0;      // текущее время работы в часах
_real_time_ch:
	.BYTE 0x1
;     185 volatile unsigned char real_time_min      = 0;      // текущее время работы в минутах
_real_time_min:
	.BYTE 0x1
;     186 volatile unsigned char real_time_sek      = 0;      // текущее время работы в минутах
_real_time_sek:
	.BYTE 0x1
;     187 
;     188 volatile unsigned char real_temp          = 0;      // минимальная температура работы, в градусах Цельсия
_real_temp:
	.BYTE 0x1
;     189 
;     190 volatile unsigned char real_temp_1razryad = 0;      // 1 разряд температуры при отображении
_real_temp_1razryad:
	.BYTE 0x1
;     191 volatile unsigned char real_temp_2razryad = 0;      // 2 разряд температуры при отображении
_real_temp_2razryad:
	.BYTE 0x1
;     192 volatile unsigned char real_temp_3razryad = 0;      // 3 разряд температуры при отображении
_real_temp_3razryad:
	.BYTE 0x1
;     193 
;     194 volatile unsigned char regim_rabot        = 1;      // состояние режим работы
_regim_rabot:
	.BYTE 0x1
;     195 volatile unsigned char regim_rabot_old    = 1;      // предыдущее состояние режима работы
_regim_rabot_old:
	.BYTE 0x1
;     196 
;     197 unsigned char zadergka_pri_nagatii        = 200;    // задержка при нажатии кнопки
;     198 int zadergka_zastavka                     = 1000;    // время показа заставки
;     199 unsigned char t_puskatel                  = 100;    // необходимое время для старта пускателя
;     200 
;     201 volatile char lcd_str_1[16];
_lcd_str_1:
	.BYTE 0x10
;     202 volatile char lcd_str_2[16];
_lcd_str_2:
	.BYTE 0x10
;     203 
;     204 //=============================================================================
;     205 // Объявление без задания функций. (для обеспечения компиляции)
;     206 void frame(void);
;     207 void screen(void);
;     208 void regim(void);
;     209 void init(void);
;     210 //=============================================================================
;     211 // прерывание ежесекундного (или 0,2 секундного таймера)
;     212 interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;     213 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     214     #asm("cli")
	cli
;     215 
;     216     TCNT1H=0;
	RCALL SUBOPT_0x1
;     217     TCNT1L=0;
;     218 
;     219     real_time_sek++;
	LDS  R30,_real_time_sek
	SUBI R30,-LOW(1)
	STS  _real_time_sek,R30
	SUBI R30,LOW(1)
;     220   	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x3C)
	BREQ PC+2
	RJMP _0x12
	LDS  R30,_real_time_min
	SUBI R30,-LOW(1)
	STS  _real_time_min,R30
	LDI  R30,LOW(0)
	STS  _real_time_sek,R30
;     221 	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
_0x12:
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x3C)
	BREQ PC+2
	RJMP _0x13
	LDS  R30,_real_time_ch
	SUBI R30,-LOW(1)
	STS  _real_time_ch,R30
	LDI  R30,LOW(0)
	STS  _real_time_min,R30
;     222 	if (real_time_ch  == 24) real_time_ch=0;
_0x13:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x18)
	BREQ PC+2
	RJMP _0x14
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
;     223 
;     224     #asm("sei")
_0x14:
	sei
;     225 
;     226 //    frame();
;     227 //    screen();
;     228 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     229 
;     230 //=============================================================================
;     231 // Реакция на нажатие кнопки вверх
;     232 void vverh (void)
;     233 {
_vverh:
;     234     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     235     {
;     236         case 11:    t_max_razogrev++;    break;
	BREQ PC+2
	RJMP _0x18
	LDS  R30,_t_max_razogrev
	SUBI R30,-LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x17
;     237         case 12:    t_min_razogrev++;    break;
_0x18:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x19
	LDS  R30,_t_min_razogrev
	SUBI R30,-LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x17
;     238         case 21:    t_max_rabochee++;    break;
_0x19:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x1A
	LDS  R30,_t_max_rabochee
	SUBI R30,-LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x17
;     239         case 22:    t_min_rabochee++;    break;
_0x1A:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x1B
	LDS  R30,_t_min_rabochee
	SUBI R30,-LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x17
;     240         case 31:    time_rabota_ch++;    break;
_0x1B:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x1C
	LDS  R30,_time_rabota_ch
	SUBI R30,-LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x17
;     241         case 32:    time_rabota_min++;   break;
_0x1C:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x1D
	LDS  R30,_time_rabota_min
	SUBI R30,-LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x17
;     242         case 41:    time_smoke_ch++;     break;
_0x1D:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x1E
	LDS  R30,_time_smoke_ch
	SUBI R30,-LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x17
;     243         case 42:    time_smoke_min++;    break;
_0x1E:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x20
	LDS  R30,_time_smoke_min
	SUBI R30,-LOW(1)
	STS  _time_smoke_min,R30
	RJMP _0x17
;     244         default    :    {};
_0x20:
;     245     }
_0x17:
;     246 }
	RET
;     247 
;     248 // Реакция на нажатие кнопки вниз
;     249 void vniz (void)
;     250 {
_vniz:
;     251     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     252     {
;     253         case 11:	t_max_razogrev--;	break;
	BREQ PC+2
	RJMP _0x24
	LDS  R30,_t_max_razogrev
	SUBI R30,LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x23
;     254         case 12:	t_min_razogrev--;	break;
_0x24:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x25
	LDS  R30,_t_min_razogrev
	SUBI R30,LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x23
;     255         case 21:	t_max_rabochee--;	break;
_0x25:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x26
	LDS  R30,_t_max_rabochee
	SUBI R30,LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x23
;     256         case 22:	t_min_rabochee--;	break;
_0x26:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x27
	LDS  R30,_t_min_rabochee
	SUBI R30,LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x23
;     257         case 31:	time_rabota_ch--;	break;
_0x27:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x28
	LDS  R30,_time_rabota_ch
	SUBI R30,LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x23
;     258         case 32:	time_rabota_min--;	break;
_0x28:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x29
	LDS  R30,_time_rabota_min
	SUBI R30,LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x23
;     259         case 41:	time_smoke_ch--;	break;
_0x29:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x2A
	LDS  R30,_time_smoke_ch
	SUBI R30,LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x23
;     260         case 42:	time_smoke_min--;	break;
_0x2A:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x2C
	LDS  R30,_time_smoke_min
	SUBI R30,LOW(1)
	STS  _time_smoke_min,R30
	RJMP _0x23
;     261         default	:	{};
_0x2C:
;     262     }
_0x23:
;     263 }
	RET
;     264 
;     265 // Реакция на нажатие кнопки вправо
;     266 void vpravo(void)
;     267 {
_vpravo:
;     268     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     269     {
;     270         case 11:	regim_rabot = 12;	break;
	BREQ PC+2
	RJMP _0x30
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     271         case 12:	regim_rabot = 21;	break;
_0x30:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x31
	LDI  R30,LOW(21)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     272         case 21:	regim_rabot = 22;	break;
_0x31:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x32
	LDI  R30,LOW(22)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     273         case 22:	regim_rabot = 31;	break;
_0x32:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x33
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     274         case 31:	regim_rabot = 32;	break;
_0x33:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x34
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     275         case 32:	regim_rabot = 41;	break;
_0x34:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x35
	LDI  R30,LOW(41)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     276         case 41:	regim_rabot = 42;	break;
_0x35:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x36
	LDI  R30,LOW(42)
	RCALL SUBOPT_0xD
	RJMP _0x2F
;     277         case 42:	regim_rabot = 11;	break;
_0x36:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x38
	RCALL SUBOPT_0xE
	RJMP _0x2F
;     278         default	:	{};
_0x38:
;     279     }
_0x2F:
;     280 }
	RET
;     281 
;     282 // Реакция на нажатие кнопки влево
;     283 void vlevo(void)
;     284 {
_vlevo:
;     285     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     286     {
;     287         case 11:	regim_rabot = 42;	break;
	BREQ PC+2
	RJMP _0x3C
	LDI  R30,LOW(42)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     288         case 12:	regim_rabot = 11;	break;
_0x3C:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x3D
	RCALL SUBOPT_0xE
	RJMP _0x3B
;     289         case 21:	regim_rabot = 12;	break;
_0x3D:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x3E
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     290         case 22:	regim_rabot = 21;	break;
_0x3E:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x3F
	LDI  R30,LOW(21)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     291         case 31:	regim_rabot = 22;	break;
_0x3F:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x40
	LDI  R30,LOW(22)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     292         case 32:	regim_rabot = 31;	break;
_0x40:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x41
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     293         case 41:	regim_rabot = 32;	break;
_0x41:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x42
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     294         case 42:	regim_rabot = 41;	break;
_0x42:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x44
	LDI  R30,LOW(41)
	RCALL SUBOPT_0xD
	RJMP _0x3B
;     295         default	:	{};
_0x44:
;     296     }
_0x3B:
;     297 }
	RET
;     298 // Реакция на нажатие кнопки enter
;     299 void enter(void)
;     300 {
_enter:
;     301     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     302     {
;     303         case 11:	regim_rabot = 60;	break;
	BREQ PC+2
	RJMP _0x48
	RCALL SUBOPT_0xF
	RJMP _0x47
;     304         case 12:	regim_rabot = 60;	break;
_0x48:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x49
	RCALL SUBOPT_0xF
	RJMP _0x47
;     305         case 21:	regim_rabot = 60;	break;
_0x49:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x4A
	RCALL SUBOPT_0xF
	RJMP _0x47
;     306         case 22:	regim_rabot = 60;	break;
_0x4A:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x4B
	RCALL SUBOPT_0xF
	RJMP _0x47
;     307         case 31:	regim_rabot = 60;	break;
_0x4B:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x4C
	RCALL SUBOPT_0xF
	RJMP _0x47
;     308         case 32:	regim_rabot = 60;	break;
_0x4C:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x4D
	RCALL SUBOPT_0xF
	RJMP _0x47
;     309         case 41:	regim_rabot = 60;	break;
_0x4D:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x4E
	RCALL SUBOPT_0xF
	RJMP _0x47
;     310         case 42:	regim_rabot = 60;	break;
_0x4E:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x50
	RCALL SUBOPT_0xF
	RJMP _0x47
;     311         default	:	{};
_0x50:
;     312     }
_0x47:
;     313 }
	RET
;     314 
;     315 // Реакция на нажатие кнопки esc
;     316 void esc(void)
;     317 {
_esc:
;     318     regim_rabot        = 11;
	RCALL SUBOPT_0xE
;     319     real_time_ch       = 0;      // текущее время работы в часах
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
;     320     real_time_min      = 0;      // текущее время работы в минутах
	STS  _real_time_min,R30
;     321     real_time_sek      = 0;      // текущее время работы в минутах
	STS  _real_time_sek,R30
;     322 }
	RET
;     323 
;     324 // проверка нажатия кнопок
;     325 void klaviatura(void)
;     326 {
_klaviatura:
;     327         if (PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x51
;     328             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     329             vverh();
	RCALL _vverh
;     330             }
;     331         if (PINC.1==0) {
_0x51:
	SBIC 0x13,1
	RJMP _0x52
;     332             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     333             vlevo();
	RCALL _vlevo
;     334             }
;     335         if (PINC.2==0) {
_0x52:
	SBIC 0x13,2
	RJMP _0x53
;     336             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     337             vniz();
	RCALL _vniz
;     338             }
;     339         if (PINC.3==0) {
_0x53:
	SBIC 0x13,3
	RJMP _0x54
;     340             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     341             vpravo();
	RCALL _vpravo
;     342             }
;     343         if (PINC.4==0) {
_0x54:
	SBIC 0x13,4
	RJMP _0x55
;     344             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     345             enter();
	RCALL _enter
;     346             }
;     347         if (PINC.5==0) {
_0x55:
	SBIC 0x13,5
	RJMP _0x56
;     348             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
;     349             esc();
	RCALL _esc
;     350             }
;     351 }
_0x56:
	RET
;     352 
;     353 //=================================================
;     354 void screen(void)
;     355 {
_screen:
;     356     lcd_clear();          	// очистка ЛСД
	RCALL _lcd_clear
;     357 
;     358     lcd_gotoxy(0,0);      	// установка курсора на 0,0
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL _lcd_gotoxy
;     359     lcd_puts(lcd_str_1);
	RCALL SUBOPT_0x12
	RCALL _lcd_puts
;     360 
;     361     lcd_gotoxy(0,1);      	// установка курсора на начало второй строки
	RCALL SUBOPT_0x11
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;     362     lcd_puts(lcd_str_2);
	RCALL SUBOPT_0x13
	RCALL _lcd_puts
;     363 
;     364 
;     365 }
	RET
;     366 
;     367 //==================================================
;     368 void frame(void)
;     369 {
_frame:
;     370     switch(regim_rabot)
	RCALL SUBOPT_0x14
;     371     {
;     372         case 1		:
	BREQ PC+2
	RJMP _0x5A
;     373             sprintf(lcd_str_1,"Koptilnya");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,0
	RCALL SUBOPT_0x15
;     374             sprintf(lcd_str_2,"v.1.0");
	RCALL SUBOPT_0x13
	__POINTW1FN _0,10
	RCALL SUBOPT_0x15
;     375             delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RCALL _delay_ms
;     376             break;
	RJMP _0x59
;     377         case 11		:
_0x5A:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x5B
;     378             sprintf(lcd_str_1,"Max T razogreva");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,16
	RCALL SUBOPT_0x15
;     379             sprintf(lcd_str_2,"%c%c%c",
;     380             (t_max_razogrev/100)%10 +0x30,
;     381             (t_max_razogrev/10)%10  +0x30,
;     382             t_max_razogrev%10       +0x30
;     383             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x17
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x18
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x19
;     384             break;
	RJMP _0x59
;     385         case 12	    :
_0x5B:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x5C
;     386             sprintf(lcd_str_1,"Min T razogreva");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,39
	RCALL SUBOPT_0x15
;     387             sprintf(lcd_str_2,"%c%c%c",
;     388             (t_min_razogrev/100)%10 +0x30,
;     389             (t_min_razogrev/10)%10  +0x30,
;     390             t_min_razogrev%10       +0x30
;     391             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x17
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x18
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x19
;     392             break;
	RJMP _0x59
;     393         case 21		:
_0x5C:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x5D
;     394             sprintf(lcd_str_1,"Max T rabotia");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,55
	RCALL SUBOPT_0x15
;     395             sprintf(lcd_str_2,"%c%c%c",
;     396             (t_max_rabochee/100)%10 +0x30,
;     397             (t_max_rabochee/10)%10  +0x30,
;     398             t_max_rabochee%10       +0x30
;     399             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x17
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x18
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x19
;     400             break;
	RJMP _0x59
;     401         case 22		:
_0x5D:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x5E
;     402             sprintf(lcd_str_1,"Min T raboti");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,69
	RCALL SUBOPT_0x15
;     403             sprintf(lcd_str_2,"%c%c%c",
;     404             (t_min_rabochee/100)%10 +0x30,
;     405             (t_min_rabochee/10)%10  +0x30,
;     406             t_min_rabochee%10       +0x30
;     407             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x17
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x18
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x19
;     408             break;
	RJMP _0x59
;     409         case 31		:
_0x5E:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x5F
;     410             sprintf(lcd_str_1,"Time rabota, ch");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,82
	RCALL SUBOPT_0x15
;     411             sprintf(lcd_str_2,"%c%c",
;     412             (time_rabota_ch/10)%10  +0x30,
;     413             time_rabota_ch%10       +0x30
;     414             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1A
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x18
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x1B
;     415             break;
	RJMP _0x59
;     416         case 32		:
_0x5F:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x60
;     417             sprintf(lcd_str_1,"Time rabota, min");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,98
	RCALL SUBOPT_0x15
;     418             sprintf(lcd_str_2,"%c%c",
;     419             (time_rabota_min/10)%10 +0x30,
;     420             time_rabota_min%10      +0x30
;     421             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1A
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x18
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x1B
;     422             break;
	RJMP _0x59
;     423         case 41		:
_0x60:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x61
;     424             sprintf(lcd_str_1,"Time smoke, ch");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,115
	RCALL SUBOPT_0x15
;     425             sprintf(lcd_str_2,"%c%c",
;     426             (time_smoke_ch/10)%10   +0x30,
;     427             time_smoke_ch%10        +0x30
;     428             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1A
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x18
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x1B
;     429             break;
	RJMP _0x59
;     430         case 42		:
_0x61:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x62
;     431             sprintf(lcd_str_1,"Time smoke, min");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,130
	RCALL SUBOPT_0x15
;     432             sprintf(lcd_str_2,"%c%c",
;     433             (time_smoke_min/10)%10  +0x30,
;     434             time_smoke_min%10       +0x30
;     435             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1A
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x18
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x1B
;     436             break;
	RJMP _0x59
;     437         case 60		:
_0x62:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x63
;     438 #pragma rl+
;     439             sprintf(lcd_str_1,"RAZOGREVРазогрев");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,146
	RCALL SUBOPT_0x15
;     440             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     441 //#pragma rl-
;     442 
;     443             (real_time_ch/10)%10	+0x30,
;     444             real_time_ch%10		    +0x30,
;     445             (real_time_min/10)%10	+0x30,
;     446             real_time_min%10		+0x30,
;     447             (real_time_sek/10)%10	+0x30,
;     448             real_time_sek%10		+0x30,
;     449 
;     450             real_temp_1razryad,
;     451             real_temp_2razryad,
;     452             real_temp_3razryad
;     453             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
;     454             break;
	RJMP _0x59
;     455         case 70		:
_0x63:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x64
;     456             sprintf(lcd_str_1,"RABOTA");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,189
	RCALL SUBOPT_0x15
;     457             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     458             (real_time_ch/10)%10	+0x30,
;     459             real_time_ch%10             +0x30,
;     460             (real_time_min/10)%10	+0x30,
;     461             real_time_min%10		+0x30,
;     462             (real_time_sek/10)%10	+0x30,
;     463             real_time_sek%10		+0x30,
;     464 
;     465             real_temp_1razryad,
;     466             real_temp_2razryad,
;     467             real_temp_3razryad
;     468             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
;     469             break;
	RJMP _0x59
;     470         case 80		:
_0x64:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x65
;     471             sprintf(lcd_str_1,"SMOKE");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,196
	RCALL SUBOPT_0x15
;     472             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     473             (real_time_ch/10)%10	+0x30,
;     474             real_time_ch%10             +0x30,
;     475             (real_time_min/10)%10	+0x30,
;     476             real_time_min%10		+0x30,
;     477             (real_time_sek/10)%10	+0x30,
;     478             real_time_sek%10		+0x30,
;     479 
;     480             real_temp_1razryad,
;     481             real_temp_2razryad,
;     482             real_temp_3razryad
;     483             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
;     484             break;
	RJMP _0x59
;     485         case 100	:
_0x65:
	RCALL SUBOPT_0x20
	BREQ PC+2
	RJMP _0x67
;     486             sprintf(lcd_str_1,"STOP");
	RCALL SUBOPT_0x12
	__POINTW1FN _0,202
	RCALL SUBOPT_0x15
;     487             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     488             (real_time_ch/10)%10	+0x30,
;     489             real_time_ch%10             +0x30,
;     490             (real_time_min/10)%10	+0x30,
;     491             real_time_min%10		+0x30,
;     492             (real_time_sek/10)%10	+0x30,
;     493             real_time_sek%10		+0x30,
;     494 
;     495             real_temp_1razryad,
;     496             real_temp_2razryad,
;     497             real_temp_3razryad
;     498             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
;     499             break;
	RJMP _0x59
;     500 
;     501         default	    :
_0x67:
;     502             lcd_putsf("www.xxx.ua");
	__POINTW1FN _0,207
	RCALL SUBOPT_0x21
	RCALL _lcd_putsf
;     503             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x21
	RCALL _delay_ms
;     504             break;
;     505     }
_0x59:
;     506 }
	RET
;     507 //=================================================
;     508 void regim(void)
;     509 {
_regim:
;     510 
;     511 //       regim_rabot_old = regim_rabot;
;     512 
;     513         switch(regim_rabot)
	RCALL SUBOPT_0x14
;     514         {
;     515         case 1		:
	BREQ PC+2
	RJMP _0x6B
;     516                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     517                 blok_lamp_2_OFF         ;
;     518                 blok_lamp_3_OFF         ;
;     519                 blok_lamp_en_OFF        ;
;     520                 blok_lamp_dis_OFF       ;
;     521                 blok_silovoy_en_OFF     ;
;     522                 blok_silovoy_dis_OFF    ;
;     523                 blok_rezerv_OFF         ;
;     524             break;
	RJMP _0x6A
;     525         case 11		:
_0x6B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x6C
;     526             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x6E
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x6E
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x6E
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x6E
	LDI  R30,0
	RJMP _0x6F
_0x6E:
	LDI  R30,1
_0x6F:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x6D
;     527             {
;     528                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     529                 blok_lamp_2_OFF         ;
;     530                 blok_lamp_3_OFF         ;
;     531                 blok_lamp_en_OFF        ;
;     532                 blok_lamp_dis_OFF       ;
;     533                 blok_silovoy_en_OFF     ;
;     534                 blok_silovoy_dis_OFF    ;
;     535                 blok_rezerv_OFF         ;
;     536             }
;     537             break;
_0x6D:
	RJMP _0x6A
;     538         case 12         :
_0x6C:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x70
;     539             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x72
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x72
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x72
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x72
	LDI  R30,0
	RJMP _0x73
_0x72:
	LDI  R30,1
_0x73:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x71
;     540             {
;     541                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     542                 blok_lamp_2_OFF         ;
;     543                 blok_lamp_3_OFF         ;
;     544                 blok_lamp_en_OFF        ;
;     545                 blok_lamp_dis_OFF       ;
;     546                 blok_silovoy_en_OFF     ;
;     547                 blok_silovoy_dis_OFF    ;
;     548                 blok_rezerv_OFF         ;
;     549             }
;     550             break;
_0x71:
	RJMP _0x6A
;     551         case 21		:
_0x70:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x74
;     552             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x76
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x76
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x76
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x76
	LDI  R30,0
	RJMP _0x77
_0x76:
	LDI  R30,1
_0x77:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x75
;     553             {
;     554                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     555                 blok_lamp_2_OFF         ;
;     556                 blok_lamp_3_OFF         ;
;     557                 blok_lamp_en_OFF        ;
;     558                 blok_lamp_dis_OFF       ;
;     559                 blok_silovoy_en_OFF     ;
;     560                 blok_silovoy_dis_OFF    ;
;     561                 blok_rezerv_OFF         ;
;     562             }
;     563             break;
_0x75:
	RJMP _0x6A
;     564         case 22		:
_0x74:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x78
;     565             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x7A
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x7A
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x7A
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x7A
	LDI  R30,0
	RJMP _0x7B
_0x7A:
	LDI  R30,1
_0x7B:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x79
;     566             {
;     567                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     568                 blok_lamp_2_OFF         ;
;     569                 blok_lamp_3_OFF         ;
;     570                 blok_lamp_en_OFF        ;
;     571                 blok_lamp_dis_OFF       ;
;     572                 blok_silovoy_en_OFF     ;
;     573                 blok_silovoy_dis_OFF    ;
;     574                 blok_rezerv_OFF         ;
;     575             }
;     576             break;
_0x79:
	RJMP _0x6A
;     577         case 31		:
_0x78:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x7C
;     578             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x7E
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x7E
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x7E
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x7E
	LDI  R30,0
	RJMP _0x7F
_0x7E:
	LDI  R30,1
_0x7F:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x7D
;     579             {
;     580                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     581                 blok_lamp_2_OFF         ;
;     582                 blok_lamp_3_OFF         ;
;     583                 blok_lamp_en_OFF        ;
;     584                 blok_lamp_dis_OFF       ;
;     585                 blok_silovoy_en_OFF     ;
;     586                 blok_silovoy_dis_OFF    ;
;     587                 blok_rezerv_OFF         ;
;     588             }
;     589             break;
_0x7D:
	RJMP _0x6A
;     590         case 32		:
_0x7C:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x80
;     591             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x82
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x82
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x82
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x82
	LDI  R30,0
	RJMP _0x83
_0x82:
	LDI  R30,1
_0x83:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x81
;     592             {
;     593                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     594                 blok_lamp_2_OFF         ;
;     595                 blok_lamp_3_OFF         ;
;     596                 blok_lamp_en_OFF        ;
;     597                 blok_lamp_dis_OFF       ;
;     598                 blok_silovoy_en_OFF     ;
;     599                 blok_silovoy_dis_OFF    ;
;     600                 blok_rezerv_OFF         ;
;     601             }
;     602             break;
_0x81:
	RJMP _0x6A
;     603         case 41		:
_0x80:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x84
;     604             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x86
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x86
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x86
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x86
	LDI  R30,0
	RJMP _0x87
_0x86:
	LDI  R30,1
_0x87:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x85
;     605             {
;     606                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     607                 blok_lamp_2_OFF         ;
;     608                 blok_lamp_3_OFF         ;
;     609                 blok_lamp_en_OFF        ;
;     610                 blok_lamp_dis_OFF       ;
;     611                 blok_silovoy_en_OFF     ;
;     612                 blok_silovoy_dis_OFF    ;
;     613                 blok_rezerv_OFF         ;
;     614             }
;     615             break;
_0x85:
	RJMP _0x6A
;     616         case 42		:
_0x84:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x88
;     617             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x8A
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x8A
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x8A
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x8A
	LDI  R30,0
	RJMP _0x8B
_0x8A:
	LDI  R30,1
_0x8B:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x89
;     618             {
;     619                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     620                 blok_lamp_2_OFF         ;
;     621                 blok_lamp_3_OFF         ;
;     622                 blok_lamp_en_OFF        ;
;     623                 blok_lamp_dis_OFF       ;
;     624                 blok_silovoy_en_OFF     ;
;     625                 blok_silovoy_dis_OFF    ;
;     626                 blok_rezerv_OFF         ;
;     627             }
;     628             break;
_0x89:
	RJMP _0x6A
;     629         case 60		:
_0x88:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x8C
;     630             if (regim_rabot_old==(11||12||21||22||31||31||41||42))
	LDI  R30,LOW(11)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(12)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(21)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(22)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(31)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(41)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,LOW(42)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x8E
	LDI  R30,0
	RJMP _0x8F
_0x8E:
	LDI  R30,1
_0x8F:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x8D
;     631             {
;     632                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x28
;     633                 blok_lamp_2_ON         ;
;     634                 blok_lamp_3_ON         ;
;     635                 blok_lamp_dis_OFF      ;
	CBI  0x1B,4
;     636                 blok_silovoy_en_OFF    ;
	CBI  0x1B,5
;     637                 blok_silovoy_dis_OFF   ;
	CBI  0x1B,6
;     638                 blok_rezerv_OFF        ;
	CBI  0x1B,7
;     639 
;     640                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x29
;     641                 delay_ms(t_puskatel)   ;
;     642                 blok_lamp_en_OFF       ;
	CBI  0x1B,3
;     643             }
;     644             if (real_temp<t_max_razogrev)
_0x8D:
	LDS  R30,_t_max_razogrev
	LDS  R26,_real_temp
	CP   R26,R30
	BRLO PC+2
	RJMP _0x90
;     645             {
;     646                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x29
;     647                 delay_ms(t_puskatel)   ;
;     648             }
;     649 
;     650                 blok_lamp_1_ON         ;
_0x90:
	RCALL SUBOPT_0x28
;     651                 blok_lamp_2_ON         ;
;     652                 blok_lamp_3_ON         ;
;     653                 blok_lamp_en_OFF      ;
	CBI  0x1B,3
;     654             break;
	RJMP _0x6A
;     655         case 70		:
_0x8C:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x91
;     656                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x28
;     657                 blok_lamp_2_ON         ;
;     658                 blok_lamp_3_ON         ;
;     659 
;     660                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
;     661             break;
	RJMP _0x6A
;     662         case 80		:
_0x91:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x92
;     663                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x28
;     664                 blok_lamp_2_ON         ;
;     665                 blok_lamp_3_ON         ;
;     666 
;     667                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
;     668             break;
	RJMP _0x6A
;     669         case 100	:
_0x92:
	RCALL SUBOPT_0x20
	BREQ PC+2
	RJMP _0x94
;     670                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     671                 blok_lamp_2_OFF         ;
;     672                 blok_lamp_3_OFF         ;
;     673                 blok_lamp_en_OFF        ;
;     674                 blok_lamp_dis_OFF       ;
;     675                 blok_silovoy_en_OFF     ;
;     676                 blok_silovoy_dis_OFF    ;
;     677                 blok_rezerv_OFF         ;
;     678             break;
	RJMP _0x6A
;     679         default	    :
_0x94:
;     680             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x23
	BREQ PC+2
	RJMP _0x96
	RCALL SUBOPT_0x24
	BREQ PC+2
	RJMP _0x96
	RCALL SUBOPT_0x25
	BREQ PC+2
	RJMP _0x96
	RCALL SUBOPT_0x26
	BREQ PC+2
	RJMP _0x96
	LDI  R30,0
	RJMP _0x97
_0x96:
	LDI  R30,1
_0x97:
	RCALL SUBOPT_0x27
	BREQ PC+2
	RJMP _0x95
;     681             {
;     682                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x22
;     683                 blok_lamp_2_OFF         ;
;     684                 blok_lamp_3_OFF         ;
;     685                 blok_lamp_en_OFF        ;
;     686                 blok_lamp_dis_OFF       ;
;     687                 blok_silovoy_en_OFF     ;
;     688                 blok_silovoy_dis_OFF    ;
;     689                 blok_rezerv_OFF         ;
;     690             }
;     691             break;
_0x95:
;     692         };
_0x6A:
;     693 
;     694         regim_rabot_old = regim_rabot;
	LDS  R30,_regim_rabot
	STS  _regim_rabot_old,R30
;     695 }
	RET
;     696 //=================================================
;     697 void init(void)
;     698 {
_init:
;     699 // Port A initialization
;     700     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     701     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
;     702 // Port B initialization
;     703     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     704     DDRB=0x00;
	OUT  0x17,R30
;     705 
;     706 // Инициализация порта клавиатуры.
;     707 // Port C initialization
;     708     PORTC=0xFF;         // вкл. подтягивающие резисторы
	LDI  R30,LOW(255)
	OUT  0x15,R30
;     709     DDRC=0x00;          // весь порт как вход
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     710 
;     711 // Timer/Counter 1 initialization
;     712 // Clock source: System Clock
;     713 // Clock value: 7,813 kHz
;     714 // Mode: Normal top=FFFFh
;     715 // OC1A output: Discon.
;     716 // OC1B output: Discon.
;     717 // Noise Canceler: Off
;     718 // Input Capture on Falling Edge
;     719 // Timer 1 Overflow Interrupt: Off
;     720 // Input Capture Interrupt: Off
;     721 // Compare A Match Interrupt: On
;     722 // Compare B Match Interrupt: Off
;     723     TCCR1A=0x00;
	OUT  0x2F,R30
;     724     TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     725     TCNT1H=0x00;
	RCALL SUBOPT_0x1
;     726     TCNT1L=0x00;
;     727     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
;     728     ICR1L=0x00;
	OUT  0x26,R30
;     729     OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
;     730     OCR1AL=0x85;
	LDI  R30,LOW(133)
	OUT  0x2A,R30
;     731     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;     732     OCR1BL=0x00;
	OUT  0x28,R30
;     733 
;     734 // Timer(s)/Counter(s) Interrupt(s) initialization
;     735     TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
;     736 
;     737 //=================================================
;     738 // USART initialization
;     739 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     740 // USART Receiver: On
;     741 // USART Transmitter: On
;     742 // USART Mode: Asynchronous
;     743 // USART Baud Rate: 38400
;     744     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     745     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     746     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     747     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     748     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     749 //=================================================
;     750 // LCD module initialization
;     751     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
;     752 }
	RET
;     753 
;     754 void main(void)
;     755 {
_main:
;     756     init();
	RCALL _init
;     757 
;     758     regim_rabot=1;             // Заставка
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
;     759     frame();
	RCALL _frame
;     760     screen();
	RCALL _screen
;     761 
;     762     delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RCALL _delay_ms
;     763 
;     764     regim_rabot=11;            // Установка режима работ на задание температуры
	RCALL SUBOPT_0xE
;     765 
;     766     frame();
	RCALL _frame
;     767     screen();
	RCALL _screen
;     768 
;     769     #asm("sei")                // Разрешение прерываний
	sei
;     770 
;     771     while(1)                   // Вечный цикл
_0x98:
;     772     {
;     773         klaviatura();          // обработка нажатой кнопки
	RCALL _klaviatura
;     774 
;     775         regim();
	RCALL _regim
;     776 
;     777 /*
;     778         if (getchar()=='#')
;     779         {
;     780                 real_temp_1razryad = getchar();      // 1 разряд температуры при отображении
;     781                 real_temp_2razryad = getchar();      // 2 разряд температуры при отображении
;     782                 real_temp_3razryad = getchar();      // 3 разряд температуры при отображении
;     783 
;     784                 real_temp=(real_temp_1razryad*100+real_temp_2razryad*10+real_temp_3razryad);
;     785         }
;     786 */
;     787         frame();
	RCALL _frame
;     788         screen();
	RCALL _screen
;     789     }
	RJMP _0x98
_0x9A:
;     790 }
_0x9B:
	RJMP _0x9B

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
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	SBIW R30,0
	BRNE PC+2
	RJMP _0xA9
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+2
	RJMP _0xAA
	RJMP _0xAB
_0xAA:
	__CPWRN 16,17,2
	BRSH PC+2
	RJMP _0xAC
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X+,R30
	ST   X,R31
_0xAB:
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
_0xAC:
	RJMP _0xAD
_0xA9:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0xAD:
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
_0xAE:
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
	RJMP _0xB0
	MOV  R30,R17
	RCALL SUBOPT_0x0
	SBIW R30,0
	BREQ PC+2
	RJMP _0xB4
	CPI  R18,37
	BREQ PC+2
	RJMP _0xB5
	LDI  R17,LOW(1)
	RJMP _0xB6
_0xB5:
	RCALL SUBOPT_0x2A
_0xB6:
	RJMP _0xB3
_0xB4:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xB7
	CPI  R18,37
	BREQ PC+2
	RJMP _0xB8
	RCALL SUBOPT_0x2A
	LDI  R17,LOW(0)
	RJMP _0xB3
_0xB8:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+2
	RJMP _0xB9
	LDI  R16,LOW(1)
	RJMP _0xB3
_0xB9:
	CPI  R18,43
	BREQ PC+2
	RJMP _0xBA
	LDI  R20,LOW(43)
	RJMP _0xB3
_0xBA:
	CPI  R18,32
	BREQ PC+2
	RJMP _0xBB
	LDI  R20,LOW(32)
	RJMP _0xB3
_0xBB:
	RJMP _0xBC
_0xB7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xBD
_0xBC:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+2
	RJMP _0xBE
	ORI  R16,LOW(128)
	RJMP _0xB3
_0xBE:
	RJMP _0xBF
_0xBD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xB3
_0xBF:
	CPI  R18,48
	BRSH PC+2
	RJMP _0xC2
	CPI  R18,58
	BRLO PC+2
	RJMP _0xC2
	RJMP _0xC3
_0xC2:
	RJMP _0xC1
_0xC3:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	RCALL SUBOPT_0x0
	ADD  R21,R30
	RJMP _0xB3
_0xC1:
	MOV  R30,R18
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xC7
	RCALL SUBOPT_0x2B
	LD   R30,X
	RCALL SUBOPT_0x2C
	RJMP _0xC8
	RJMP _0xC9
_0xC7:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xCA
_0xC9:
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2D
	RCALL _strlen
	MOV  R17,R30
	RJMP _0xCB
	RJMP _0xCC
_0xCA:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xCD
_0xCC:
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2D
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0xCB:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0xCE
	RJMP _0xCF
_0xCD:
	RCALL SUBOPT_0x20
	BREQ PC+2
	RJMP _0xD0
_0xCF:
	RJMP _0xD1
_0xD0:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xD2
_0xD1:
	ORI  R16,LOW(4)
	RJMP _0xD3
_0xD2:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xD4
_0xD3:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	RCALL SUBOPT_0x2E
	LDI  R17,LOW(5)
	RJMP _0xD5
	RJMP _0xD6
_0xD4:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xD7
_0xD6:
	ORI  R16,LOW(8)
	RJMP _0xD8
_0xD7:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x109
_0xD8:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	RCALL SUBOPT_0x2E
	LDI  R17,LOW(4)
_0xD5:
	SBRS R16,2
	RJMP _0xDA
	RCALL SUBOPT_0x2B
	RCALL __GETW1P
	RCALL SUBOPT_0x2F
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRLT PC+2
	RJMP _0xDB
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x2F
	LDI  R20,LOW(45)
_0xDB:
	CPI  R20,0
	BRNE PC+2
	RJMP _0xDC
	SUBI R17,-LOW(1)
	RJMP _0xDD
_0xDC:
	ANDI R16,LOW(251)
_0xDD:
	RJMP _0xDE
_0xDA:
	RCALL SUBOPT_0x2B
	RCALL __GETW1P
	RCALL SUBOPT_0x2F
_0xDE:
_0xCE:
	SBRC R16,0
	RJMP _0xDF
_0xE0:
	CP   R17,R21
	BRLO PC+2
	RJMP _0xE2
	SBRS R16,7
	RJMP _0xE3
	SBRS R16,2
	RJMP _0xE4
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0xE5
_0xE4:
	LDI  R18,LOW(48)
_0xE5:
	RJMP _0xE6
_0xE3:
	LDI  R18,LOW(32)
_0xE6:
	RCALL SUBOPT_0x2A
	SUBI R21,LOW(1)
	RJMP _0xE0
_0xE2:
_0xDF:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0xE7
_0xE8:
	CPI  R19,0
	BRNE PC+2
	RJMP _0xEA
	SBRS R16,3
	RJMP _0xEB
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	RCALL SUBOPT_0x2E
	SBIW R30,1
	LPM  R30,Z
	RCALL SUBOPT_0x2C
	RJMP _0xEC
_0xEB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	RCALL SUBOPT_0x2C
_0xEC:
	CPI  R21,0
	BRNE PC+2
	RJMP _0xED
	SUBI R21,LOW(1)
_0xED:
	SUBI R19,LOW(1)
	RJMP _0xE8
_0xEA:
	RJMP _0xEE
_0xE7:
_0xF0:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x2E
	SBIW R30,2
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
_0xF2:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+2
	RJMP _0xF4
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x2F
	RJMP _0xF2
_0xF4:
	CPI  R18,58
	BRSH PC+2
	RJMP _0xF5
	SBRS R16,3
	RJMP _0xF6
	SUBI R18,-LOW(7)
	RJMP _0xF7
_0xF6:
	SUBI R18,-LOW(39)
_0xF7:
_0xF5:
	SBRS R16,4
	RJMP _0xF8
	RJMP _0xF9
_0xF8:
	CPI  R18,49
	BRLO PC+2
	RJMP _0xFB
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+2
	RJMP _0xFB
	RJMP _0xFA
_0xFB:
	ORI  R16,LOW(16)
	RJMP _0xFD
_0xFA:
	CP   R21,R19
	BRSH PC+2
	RJMP _0xFF
	SBRC R16,0
	RJMP _0xFF
	RJMP _0x100
_0xFF:
	RJMP _0xFE
_0x100:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x101
	LDI  R18,LOW(48)
	ORI  R16,LOW(16)
_0xFD:
	SBRS R16,2
	RJMP _0x102
	ANDI R16,LOW(251)
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x21
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x21
	RCALL __put_G2
	CPI  R21,0
	BRNE PC+2
	RJMP _0x103
	SUBI R21,LOW(1)
_0x103:
_0x102:
_0x101:
_0xF9:
	RCALL SUBOPT_0x2A
	CPI  R21,0
	BRNE PC+2
	RJMP _0x104
	SUBI R21,LOW(1)
_0x104:
_0xFE:
	SUBI R19,LOW(1)
_0xEF:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+2
	RJMP _0xF1
	RJMP _0xF0
_0xF1:
_0xEE:
	SBRS R16,0
	RJMP _0x105
_0x106:
	CPI  R21,0
	BRNE PC+2
	RJMP _0x108
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x2C
	RJMP _0x106
_0x108:
_0x105:
_0x109:
_0xC8:
	LDI  R17,LOW(0)
_0xC6:
_0xB3:
	RJMP _0xAE
_0xB0:
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
	RCALL SUBOPT_0x21
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x21
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x21
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
	RCALL SUBOPT_0x30
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x30
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x30
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x30
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R11
	CP   R13,R11
	BRLO PC+2
	RJMP _0x156
	__lcd_putchar1:
	INC  R10
	RCALL SUBOPT_0x11
	ST   -Y,R10
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x156:
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
_0x157:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x159
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x157
_0x159:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_putsf:
	ST   -Y,R17
_0x15A:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x15C
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x15A
_0x15C:
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
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G3,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G3,3
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x31
	RCALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G3
	RCALL __long_delay_G3
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x30
	RCALL __long_delay_G3
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x30
	RCALL __long_delay_G3
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x30
	RCALL __long_delay_G3
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BRNE PC+2
	RJMP _0x15D
	LDI  R30,LOW(0)
	ADIW R28,1
	RET
_0x15D:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x30
	RCALL _lcd_clear
	LDI  R30,LOW(1)
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
_p_S61:
	.BYTE 0x2

	.CSEG

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDS  R26,_real_time_sek
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDS  R26,_real_time_min
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R26,_real_time_ch
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDS  R30,_regim_rabot
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xD:
	STS  _regim_rabot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(11)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(60)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10:
	MOV  R30,R7
	RCALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_lcd_str_1)
	LDI  R31,HIGH(_lcd_str_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(_lcd_str_2)
	LDI  R31,HIGH(_lcd_str_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R30,_regim_rabot
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:50 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	__POINTW1FN _0,32
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(100)
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:169 WORDS
SUBOPT_0x18:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	__POINTW1FN _0,34
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	__POINTW1FN _0,163
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x4
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x3
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x3
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x2
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_real_temp_1razryad
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_real_temp_2razryad
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_real_temp_3razryad
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,36
	RCALL _sprintf
	ADIW R28,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x22:
	CBI  0x1B,0
	CBI  0x1B,1
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,4
	CBI  0x1B,5
	CBI  0x1B,6
	CBI  0x1B,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(60)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(70)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(80)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(100)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x0
	LDS  R26,_regim_rabot_old
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x28:
	SBI  0x1B,0
	SBI  0x1B,1
	SBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	SBI  0x1B,3
	MOV  R30,R6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x21
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2A:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x21
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x21
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2C:
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x21
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x21
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
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
	__DELAY_USW 0x7A1
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
