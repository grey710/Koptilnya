/*****************************************************
Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,0000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <math.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x00          

#define	KEY1_DOWN	(PINC.1 == 0)
#define	KEY2_DOWN	(PINC.2 == 0)
#define	KEY3_DOWN	(PINC.3 == 0)
#define	KEY4_DOWN	(PINB.5 == 0)
#define	KEY5_DOWN	(PINB.4 == 0)
#define	KEY6_DOWN	(PINB.3 == 0)

#define BEEP            PORTB.0   

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
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
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
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        TCNT0=0x00;
        if (ReadKey == 0) {
	        if (KeyDelay == 0) {              // Если KeyDelay == 0, то можно нажимать опять 		
	                KeyDelay = 0;
	                if (KEY1_DOWN)	{
	                        ReadKey = 1;
	                        my_beep();
	                }
	                if (KEY2_DOWN)	{
	                        ReadKey = 2;
	                        my_beep();
	                }
	                if (KEY3_DOWN)	{
	                        ReadKey = 3;
	                        my_beep();
	                }
	                if (KEY4_DOWN)	{
	                        ReadKey = 4;
	                        my_beep();
	                }
	                if (KEY5_DOWN)	{
	                        ReadKey = 5;
	                        my_beep();
	                }
	                if (KEY6_DOWN)	{
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
        BEEP = 1;
        delay_ms(10);
        BEEP = 0;
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
ADMUX=ADC_VREF_TYPE;
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
