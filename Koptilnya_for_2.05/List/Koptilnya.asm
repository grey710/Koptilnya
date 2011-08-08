
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 7,813000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_counter=R4
	.DEF _zadergka_pri_nagatii=R7
	.DEF _zadergka_zastavka=R8
	.DEF _t_puskatel=R6
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x6:
	.DB  0x73
_0x7:
	.DB  0x4B
_0x8:
	.DB  0x69
_0x9:
	.DB  0x41
_0xA:
	.DB  0x4
_0xB:
	.DB  0x1E
_0xC:
	.DB  0xA
_0xD:
	.DB  0x1
_0xE:
	.DB  0x1
_0x175:
	.DB  0x64,0xC8,0xE8,0x3
_0x0:
	.DB  0x4B,0x6F,0x70,0x74,0x69,0x6C,0x6E,0x79
	.DB  0x61,0x0,0x76,0x2E,0x31,0x2E,0x30,0x0
	.DB  0x4D,0x61,0x78,0x20,0x54,0x20,0x72,0x61
	.DB  0x7A,0x6F,0x67,0x72,0x65,0x76,0x61,0x0
	.DB  0x25,0x63,0x25,0x63,0x25,0x63,0x0,0x4D
	.DB  0x69,0x6E,0x20,0x54,0x20,0x72,0x61,0x7A
	.DB  0x6F,0x67,0x72,0x65,0x76,0x61,0x0,0x4D
	.DB  0x61,0x78,0x20,0x54,0x20,0x72,0x61,0x62
	.DB  0x6F,0x74,0x69,0x61,0x0,0x4D,0x69,0x6E
	.DB  0x20,0x54,0x20,0x72,0x61,0x62,0x6F,0x74
	.DB  0x69,0x0,0x54,0x69,0x6D,0x65,0x20,0x72
	.DB  0x61,0x62,0x6F,0x74,0x61,0x2C,0x20,0x63
	.DB  0x68,0x0,0x54,0x69,0x6D,0x65,0x20,0x72
	.DB  0x61,0x62,0x6F,0x74,0x61,0x2C,0x20,0x6D
	.DB  0x69,0x6E,0x0,0x54,0x69,0x6D,0x65,0x20
	.DB  0x73,0x6D,0x6F,0x6B,0x65,0x2C,0x20,0x63
	.DB  0x68,0x0,0x54,0x69,0x6D,0x65,0x20,0x73
	.DB  0x6D,0x6F,0x6B,0x65,0x2C,0x20,0x6D,0x69
	.DB  0x6E,0x0,0x52,0x41,0x5A,0x4F,0x47,0x52
	.DB  0x45,0x56,0xD0,0xE0,0xE7,0xEE,0xE3,0xF0
	.DB  0xE5,0xE2,0x0,0x25,0x63,0x25,0x63,0x3A
	.DB  0x25,0x63,0x25,0x63,0x3A,0x25,0x63,0x25
	.DB  0x63,0x20,0x54,0x3D,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x20,0x43,0x0,0x52,0x41,0x42
	.DB  0x4F,0x54,0x41,0x0,0x53,0x4D,0x4F,0x4B
	.DB  0x45,0x0,0x53,0x54,0x4F,0x50,0x0,0x77
	.DB  0x77,0x77,0x2E,0x78,0x78,0x78,0x2E,0x75
	.DB  0x61,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _t_max_razogrev
	.DW  _0x6*2

	.DW  0x01
	.DW  _t_max_rabochee
	.DW  _0x7*2

	.DW  0x01
	.DW  _t_min_razogrev
	.DW  _0x8*2

	.DW  0x01
	.DW  _t_min_rabochee
	.DW  _0x9*2

	.DW  0x01
	.DW  _time_rabota_ch
	.DW  _0xA*2

	.DW  0x01
	.DW  _time_rabota_min
	.DW  _0xB*2

	.DW  0x01
	.DW  _time_smoke_min
	.DW  _0xC*2

	.DW  0x01
	.DW  _regim_rabot
	.DW  _0xD*2

	.DW  0x01
	.DW  _regim_rabot_old
	.DW  _0xE*2

	.DW  0x04
	.DW  0x06
	.DW  _0x175*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
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

	.CSEG
;/*****************************************************
;CodeWizardAVR V2.05.0 Professional
;Project : Koptilnya
;Version : 1
;Date    : 14.07.2011
;
;Chip type               : ATmega8535
;AVR Core Clock frequency: 7,813000 MHz
;*****************************************************/
;// Standard Input/Output functions
;#include <mega8535.h>
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
;#include <stdio.h>
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;//Инициализация экрана
;#asm
  .equ __lcd_port=0x18 ;PORTB
; 0000 0013 #endasm
;#include <lcd.h>
;//#include "lcd_rus\lcd_rus.h"
;//=================================
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR       (1<<FE)
;#define PARITY_ERROR        (1<<UPE)
;#define DATA_OVERRUN        (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE         (1<<RXC)
;
;#define _DEBUG_TERMINAL_IO_
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;//unsigned char rx_wr_index,rx_rd_index,rx_counter;
;unsigned char rx_wr_index,rx_counter;
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;//===================================================================
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0048 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0049 char status,data;
; 0000 004A 
; 0000 004B #asm("cli")
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	cli
; 0000 004C 
; 0000 004D status=UCSRA;
	IN   R17,11
; 0000 004E data=UDR;
	IN   R16,12
; 0000 004F if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x3
; 0000 0050     {
; 0000 0051         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0052 
; 0000 0053         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x4
	CLR  R5
; 0000 0054         if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x5
; 0000 0055         {
; 0000 0056             rx_counter=0;
	CLR  R4
; 0000 0057             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0058         }
; 0000 0059     }
_0x5:
; 0000 005A #asm("sei")
_0x3:
	sei
; 0000 005B }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;
;#pragma used+
;
;char getchar(void)
;{
;    char data;
;    while (rx_counter==0);
;    data=rx_buffer[rx_rd_index++];
;
;    #asm("cli")
;    --rx_counter;
;    #asm("sei")
;    return data;
;}
;
;#pragma used-
;#endif
;
;//=============================================================================
;// управление в режимах
;//порты подключения управляющих реле
;#define blok_lamp_1_ON         PORTA.0 = 1    //Включатель/выключатель первого блока ламп
;#define blok_lamp_2_ON         PORTA.1 = 1    //Включатель/выключатель второго блока ламп
;#define blok_lamp_3_ON         PORTA.2 = 1    //Включатель/выключатель третьего блока ламп
;#define blok_lamp_en_ON        PORTA.3 = 1    //Включатель блока ламп
;#define blok_lamp_dis_ON       PORTA.4 = 1    //Выключатель блока ламп
;#define blok_silovoy_en_ON     PORTA.5 = 1    //Включатель блока электромагнит, дымогенератор, высокое напряжение
;#define blok_silovoy_dis_ON    PORTA.6 = 1    //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;#define blok_rezerv_ON         PORTA.7 = 1    //резерв
;
;#define blok_lamp_1_OFF         PORTA.0 = 0      //Включатель/выключатель первого блока ламп
;#define blok_lamp_2_OFF         PORTA.1 = 0     //Включатель/выключатель второго блока ламп
;#define blok_lamp_3_OFF         PORTA.2 = 0     //Включатель/выключатель третьего блока ламп
;#define blok_lamp_en_OFF        PORTA.3 = 0     //Включатель блока ламп
;#define blok_lamp_dis_OFF       PORTA.4 = 0     //Выключатель блока ламп
;#define blok_silovoy_en_OFF     PORTA.5 = 0     //Включатель блока электромагнит, дымогенератор, высокое напряжение
;#define blok_silovoy_dis_OFF    PORTA.6 = 0     //Выключатель блока электромагнит, дымогенератор, высокое напряжение
;#define blok_rezerv_OFF         PORTA.7 = 0     //резерв
;
;//=============================================================================
;//Режимы работы                                         regim_rabot
;//Инициализация (заставка при включении).               1
;//Корректировка максимальной температуры разогрева. 	11
;//Корректировка минимальной температуры разогрева.      12
;//Корректировка максимальной температуры копчения.  	21
;//Корректировка минимальной температуры копчения.       22
;//Корректировка часов времени работы.	                31
;//Корректировка минут времени работы.                   32
;//Корректировка часов времени работы вытяжки.	        41
;//Корректировка минут времени работы вытяжки.	        42
;//Работа в режиме разогрева.	                        60
;//Работа в режиме копчения.                             70
;//Работа в режиме остывания.	                        80
;//STOP	                                                100
;//===============================================================================
;//порты обозначения кнопок
;#define kn_vverh            PINC.0
;#define kn_vniz             PINC.1
;#define kn_vpravo           PINC.2
;#define kn_vlevo            PINC.3
;#define kn_ENTER            PINC.4
;#define kn_ESC              PINC.5
;
;//==========================================================================
;// Глобальные переменные
;volatile unsigned char t_max_razogrev     = 115;    // максимальная температура разогрева, в градусах Цельсия

	.DSEG
;volatile unsigned char t_max_rabochee     = 75;     // максимальная температура работы, в градусах Цельсия
;volatile unsigned char t_min_razogrev     = 105;    // минимальная  температура разогрева, в градусах Цельсия
;volatile unsigned char t_min_rabochee     = 65;     // минимальная температура работы, в градусах Цельсия
;
;volatile unsigned char time_rabota_ch     = 4;      // время работы, измеряется в часах
;volatile unsigned char time_rabota_min    = 30;     // время работы, измеряется в минутах
;volatile unsigned char time_smoke_ch      = 0;      // время работы вытяжки, задается в часах
;volatile unsigned char time_smoke_min     = 10;     // время работы вытяжки, задается в минутах
;
;volatile unsigned char real_time_ch       = 0;      // текущее время работы в часах
;volatile unsigned char real_time_min      = 0;      // текущее время работы в минутах
;volatile unsigned char real_time_sek      = 0;      // текущее время работы в минутах
;
;volatile unsigned char real_temp          = 0;      // минимальная температура работы, в градусах Цельсия
;
;volatile unsigned char real_temp_1razryad = 0;      // 1 разряд температуры при отображении
;volatile unsigned char real_temp_2razryad = 0;      // 2 разряд температуры при отображении
;volatile unsigned char real_temp_3razryad = 0;      // 3 разряд температуры при отображении
;
;volatile unsigned char regim_rabot        = 1;      // состояние режим работы
;volatile unsigned char regim_rabot_old    = 1;      // предыдущее состояние режима работы
;
;unsigned char zadergka_pri_nagatii        = 200;    // задержка при нажатии кнопки
;int zadergka_zastavka                     = 1000;    // время показа заставки
;unsigned char t_puskatel                  = 100;    // необходимое время для старта пускателя
;
;volatile char lcd_str_1[16];
;volatile char lcd_str_2[16];
;
;//=============================================================================
;// Объявление без задания функций. (для обеспечения компиляции)
;void frame(void);
;void screen(void);
;void regim(void);
;void init(void);
;//=============================================================================
;// прерывание ежесекундного (или 0,2 секундного таймера)
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00C8 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C9     #asm("cli")
	cli
; 0000 00CA 
; 0000 00CB     TCNT1H=0;
	RCALL SUBOPT_0x1
; 0000 00CC     TCNT1L=0;
; 0000 00CD 
; 0000 00CE     real_time_sek++;
	LDS  R30,_real_time_sek
	SUBI R30,-LOW(1)
	STS  _real_time_sek,R30
; 0000 00CF   	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x3C)
	BREQ PC+2
	RJMP _0xF
	LDS  R30,_real_time_min
	SUBI R30,-LOW(1)
	STS  _real_time_min,R30
	LDI  R30,LOW(0)
	STS  _real_time_sek,R30
; 0000 00D0 	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
_0xF:
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x3C)
	BREQ PC+2
	RJMP _0x10
	LDS  R30,_real_time_ch
	SUBI R30,-LOW(1)
	STS  _real_time_ch,R30
	LDI  R30,LOW(0)
	STS  _real_time_min,R30
; 0000 00D1 	if (real_time_ch  == 24) real_time_ch=0;
_0x10:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x18)
	BREQ PC+2
	RJMP _0x11
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
; 0000 00D2 
; 0000 00D3     #asm("sei")
_0x11:
	sei
; 0000 00D4 
; 0000 00D5 //    frame();
; 0000 00D6 //    screen();
; 0000 00D7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;//=============================================================================
;// Реакция на нажатие кнопки вверх
;void vverh (void)
; 0000 00DC {
_vverh:
; 0000 00DD     switch(regim_rabot)
	RCALL SUBOPT_0x5
; 0000 00DE     {
; 0000 00DF         case 11:    t_max_razogrev++;    break;
	BREQ PC+2
	RJMP _0x15
	LDS  R30,_t_max_razogrev
	SUBI R30,-LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x14
; 0000 00E0         case 12:    t_min_razogrev++;    break;
_0x15:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x16
	LDS  R30,_t_min_razogrev
	SUBI R30,-LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x14
; 0000 00E1         case 21:    t_max_rabochee++;    break;
_0x16:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x17
	LDS  R30,_t_max_rabochee
	SUBI R30,-LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x14
; 0000 00E2         case 22:    t_min_rabochee++;    break;
_0x17:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x18
	LDS  R30,_t_min_rabochee
	SUBI R30,-LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x14
; 0000 00E3         case 31:    time_rabota_ch++;    break;
_0x18:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x19
	LDS  R30,_time_rabota_ch
	SUBI R30,-LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x14
; 0000 00E4         case 32:    time_rabota_min++;   break;
_0x19:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x1A
	LDS  R30,_time_rabota_min
	SUBI R30,-LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x14
; 0000 00E5         case 41:    time_smoke_ch++;     break;
_0x1A:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x1B
	LDS  R30,_time_smoke_ch
	SUBI R30,-LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x14
; 0000 00E6         case 42:    time_smoke_min++;    break;
_0x1B:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x1D
	LDS  R30,_time_smoke_min
	SUBI R30,-LOW(1)
	STS  _time_smoke_min,R30
	RJMP _0x14
; 0000 00E7         default    :    {};
_0x1D:
; 0000 00E8     }
_0x14:
; 0000 00E9 }
	RET
;
;// Реакция на нажатие кнопки вниз
;void vniz (void)
; 0000 00ED {
_vniz:
; 0000 00EE     switch(regim_rabot)
	RCALL SUBOPT_0x5
; 0000 00EF     {
; 0000 00F0         case 11:	t_max_razogrev--;	break;
	BREQ PC+2
	RJMP _0x21
	LDS  R30,_t_max_razogrev
	SUBI R30,LOW(1)
	STS  _t_max_razogrev,R30
	RJMP _0x20
; 0000 00F1         case 12:	t_min_razogrev--;	break;
_0x21:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x22
	LDS  R30,_t_min_razogrev
	SUBI R30,LOW(1)
	STS  _t_min_razogrev,R30
	RJMP _0x20
; 0000 00F2         case 21:	t_max_rabochee--;	break;
_0x22:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x23
	LDS  R30,_t_max_rabochee
	SUBI R30,LOW(1)
	STS  _t_max_rabochee,R30
	RJMP _0x20
; 0000 00F3         case 22:	t_min_rabochee--;	break;
_0x23:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x24
	LDS  R30,_t_min_rabochee
	SUBI R30,LOW(1)
	STS  _t_min_rabochee,R30
	RJMP _0x20
; 0000 00F4         case 31:	time_rabota_ch--;	break;
_0x24:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x25
	LDS  R30,_time_rabota_ch
	SUBI R30,LOW(1)
	STS  _time_rabota_ch,R30
	RJMP _0x20
; 0000 00F5         case 32:	time_rabota_min--;	break;
_0x25:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x26
	LDS  R30,_time_rabota_min
	SUBI R30,LOW(1)
	STS  _time_rabota_min,R30
	RJMP _0x20
; 0000 00F6         case 41:	time_smoke_ch--;	break;
_0x26:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x27
	LDS  R30,_time_smoke_ch
	SUBI R30,LOW(1)
	STS  _time_smoke_ch,R30
	RJMP _0x20
; 0000 00F7         case 42:	time_smoke_min--;	break;
_0x27:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x29
	LDS  R30,_time_smoke_min
	SUBI R30,LOW(1)
	STS  _time_smoke_min,R30
	RJMP _0x20
; 0000 00F8         default	:	{};
_0x29:
; 0000 00F9     }
_0x20:
; 0000 00FA }
	RET
;
;// Реакция на нажатие кнопки вправо
;void vpravo(void)
; 0000 00FE {
_vpravo:
; 0000 00FF     switch(regim_rabot)
	RCALL SUBOPT_0x5
; 0000 0100     {
; 0000 0101         case 11:	regim_rabot = 12;	break;
	BREQ PC+2
	RJMP _0x2D
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0102         case 12:	regim_rabot = 21;	break;
_0x2D:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x2E
	LDI  R30,LOW(21)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0103         case 21:	regim_rabot = 22;	break;
_0x2E:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x2F
	LDI  R30,LOW(22)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0104         case 22:	regim_rabot = 31;	break;
_0x2F:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x30
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0105         case 31:	regim_rabot = 32;	break;
_0x30:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x31
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0106         case 32:	regim_rabot = 41;	break;
_0x31:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x32
	LDI  R30,LOW(41)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0107         case 41:	regim_rabot = 42;	break;
_0x32:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x33
	LDI  R30,LOW(42)
	RCALL SUBOPT_0xD
	RJMP _0x2C
; 0000 0108         case 42:	regim_rabot = 11;	break;
_0x33:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x35
	RCALL SUBOPT_0xE
	RJMP _0x2C
; 0000 0109         default	:	{};
_0x35:
; 0000 010A     }
_0x2C:
; 0000 010B }
	RET
;
;// Реакция на нажатие кнопки влево
;void vlevo(void)
; 0000 010F {
_vlevo:
; 0000 0110     switch(regim_rabot)
	RCALL SUBOPT_0x5
; 0000 0111     {
; 0000 0112         case 11:	regim_rabot = 42;	break;
	BREQ PC+2
	RJMP _0x39
	LDI  R30,LOW(42)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0113         case 12:	regim_rabot = 11;	break;
_0x39:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x3A
	RCALL SUBOPT_0xE
	RJMP _0x38
; 0000 0114         case 21:	regim_rabot = 12;	break;
_0x3A:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x3B
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0115         case 22:	regim_rabot = 21;	break;
_0x3B:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x3C
	LDI  R30,LOW(21)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0116         case 31:	regim_rabot = 22;	break;
_0x3C:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x3D
	LDI  R30,LOW(22)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0117         case 32:	regim_rabot = 31;	break;
_0x3D:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x3E
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0118         case 41:	regim_rabot = 32;	break;
_0x3E:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x3F
	LDI  R30,LOW(32)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 0119         case 42:	regim_rabot = 41;	break;
_0x3F:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x41
	LDI  R30,LOW(41)
	RCALL SUBOPT_0xD
	RJMP _0x38
; 0000 011A         default	:	{};
_0x41:
; 0000 011B     }
_0x38:
; 0000 011C }
	RET
;// Реакция на нажатие кнопки enter
;void enter(void)
; 0000 011F {
_enter:
; 0000 0120     switch(regim_rabot)
	RCALL SUBOPT_0x5
; 0000 0121     {
; 0000 0122         case 11:	regim_rabot = 60;	break;
	BREQ PC+2
	RJMP _0x45
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0123         case 12:	regim_rabot = 60;	break;
_0x45:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x46
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0124         case 21:	regim_rabot = 60;	break;
_0x46:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x47
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0125         case 22:	regim_rabot = 60;	break;
_0x47:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x48
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0126         case 31:	regim_rabot = 60;	break;
_0x48:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x49
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0127         case 32:	regim_rabot = 60;	break;
_0x49:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x4A
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0128         case 41:	regim_rabot = 60;	break;
_0x4A:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x4B
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 0129         case 42:	regim_rabot = 60;	break;
_0x4B:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x4D
	RCALL SUBOPT_0xF
	RJMP _0x44
; 0000 012A         default	:	{};
_0x4D:
; 0000 012B     }
_0x44:
; 0000 012C }
	RET
;
;// Реакция на нажатие кнопки esc
;void esc(void)
; 0000 0130 {
_esc:
; 0000 0131     regim_rabot        = 11;
	RCALL SUBOPT_0xE
; 0000 0132     real_time_ch       = 0;      // текущее время работы в часах
	LDI  R30,LOW(0)
	STS  _real_time_ch,R30
; 0000 0133     real_time_min      = 0;      // текущее время работы в минутах
	STS  _real_time_min,R30
; 0000 0134     real_time_sek      = 0;      // текущее время работы в минутах
	STS  _real_time_sek,R30
; 0000 0135 }
	RET
;
;// проверка нажатия кнопок
;void klaviatura(void)
; 0000 0139 {
_klaviatura:
; 0000 013A         if (PINC.0==0) {
	SBIC 0x13,0
	RJMP _0x4E
; 0000 013B             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 013C             vverh();
	RCALL _vverh
; 0000 013D             }
; 0000 013E         if (PINC.1==0) {
_0x4E:
	SBIC 0x13,1
	RJMP _0x4F
; 0000 013F             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 0140             vlevo();
	RCALL _vlevo
; 0000 0141             }
; 0000 0142         if (PINC.2==0) {
_0x4F:
	SBIC 0x13,2
	RJMP _0x50
; 0000 0143             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 0144             vniz();
	RCALL _vniz
; 0000 0145             }
; 0000 0146         if (PINC.3==0) {
_0x50:
	SBIC 0x13,3
	RJMP _0x51
; 0000 0147             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 0148             vpravo();
	RCALL _vpravo
; 0000 0149             }
; 0000 014A         if (PINC.4==0) {
_0x51:
	SBIC 0x13,4
	RJMP _0x52
; 0000 014B             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 014C             enter();
	RCALL _enter
; 0000 014D             }
; 0000 014E         if (PINC.5==0) {
_0x52:
	SBIC 0x13,5
	RJMP _0x53
; 0000 014F             delay_ms(zadergka_pri_nagatii);
	RCALL SUBOPT_0x10
; 0000 0150             esc();
	RCALL _esc
; 0000 0151             }
; 0000 0152 }
_0x53:
	RET
;
;//=================================================
;void screen(void)
; 0000 0156 {
_screen:
; 0000 0157     lcd_clear();          	// очистка ЛСД
	RCALL _lcd_clear
; 0000 0158 
; 0000 0159     lcd_gotoxy(0,0);      	// установка курсора на 0,0
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL _lcd_gotoxy
; 0000 015A     lcd_puts(lcd_str_1);
	RCALL SUBOPT_0x12
	RCALL _lcd_puts
; 0000 015B 
; 0000 015C     lcd_gotoxy(0,1);      	// установка курсора на начало второй строки
	RCALL SUBOPT_0x11
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 015D     lcd_puts(lcd_str_2);
	RCALL SUBOPT_0x13
	RCALL _lcd_puts
; 0000 015E 
; 0000 015F 
; 0000 0160 }
	RET
;
;//==================================================
;void frame(void)
; 0000 0164 {
_frame:
; 0000 0165     switch(regim_rabot)
	RCALL SUBOPT_0x14
; 0000 0166     {
; 0000 0167         case 1		:
	BREQ PC+2
	RJMP _0x57
; 0000 0168             sprintf(lcd_str_1,"Koptilnya");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x15
; 0000 0169             sprintf(lcd_str_2,"v.1.0");
	RCALL SUBOPT_0x13
	__POINTW1FN _0x0,10
	RCALL SUBOPT_0x15
; 0000 016A             delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RCALL _delay_ms
; 0000 016B             break;
	RJMP _0x56
; 0000 016C         case 11		:
_0x57:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x58
; 0000 016D             sprintf(lcd_str_1,"Max T razogreva");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,16
	RCALL SUBOPT_0x15
; 0000 016E             sprintf(lcd_str_2,"%c%c%c",
; 0000 016F             (t_max_razogrev/100)%10 +0x30,
; 0000 0170             (t_max_razogrev/10)%10  +0x30,
; 0000 0171             t_max_razogrev%10       +0x30
; 0000 0172             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	LDS  R26,_t_max_razogrev
	RCALL SUBOPT_0x1B
; 0000 0173             break;
	RJMP _0x56
; 0000 0174         case 12	    :
_0x58:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x59
; 0000 0175             sprintf(lcd_str_1,"Min T razogreva");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,39
	RCALL SUBOPT_0x15
; 0000 0176             sprintf(lcd_str_2,"%c%c%c",
; 0000 0177             (t_min_razogrev/100)%10 +0x30,
; 0000 0178             (t_min_razogrev/10)%10  +0x30,
; 0000 0179             t_min_razogrev%10       +0x30
; 0000 017A             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	LDS  R26,_t_min_razogrev
	RCALL SUBOPT_0x1B
; 0000 017B             break;
	RJMP _0x56
; 0000 017C         case 21		:
_0x59:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0x5A
; 0000 017D             sprintf(lcd_str_1,"Max T rabotia");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,55
	RCALL SUBOPT_0x15
; 0000 017E             sprintf(lcd_str_2,"%c%c%c",
; 0000 017F             (t_max_rabochee/100)%10 +0x30,
; 0000 0180             (t_max_rabochee/10)%10  +0x30,
; 0000 0181             t_max_rabochee%10       +0x30
; 0000 0182             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
	LDS  R26,_t_max_rabochee
	RCALL SUBOPT_0x1B
; 0000 0183             break;
	RJMP _0x56
; 0000 0184         case 22		:
_0x5A:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0x5B
; 0000 0185             sprintf(lcd_str_1,"Min T raboti");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,69
	RCALL SUBOPT_0x15
; 0000 0186             sprintf(lcd_str_2,"%c%c%c",
; 0000 0187             (t_min_rabochee/100)%10 +0x30,
; 0000 0188             (t_min_rabochee/10)%10  +0x30,
; 0000 0189             t_min_rabochee%10       +0x30
; 0000 018A             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1D
	LDS  R26,_t_min_rabochee
	RCALL SUBOPT_0x1B
; 0000 018B             break;
	RJMP _0x56
; 0000 018C         case 31		:
_0x5B:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x5C
; 0000 018D             sprintf(lcd_str_1,"Time rabota, ch");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,82
	RCALL SUBOPT_0x15
; 0000 018E             sprintf(lcd_str_2,"%c%c",
; 0000 018F             (time_rabota_ch/10)%10  +0x30,
; 0000 0190             time_rabota_ch%10       +0x30
; 0000 0191             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x20
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x21
	LDS  R26,_time_rabota_ch
	RCALL SUBOPT_0x22
; 0000 0192             break;
	RJMP _0x56
; 0000 0193         case 32		:
_0x5C:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x5D
; 0000 0194             sprintf(lcd_str_1,"Time rabota, min");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,98
	RCALL SUBOPT_0x15
; 0000 0195             sprintf(lcd_str_2,"%c%c",
; 0000 0196             (time_rabota_min/10)%10 +0x30,
; 0000 0197             time_rabota_min%10      +0x30
; 0000 0198             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x20
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x21
	LDS  R26,_time_rabota_min
	RCALL SUBOPT_0x22
; 0000 0199             break;
	RJMP _0x56
; 0000 019A         case 41		:
_0x5D:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0x5E
; 0000 019B             sprintf(lcd_str_1,"Time smoke, ch");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,115
	RCALL SUBOPT_0x15
; 0000 019C             sprintf(lcd_str_2,"%c%c",
; 0000 019D             (time_smoke_ch/10)%10   +0x30,
; 0000 019E             time_smoke_ch%10        +0x30
; 0000 019F             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x20
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x21
	LDS  R26,_time_smoke_ch
	RCALL SUBOPT_0x22
; 0000 01A0             break;
	RJMP _0x56
; 0000 01A1         case 42		:
_0x5E:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x5F
; 0000 01A2             sprintf(lcd_str_1,"Time smoke, min");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,130
	RCALL SUBOPT_0x15
; 0000 01A3             sprintf(lcd_str_2,"%c%c",
; 0000 01A4             (time_smoke_min/10)%10  +0x30,
; 0000 01A5             time_smoke_min%10       +0x30
; 0000 01A6             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x20
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x21
	LDS  R26,_time_smoke_min
	RCALL SUBOPT_0x22
; 0000 01A7             break;
	RJMP _0x56
; 0000 01A8         case 60		:
_0x5F:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x60
; 0000 01A9 //#pragma rl+
; 0000 01AA             sprintf(lcd_str_1,"RAZOGREVРазогрев");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,146
	RCALL SUBOPT_0x15
; 0000 01AB             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
; 0000 01AC //#pragma rl-
; 0000 01AD 
; 0000 01AE             (real_time_ch/10)%10	+0x30,
; 0000 01AF             real_time_ch%10		    +0x30,
; 0000 01B0             (real_time_min/10)%10	+0x30,
; 0000 01B1             real_time_min%10		+0x30,
; 0000 01B2             (real_time_sek/10)%10	+0x30,
; 0000 01B3             real_time_sek%10		+0x30,
; 0000 01B4 
; 0000 01B5             real_temp_1razryad,
; 0000 01B6             real_temp_2razryad,
; 0000 01B7             real_temp_3razryad
; 0000 01B8             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
; 0000 01B9             break;
	RJMP _0x56
; 0000 01BA         case 70		:
_0x60:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x61
; 0000 01BB             sprintf(lcd_str_1,"RABOTA");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,189
	RCALL SUBOPT_0x15
; 0000 01BC             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
; 0000 01BD             (real_time_ch/10)%10	+0x30,
; 0000 01BE             real_time_ch%10             +0x30,
; 0000 01BF             (real_time_min/10)%10	+0x30,
; 0000 01C0             real_time_min%10		+0x30,
; 0000 01C1             (real_time_sek/10)%10	+0x30,
; 0000 01C2             real_time_sek%10		+0x30,
; 0000 01C3 
; 0000 01C4             real_temp_1razryad,
; 0000 01C5             real_temp_2razryad,
; 0000 01C6             real_temp_3razryad
; 0000 01C7             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
; 0000 01C8             break;
	RJMP _0x56
; 0000 01C9         case 80		:
_0x61:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x62
; 0000 01CA             sprintf(lcd_str_1,"SMOKE");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,196
	RCALL SUBOPT_0x15
; 0000 01CB             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
; 0000 01CC             (real_time_ch/10)%10	+0x30,
; 0000 01CD             real_time_ch%10             +0x30,
; 0000 01CE             (real_time_min/10)%10	+0x30,
; 0000 01CF             real_time_min%10		+0x30,
; 0000 01D0             (real_time_sek/10)%10	+0x30,
; 0000 01D1             real_time_sek%10		+0x30,
; 0000 01D2 
; 0000 01D3             real_temp_1razryad,
; 0000 01D4             real_temp_2razryad,
; 0000 01D5             real_temp_3razryad
; 0000 01D6             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
; 0000 01D7             break;
	RJMP _0x56
; 0000 01D8         case 100	:
_0x62:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x64
; 0000 01D9             sprintf(lcd_str_1,"STOP");
	RCALL SUBOPT_0x12
	__POINTW1FN _0x0,202
	RCALL SUBOPT_0x15
; 0000 01DA             sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
; 0000 01DB             (real_time_ch/10)%10	+0x30,
; 0000 01DC             real_time_ch%10             +0x30,
; 0000 01DD             (real_time_min/10)%10	+0x30,
; 0000 01DE             real_time_min%10		+0x30,
; 0000 01DF             (real_time_sek/10)%10	+0x30,
; 0000 01E0             real_time_sek%10		+0x30,
; 0000 01E1 
; 0000 01E2             real_temp_1razryad,
; 0000 01E3             real_temp_2razryad,
; 0000 01E4             real_temp_3razryad
; 0000 01E5             );
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
; 0000 01E6             break;
	RJMP _0x56
; 0000 01E7 
; 0000 01E8         default	    :
_0x64:
; 0000 01E9             lcd_putsf("www.xxx.ua");
	__POINTW1FN _0x0,207
	RCALL SUBOPT_0x27
	RCALL _lcd_putsf
; 0000 01EA             delay_ms(10);
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x27
	RCALL _delay_ms
; 0000 01EB             break;
; 0000 01EC     }
_0x56:
; 0000 01ED }
	RET
;//=================================================
;void regim(void)
; 0000 01F0 {
_regim:
; 0000 01F1 
; 0000 01F2 //       regim_rabot_old = regim_rabot;
; 0000 01F3 
; 0000 01F4         switch(regim_rabot)
	RCALL SUBOPT_0x14
; 0000 01F5         {
; 0000 01F6         case 1		:
	BREQ PC+2
	RJMP _0x68
; 0000 01F7                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 01F8                 blok_lamp_2_OFF         ;
; 0000 01F9                 blok_lamp_3_OFF         ;
; 0000 01FA                 blok_lamp_en_OFF        ;
; 0000 01FB                 blok_lamp_dis_OFF       ;
; 0000 01FC                 blok_silovoy_en_OFF     ;
; 0000 01FD                 blok_silovoy_dis_OFF    ;
; 0000 01FE                 blok_rezerv_OFF         ;
; 0000 01FF             break;
	RJMP _0x67
; 0000 0200         case 11		:
_0x68:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x79
; 0000 0201             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0x7B
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0x7B
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0x7B
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0x7B
	LDI  R30,0
	RJMP _0x7C
_0x7B:
	LDI  R30,1
_0x7C:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0x7A
; 0000 0202             {
; 0000 0203                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0204                 blok_lamp_2_OFF         ;
; 0000 0205                 blok_lamp_3_OFF         ;
; 0000 0206                 blok_lamp_en_OFF        ;
; 0000 0207                 blok_lamp_dis_OFF       ;
; 0000 0208                 blok_silovoy_en_OFF     ;
; 0000 0209                 blok_silovoy_dis_OFF    ;
; 0000 020A                 blok_rezerv_OFF         ;
; 0000 020B             }
; 0000 020C             break;
_0x7A:
	RJMP _0x67
; 0000 020D         case 12         :
_0x79:
	RCALL SUBOPT_0x6
	BREQ PC+2
	RJMP _0x8D
; 0000 020E             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0x8F
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0x8F
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0x8F
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0x8F
	LDI  R30,0
	RJMP _0x90
_0x8F:
	LDI  R30,1
_0x90:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0x8E
; 0000 020F             {
; 0000 0210                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0211                 blok_lamp_2_OFF         ;
; 0000 0212                 blok_lamp_3_OFF         ;
; 0000 0213                 blok_lamp_en_OFF        ;
; 0000 0214                 blok_lamp_dis_OFF       ;
; 0000 0215                 blok_silovoy_en_OFF     ;
; 0000 0216                 blok_silovoy_dis_OFF    ;
; 0000 0217                 blok_rezerv_OFF         ;
; 0000 0218             }
; 0000 0219             break;
_0x8E:
	RJMP _0x67
; 0000 021A         case 21		:
_0x8D:
	RCALL SUBOPT_0x7
	BREQ PC+2
	RJMP _0xA1
; 0000 021B             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0xA3
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0xA3
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0xA3
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0xA3
	LDI  R30,0
	RJMP _0xA4
_0xA3:
	LDI  R30,1
_0xA4:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0xA2
; 0000 021C             {
; 0000 021D                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 021E                 blok_lamp_2_OFF         ;
; 0000 021F                 blok_lamp_3_OFF         ;
; 0000 0220                 blok_lamp_en_OFF        ;
; 0000 0221                 blok_lamp_dis_OFF       ;
; 0000 0222                 blok_silovoy_en_OFF     ;
; 0000 0223                 blok_silovoy_dis_OFF    ;
; 0000 0224                 blok_rezerv_OFF         ;
; 0000 0225             }
; 0000 0226             break;
_0xA2:
	RJMP _0x67
; 0000 0227         case 22		:
_0xA1:
	RCALL SUBOPT_0x8
	BREQ PC+2
	RJMP _0xB5
; 0000 0228             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0xB7
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0xB7
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0xB7
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0xB7
	LDI  R30,0
	RJMP _0xB8
_0xB7:
	LDI  R30,1
_0xB8:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0xB6
; 0000 0229             {
; 0000 022A                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 022B                 blok_lamp_2_OFF         ;
; 0000 022C                 blok_lamp_3_OFF         ;
; 0000 022D                 blok_lamp_en_OFF        ;
; 0000 022E                 blok_lamp_dis_OFF       ;
; 0000 022F                 blok_silovoy_en_OFF     ;
; 0000 0230                 blok_silovoy_dis_OFF    ;
; 0000 0231                 blok_rezerv_OFF         ;
; 0000 0232             }
; 0000 0233             break;
_0xB6:
	RJMP _0x67
; 0000 0234         case 31		:
_0xB5:
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0xC9
; 0000 0235             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0xCB
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0xCB
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0xCB
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0xCB
	LDI  R30,0
	RJMP _0xCC
_0xCB:
	LDI  R30,1
_0xCC:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0xCA
; 0000 0236             {
; 0000 0237                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0238                 blok_lamp_2_OFF         ;
; 0000 0239                 blok_lamp_3_OFF         ;
; 0000 023A                 blok_lamp_en_OFF        ;
; 0000 023B                 blok_lamp_dis_OFF       ;
; 0000 023C                 blok_silovoy_en_OFF     ;
; 0000 023D                 blok_silovoy_dis_OFF    ;
; 0000 023E                 blok_rezerv_OFF         ;
; 0000 023F             }
; 0000 0240             break;
_0xCA:
	RJMP _0x67
; 0000 0241         case 32		:
_0xC9:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0xDD
; 0000 0242             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0xDF
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0xDF
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0xDF
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0xDF
	LDI  R30,0
	RJMP _0xE0
_0xDF:
	LDI  R30,1
_0xE0:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0xDE
; 0000 0243             {
; 0000 0244                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0245                 blok_lamp_2_OFF         ;
; 0000 0246                 blok_lamp_3_OFF         ;
; 0000 0247                 blok_lamp_en_OFF        ;
; 0000 0248                 blok_lamp_dis_OFF       ;
; 0000 0249                 blok_silovoy_en_OFF     ;
; 0000 024A                 blok_silovoy_dis_OFF    ;
; 0000 024B                 blok_rezerv_OFF         ;
; 0000 024C             }
; 0000 024D             break;
_0xDE:
	RJMP _0x67
; 0000 024E         case 41		:
_0xDD:
	RCALL SUBOPT_0xB
	BREQ PC+2
	RJMP _0xF1
; 0000 024F             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0xF3
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0xF3
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0xF3
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0xF3
	LDI  R30,0
	RJMP _0xF4
_0xF3:
	LDI  R30,1
_0xF4:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0xF2
; 0000 0250             {
; 0000 0251                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0252                 blok_lamp_2_OFF         ;
; 0000 0253                 blok_lamp_3_OFF         ;
; 0000 0254                 blok_lamp_en_OFF        ;
; 0000 0255                 blok_lamp_dis_OFF       ;
; 0000 0256                 blok_silovoy_en_OFF     ;
; 0000 0257                 blok_silovoy_dis_OFF    ;
; 0000 0258                 blok_rezerv_OFF         ;
; 0000 0259             }
; 0000 025A             break;
_0xF2:
	RJMP _0x67
; 0000 025B         case 42		:
_0xF1:
	RCALL SUBOPT_0xC
	BREQ PC+2
	RJMP _0x105
; 0000 025C             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0x107
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0x107
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0x107
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0x107
	LDI  R30,0
	RJMP _0x108
_0x107:
	LDI  R30,1
_0x108:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0x106
; 0000 025D             {
; 0000 025E                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 025F                 blok_lamp_2_OFF         ;
; 0000 0260                 blok_lamp_3_OFF         ;
; 0000 0261                 blok_lamp_en_OFF        ;
; 0000 0262                 blok_lamp_dis_OFF       ;
; 0000 0263                 blok_silovoy_en_OFF     ;
; 0000 0264                 blok_silovoy_dis_OFF    ;
; 0000 0265                 blok_rezerv_OFF         ;
; 0000 0266             }
; 0000 0267             break;
_0x106:
	RJMP _0x67
; 0000 0268         case 60		:
_0x105:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x119
; 0000 0269             if (regim_rabot_old==(11||12||21||22||31||31||41||42))
	LDI  R30,LOW(11)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(12)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(21)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(22)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(31)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(41)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,LOW(42)
	CPI  R30,0
	BREQ PC+2
	RJMP _0x11B
	LDI  R30,0
	RJMP _0x11C
_0x11B:
	LDI  R30,1
_0x11C:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0x11A
; 0000 026A             {
; 0000 026B                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x2E
; 0000 026C                 blok_lamp_2_ON         ;
; 0000 026D                 blok_lamp_3_ON         ;
; 0000 026E                 blok_lamp_dis_OFF      ;
	CBI  0x1B,4
; 0000 026F                 blok_silovoy_en_OFF    ;
	CBI  0x1B,5
; 0000 0270                 blok_silovoy_dis_OFF   ;
	CBI  0x1B,6
; 0000 0271                 blok_rezerv_OFF        ;
	CBI  0x1B,7
; 0000 0272 
; 0000 0273                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x2F
; 0000 0274                 delay_ms(t_puskatel)   ;
; 0000 0275                 blok_lamp_en_OFF       ;
	CBI  0x1B,3
; 0000 0276             }
; 0000 0277             if (real_temp<t_max_razogrev)
_0x11A:
	LDS  R30,_t_max_razogrev
	LDS  R26,_real_temp
	CP   R26,R30
	BRLO PC+2
	RJMP _0x12F
; 0000 0278             {
; 0000 0279                 blok_lamp_en_ON        ;
	RCALL SUBOPT_0x2F
; 0000 027A                 delay_ms(t_puskatel)   ;
; 0000 027B             }
; 0000 027C 
; 0000 027D                 blok_lamp_1_ON         ;
_0x12F:
	RCALL SUBOPT_0x2E
; 0000 027E                 blok_lamp_2_ON         ;
; 0000 027F                 blok_lamp_3_ON         ;
; 0000 0280                 blok_lamp_en_OFF      ;
	CBI  0x1B,3
; 0000 0281             break;
	RJMP _0x67
; 0000 0282         case 70		:
_0x119:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x13A
; 0000 0283                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x2E
; 0000 0284                 blok_lamp_2_ON         ;
; 0000 0285                 blok_lamp_3_ON         ;
; 0000 0286 
; 0000 0287                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
; 0000 0288             break;
	RJMP _0x67
; 0000 0289         case 80		:
_0x13A:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x143
; 0000 028A                 blok_lamp_1_ON         ;
	RCALL SUBOPT_0x2E
; 0000 028B                 blok_lamp_2_ON         ;
; 0000 028C                 blok_lamp_3_ON         ;
; 0000 028D 
; 0000 028E                 blok_silovoy_en_ON    ;
	SBI  0x1B,5
; 0000 028F             break;
	RJMP _0x67
; 0000 0290         case 100	:
_0x143:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x15D
; 0000 0291                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 0292                 blok_lamp_2_OFF         ;
; 0000 0293                 blok_lamp_3_OFF         ;
; 0000 0294                 blok_lamp_en_OFF        ;
; 0000 0295                 blok_lamp_dis_OFF       ;
; 0000 0296                 blok_silovoy_en_OFF     ;
; 0000 0297                 blok_silovoy_dis_OFF    ;
; 0000 0298                 blok_rezerv_OFF         ;
; 0000 0299             break;
	RJMP _0x67
; 0000 029A         default	    :
_0x15D:
; 0000 029B             if (regim_rabot_old==(60||70||80||100))
	RCALL SUBOPT_0x29
	BREQ PC+2
	RJMP _0x15F
	RCALL SUBOPT_0x2A
	BREQ PC+2
	RJMP _0x15F
	RCALL SUBOPT_0x2B
	BREQ PC+2
	RJMP _0x15F
	RCALL SUBOPT_0x2C
	BREQ PC+2
	RJMP _0x15F
	LDI  R30,0
	RJMP _0x160
_0x15F:
	LDI  R30,1
_0x160:
	RCALL SUBOPT_0x2D
	BREQ PC+2
	RJMP _0x15E
; 0000 029C             {
; 0000 029D                 blok_lamp_1_OFF         ;
	RCALL SUBOPT_0x28
; 0000 029E                 blok_lamp_2_OFF         ;
; 0000 029F                 blok_lamp_3_OFF         ;
; 0000 02A0                 blok_lamp_en_OFF        ;
; 0000 02A1                 blok_lamp_dis_OFF       ;
; 0000 02A2                 blok_silovoy_en_OFF     ;
; 0000 02A3                 blok_silovoy_dis_OFF    ;
; 0000 02A4                 blok_rezerv_OFF         ;
; 0000 02A5             }
; 0000 02A6             break;
_0x15E:
; 0000 02A7         };
_0x67:
; 0000 02A8 
; 0000 02A9         regim_rabot_old = regim_rabot;
	LDS  R30,_regim_rabot
	STS  _regim_rabot_old,R30
; 0000 02AA }
	RET
;//=================================================
;void init(void)
; 0000 02AD {
_init:
; 0000 02AE // Port A initialization
; 0000 02AF     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 02B0     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 02B1 // Port B initialization
; 0000 02B2     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02B3     DDRB=0x00;
	OUT  0x17,R30
; 0000 02B4 
; 0000 02B5 // Инициализация порта клавиатуры.
; 0000 02B6 // Port C initialization
; 0000 02B7     PORTC=0xFF;         // вкл. подтягивающие резисторы
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 02B8     DDRC=0x00;          // весь порт как вход
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 02B9 
; 0000 02BA // Timer/Counter 1 initialization
; 0000 02BB // Clock source: System Clock
; 0000 02BC // Clock value: 7,813 kHz
; 0000 02BD // Mode: Normal top=FFFFh
; 0000 02BE // OC1A output: Discon.
; 0000 02BF // OC1B output: Discon.
; 0000 02C0 // Noise Canceler: Off
; 0000 02C1 // Input Capture on Falling Edge
; 0000 02C2 // Timer 1 Overflow Interrupt: Off
; 0000 02C3 // Input Capture Interrupt: Off
; 0000 02C4 // Compare A Match Interrupt: On
; 0000 02C5 // Compare B Match Interrupt: Off
; 0000 02C6     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02C7     TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 02C8     TCNT1H=0x00;
	RCALL SUBOPT_0x1
; 0000 02C9     TCNT1L=0x00;
; 0000 02CA     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 02CB     ICR1L=0x00;
	OUT  0x26,R30
; 0000 02CC     OCR1AH=0x1E;
	LDI  R30,LOW(30)
	OUT  0x2B,R30
; 0000 02CD     OCR1AL=0x85;
	LDI  R30,LOW(133)
	OUT  0x2A,R30
; 0000 02CE     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 02CF     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02D0 
; 0000 02D1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02D2     TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 02D3 
; 0000 02D4 //=================================================
; 0000 02D5 // USART initialization
; 0000 02D6 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02D7 // USART Receiver: On
; 0000 02D8 // USART Transmitter: On
; 0000 02D9 // USART Mode: Asynchronous
; 0000 02DA // USART Baud Rate: 38400
; 0000 02DB     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 02DC     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 02DD     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02DE     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02DF     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 02E0 //=================================================
; 0000 02E1 // LCD module initialization
; 0000 02E2     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 02E3 }
	RET
;
;void main(void)
; 0000 02E6 {
_main:
; 0000 02E7     init();
	RCALL _init
; 0000 02E8 
; 0000 02E9     regim_rabot=1;             // Заставка
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
; 0000 02EA     frame();
	RCALL _frame
; 0000 02EB     screen();
	RCALL _screen
; 0000 02EC 
; 0000 02ED     delay_ms(zadergka_zastavka);
	ST   -Y,R9
	ST   -Y,R8
	RCALL _delay_ms
; 0000 02EE 
; 0000 02EF     regim_rabot=11;            // Установка режима работ на задание температуры
	RCALL SUBOPT_0xE
; 0000 02F0 
; 0000 02F1     frame();
	RCALL _frame
; 0000 02F2     screen();
	RCALL _screen
; 0000 02F3 
; 0000 02F4     #asm("sei")                // Разрешение прерываний
	sei
; 0000 02F5 
; 0000 02F6     while(1)                   // Вечный цикл
_0x171:
; 0000 02F7     {
; 0000 02F8         klaviatura();          // обработка нажатой кнопки
	RCALL _klaviatura
; 0000 02F9 
; 0000 02FA         regim();
	RCALL _regim
; 0000 02FB 
; 0000 02FC /*
; 0000 02FD         if (getchar()=='#')
; 0000 02FE         {
; 0000 02FF                 real_temp_1razryad = getchar();      // 1 разряд температуры при отображении
; 0000 0300                 real_temp_2razryad = getchar();      // 2 разряд температуры при отображении
; 0000 0301                 real_temp_3razryad = getchar();      // 3 разряд температуры при отображении
; 0000 0302 
; 0000 0303                 real_temp=(real_temp_1razryad*100+real_temp_2razryad*10+real_temp_3razryad);
; 0000 0304         }
; 0000 0305 */
; 0000 0306         frame();
	RCALL _frame
; 0000 0307         screen();
	RCALL _screen
; 0000 0308     }
	RJMP _0x171
_0x173:
; 0000 0309 }
_0x174:
	RJMP _0x174
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

	.CSEG
_put_buff_G100:
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x30
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2000010
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2000011
	RJMP _0x2000012
_0x2000011:
	__CPWRN 16,17,2
	BRSH PC+2
	RJMP _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x30
	ADIW R26,2
	RCALL SUBOPT_0x32
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x30
	RCALL __GETW1P
	TST  R31
	BRPL PC+2
	RJMP _0x2000014
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x32
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
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
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+2
	RJMP _0x200001C
	CPI  R18,37
	BREQ PC+2
	RJMP _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x33
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x200001F
	CPI  R18,37
	BREQ PC+2
	RJMP _0x2000020
	RCALL SUBOPT_0x33
	LDI  R17,LOW(0)
	RJMP _0x200001B
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+2
	RJMP _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BREQ PC+2
	RJMP _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BREQ PC+2
	RJMP _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+2
	RJMP _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRSH PC+2
	RJMP _0x200002A
	CPI  R18,58
	BRLO PC+2
	RJMP _0x200002A
	RJMP _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+2
	RJMP _0x200002F
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x34
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x36
	RJMP _0x2000030
	RJMP _0x2000031
_0x200002F:
	CPI  R30,LOW(0x73)
	BREQ PC+2
	RJMP _0x2000032
_0x2000031:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
	RJMP _0x2000034
_0x2000032:
	CPI  R30,LOW(0x70)
	BREQ PC+2
	RJMP _0x2000035
_0x2000034:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
	RJMP _0x2000037
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ PC+2
	RJMP _0x2000038
_0x2000037:
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x69)
	BREQ PC+2
	RJMP _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BREQ PC+2
	RJMP _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(5)
	RJMP _0x200003D
	RJMP _0x200003E
_0x200003C:
	CPI  R30,LOW(0x58)
	BREQ PC+2
	RJMP _0x200003F
_0x200003E:
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x3A
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3B
	LDD  R26,Y+11
	TST  R26
	BRMI PC+2
	RJMP _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x3B
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BRNE PC+2
	RJMP _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3B
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRLO PC+2
	RJMP _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x33
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x3A
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x33
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x3A
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+2
	RJMP _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x3B
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRSH PC+2
	RJMP _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRS R16,4
	RJMP _0x2000060
	RJMP _0x2000061
_0x2000060:
	CPI  R18,49
	BRLO PC+2
	RJMP _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+2
	RJMP _0x2000063
	RJMP _0x2000062
_0x2000063:
	ORI  R16,LOW(16)
	RJMP _0x2000065
_0x2000062:
	CP   R21,R19
	BRSH PC+2
	RJMP _0x2000067
	SBRC R16,0
	RJMP _0x2000067
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
	ORI  R16,LOW(16)
_0x2000065:
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x36
	CPI  R21,0
	BRNE PC+2
	RJMP _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x33
	CPI  R21,0
	BRNE PC+2
	RJMP _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
_0x2000057:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+2
	RJMP _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x36
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
	LDI  R17,LOW(0)
_0x200002E:
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x3C
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3A
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x27
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x27
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x27
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	RCALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x3D
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3D
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x3D
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3D
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
	CP   R11,R13
	BRSH PC+2
	RJMP _0x2020004
	__lcd_putchar1:
	INC  R10
	RCALL SUBOPT_0x11
	ST   -Y,R10
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	INC  R11
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
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
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
	RJMP _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3E
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x3D
	RCALL __long_delay_G101
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3D
	RCALL __long_delay_G101
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x3D
	RCALL __long_delay_G101
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BRNE PC+2
	RJMP _0x202000B
	LDI  R30,LOW(0)
	ADIW R28,1
	RET
_0x202000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3D
	RCALL _lcd_clear
	LDI  R30,LOW(1)
	ADIW R28,1
	RET

	.CSEG

	.CSEG
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
_rx_buffer:
	.BYTE 0x8
_t_max_razogrev:
	.BYTE 0x1
_t_max_rabochee:
	.BYTE 0x1
_t_min_razogrev:
	.BYTE 0x1
_t_min_rabochee:
	.BYTE 0x1
_time_rabota_ch:
	.BYTE 0x1
_time_rabota_min:
	.BYTE 0x1
_time_smoke_ch:
	.BYTE 0x1
_time_smoke_min:
	.BYTE 0x1
_real_time_ch:
	.BYTE 0x1
_real_time_min:
	.BYTE 0x1
_real_time_sek:
	.BYTE 0x1
_real_temp:
	.BYTE 0x1
_real_temp_1razryad:
	.BYTE 0x1
_real_temp_2razryad:
	.BYTE 0x1
_real_temp_3razryad:
	.BYTE 0x1
_regim_rabot:
	.BYTE 0x1
_regim_rabot_old:
	.BYTE 0x1
_lcd_str_1:
	.BYTE 0x10
_lcd_str_2:
	.BYTE 0x10
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:30 WORDS
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
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDS  R26,_t_max_razogrev
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 61 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:131 WORDS
SUBOPT_0x1A:
	RCALL __DIVW21
	MOVW R26,R30
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1B:
	CLR  R27
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDS  R26,_t_min_razogrev
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x19
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDS  R26,_t_max_rabochee
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	LDS  R26,_t_min_rabochee
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x21:
	LDI  R27,0
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x22:
	CLR  R27
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x23:
	__POINTW1FN _0x0,163
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x4
	CLR  R27
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	RCALL SUBOPT_0x3
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x3
	CLR  R27
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
	RCALL __PUTPARD1
	RCALL SUBOPT_0x2
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x2
	CLR  R27
	RCALL SUBOPT_0x19
	RCALL __MODW21
	ADIW R30,48
	RCALL __CWD1
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x27:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x28:
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
SUBOPT_0x29:
	LDI  R30,LOW(60)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(70)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(80)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(100)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x2D:
	LDS  R26,_regim_rabot_old
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2E:
	SBI  0x1B,0
	SBI  0x1B,1
	SBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	SBI  0x1B,3
	MOV  R30,R6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x27
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x33:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x27
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x27
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x34
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
	RCALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G101


	.CSEG
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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
