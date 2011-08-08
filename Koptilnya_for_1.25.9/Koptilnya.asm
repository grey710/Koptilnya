
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
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
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
;      68 #define _DEBUG_TERMINAL_IO_
;      69 
;      70 // USART Receiver buffer
;      71 #define RX_BUFFER_SIZE 8
;      72 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      73 
;      74 //unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      75 unsigned char rx_wr_index,rx_counter;
;      76 
;      77 // This flag is set on USART Receiver buffer overflow
;      78 bit rx_buffer_overflow;
;      79 
;      80 //===================================================================
;      81 // USART Receiver interrupt service routine
;      82 interrupt [USART_RXC] void usart_rx_isr(void)
;      83 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      84 char status,data;
;      85 
;      86 #asm("cli")
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	cli
;      87 
;      88 status=UCSRA;
	IN   R17,11
;      89 data=UDR;
	IN   R16,12
;      90 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;      91     {
;      92         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;      93 
;      94         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;      95         if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x5
;      96         {
;      97             rx_counter=0;
	CLR  R4
;      98             rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      99         }
;     100     }
_0x5:
;     101 #asm("sei")
_0x3:
	sei
;     102 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     103 
;     104 #ifndef _DEBUG_TERMINAL_IO_
;     105 // Get a character from the USART Receiver buffer
;     106 #define _ALTERNATE_GETCHAR_
;     107 
;     108 #pragma used+
;     109 
;     110 char getchar(void)
;     111 {
;     112     char data;
;     113     while (rx_counter==0);
;     114     data=rx_buffer[rx_rd_index++];
;     115 
;     116     #asm("cli")
;     117     --rx_counter;
;     118     #asm("sei")
;     119     return data;
;     120 }
;     121 
;     122 #pragma used-
;     123 #endif
;     124 
;     125 //=============================================================================
;     126 // управление в режимах
;     127 //порты подключения управляющих реле
;     128 #define blok_lamp_1_ON         PORTA.0 = 1    //Включатель/выключатель первого блока ламп
;     129 #define blok_lamp_2_ON         PORTA.1 = 1    //Включатель/выключатель второго блока ламп
;     130 #define blok_lamp_3_ON         PORTA.2 = 1    //Включатель/выключатель третьего блока ламп
;     131 #define blok_lamp_en_ON        PORTA.3 = 1    //Включатель блока ламп
;     132 #define blok_lamp_dis_ON       PORTA.4 = 1    //Выключатель блока ламп
;     133 #define blok_silovoy_en_ON     PORTA.5 = 1    //Включатель блока электромагнит, дымогенератор, высокое напряжение
;     134 #define blok_silovoy_dis_ON    PORTA.6 = 1    //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;     135 #define blok_rezerv_ON         PORTA.7 = 1    //резерв
;     136 
;     137 #define blok_lamp_1_OFF         PORTA.0 = 0      //Включатель/выключатель первого блока ламп
;     138 #define blok_lamp_2_OFF         PORTA.1 = 0     //Включатель/выключатель второго блока ламп
;     139 #define blok_lamp_3_OFF         PORTA.2 = 0     //Включатель/выключатель третьего блока ламп
;     140 #define blok_lamp_en_OFF        PORTA.3 = 0     //Включатель блока ламп
;     141 #define blok_lamp_dis_OFF       PORTA.4 = 0     //Выключатель блока ламп
;     142 #define blok_silovoy_en_OFF     PORTA.5 = 0     //Включатель блока электромагнит, дымогенератор, высокое напряжение
;     143 #define blok_silovoy_dis_OFF    PORTA.6 = 0     //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;     144 #define blok_rezerv_OFF         PORTA.7 = 0     //резерв
;     145 
;     146 //=============================================================================
;     147 //Режимы работы                                         regim_rabot
;     148 //Инициализация (заставка при включении).               1
;     149 //Корректировка максимальной температуры разогрева. 	11
;     150 //Корректировка минимальной температуры разогрева.      12
;     151 //Корректировка максимальной температуры копчения.  	21
;     152 //Корректировка минимальной температуры копчения.       22
;     153 //Корректировка часов времени работы.	                31
;     154 //Корректировка минут времени работы.                   32
;     155 //Корректировка часов времени работы вытяжки.	        41
;     156 //Корректировка минут времени работы вытяжки.	        42
;     157 //Работа в режиме разогрева.	                        60
;     158 //Работа в режиме копчения.                             70
;     159 //Работа в режиме остывания.	                        80
;     160 //STOP	                                                100
;     161 //===============================================================================
;     162 //порты обозначения кнопок
;     163 #define kn_vverh            PINC.0
;     164 #define kn_vniz             PINC.1
;     165 #define kn_vpravo           PINC.2
;     166 #define kn_vlevo            PINC.3
;     167 #define kn_ENTER            PINC.4
;     168 #define kn_ESC              PINC.5
;     169 
;     170 //==========================================================================
;     171 // Глобальные переменные
;     172 volatile unsigned char t_max_razogrev     = 115;    // максимальная температура разогрева, в градусах Цельсия

	.DSEG
_t_max_razogrev:
	.BYTE 0x1
;     173 volatile unsigned char t_max_rabochee     = 75;     // максимальная температура работы, в градусах Цельсия
_t_max_rabochee:
	.BYTE 0x1
;     174 volatile unsigned char t_min_razogrev     = 105;    // минимальная  температура разогрева, в градусах Цельсия
_t_min_razogrev:
	.BYTE 0x1
;     175 volatile unsigned char t_min_rabochee     = 65;     // минимальная температура работы, в градусах Цельсия
_t_min_rabochee:
	.BYTE 0x1
;     176 
;     177 volatile unsigned char time_rabota_ch     = 4;      // время работы, измеряется в часах
_time_rabota_ch:
	.BYTE 0x1
;     178 volatile unsigned char time_rabota_min    = 30;     // время работы, измеряется в минутах
_time_rabota_min:
	.BYTE 0x1
;     179 volatile unsigned char time_smoke_ch      = 0;      // время работы вытяжки, задается в часах
_time_smoke_ch:
	.BYTE 0x1
;     180 volatile unsigned char time_smoke_min     = 10;     // время работы вытяжки, задается в минутах
_time_smoke_min:
	.BYTE 0x1
;     181 
;     182 volatile unsigned char real_time_ch       = 0;      // текущее время работы в часах
_real_time_ch:
	.BYTE 0x1
;     183 volatile unsigned char real_time_min      = 0;      // текущее время работы в минутах
_real_time_min:
	.BYTE 0x1
;     184 volatile unsigned char real_time_sek      = 0;      // текущее время работы в минутах
_real_time_sek:
	.BYTE 0x1
;     185 
;     186 volatile unsigned char real_temp          = 0;      // минимальная температура работы, в градусах Цельсия
_real_temp:
	.BYTE 0x1
;     187 
;     188 volatile unsigned char real_temp_1razryad = 0;      // 1 разряд температуры при отображении
_real_temp_1razryad:
	.BYTE 0x1
;     189 volatile unsigned char real_temp_2razryad = 0;      // 2 разряд температуры при отображении
_real_temp_2razryad:
	.BYTE 0x1
;     190 volatile unsigned char real_temp_3razryad = 0;      // 3 разряд температуры при отображении
_real_temp_3razryad:
	.BYTE 0x1
;     191 
;     192 volatile unsigned char regim_rabot        = 1;      // состояние режим работы
_regim_rabot:
	.BYTE 0x1
;     193 volatile unsigned char regim_rabot_old    = 1;      // предыдущее состояние режима работы
_regim_rabot_old:
	.BYTE 0x1
;     194 
;     195 unsigned char zadergka_pri_nagatii        = 200;    // задержка при нажатии кнопки
;     196 int zadergka_zastavka                     = 1000;    // время показа заставки
;     197 unsigned char t_puskatel                  = 100;    // необходимое время для старта пускателя
;     198 
;     199 volatile char lcd_str_1[16];
_lcd_str_1:
	.BYTE 0x10
;     200 volatile char lcd_str_2[16];
_lcd_str_2:
	.BYTE 0x10
;     201 
;     202 //=============================================================================
;     203 // Объявление без задания функций. (для обеспечения компиляции)
;     204 void frame(void);
;     205 void screen(void);
;     206 void regim(void);
;     207 void init(void);
;     208 //=============================================================================
;     209 // прерывание ежесекундного (или 0,2 секундного таймера)
;     210 interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;     211 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     212     #asm("cli")
	cli
;     213 
;     214     TCNT1H=0;
	RCALL SUBOPT_0x1
;     215     TCNT1L=0;
;     216 
;     217     real_time_sek++;
	LDS  R30,_real_time_sek
	SUBI R30,-LOW(1)
	STS  _real_time_sek,R30
	SUBI R30,LOW(1)
;     218   	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x3C)
	BRNE _0x12
	LDS  R30,_real_time_min
	SUBI R30,-LOW(1)
	STS  _real_time_min,R30
	LDI  R30,LOW(0)
	STS  _real_time_sek,R30
;     219 	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
_0x12:
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x3C)
	BRNE _0x13
	LDS  R30,_real_time_ch
	SUBI R30,-LOW(1)
	STS  _real_time_ch,R30
	LDI  R30,LOW(0)
	STS  _real_time_min,R30
;     220 	if (real_time_ch  == 24) real_time_ch=0;
_0x13:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x18)
	BRNE _0x14
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
;     221 
;     222     #asm("sei")
_0x14:
	sei
;     223 
;     224 //    frame();
;     225 //    screen();
;     226 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     227 
;     228 //=============================================================================
;     229 // Реакция на нажатие кнопки вверх
;     230 void vverh (void)
;     231 {
_vverh:
;     232     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     233     {
;     234         case 11:    t_max_razogrev++;    break;
	BRNE _0x18
	LDS  R30,_t_max_razogrev
	SUBI R30,-LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x17
;     235         case 12:    t_min_razogrev++;    break;
_0x18:
	CPI  R30,LOW(0xC)
	BRNE _0x19
	LDS  R30,_t_min_razogrev
	SUBI R30,-LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x17
;     236         case 21:    t_max_rabochee++;    break;
_0x19:
	CPI  R30,LOW(0x15)
	BRNE _0x1A
	LDS  R30,_t_max_rabochee
	SUBI R30,-LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x17
;     237         case 22:    t_min_rabochee++;    break;
_0x1A:
	CPI  R30,LOW(0x16)
	BRNE _0x1B
	LDS  R30,_t_min_rabochee
	SUBI R30,-LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x17
;     238         case 31:    time_rabota_ch++;    break;
_0x1B:
	CPI  R30,LOW(0x1F)
	BRNE _0x1C
	LDS  R30,_time_rabota_ch
	SUBI R30,-LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x17
;     239         case 32:    time_rabota_min++;   break;
_0x1C:
	CPI  R30,LOW(0x20)
	BRNE _0x1D
	LDS  R30,_time_rabota_min
	SUBI R30,-LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x17
;     240         case 41:    time_smoke_ch++;     break;
_0x1D:
	CPI  R30,LOW(0x29)
	BRNE _0x1E
	LDS  R30,_time_smoke_ch
	SUBI R30,-LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x17
;     241         case 42:    time_smoke_min++;    break;
_0x1E:
	CPI  R30,LOW(0x2A)
	BRNE _0x20
	LDS  R30,_time_smoke_min
	SUBI R30,-LOW(1)
	STS  _time_smoke_min,R30
;     242         default    :    {};
_0x20:
;     243     }
_0x17:
;     244 }
	RET
;     245 
;     246 // Реакция на нажатие кнопки вниз
;     247 void vniz (void)
;     248 {
_vniz:
;     249     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     250     {
;     251         case 11:	t_max_razogrev--;	break;
	BRNE _0x24
	LDS  R30,_t_max_razogrev
	SUBI R30,LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x23
;     252         case 12:	t_min_razogrev--;	break;
_0x24:
	CPI  R30,LOW(0xC)
	BRNE _0x25
	LDS  R30,_t_min_razogrev
	SUBI R30,LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x23
;     253         case 21:	t_max_rabochee--;	break;
_0x25:
	CPI  R30,LOW(0x15)
	BRNE _0x26
	LDS  R30,_t_max_rabochee
	SUBI R30,LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x23
;     254         case 22:	t_min_rabochee--;	break;
_0x26:
	CPI  R30,LOW(0x16)
	BRNE _0x27
	LDS  R30,_t_min_rabochee
	SUBI R30,LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x23
;     255         case 31:	time_rabota_ch--;	break;
_0x27:
	CPI  R30,LOW(0x1F)
	BRNE _0x28
	LDS  R30,_time_rabota_ch
	SUBI R30,LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x23
;     256         case 32:	time_rabota_min--;	break;
_0x28:
	CPI  R30,LOW(0x20)
	BRNE _0x29
	LDS  R30,_time_rabota_min
	SUBI R30,LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x23
;     257         case 41:	time_smoke_ch--;	break;
_0x29:
	CPI  R30,LOW(0x29)
	BRNE _0x2A
	LDS  R30,_time_smoke_ch
	SUBI R30,LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x23
;     258         case 42:	time_smoke_min--;	break;
_0x2A:
	CPI  R30,LOW(0x2A)
	BRNE _0x2C
	LDS  R30,_time_smoke_min
	SUBI R30,LOW(1)
	STS  _time_smoke_min,R30
;     259         default	:	{};
_0x2C:
;     260     }
_0x23:
;     261 }
	RET
;     262 
;     263 // Реакция на нажатие кнопки вправо
;     264 void vpravo(void)
;     265 {
_vpravo:
;     266     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     267     {
;     268         case 11:	regim_rabot = 12;	break;
	BRNE _0x30
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     269         case 12:	regim_rabot = 21;	break;
_0x30:
	CPI  R30,LOW(0xC)
	BRNE _0x31
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     270         case 21:	regim_rabot = 22;	break;
_0x31:
	CPI  R30,LOW(0x15)
	BRNE _0x32
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     271         case 22:	regim_rabot = 31;	break;
_0x32:
	CPI  R30,LOW(0x16)
	BRNE _0x33
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     272         case 31:	regim_rabot = 32;	break;
_0x33:
	CPI  R30,LOW(0x1F)
	BRNE _0x34
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     273         case 32:	regim_rabot = 41;	break;
_0x34:
	CPI  R30,LOW(0x20)
	BRNE _0x35
	LDI  R30,LOW(41)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     274         case 41:	regim_rabot = 42;	break;
_0x35:
	CPI  R30,LOW(0x29)
	BRNE _0x36
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x6
	RJMP _0x2F
;     275         case 42:	regim_rabot = 11;	break;
_0x36:
	CPI  R30,LOW(0x2A)
	BRNE _0x38
	RCALL SUBOPT_0x7
;     276         default	:	{};
_0x38:
;     277     }
_0x2F:
;     278 }
	RET
;     279 
;     280 // Реакция на нажатие кнопки влево
;     281 void vlevo(void)
;     282 {
_vlevo:
;     283     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     284     {
;     285         case 11:	regim_rabot = 42;	break;
	BRNE _0x3C
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     286         case 12:	regim_rabot = 11;	break;
_0x3C:
	CPI  R30,LOW(0xC)
	BRNE _0x3D
	RCALL SUBOPT_0x7
	RJMP _0x3B
;     287         case 21:	regim_rabot = 12;	break;
_0x3D:
	CPI  R30,LOW(0x15)
	BRNE _0x3E
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     288         case 22:	regim_rabot = 21;	break;
_0x3E:
	CPI  R30,LOW(0x16)
	BRNE _0x3F
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     289         case 31:	regim_rabot = 22;	break;
_0x3F:
	CPI  R30,LOW(0x1F)
	BRNE _0x40
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     290         case 32:	regim_rabot = 31;	break;
_0x40:
	CPI  R30,LOW(0x20)
	BRNE _0x41
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     291         case 41:	regim_rabot = 32;	break;
_0x41:
	CPI  R30,LOW(0x29)
	BRNE _0x42
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x6
	RJMP _0x3B
;     292         case 42:	regim_rabot = 41;	break;
_0x42:
	CPI  R30,LOW(0x2A)
	BRNE _0x44
	LDI  R30,LOW(41)
	RCALL SUBOPT_0x6
;     293         default	:	{};
_0x44:
;     294     }
_0x3B:
;     295 }
	RET
;     296 // Реакция на нажатие кнопки enter
;     297 void enter(void)
;     298 {
_enter:
;     299     switch(regim_rabot)
	RCALL SUBOPT_0x5
;     300     {
;     301         case 11:	regim_rabot = 60;	break;
	BRNE _0x48
	RCALL SUBOPT_0x8
	RJMP _0x47
;     302         case 12:	regim_rabot = 60;	break;
_0x48:
	CPI  R30,LOW(0xC)
	BRNE _0x49
	RCALL SUBOPT_0x8
	RJMP _0x47
;     303         case 21:	regim_rabot = 60;	break;
_0x49:
	CPI  R30,LOW(0x15)
	BRNE _0x4A
	RCALL SUBOPT_0x8
	RJMP _0x47
;     304         case 22:	regim_rabot = 60;	break;
_0x4A:
	CPI  R30,LOW(0x16)
	BRNE _0x4B
	RCALL SUBOPT_0x8
	RJMP _0x47
;     305         case 31:	regim_rabot = 60;	break;
_0x4B:
	CPI  R30,LOW(0x1F)
	BRNE _0x4C
	RCALL SUBOPT_0x8
	RJMP _0x47
;     306         case 32:	regim_rabot = 60;	break;
_0x4C:
	CPI  R30,LOW(0x20)
	BRNE _0x4D
	RCALL SUBOPT_0x8
	RJMP _0x47
;     307         case 41:	regim_rabot = 60;	break;
_0x4D:
	CPI  R30,LOW(0x29)
	BRNE _0x4E
	RCALL SUBOPT_0x8
	RJMP _0x47
;     308         case 42:	regim_rabot = 60;	break;
_0x4E:
	CPI  R30,LOW(0x2A)
	BRNE _0x50
	RCALL SUBOPT_0x8
;     309         default	:	{};
_0x50:
;     310     }
_0x47:
;     311 }
	RET
;     312 
;     313 // Реакция на нажатие кнопки esc
;     314 void esc(void)
;     315 {
_esc:
;     316     regim_rabot        = 11;
	RCALL SUBOPT_0x7
;     317     real_time_ch       = 0;      // текущее время работы в часах
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
;     318     real_time_min      = 0;      // текущее время работы в минутах
	STS  _real_time_min,R30
;     319     real_time_sek      = 0;      // текущее время работы в минутах
	STS  _real_time_sek,R30
;     320 }
	RET
;     321 
;     322 // проверка нажатия кнопок
;     323 void klaviatura(void)
;     324 {
_klaviatura:
;     325         if (PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x51
;     326             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     327             vverh();
	RCALL _vverh
;     328             }
;     329         if (PINC.1==0) {
_0x51:
	SBIC 0x13,1
	RJMP _0x52
;     330             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     331             vlevo();
	RCALL _vlevo
;     332             }
;     333         if (PINC.2==0) {
_0x52:
	SBIC 0x13,2
	RJMP _0x53
;     334             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     335             vniz();
	RCALL _vniz
;     336             }
;     337         if (PINC.3==0) {
_0x53:
	SBIC 0x13,3
	RJMP _0x54
;     338             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     339             vpravo();
	RCALL _vpravo
;     340             }
;     341         if (PINC.4==0) {
_0x54:
	SBIC 0x13,4
	RJMP _0x55
;     342             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     343             enter();
	RCALL _enter
;     344             }
;     345         if (PINC.5==0) {
_0x55:
	SBIC 0x13,5
	RJMP _0x56
;     346             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x9
;     347             esc();
	RCALL _esc
;     348             }
;     349 }
_0x56:
	RET
;     350 
;     351 //=================================================
;     352 void screen(void)
;     353 {
_screen:
;     354     lcd_clear();          	// очистка ЛСД
	RCALL _lcd_clear
;     355 
;     356     lcd_gotoxy(0,0);      	// установка курсора на 0,0
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xA
	RCALL _lcd_gotoxy
;     357     lcd_puts(lcd_str_1);
	RCALL SUBOPT_0xB
	RCALL _lcd_puts
;     358 
;     359     lcd_gotoxy(0,1);      	// установка курсора на начало второй строки
	RCALL SUBOPT_0xA
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
;     360     lcd_puts(lcd_str_2);
	RCALL SUBOPT_0xC
	RCALL _lcd_puts
;     361 
;     362 
;     363 }
	RET
;     364 
;     365 //==================================================
;     366 void frame(void)
;     367 {
_frame:
;     368     switch(regim_rabot)
	LDS  R30,_regim_rabot
;     369     {
;     370         case 1		:
	CPI  R30,LOW(0x1)
	BRNE _0x5A
;     371 #pragma rl+
;     372             sprintf(lcd_str_1,"Коптильня");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,0
	RCALL SUBOPT_0xD
;     373 #pragma rl-
;     374             sprintf(lcd_str_2,"v.2.0 ru");
	RCALL SUBOPT_0xC
	__POINTW1FN _0,10
	RCALL SUBOPT_0xD
;     375             delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RJMP _0x165
;     376             break;
;     377         case 11		:
_0x5A:
	CPI  R30,LOW(0xB)
	BRNE _0x5B
;     378 #pragma rl+
;     379             sprintf(lcd_str_1,"Макс Т разогрева");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,19
	RCALL SUBOPT_0xD
;     380 #pragma rl-
;     381             sprintf(lcd_str_2,"%c%c%c",
;     382             (t_max_razogrev/100)%10 +0x30,
;     383             (t_max_razogrev/10)%10  +0x30,
;     384             t_max_razogrev%10       +0x30
;     385             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0xF
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x10
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x11
;     386             break;
	RJMP _0x59
;     387         case 12	    :
_0x5B:
	CPI  R30,LOW(0xC)
	BRNE _0x5C
;     388 #pragma rl+
;     389             sprintf(lcd_str_1,"Мин Т разогрева");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,43
	RCALL SUBOPT_0xD
;     390 #pragma rl-
;     391             sprintf(lcd_str_2,"%c%c%c",
;     392             (t_min_razogrev/100)%10 +0x30,
;     393             (t_min_razogrev/10)%10  +0x30,
;     394             t_min_razogrev%10       +0x30
;     395             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0xF
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x10
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x11
;     396             break;
	RJMP _0x59
;     397         case 21		:
_0x5C:
	CPI  R30,LOW(0x15)
	BRNE _0x5D
;     398 #pragma rl+
;     399             sprintf(lcd_str_1,"Макс Т работы");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,59
	RCALL SUBOPT_0xD
;     400 #pragma rl-
;     401             sprintf(lcd_str_2,"%c%c%c",
;     402             (t_max_rabochee/100)%10 +0x30,
;     403             (t_max_rabochee/10)%10  +0x30,
;     404             t_max_rabochee%10       +0x30
;     405             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0xF
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x10
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x11
;     406             break;
	RJMP _0x59
;     407         case 22		:
_0x5D:
	CPI  R30,LOW(0x16)
	BRNE _0x5E
;     408 #pragma rl+
;     409             sprintf(lcd_str_1,"Мин Т работы");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,73
	RCALL SUBOPT_0xD
;     410 #pragma rl-
;     411             sprintf(lcd_str_2,"%c%c%c",
;     412             (t_min_rabochee/100)%10 +0x30,
;     413             (t_min_rabochee/10)%10  +0x30,
;     414             t_min_rabochee%10       +0x30
;     415             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0xF
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x10
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x11
;     416             break;
	RJMP _0x59
;     417         case 31		:
_0x5E:
	CPI  R30,LOW(0x1F)
	BRNE _0x5F
;     418 #pragma rl+
;     419             sprintf(lcd_str_1,"Вр. работы, часы");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,86
	RCALL SUBOPT_0xD
;     420 #pragma rl-
;     421             sprintf(lcd_str_2,"%c%c",
;     422             (time_rabota_ch/10)%10  +0x30,
;     423             time_rabota_ch%10       +0x30
;     424             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x12
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x10
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x13
;     425             break;
	RJMP _0x59
;     426         case 32		:
_0x5F:
	CPI  R30,LOW(0x20)
	BRNE _0x60
;     427 #pragma rl+
;     428             sprintf(lcd_str_1,"Вр. работы, мин.");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,103
	RCALL SUBOPT_0xD
;     429 #pragma rl-
;     430             sprintf(lcd_str_2,"%c%c",
;     431             (time_rabota_min/10)%10 +0x30,
;     432             time_rabota_min%10      +0x30
;     433             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x12
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x10
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x13
;     434             break;
	RJMP _0x59
;     435         case 41		:
_0x60:
	CPI  R30,LOW(0x29)
	BRNE _0x61
;     436 #pragma rl+
;     437             sprintf(lcd_str_1,"Вр. дым, часы");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,120
	RCALL SUBOPT_0xD
;     438 #pragma rl-
;     439             sprintf(lcd_str_2,"%c%c",
;     440             (time_smoke_ch/10)%10   +0x30,
;     441             time_smoke_ch%10        +0x30
;     442             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x12
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x10
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x13
;     443             break;
	RJMP _0x59
;     444         case 42		:
_0x61:
	CPI  R30,LOW(0x2A)
	BRNE _0x62
;     445 #pragma rl+
;     446             sprintf(lcd_str_1,"Вр. дым, минуты");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,134
	RCALL SUBOPT_0xD
;     447 #pragma rl-
;     448             sprintf(lcd_str_2,"%c%c",
;     449             (time_smoke_min/10)%10  +0x30,
;     450             time_smoke_min%10       +0x30
;     451             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x12
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x10
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x13
;     452             break;
	RJMP _0x59
;     453         case 60		:
_0x62:
	CPI  R30,LOW(0x3C)
	BRNE _0x63
;     454 #pragma rl+
;     455             sprintf(lcd_str_1,"    РАЗОГРЕВ");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,150
	RCALL SUBOPT_0xD
;     456 #pragma rl-
;     457             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     458 
;     459 
;     460             (real_time_ch/10)%10	+0x30,
;     461             real_time_ch%10		    +0x30,
;     462             (real_time_min/10)%10	+0x30,
;     463             real_time_min%10		+0x30,
;     464             (real_time_sek/10)%10	+0x30,
;     465             real_time_sek%10		+0x30,
;     466 
;     467             real_temp_1razryad,
;     468             real_temp_2razryad,
;     469             real_temp_3razryad
;     470             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
;     471             break;
	RJMP _0x59
;     472         case 70		:
_0x63:
	CPI  R30,LOW(0x46)
	BRNE _0x64
;     473 #pragma rl+
;     474             sprintf(lcd_str_1,"     РАБОТА");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,189
	RCALL SUBOPT_0xD
;     475 #pragma rl-
;     476             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     477             (real_time_ch/10)%10	+0x30,
;     478             real_time_ch%10         +0x30,
;     479             (real_time_min/10)%10	+0x30,
;     480             real_time_min%10		+0x30,
;     481             (real_time_sek/10)%10	+0x30,
;     482             real_time_sek%10		+0x30,
;     483 
;     484             real_temp_1razryad,
;     485             real_temp_2razryad,
;     486             real_temp_3razryad
;     487             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
;     488             break;
	RJMP _0x59
;     489         case 80		:
_0x64:
	CPI  R30,LOW(0x50)
	BRNE _0x65
;     490 #pragma rl+
;     491             sprintf(lcd_str_1,"    ВЫТЯЖКА");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,201
	RCALL SUBOPT_0xD
;     492 #pragma rl-
;     493             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     494             (real_time_ch/10)%10	+0x30,
;     495             real_time_ch%10             +0x30,
;     496             (real_time_min/10)%10	+0x30,
;     497             real_time_min%10		+0x30,
;     498             (real_time_sek/10)%10	+0x30,
;     499             real_time_sek%10		+0x30,
;     500 
;     501             real_temp_1razryad,
;     502             real_temp_2razryad,
;     503             real_temp_3razryad
;     504             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
;     505             break;
	RJMP _0x59
;     506         case 100	:
_0x65:
	CPI  R30,LOW(0x64)
	BRNE _0x67
;     507 #pragma rl+
;     508             sprintf(lcd_str_1,"      СТОП");
	RCALL SUBOPT_0xB
	__POINTW1FN _0,213
	RCALL SUBOPT_0xD
;     509 #pragma rl-
;     510             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
;     511             (real_time_ch/10)%10	+0x30,
;     512             real_time_ch%10             +0x30,
;     513             (real_time_min/10)%10	+0x30,
;     514             real_time_min%10		+0x30,
;     515             (real_time_sek/10)%10	+0x30,
;     516             real_time_sek%10		+0x30,
;     517 
;     518             real_temp_1razryad,
;     519             real_temp_2razryad,
;     520             real_temp_3razryad
;     521             );
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
;     522             break;
	RJMP _0x59
;     523 
;     524         default	    :
_0x67:
;     525             lcd_putsf("www.xxx.ua");
	__POINTW1FN _0,224
	RCALL SUBOPT_0x18
	RCALL _lcd_putsf
;     526             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x18
_0x165:
	RCALL _delay_ms
;     527             break;
;     528     }
_0x59:
;     529 }
	RET
;     530 //=================================================
;     531 void regim(void)
;     532 {
_regim:
;     533 
;     534 //       regim_rabot_old = regim_rabot;
;     535 
;     536         switch(regim_rabot)
	LDS  R30,_regim_rabot
;     537         {
;     538         case 1		:
	CPI  R30,LOW(0x1)
	BRNE _0x6B
;     539                 blok_lamp_1_OFF         ;
	RJMP _0x166
;     540                 blok_lamp_2_OFF         ;
;     541                 blok_lamp_3_OFF         ;
;     542                 blok_lamp_en_OFF        ;
;     543                 blok_lamp_dis_OFF       ;
;     544                 blok_silovoy_en_OFF     ;
;     545                 blok_silovoy_dis_OFF    ;
;     546                 blok_rezerv_OFF         ;
;     547             break;
;     548         case 11		:
_0x6B:
	CPI  R30,LOW(0xB)
	BRNE _0x6C
;     549             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x6E
	RCALL SUBOPT_0x1A
	BRNE _0x6E
	RCALL SUBOPT_0x1B
	BRNE _0x6E
	RCALL SUBOPT_0x1C
	BRNE _0x6E
	LDI  R30,0
	RJMP _0x6F
_0x6E:
	LDI  R30,1
_0x6F:
	RCALL SUBOPT_0x1D
	BRNE _0x6D
;     550             {
;     551                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     552                 blok_lamp_2_OFF         ;
;     553                 blok_lamp_3_OFF         ;
;     554                 blok_lamp_en_OFF        ;
;     555                 blok_lamp_dis_OFF       ;
;     556                 blok_silovoy_en_OFF     ;
;     557                 blok_silovoy_dis_OFF    ;
;     558                 blok_rezerv_OFF         ;
;     559             }
;     560             break;
_0x6D:
	RJMP _0x6A
;     561         case 12         :
_0x6C:
	CPI  R30,LOW(0xC)
	BRNE _0x70
;     562             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x72
	RCALL SUBOPT_0x1A
	BRNE _0x72
	RCALL SUBOPT_0x1B
	BRNE _0x72
	RCALL SUBOPT_0x1C
	BRNE _0x72
	LDI  R30,0
	RJMP _0x73
_0x72:
	LDI  R30,1
_0x73:
	RCALL SUBOPT_0x1D
	BRNE _0x71
;     563             {
;     564                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     565                 blok_lamp_2_OFF         ;
;     566                 blok_lamp_3_OFF         ;
;     567                 blok_lamp_en_OFF        ;
;     568                 blok_lamp_dis_OFF       ;
;     569                 blok_silovoy_en_OFF     ;
;     570                 blok_silovoy_dis_OFF    ;
;     571                 blok_rezerv_OFF         ;
;     572             }
;     573             break;
_0x71:
	RJMP _0x6A
;     574         case 21		:
_0x70:
	CPI  R30,LOW(0x15)
	BRNE _0x74
;     575             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x76
	RCALL SUBOPT_0x1A
	BRNE _0x76
	RCALL SUBOPT_0x1B
	BRNE _0x76
	RCALL SUBOPT_0x1C
	BRNE _0x76
	LDI  R30,0
	RJMP _0x77
_0x76:
	LDI  R30,1
_0x77:
	RCALL SUBOPT_0x1D
	BRNE _0x75
;     576             {
;     577                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     578                 blok_lamp_2_OFF         ;
;     579                 blok_lamp_3_OFF         ;
;     580                 blok_lamp_en_OFF        ;
;     581                 blok_lamp_dis_OFF       ;
;     582                 blok_silovoy_en_OFF     ;
;     583                 blok_silovoy_dis_OFF    ;
;     584                 blok_rezerv_OFF         ;
;     585             }
;     586             break;
_0x75:
	RJMP _0x6A
;     587         case 22		:
_0x74:
	CPI  R30,LOW(0x16)
	BRNE _0x78
;     588             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x7A
	RCALL SUBOPT_0x1A
	BRNE _0x7A
	RCALL SUBOPT_0x1B
	BRNE _0x7A
	RCALL SUBOPT_0x1C
	BRNE _0x7A
	LDI  R30,0
	RJMP _0x7B
_0x7A:
	LDI  R30,1
_0x7B:
	RCALL SUBOPT_0x1D
	BRNE _0x79
;     589             {
;     590                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     591                 blok_lamp_2_OFF         ;
;     592                 blok_lamp_3_OFF         ;
;     593                 blok_lamp_en_OFF        ;
;     594                 blok_lamp_dis_OFF       ;
;     595                 blok_silovoy_en_OFF     ;
;     596                 blok_silovoy_dis_OFF    ;
;     597                 blok_rezerv_OFF         ;
;     598             }
;     599             break;
_0x79:
	RJMP _0x6A
;     600         case 31		:
_0x78:
	CPI  R30,LOW(0x1F)
	BRNE _0x7C
;     601             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x7E
	RCALL SUBOPT_0x1A
	BRNE _0x7E
	RCALL SUBOPT_0x1B
	BRNE _0x7E
	RCALL SUBOPT_0x1C
	BRNE _0x7E
	LDI  R30,0
	RJMP _0x7F
_0x7E:
	LDI  R30,1
_0x7F:
	RCALL SUBOPT_0x1D
	BRNE _0x7D
;     602             {
;     603                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     604                 blok_lamp_2_OFF         ;
;     605                 blok_lamp_3_OFF         ;
;     606                 blok_lamp_en_OFF        ;
;     607                 blok_lamp_dis_OFF       ;
;     608                 blok_silovoy_en_OFF     ;
;     609                 blok_silovoy_dis_OFF    ;
;     610                 blok_rezerv_OFF         ;
;     611             }
;     612             break;
_0x7D:
	RJMP _0x6A
;     613         case 32		:
_0x7C:
	CPI  R30,LOW(0x20)
	BRNE _0x80
;     614             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x82
	RCALL SUBOPT_0x1A
	BRNE _0x82
	RCALL SUBOPT_0x1B
	BRNE _0x82
	RCALL SUBOPT_0x1C
	BRNE _0x82
	LDI  R30,0
	RJMP _0x83
_0x82:
	LDI  R30,1
_0x83:
	RCALL SUBOPT_0x1D
	BRNE _0x81
;     615             {
;     616                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     617                 blok_lamp_2_OFF         ;
;     618                 blok_lamp_3_OFF         ;
;     619                 blok_lamp_en_OFF        ;
;     620                 blok_lamp_dis_OFF       ;
;     621                 blok_silovoy_en_OFF     ;
;     622                 blok_silovoy_dis_OFF    ;
;     623                 blok_rezerv_OFF         ;
;     624             }
;     625             break;
_0x81:
	RJMP _0x6A
;     626         case 41		:
_0x80:
	CPI  R30,LOW(0x29)
	BRNE _0x84
;     627             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x86
	RCALL SUBOPT_0x1A
	BRNE _0x86
	RCALL SUBOPT_0x1B
	BRNE _0x86
	RCALL SUBOPT_0x1C
	BRNE _0x86
	LDI  R30,0
	RJMP _0x87
_0x86:
	LDI  R30,1
_0x87:
	RCALL SUBOPT_0x1D
	BRNE _0x85
;     628             {
;     629                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     630                 blok_lamp_2_OFF         ;
;     631                 blok_lamp_3_OFF         ;
;     632                 blok_lamp_en_OFF        ;
;     633                 blok_lamp_dis_OFF       ;
;     634                 blok_silovoy_en_OFF     ;
;     635                 blok_silovoy_dis_OFF    ;
;     636                 blok_rezerv_OFF         ;
;     637             }
;     638             break;
_0x85:
	RJMP _0x6A
;     639         case 42		:
_0x84:
	CPI  R30,LOW(0x2A)
	BRNE _0x88
;     640             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x8A
	RCALL SUBOPT_0x1A
	BRNE _0x8A
	RCALL SUBOPT_0x1B
	BRNE _0x8A
	RCALL SUBOPT_0x1C
	BRNE _0x8A
	LDI  R30,0
	RJMP _0x8B
_0x8A:
	LDI  R30,1
_0x8B:
	RCALL SUBOPT_0x1D
	BRNE _0x89
;     641             {
;     642                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x1E
;     643                 blok_lamp_2_OFF         ;
;     644                 blok_lamp_3_OFF         ;
;     645                 blok_lamp_en_OFF        ;
;     646                 blok_lamp_dis_OFF       ;
;     647                 blok_silovoy_en_OFF     ;
;     648                 blok_silovoy_dis_OFF    ;
;     649                 blok_rezerv_OFF         ;
;     650             }
;     651             break;
_0x89:
	RJMP _0x6A
;     652         case 60		:
_0x88:
	CPI  R30,LOW(0x3C)
	BRNE _0x8C
;     653             if (regim_rabot_old==(11||12||21||22||31||31||41||42))
	LDI  R30,LOW(11)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(12)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(21)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(22)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(31)
	CPI  R30,0
	BRNE _0x8E
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(41)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,LOW(42)
	CPI  R30,0
	BRNE _0x8E
	LDI  R30,0
	RJMP _0x8F
_0x8E:
	LDI  R30,1
_0x8F:
	RCALL SUBOPT_0x1D
	BRNE _0x8D
;     654             {
;     655                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x1F
;     656                 blok_lamp_2_ON         ;
;     657                 blok_lamp_3_ON         ;
;     658                 blok_lamp_dis_OFF      ;
	RCALL SUBOPT_0x20
;     659                 blok_silovoy_en_OFF    ;
;     660                 blok_silovoy_dis_OFF   ;
;     661                 blok_rezerv_OFF        ;
;     662 
;     663                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x21
;     664                 delay_ms(t_puskatel)   ;
;     665                 blok_lamp_en_OFF       ;
	CBI  0x1B,3
;     666             }
;     667             if (real_temp<t_max_razogrev)
_0x8D:
	LDS  R30,_t_max_razogrev
	LDS  R26,_real_temp
	CP   R26,R30
	BRSH _0x90
;     668             {
;     669                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x21
;     670                 delay_ms(t_puskatel)   ;
;     671             }
;     672 
;     673                 blok_lamp_1_ON         ;
_0x90:
	RCALL SUBOPT_0x1F
;     674                 blok_lamp_2_ON         ;
;     675                 blok_lamp_3_ON         ;
;     676                 blok_lamp_en_OFF      ;
	CBI  0x1B,3
;     677             break;
	RJMP _0x6A
;     678         case 70		:
_0x8C:
	CPI  R30,LOW(0x46)
	BRNE _0x91
;     679                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x1F
;     680                 blok_lamp_2_ON         ;
;     681                 blok_lamp_3_ON         ;
;     682 
;     683                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
;     684             break;
	RJMP _0x6A
;     685         case 80		:
_0x91:
	CPI  R30,LOW(0x50)
	BRNE _0x92
;     686                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x1F
;     687                 blok_lamp_2_ON         ;
;     688                 blok_lamp_3_ON         ;
;     689 
;     690                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
;     691             break;
	RJMP _0x6A
;     692         case 100	:
_0x92:
	CPI  R30,LOW(0x64)
	BREQ _0x166
;     693                 blok_lamp_1_OFF         ;
;     694                 blok_lamp_2_OFF         ;
;     695                 blok_lamp_3_OFF         ;
;     696                 blok_lamp_en_OFF        ;
;     697                 blok_lamp_dis_OFF       ;
;     698                 blok_silovoy_en_OFF     ;
;     699                 blok_silovoy_dis_OFF    ;
;     700                 blok_rezerv_OFF         ;
;     701             break;
;     702         default	    :
;     703             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x19
	BRNE _0x96
	RCALL SUBOPT_0x1A
	BRNE _0x96
	RCALL SUBOPT_0x1B
	BRNE _0x96
	RCALL SUBOPT_0x1C
	BRNE _0x96
	LDI  R30,0
	RJMP _0x97
_0x96:
	LDI  R30,1
_0x97:
	RCALL SUBOPT_0x1D
	BRNE _0x95
;     704             {
;     705                 blok_lamp_1_OFF         ;
_0x166:
	CBI  0x1B,0
;     706                 blok_lamp_2_OFF         ;
	CBI  0x1B,1
;     707                 blok_lamp_3_OFF         ;
	CBI  0x1B,2
;     708                 blok_lamp_en_OFF        ;
	CBI  0x1B,3
;     709                 blok_lamp_dis_OFF       ;
	RCALL SUBOPT_0x20
;     710                 blok_silovoy_en_OFF     ;
;     711                 blok_silovoy_dis_OFF    ;
;     712                 blok_rezerv_OFF         ;
;     713             }
;     714             break;
_0x95:
;     715         };
_0x6A:
;     716 
;     717         regim_rabot_old = regim_rabot;
	LDS  R30,_regim_rabot
	STS  _regim_rabot_old,R30
;     718 }
	RET
;     719 //=================================================
;     720 void init(void)
;     721 {
_init:
;     722 // Port A initialization
;     723     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     724     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
;     725 // Port B initialization
;     726     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     727     DDRB=0x00;
	OUT  0x17,R30
;     728 
;     729 // Инициализация порта клавиатуры.
;     730 // Port C initialization
;     731     PORTC=0xFF;         // вкл. подтягивающие резисторы
	LDI  R30,LOW(255)
	OUT  0x15,R30
;     732     DDRC=0x00;          // весь порт как вход
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     733 
;     734 // Timer/Counter 1 initialization
;     735 // Clock source: System Clock
;     736 // Clock value: 7,813 kHz
;     737 // Mode: Normal top=FFFFh
;     738 // OC1A output: Discon.
;     739 // OC1B output: Discon.
;     740 // Noise Canceler: Off
;     741 // Input Capture on Falling Edge
;     742 // Timer 1 Overflow Interrupt: Off
;     743 // Input Capture Interrupt: Off
;     744 // Compare A Match Interrupt: On
;     745 // Compare B Match Interrupt: Off
;     746     TCCR1A=0x00;
	OUT  0x2F,R30
;     747     TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     748     TCNT1H=0x00;
	RCALL SUBOPT_0x1
;     749     TCNT1L=0x00;
;     750     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
;     751     ICR1L=0x00;
	OUT  0x26,R30
;     752     OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
;     753     OCR1AL=0x85;
	LDI  R30,LOW(133)
	OUT  0x2A,R30
;     754     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;     755     OCR1BL=0x00;
	OUT  0x28,R30
;     756 
;     757 // Timer(s)/Counter(s) Interrupt(s) initialization
;     758     TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
;     759 
;     760 //=================================================
;     761 // USART initialization
;     762 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     763 // USART Receiver: On
;     764 // USART Transmitter: On
;     765 // USART Mode: Asynchronous
;     766 // USART Baud Rate: 38400
;     767     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     768     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     769     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     770     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     771     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     772 //=================================================
;     773 // LCD module initialization
;     774     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
;     775 }
	RET
;     776 
;     777 void main(void)
;     778 {
_main:
;     779     init();
	RCALL _init
;     780 
;     781     regim_rabot=1;             // Заставка
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
;     782     frame();
	RCALL _frame
;     783     screen();
	RCALL _screen
;     784 
;     785     delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RCALL _delay_ms
;     786 
;     787     regim_rabot=11;            // Установка режима работ на задание температуры
	RCALL SUBOPT_0x7
;     788 
;     789     frame();
	RCALL _frame
;     790     screen();
	RCALL _screen
;     791 
;     792     #asm("sei")                // Разрешение прерываний
	sei
;     793 
;     794     while(1)                   // Вечный цикл
_0x98:
;     795     {
;     796         klaviatura();          // обработка нажатой кнопки
	RCALL _klaviatura
;     797 
;     798         regim();
	RCALL _regim
;     799 
;     800 /*
;     801         if (getchar()=='#')
;     802         {
;     803                 real_temp_1razryad = getchar();      // 1 разряд температуры при отображении
;     804                 real_temp_2razryad = getchar();      // 2 разряд температуры при отображении
;     805                 real_temp_3razryad = getchar();      // 3 разряд температуры при отображении
;     806 
;     807                 real_temp=(real_temp_1razryad*100+real_temp_2razryad*10+real_temp_3razryad);
;     808         }
;     809 */
;     810         frame();
	RCALL _frame
;     811         screen();
	RCALL _screen
;     812     }
	RJMP _0x98
;     813 }
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
	BREQ _0xA9
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xAB
	__CPWRN 16,17,2
	BRLO _0xAC
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
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
	CPI  R30,0
	BRNE _0xB4
	CPI  R18,37
	BRNE _0xB5
	LDI  R17,LOW(1)
	RJMP _0xB6
_0xB5:
	RCALL SUBOPT_0x22
_0xB6:
	RJMP _0xB3
_0xB4:
	CPI  R30,LOW(0x1)
	BRNE _0xB7
	CPI  R18,37
	BRNE _0xB8
	RCALL SUBOPT_0x22
	RJMP _0x167
_0xB8:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0xB9
	LDI  R16,LOW(1)
	RJMP _0xB3
_0xB9:
	CPI  R18,43
	BRNE _0xBA
	LDI  R20,LOW(43)
	RJMP _0xB3
_0xBA:
	CPI  R18,32
	BRNE _0xBB
	LDI  R20,LOW(32)
	RJMP _0xB3
_0xBB:
	RJMP _0xBC
_0xB7:
	CPI  R30,LOW(0x2)
	BRNE _0xBD
_0xBC:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0xBE
	ORI  R16,LOW(128)
	RJMP _0xB3
_0xBE:
	RJMP _0xBF
_0xBD:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0xB3
_0xBF:
	CPI  R18,48
	BRLO _0xC2
	CPI  R18,58
	BRLO _0xC3
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
	ADD  R21,R30
	RJMP _0xB3
_0xC1:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0xC7
	RCALL SUBOPT_0x23
	LD   R30,X
	RCALL SUBOPT_0x24
	RJMP _0xC8
_0xC7:
	CPI  R30,LOW(0x73)
	BRNE _0xCA
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL _strlen
	MOV  R17,R30
	RJMP _0xCB
_0xCA:
	CPI  R30,LOW(0x70)
	BRNE _0xCD
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x25
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0xCB:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0xCE
_0xCD:
	CPI  R30,LOW(0x64)
	BREQ _0xD1
	CPI  R30,LOW(0x69)
	BRNE _0xD2
_0xD1:
	ORI  R16,LOW(4)
	RJMP _0xD3
_0xD2:
	CPI  R30,LOW(0x75)
	BRNE _0xD4
_0xD3:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	RCALL SUBOPT_0x26
	LDI  R17,LOW(5)
	RJMP _0xD5
_0xD4:
	CPI  R30,LOW(0x58)
	BRNE _0xD7
	ORI  R16,LOW(8)
	RJMP _0xD8
_0xD7:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x109
_0xD8:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	RCALL SUBOPT_0x26
	LDI  R17,LOW(4)
_0xD5:
	SBRS R16,2
	RJMP _0xDA
	RCALL SUBOPT_0x23
	RCALL __GETW1P
	RCALL SUBOPT_0x27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0xDB
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x27
	LDI  R20,LOW(45)
_0xDB:
	CPI  R20,0
	BREQ _0xDC
	SUBI R17,-LOW(1)
	RJMP _0xDD
_0xDC:
	ANDI R16,LOW(251)
_0xDD:
	RJMP _0xDE
_0xDA:
	RCALL SUBOPT_0x23
	RCALL __GETW1P
	RCALL SUBOPT_0x27
_0xDE:
_0xCE:
	SBRC R16,0
	RJMP _0xDF
_0xE0:
	CP   R17,R21
	BRSH _0xE2
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
	RCALL SUBOPT_0x22
	SUBI R21,LOW(1)
	RJMP _0xE0
_0xE2:
_0xDF:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0xE7
_0xE8:
	CPI  R19,0
	BREQ _0xEA
	SBRS R16,3
	RJMP _0xEB
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	RCALL SUBOPT_0x26
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x168
_0xEB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x168:
	ST   -Y,R30
	RCALL SUBOPT_0x28
	CPI  R21,0
	BREQ _0xED
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
	RCALL SUBOPT_0x26
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
	BRLO _0xF4
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x27
	RJMP _0xF2
_0xF4:
	CPI  R18,58
	BRLO _0xF5
	SBRS R16,3
	RJMP _0xF6
	SUBI R18,-LOW(7)
	RJMP _0xF7
_0xF6:
	SUBI R18,-LOW(39)
_0xF7:
_0xF5:
	SBRC R16,4
	RJMP _0xF9
	CPI  R18,49
	BRSH _0xFB
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0xFA
_0xFB:
	RJMP _0x169
_0xFA:
	CP   R21,R19
	BRLO _0xFF
	SBRS R16,0
	RJMP _0x100
_0xFF:
	RJMP _0xFE
_0x100:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x101
	LDI  R18,LOW(48)
_0x169:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x102
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x28
	CPI  R21,0
	BREQ _0x103
	SUBI R21,LOW(1)
_0x103:
_0x102:
_0x101:
_0xF9:
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x104
	SUBI R21,LOW(1)
_0x104:
_0xFE:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0xF1
	RJMP _0xF0
_0xF1:
_0xEE:
	SBRS R16,0
	RJMP _0x105
_0x106:
	CPI  R21,0
	BREQ _0x108
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x24
	RJMP _0x106
_0x108:
_0x105:
_0x109:
_0xC8:
_0x167:
	LDI  R17,LOW(0)
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
	RCALL SUBOPT_0x18
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x18
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
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x29
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x29
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x29
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x29
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
	BRSH _0x156
	__lcd_putchar1:
	INC  R10
	RCALL SUBOPT_0xA
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
	BREQ _0x159
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x157
_0x159:
	LDD  R17,Y+0
	RJMP _0x164
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
	BREQ _0x15C
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x15A
_0x15C:
	LDD  R17,Y+0
_0x164:
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
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2A
	RCALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G3
	RCALL __long_delay_G3
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x29
	RCALL __long_delay_G3
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x29
	RCALL __long_delay_G3
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x29
	RCALL __long_delay_G3
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x15D
	LDI  R30,LOW(0)
	RJMP _0x163
_0x15D:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x29
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x163:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDS  R30,_regim_rabot
	CPI  R30,LOW(0xB)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x6:
	STS  _regim_rabot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(11)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(60)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	MOV  R30,R7
	RCALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_lcd_str_1)
	LDI  R31,HIGH(_lcd_str_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_lcd_str_2)
	LDI  R31,HIGH(_lcd_str_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:50 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	__POINTW1FN _0,36
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF:
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
SUBOPT_0x10:
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
SUBOPT_0x11:
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
SUBOPT_0x12:
	__POINTW1FN _0,38
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x13:
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
SUBOPT_0x14:
	__POINTW1FN _0,163
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x4
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x3
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x3
	LDI  R30,LOW(10)
	RCALL __MODB21U
	SUBI R30,-LOW(48)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x2
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x17:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(60)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(70)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(80)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(100)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1D:
	LDS  R26,_regim_rabot_old
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x1E:
	CBI  0x1B,0
	CBI  0x1B,1
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,4
	CBI  0x1B,5
	CBI  0x1B,6
	CBI  0x1B,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	SBI  0x1B,0
	SBI  0x1B,1
	SBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CBI  0x1B,4
	CBI  0x1B,5
	CBI  0x1B,6
	CBI  0x1B,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	SBI  0x1B,3
	MOV  R30,R6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x18
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x22:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x18
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x18
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x18
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x18
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x28:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x18
	MOVW R30,R28
	ADIW R30,15
	RCALL SUBOPT_0x18
	RJMP __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
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
