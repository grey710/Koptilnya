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
#include <delay.h>

#define ADC_VREF_TYPE 0x00      
unsigned int adc_data = 0, T_now=0;

static void avr_init();
 
//unsigned int read_adc(unsigned char adc_input);

int i=100;

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

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
    UCSRA=0x00;
    UCSRB=0x18;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=0x0C;

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

// Global enable interrupts
    #asm("sei")   
}

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
   


void main(void)
{
    avr_init();
        
    while (1)
    {
        delay_ms(100);          
        adc_data=read_adc(0);
       
        T_now = (1000 - adc_data) / 2; 
        
        printf("%i", T_now);
        printf("#");   
        i++;

    };
}



