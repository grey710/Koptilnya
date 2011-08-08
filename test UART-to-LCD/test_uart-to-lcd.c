/*****************************************************
CodeWizardAVR V2.05.0 Professional
Project : Koptilnya
Version : 1
Date    : 14.07.2011

Chip type               : ATmega8535
AVR Core Clock frequency: 7,813000 MHz
*****************************************************/
// Standard Input/Output functions
#include <mega8535.h>
#include <stdio.h>           
#include <delay.h>

// Alphanumeric LCD Module functions
//������������� ������
#asm
  .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

//=================================
#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR       (1<<FE)
#define PARITY_ERROR        (1<<UPE)
#define DATA_OVERRUN        (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE         (1<<RXC)

#define _DEBUG_TERMINAL_IO_

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

unsigned char rx_wr_index,rx_rd_index,rx_counter;

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

//===================================================================
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;

#asm("cli")
    
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {
        rx_buffer[rx_wr_index++]=data;

        if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
        if (++rx_counter == RX_BUFFER_SIZE)
        {
            rx_counter=0;
            rx_buffer_overflow=1;
        }
    }
#asm("sei")
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_

#pragma used+

char getchar(void)
{
    char data;
    while (rx_counter==0);
    data=rx_buffer[rx_rd_index++];

    #asm("cli")
    --rx_counter;
    #asm("sei")
    return data;
}

#pragma used-
#endif

//����� ����������� ������
#define kn_vverh            PINC.0
#define kn_vniz             PINC.1
#define kn_vpravo           PINC.2
#define kn_vlevo            PINC.3
#define kn_ENTER            PINC.4
#define kn_ESC              PINC.5
//==========================================================================
// ���������� ����������
//volatile unsigned char t_max_razogrev     = 115;    // ������������ ����������� ���������, � �������� �������
//volatile unsigned char t_max_rabochee     = 75;     // ������������ ����������� ������, � �������� �������
//volatile unsigned char t_min_razogrev     = 105;    // �����������  ����������� ���������, � �������� �������
//volatile unsigned char t_min_rabochee     = 65;     // ����������� ����������� ������, � �������� �������

volatile unsigned char real_temp;                   // ������� �����������

//volatile unsigned char time_rabota_ch     = 4;      // ����� ������, ���������� � �����
//volatile unsigned char time_rabota_min    = 30;     // ����� ������, ���������� � �������
//volatile unsigned char time_smoke_ch      = 0;      // ����� ������ �������, �������� � �����
//volatile unsigned char time_smoke_min     = 10;     // ����� ������ �������, �������� � �������

volatile unsigned char real_time_ch       = 0;      // ������� ����� ������ � �����
volatile unsigned char real_time_min      = 0;      // ������� ����� ������ � ������� 
volatile unsigned char real_time_sek      = 0;      // ������� ����� ������ � �������

\\volatile unsigned char regim_rabot        = 1;      // ��������� ����� ������
\\volatile unsigned char regim_rabot_work   = 1;      // ���������� ��������� ������ ������

//unsigned char time_migat                = 100;    // ����� ������� ��� ������ ��������, �������� � ��.
//unsigned char zadergka_pri_nagatii        = 100;    // �������� ��� ������� ������
//unsigned char zadergka_zastavka           = 200;    // ����� ������ ��������

volatile char lcd_str_1[16];
volatile char lcd_str_2[16];

//=============================================================================
// ���������� ��� ������� �������. (��� ����������� ����������)
\\void video(void);

\\unsigned char read_temp();

//=============================================================================
// ���������� ������������� (��� 0,2 ���������� �������)
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    #asm("cli")

    TCNT1H=0;
    TCNT1L=0;         
    
    real_time_sek++;
  	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
	if (real_time_ch  == 24) real_time_ch=0;
    
    #asm("sei") 
}

//=================================================
/*
unsigned char read_temp()
{
    unsigned char n,t;   

    for (n=0; n<5 ; n++) 
    {
        if (getchar()=='#') 
        {   
            
            t=0; 
            
            t = getchar()*100;
            t = real_temp + getchar()*10;
            t = real_temp + getchar();
            
            return t;
            
        };           
    };               
    return 0;
}
*/

void main(void)
{
//=================================================
// Input/Output Ports initialization
// Port A initialization
    PORTA=0x00;
    DDRA=0xFF;
// Port B initialization
    PORTB=0x00;
    DDRB=0x00;
// ������������� ����� ����������. 
// Port C initialization
    PORTC=0xFF;         // ���. ������������� ��������� 
    DDRC=0x00;          // ���� ���� ��� ���� 

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x05;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x1E;
    OCR1AL=0x85;
    OCR1BH=0x00;
    OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x10;

//=================================================
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

//=================================================
// LCD module initialization
    lcd_init(16);

//=================================================
        
// ���������� ����������             
    #asm("sei")
// ������ ����
    while(1)
    {

        //read_temp();
//        if (getchar()=='#') real_temp = getchar()*100;
        
//        real_temp = real_temp + getchar()*10;
        real_temp = getchar();

        real_temp++;
        
        delay_ms(5);

//===============================================================
        sprintf(lcd_str_1,"RAZOGREV");            

            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
            (real_time_ch/10)%10	+0x30,
            real_time_ch%10		    +0x30,
            (real_time_min/10)%10	+0x30,
            real_time_min%10		+0x30,
            (real_time_sek/10)%10	+0x30,
            real_time_sek%10		+0x30, 
                                                   
            (real_temp/100)%10	    +0x30,
            (real_temp/10)%10	    +0x30,
            real_temp%10	    +0x30
//            getchar()		    +0x30
            );


//========================================================
    lcd_clear();          	// ������� ���      
    
    lcd_gotoxy(0,0);      	// ��������� ������� �� 0,0
    lcd_puts(lcd_str_1); 
    
    lcd_gotoxy(0,1);      	// ��������� ������� �� ������ ������ ������
    lcd_puts(lcd_str_2);
    
    delay_ms(5);
            
    }       
}

