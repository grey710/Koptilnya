
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

void USART_Init(void); 
unsigned char USART_GetTxCount(void); 
void USART_FlushTxBuf(void); 
void USART_PutChar(unsigned char sym); 
void USART_SendStr(unsigned char * data); 
unsigned char USART_GetRxCount(void); 
void USART_FlushRxBuf(void); 
unsigned char USART_GetChar(void); 

unsigned char usartTxBuf[16];
unsigned char txBufTail = 0;
unsigned char txBufHead = 0;
unsigned char txCount = 0;

unsigned char usartRxBuf[16];
unsigned char rxBufTail = 0;
unsigned char rxBufHead = 0;
unsigned char rxCount = 0;

void USART_Init(void)
{
UBRRH = 0;
UBRRL = 51; 
UCSRB = (1<<7       )|(1<<6       )|(1<<4       )|(1<<3       ); 
UCSRC = (1<<7       )|(1<<2       )|(1<<1       ); 
}

unsigned char USART_GetTxCount(void)
{
return txCount;  
}

void USART_FlushTxBuf(void)
{
txBufTail = 0; 
txCount = 0;
txBufHead = 0;
}

void USART_PutChar(unsigned char sym)
{

if(((UCSRA & (1<<5       )) != 0) && (txCount == 0)) UDR = sym;
else {
if (txCount < 16){    
usartTxBuf[txBufTail] = sym; 
txCount++;                   
txBufTail++;                 
if (txBufTail == 16) txBufTail = 0;
}
}
}

void USART_SendStr(unsigned char * data)
{
unsigned char sym;
while(*data){
sym = *data++;
USART_PutChar(sym);
}
}

interrupt [14] void usart_txc_my(void) 
{
if (txCount > 0){              
UDR = usartTxBuf[txBufHead]; 
txCount--;                   
txBufHead++;                 
if (txBufHead == 16) txBufHead = 0;
} 
} 

unsigned char USART_GetRxCount(void)
{
return rxCount;  
}

void USART_FlushRxBuf(void)
{
unsigned char saveSreg = SREG;
#asm("cli");
rxBufTail = 0;
rxBufHead = 0;
rxCount = 0;
SREG = saveSreg;
}

unsigned char USART_GetChar(void)
{
unsigned char sym;
if (rxCount > 0){                     
sym = usartRxBuf[rxBufHead];        
rxCount--;                          
rxBufHead++;                        
if (rxBufHead == 16) rxBufHead = 0;
return sym;                         
}
return 0;
}

interrupt [12] void usart_rxc_my(void) 
{
if (rxCount < 16){                
usartRxBuf[rxBufTail] = UDR;        
rxBufTail++;                             
if (rxBufTail == 16) rxBufTail = 0;  
rxCount++;                                 
}
} 

