/*****************************************************
CodeWizardAVR V2.05.0 Professional
Project : Koptilnya
Version : 1
Date    : 14.07.2011

Chip type               : ATmega8535
AVR Core Clock frequency: 7,813000 MHz
*****************************************************/
// Standard Input/Output functions
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega8535(L)
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
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
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
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
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
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
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
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
// Alphanumeric LCD Module functions
//Инициализация экрана
#asm
  .equ __lcd_port=0x18 ;PORTB
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
//#include "lcd_rus\lcd_rus.h"
//=================================
// USART Receiver buffer
char rx_buffer[8];
//unsigned char rx_wr_index,rx_rd_index,rx_counter;
unsigned char rx_wr_index,rx_counter;
// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
//===================================================================
// USART Receiver interrupt service routine
interrupt [12] void usart_rx_isr(void)
{
char status,data;
#asm("cli")
    status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
    {
        rx_buffer[rx_wr_index++]=data;
        if (rx_wr_index == 8) rx_wr_index=0;
        if (++rx_counter == 8)
        {
            rx_counter=0;
            rx_buffer_overflow=1;
        }
    }
#asm("sei")
}
                            //=============================================================================
// управление в режимах
//порты подключения управляющих реле
//=============================================================================
//Режимы работы                                         regim_rabot 
//Инициализация (заставка при включении).               1
//Корректировка максимальной температуры разогрева. 	11
//Корректировка минимальной температуры разогрева.      12
//Корректировка максимальной температуры копчения.  	21
//Корректировка минимальной температуры копчения.       22
//Корректировка часов времени работы.	                31
//Корректировка минут времени работы.                   32
//Корректировка часов времени работы вытяжки.	        41
//Корректировка минут времени работы вытяжки.	        42
//Работа в режиме разогрева.	                        60
//Работа в режиме копчения.                             70
//Работа в режиме остывания.	                        80
//STOP	                                                100
//===============================================================================
//порты обозначения кнопок
//==========================================================================
// Глобальные переменные
volatile unsigned char t_max_razogrev     = 115;    // максимальная температура разогрева, в градусах Цельсия
volatile unsigned char t_max_rabochee     = 75;     // максимальная температура работы, в градусах Цельсия
volatile unsigned char t_min_razogrev     = 105;    // минимальная  температура разогрева, в градусах Цельсия
volatile unsigned char t_min_rabochee     = 65;     // минимальная температура работы, в градусах Цельсия
volatile unsigned char time_rabota_ch     = 4;      // время работы, измеряется в часах
volatile unsigned char time_rabota_min    = 30;     // время работы, измеряется в минутах
volatile unsigned char time_smoke_ch      = 0;      // время работы вытяжки, задается в часах
volatile unsigned char time_smoke_min     = 10;     // время работы вытяжки, задается в минутах
volatile unsigned char real_time_ch       = 0;      // текущее время работы в часах
volatile unsigned char real_time_min      = 0;      // текущее время работы в минутах 
volatile unsigned char real_time_sek      = 0;      // текущее время работы в минутах
volatile unsigned char real_temp          = 0;      // минимальная температура работы, в градусах Цельсия
volatile unsigned char real_temp_1razryad = 0;      // 1 разряд температуры при отображении            
volatile unsigned char real_temp_2razryad = 0;      // 2 разряд температуры при отображении            
volatile unsigned char real_temp_3razryad = 0;      // 3 разряд температуры при отображении            
volatile unsigned char regim_rabot        = 1;      // состояние режим работы
volatile unsigned char regim_rabot_old    = 1;      // предыдущее состояние режима работы
unsigned char zadergka_pri_nagatii        = 200;    // задержка при нажатии кнопки
int zadergka_zastavka                     = 1000;    // время показа заставки
unsigned char t_puskatel                  = 100;    // необходимое время для старта пускателя    
volatile char lcd_str_1[16];
volatile char lcd_str_2[16];
//=============================================================================
// Объявление без задания функций. (для обеспечения компиляции)
void frame(void);
void screen(void);
void regim(void);
void init(void);
//=============================================================================
// прерывание ежесекундного (или 0,2 секундного таймера)
interrupt [7] void timer1_compa_isr(void)
{
    #asm("cli")
    TCNT1H=0;
    TCNT1L=0;         
        real_time_sek++;
  	if (real_time_sek == 60) real_time_min++,	real_time_sek =0 ;
	if (real_time_min == 60) real_time_ch++,	real_time_min =0 ;
	if (real_time_ch  == 24) real_time_ch=0;
        #asm("sei")    
    //    frame();
//    screen();    
}
//=============================================================================
// Реакция на нажатие кнопки вверх
void vverh (void)
{
    switch(regim_rabot)
    {
        case 11:    t_max_razogrev++;    break;
        case 12:    t_min_razogrev++;    break;
        case 21:    t_max_rabochee++;    break;
        case 22:    t_min_rabochee++;    break;
        case 31:    time_rabota_ch++;    break;
        case 32:    time_rabota_min++;   break;
        case 41:    time_smoke_ch++;     break;
        case 42:    time_smoke_min++;    break;
        default    :    {};            
    }
}
// Реакция на нажатие кнопки вниз
void vniz (void)
{
    switch(regim_rabot)
    {
        case 11:	t_max_razogrev--;	break;
        case 12:	t_min_razogrev--;	break;
        case 21:	t_max_rabochee--;	break;
        case 22:	t_min_rabochee--;	break;
        case 31:	time_rabota_ch--;	break;
        case 32:	time_rabota_min--;	break;
        case 41:	time_smoke_ch--;	break;
        case 42:	time_smoke_min--;	break;
        default	:	{};			
    }
}
// Реакция на нажатие кнопки вправо
void vpravo(void)
{
    switch(regim_rabot)
    {
        case 11:	regim_rabot = 12;	break;
        case 12:	regim_rabot = 21;	break;
        case 21:	regim_rabot = 22;	break;
        case 22:	regim_rabot = 31;	break;
        case 31:	regim_rabot = 32;	break;
        case 32:	regim_rabot = 41;	break;
        case 41:	regim_rabot = 42;	break;
        case 42:	regim_rabot = 11;	break;
        default	:	{};			
    }       
}
// Реакция на нажатие кнопки влево
void vlevo(void)
{
    switch(regim_rabot)
    {
        case 11:	regim_rabot = 42;	break;
        case 12:	regim_rabot = 11;	break;
        case 21:	regim_rabot = 12;	break;
        case 22:	regim_rabot = 21;	break;
        case 31:	regim_rabot = 22;	break;
        case 32:	regim_rabot = 31;	break;
        case 41:	regim_rabot = 32;	break;
        case 42:	regim_rabot = 41;	break;
        default	:	{};			
    }       
}
// Реакция на нажатие кнопки enter
void enter(void)	
{
    switch(regim_rabot)
    {
        case 11:	regim_rabot = 60;	break;
        case 12:	regim_rabot = 60;	break;
        case 21:	regim_rabot = 60;	break;
        case 22:	regim_rabot = 60;	break;
        case 31:	regim_rabot = 60;	break;
        case 32:	regim_rabot = 60;	break;
        case 41:	regim_rabot = 60;	break;
        case 42:	regim_rabot = 60;	break;
        default	:	{};			
    }       
}
// Реакция на нажатие кнопки esc
void esc(void)	
{
    regim_rabot        = 11;    
    real_time_ch       = 0;      // текущее время работы в часах
    real_time_min      = 0;      // текущее время работы в минутах 
    real_time_sek      = 0;      // текущее время работы в минутах
}
// проверка нажатия кнопок
void klaviatura(void)
{
        if (PINC.0==0) { 
            delay_ms(zadergka_pri_nagatii);
            vverh();
            }
        if (PINC.1==0) { 
            delay_ms(zadergka_pri_nagatii);
            vlevo();
            }
        if (PINC.2==0) { 
            delay_ms(zadergka_pri_nagatii);
            vniz();
            }
        if (PINC.3==0) { 
            delay_ms(zadergka_pri_nagatii);
            vpravo();
            }
        if (PINC.4==0) { 
            delay_ms(zadergka_pri_nagatii);
            enter();
            }
        if (PINC.5==0) { 
            delay_ms(zadergka_pri_nagatii);
            esc();
            }  
}
//=================================================
void screen(void)
{
    lcd_clear();          	// очистка ЛСД      
        lcd_gotoxy(0,0);      	// установка курсора на 0,0
    lcd_puts(lcd_str_1); 
        lcd_gotoxy(0,1);      	// установка курсора на начало второй строки
    lcd_puts(lcd_str_2);
    }
//==================================================
void frame(void)
{
    switch(regim_rabot)
    {
        case 1		:                 
#pragma rl+        
            sprintf(lcd_str_1,"Коптильня");            
#pragma rl-
            sprintf(lcd_str_2,"v.2.0 ru");             
            delay_ms(zadergka_zastavka);       
            break;
        case 11		:	
#pragma rl+        
            sprintf(lcd_str_1,"Макс Т разогрева");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c%c",   
            (t_max_razogrev/100)%10 +0x30, 
            (t_max_razogrev/10)%10  +0x30,
            t_max_razogrev%10       +0x30    
            ); 
            break;
        case 12	    :	
#pragma rl+
            sprintf(lcd_str_1,"Мин Т разогрева");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c%c",   
            (t_min_razogrev/100)%10 +0x30,
            (t_min_razogrev/10)%10  +0x30,
            t_min_razogrev%10       +0x30   
            ); 
            break;
        case 21		:	
#pragma rl+
            sprintf(lcd_str_1,"Макс Т работы");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c%c",   
            (t_max_rabochee/100)%10 +0x30,
            (t_max_rabochee/10)%10  +0x30,
            t_max_rabochee%10       +0x30   
            );             
            break;
        case 22		:	
#pragma rl+
            sprintf(lcd_str_1,"Мин Т работы");            
#pragma rl-           
            sprintf(lcd_str_2,"%c%c%c",   
            (t_min_rabochee/100)%10 +0x30,
            (t_min_rabochee/10)%10  +0x30,
            t_min_rabochee%10       +0x30   
            );             
            break;
        case 31		:	
#pragma rl+
            sprintf(lcd_str_1,"Вр. работы, часы");            
#pragma rl-           
            sprintf(lcd_str_2,"%c%c",   
            (time_rabota_ch/10)%10  +0x30,
            time_rabota_ch%10       +0x30   
            );             
            break;      
        case 32		:	
#pragma rl+           
            sprintf(lcd_str_1,"Вр. работы, мин.");            
#pragma rl-           
            sprintf(lcd_str_2,"%c%c",   
            (time_rabota_min/10)%10 +0x30, 
            time_rabota_min%10      +0x30     
            );             
            break;      
        case 41		:	
#pragma rl+
            sprintf(lcd_str_1,"Вр. дым, часы");            
#pragma rl-           
            sprintf(lcd_str_2,"%c%c",   
            (time_smoke_ch/10)%10   +0x30, 
            time_smoke_ch%10        +0x30     
            );            
            break;         
        case 42		:	
#pragma rl+
            sprintf(lcd_str_1,"Вр. дым, минуты");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c",   
            (time_smoke_min/10)%10  +0x30, 
            time_smoke_min%10       +0x30     
            );
            break;      
        case 60		:	 
#pragma rl+
            sprintf(lcd_str_1,"    РАЗОГРЕВ");            
#pragma rl-           
            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",    
                        (real_time_ch/10)%10	+0x30,
            real_time_ch%10		    +0x30,
            (real_time_min/10)%10	+0x30,
            real_time_min%10		+0x30,
            (real_time_sek/10)%10	+0x30,
            real_time_sek%10		+0x30, 
            real_temp_1razryad,
            real_temp_2razryad,
            real_temp_3razryad          
            );
            break;      
        case 70		:	
#pragma rl+
            sprintf(lcd_str_1,"     РАБОТА");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
            (real_time_ch/10)%10	+0x30,
            real_time_ch%10         +0x30,
            (real_time_min/10)%10	+0x30,
            real_time_min%10		+0x30,
            (real_time_sek/10)%10	+0x30,
            real_time_sek%10		+0x30, 
              real_temp_1razryad,
            real_temp_2razryad,
            real_temp_3razryad          
            );
            break;      
        case 80		:	
#pragma rl+
            sprintf(lcd_str_1,"    ВЫТЯЖКА");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
            (real_time_ch/10)%10	+0x30,
            real_time_ch%10             +0x30,
            (real_time_min/10)%10	+0x30,
            real_time_min%10		+0x30,
            (real_time_sek/10)%10	+0x30,
            real_time_sek%10		+0x30, 
                        real_temp_1razryad,
            real_temp_2razryad,
            real_temp_3razryad          
            );
            break;      
        case 100	:	
#pragma rl+
            sprintf(lcd_str_1,"      СТОП");            
#pragma rl-
            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",
            (real_time_ch/10)%10	+0x30,
            real_time_ch%10             +0x30,
            (real_time_min/10)%10	+0x30,
            real_time_min%10		+0x30,
            (real_time_sek/10)%10	+0x30,
            real_time_sek%10		+0x30, 
                        real_temp_1razryad,
            real_temp_2razryad,
            real_temp_3razryad          
            );
            break;          
                    default	    :	
            lcd_putsf("www.xxx.ua");
            delay_ms(10);
            break;
    }  
}
//=================================================
void regim(void) 
{
//       regim_rabot_old = regim_rabot; 
                switch(regim_rabot)
        {
        case 1		:   
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            break;  
        case 11		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }                   
            break;
        case 12         :
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }  
            break;
        case 21		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }         
            break;
        case 22		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }  
            break;
        case 31		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }        
            break;      
        case 32		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }        
            break;      
        case 41		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }     
            break;         
        case 42		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            }       
            break;      
        case 60		:	
            if (regim_rabot_old==(11||12||21||22||31||31||41||42)) 
            {
                PORTA.0 = 1             ; 
                PORTA.1 = 1             ; 
                PORTA.2 = 1             ;  
                PORTA.4 = 0           ; 
                PORTA.5 = 0         ;
                PORTA.6 = 0        ; 
                PORTA.7 = 0             ;
                                PORTA.3 = 1            ;
                delay_ms(t_puskatel)   ;
                PORTA.3 = 0            ;                
            }    
            if (real_temp<t_max_razogrev)
            {
                PORTA.3 = 1            ;   
                delay_ms(t_puskatel)   ;
            }  
                            PORTA.0 = 1             ; 
                PORTA.1 = 1             ; 
                PORTA.2 = 1             ;  
                PORTA.3 = 0           ; 
            break;      
        case 70		:	
                PORTA.0 = 1             ; 
                PORTA.1 = 1             ; 
                PORTA.2 = 1             ;  
                PORTA.5 = 1        ;
            break;      
        case 80		:	
                PORTA.0 = 1             ; 
                PORTA.1 = 1             ; 
                PORTA.2 = 1             ;  
                PORTA.5 = 1        ;
            break;      
        case 100	:	
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;
            break;          
        default	    :	
            if (regim_rabot_old==(60||70||80||100))
            {
                PORTA.0 = 0               ; 
                PORTA.1 = 0              ; 
                PORTA.2 = 0              ;  
                PORTA.3 = 0             ; 
                PORTA.4 = 0            ; 
                PORTA.5 = 0          ;
                PORTA.6 = 0         ; 
                PORTA.7 = 0              ;      
            }  
            break;
        };  
        regim_rabot_old = regim_rabot; 
}
//=================================================
void init(void)
{
// Port A initialization
    PORTA=0x00;
    DDRA=0xFF;
// Port B initialization
    PORTB=0x00;
    DDRB=0x00;
// Инициализация порта клавиатуры. 
// Port C initialization
    PORTC=0xFF;         // вкл. подтягивающие резисторы 
    DDRC=0x00;          // весь порт как вход 
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
}
void main(void)
{
    init();
    regim_rabot=1;             // Заставка    
    frame();
    screen();
        delay_ms(zadergka_zastavka);
        regim_rabot=11;            // Установка режима работ на задание температуры  
    frame();
    screen();
            #asm("sei")                // Разрешение прерываний   
    while(1)                   // Вечный цикл
    {
        klaviatura();          // обработка нажатой кнопки             
                regim();
/*
        if (getchar()=='#') 
        {
                real_temp_1razryad = getchar();      // 1 разряд температуры при отображении            
                real_temp_2razryad = getchar();      // 2 разряд температуры при отображении            
                real_temp_3razryad = getchar();      // 3 разряд температуры при отображении    
                
                real_temp=(real_temp_1razryad*100+real_temp_2razryad*10+real_temp_3razryad);        
        }
*/
        frame();
        screen();
    }       
}
