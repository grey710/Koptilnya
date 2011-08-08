/*****************************************************
Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,0000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega8
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
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
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   // 16 bit access
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
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
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
/*
CodeVisionAVR C Compiler
Prototypes for mathematical functions

Portions (C) 1998-2001 Pavel Haiduc, HP InfoTech S.R.L.
Portions (C) 2000-2001 Yuri G. Salov
*/
#pragma used+
unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);
#pragma used-
#pragma library math.lib
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE LCD IS CONNECTED!

  EXAMPLE FOR PORTB:

    #asm
        .equ __lcd_port=0x18
    #endasm
    #include <lcd.h>

*/
#pragma used+
void _lcd_ready(void);
void _lcd_write_data(unsigned char data);
// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);
// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);
// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);
// clear the LCD
void lcd_clear(void);
void lcd_putchar(char c);
// write the string str located in SRAM to the LCD
void lcd_puts(char *str);
// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str);
// initialize the LCD controller
unsigned char lcd_init(unsigned char lcd_columns);
#pragma used-
#pragma library lcd.lib
unsigned char lcd_buffer1[9] = "        ";
unsigned char lcd_buffer2[9] = "        ";
volatile unsigned int adc_data = 0, T, ee_tmprSet = 0, T_prev = 0, T_now = 0, T_disp = 0;
volatile int ReadKey = 0, KeyDelay = 0, Mode = 0, program = 1; 
unsigned int i=1, T0 = 3, Kp = 70;  // Коэффициенты нужно подбирать!
volatile int pwm_val = 0; // Для хранения величины ШИМ в 1/1024
eeprom unsigned int T_prog[3] = { 300, 150, 400 };   // Температурные режимы в EEPROM
unsigned int T_set[3];
static void avr_init();
void green(void);
void red(void);
void my_beep(void); 
unsigned int read_adc(unsigned char adc_input);
// ADC interrupt service routine
interrupt [15] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}
// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|0x00          ;
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}
// Timer 0 overflow interrupt service routine
interrupt [10] void timer0_ovf_isr(void)
{
        TCNT0=0x00;
        if (ReadKey == 0) {
	        if (KeyDelay == 0) {              // Если KeyDelay == 0, то можно нажимать опять 		
	                KeyDelay = 0;
	                if ((PINC.1 == 0))	{
	                        ReadKey = 1;
	                        my_beep();
	                }
	                if ((PINC.2 == 0))	{
	                        ReadKey = 2;
	                        my_beep();
	                }
	                if ((PINC.3 == 0))	{
	                        ReadKey = 3;
	                        my_beep();
	                }
	                if ((PINB.5 == 0))	{
	                        ReadKey = 4;
	                        my_beep();
	                }
	                if ((PINB.4 == 0))	{
	                        ReadKey = 5;
	                        my_beep();
	                }
	                if ((PINB.3 == 0))	{
	                        ReadKey = 6;
	                        my_beep();
	                }
                        if (ReadKey) {
                                KeyDelay = 10; 
                        }
                } else {
			KeyDelay--;
		}
	}    // if  
	i--;
	    	if (i==0) {
                T_disp = T;
	        i=15;
	}
}
void main(void)
{
        avr_init();
                adc_data=read_adc(0);
        T_now = (1000 - adc_data) / 2;
        T_prev = T_now;
while (1)
{
        adc_data=read_adc(0);
        T_now = (1000 - adc_data) / 2;
                if ((T_now < (T_prev - 3)) || (T_now > (T_prev + 3))) {
                T = T_prev;
        } else {
                T = T_now;
                T_prev = T_now;
        }
	                                pwm_val = Kp * (ee_tmprSet - T + T0);
                if (pwm_val > 1023) pwm_val = 1023;
        if (pwm_val < 0) pwm_val = 0;
                if ((T > (ee_tmprSet - 10)) && (T < (ee_tmprSet + 10))) {
                green();
        } else {
                red();
        }
                if (ReadKey == 5)
        {       
                if (Mode == 1 || Mode == 2 || Mode == 3) {
                        T_set[Mode - 1] = T_set[Mode - 1] + 10; 
                } else {
                        ee_tmprSet = ee_tmprSet + 10;
                }
                ReadKey = 0;                
        }
        if (ReadKey == 1)
        {
                if (Mode == 1 || Mode == 2 || Mode == 3) {
                        T_set[Mode - 1] = T_set[Mode - 1] - 10; 
                } else {
                        ee_tmprSet = ee_tmprSet - 10;
                }
                ReadKey = 0;
        }
        if (ReadKey == 3)
        {
                Mode++;
                if (Mode == 4) { 
                        #asm("cli")
                        T_prog[0] = T_set[0];
                        T_prog[1] = T_set[1];
                        T_prog[2] = T_set[2];
                        #asm("sei")
                        Mode = 0;
                }
                ReadKey = 0;
        }
                if (Mode == 1 || Mode == 2 || Mode == 3) {
                sprintf(lcd_buffer1, "Tp %i:   ", Mode);
                sprintf(lcd_buffer2, "%03i     ", T_set[Mode - 1]);        
        }
                        if (ReadKey == 6)
        {
                ee_tmprSet = T_set[0];
                program = 1;
                ReadKey = 0;
        }
        if (ReadKey == 4)
        {
                ee_tmprSet = T_set[1];
                program = 2;
                ReadKey = 0;
        }        
        if (ReadKey == 2)
        {
                ee_tmprSet = T_set[2];
                program = 3;
                ReadKey = 0;
        }        
                if (Mode == 0) {
                sprintf(lcd_buffer1, "Tc=%03i T", T_disp);
                sprintf(lcd_buffer2, "p=%03i P%i", ee_tmprSet, program);
                //sprintf(lcd_buffer2, "p=%04i  ", abs(T_now[1] - T_now[0]));
        }
                lcd_gotoxy(0, 0);
        lcd_puts(lcd_buffer1);
        lcd_gotoxy(0, 1);
        lcd_puts(lcd_buffer2);
                        OCR1AH = (unsigned char)(pwm_val>>8);         
        OCR1AL = (unsigned char)pwm_val; 
              };
}
void green(void) {
        PORTC.4 = 0;
        PORTC.5 = 1;
}
void red(void) {
        PORTC.4 = 1;
        PORTC.5 = 0;
}
void my_beep(void) {
        PORTB.0    = 1;
        delay_ms(10);
        PORTB.0    = 0;
}
static void avr_init() {
// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=P State4=P State3=P State2=P State1=0 State0=0 
PORTB=0x3C;
DDRB=0x03;
// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=0 State4=1 State3=P State2=P State1=P State0=T 
PORTC=0x1E;
DDRC=0x30;
// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 3,600 kHz
TCCR0=0x05;
TCNT0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Ph. correct PWM top=03FFh
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x83;
TCCR1B=0x03;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;
// ADC initialization
// ADC Clock frequency: 115,200 kHz
// ADC Voltage Reference: AREF pin
ADMUX=0x00          ;
ADCSRA=0x8E;
// LCD module initialization
lcd_init(16);
T_set[0] = T_prog[0];
T_set[1] = T_prog[1];
T_set[2] = T_prog[2];
ee_tmprSet = T_set[0];
// Global enable interrupts
#asm("sei")   
}
