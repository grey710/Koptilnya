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
//Инициализация экрана
#asm
  .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
//#include "lcd_rus\lcd_rus.h"      
//Компилировать в версии 1.25
#pragma rl+
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

//unsigned char rx_wr_index,rx_rd_index,rx_counter;
unsigned char rx_wr_index,rx_counter;

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

//=============================================================================
// управление в режимах
//порты подключения управляющих реле
#define blok_lamp_1_ON         PORTA.0 = 1    //Включатель/выключатель первого блока ламп
#define blok_lamp_2_ON         PORTA.1 = 1    //Включатель/выключатель второго блока ламп
#define blok_lamp_3_ON         PORTA.2 = 1    //Включатель/выключатель третьего блока ламп
#define blok_lamp_en_ON        PORTA.3 = 1    //Включатель блока ламп
#define blok_lamp_dis_ON       PORTA.4 = 1    //Выключатель блока ламп
#define blok_silovoy_en_ON     PORTA.5 = 1    //Включатель блока электромагнит, дымогенератор, высокое напряжение
#define blok_silovoy_dis_ON    PORTA.6 = 1    //Выключатель блока электромагнит, дымогенератор, высокое напряжение
#define blok_rezerv_ON         PORTA.7 = 1    //резерв

#define blok_lamp_1_OFF         PORTA.0 = 0      //Включатель/выключатель первого блока ламп
#define blok_lamp_2_OFF         PORTA.1 = 0     //Включатель/выключатель второго блока ламп
#define blok_lamp_3_OFF         PORTA.2 = 0     //Включатель/выключатель третьего блока ламп
#define blok_lamp_en_OFF        PORTA.3 = 0     //Включатель блока ламп
#define blok_lamp_dis_OFF       PORTA.4 = 0     //Выключатель блока ламп
#define blok_silovoy_en_OFF     PORTA.5 = 0     //Включатель блока электромагнит, дымогенератор, высокое напряжение
#define blok_silovoy_dis_OFF    PORTA.6 = 0     //Выключатель блока электромагнит, дымогенератор, высокое напряжение
#define blok_rezerv_OFF         PORTA.7 = 0     //резерв

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
#define kn_vverh            PINC.0
#define kn_vniz             PINC.1
#define kn_vpravo           PINC.2
#define kn_vlevo            PINC.3
#define kn_ENTER            PINC.4
#define kn_ESC              PINC.5

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
            sprintf(lcd_str_1,"Koptilnya");            
            sprintf(lcd_str_2,"v.1.0");             
            delay_ms(zadergka_zastavka);       
            break;
        case 11		:	
            sprintf(lcd_str_1,"Max T razogreva");            
            sprintf(lcd_str_2,"%c%c%c",   
            (t_max_razogrev/100)%10 +0x30, 
            (t_max_razogrev/10)%10  +0x30,
            t_max_razogrev%10       +0x30    
            ); 
            break;
        case 12	    :	
            sprintf(lcd_str_1,"Min T razogreva");            
            sprintf(lcd_str_2,"%c%c%c",   
            (t_min_razogrev/100)%10 +0x30,
            (t_min_razogrev/10)%10  +0x30,
            t_min_razogrev%10       +0x30   
            ); 
            break;
        case 21		:	
            sprintf(lcd_str_1,"Max T rabotia");            
            sprintf(lcd_str_2,"%c%c%c",   
            (t_max_rabochee/100)%10 +0x30,
            (t_max_rabochee/10)%10  +0x30,
            t_max_rabochee%10       +0x30   
            );             
            break;
        case 22		:	
            sprintf(lcd_str_1,"Min T raboti");            
            sprintf(lcd_str_2,"%c%c%c",   
            (t_min_rabochee/100)%10 +0x30,
            (t_min_rabochee/10)%10  +0x30,
            t_min_rabochee%10       +0x30   
            );             
            break;
        case 31		:	
            sprintf(lcd_str_1,"Time rabota, ch");            
            sprintf(lcd_str_2,"%c%c",   
            (time_rabota_ch/10)%10  +0x30,
            time_rabota_ch%10       +0x30   
            );             
            break;      
        case 32		:	
            sprintf(lcd_str_1,"Time rabota, min");            
            sprintf(lcd_str_2,"%c%c",   
            (time_rabota_min/10)%10 +0x30, 
            time_rabota_min%10      +0x30     
            );             
            break;      
        case 41		:	
            sprintf(lcd_str_1,"Time smoke, ch");            
            sprintf(lcd_str_2,"%c%c",   
            (time_smoke_ch/10)%10   +0x30, 
            time_smoke_ch%10        +0x30     
            );            
            break;         
        case 42		:	
            sprintf(lcd_str_1,"Time smoke, min");            
            sprintf(lcd_str_2,"%c%c",   
            (time_smoke_min/10)%10  +0x30, 
            time_smoke_min%10       +0x30     
            );
            break;      
        case 60		:	 
#pragma rl+
            sprintf(lcd_str_1,"RAZOGREVРазогрев");            
            sprintf(lcd_str_2,"%c%c:%c%c:%c%c T=%c%c%c C",    
//#pragma rl-           
            
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
            sprintf(lcd_str_1,"RABOTA");            
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
        case 80		:	
            sprintf(lcd_str_1,"SMOKE");            
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
            sprintf(lcd_str_1,"STOP");            
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
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            break;  
        case 11		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }                   
            break;
        case 12         :
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }  
            break;
        case 21		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }         
            break;
        case 22		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }  
            break;
        case 31		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }        
            break;      
        case 32		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }        
            break;      
        case 41		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }     
            break;         
        case 42		:	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            }       
            break;      
        case 60		:	
            if (regim_rabot_old==(11||12||21||22||31||31||41||42)) 
            {
                blok_lamp_1_ON         ; 
                blok_lamp_2_ON         ; 
                blok_lamp_3_ON         ;  
                blok_lamp_dis_OFF      ; 
                blok_silovoy_en_OFF    ;
                blok_silovoy_dis_OFF   ; 
                blok_rezerv_OFF        ;
                
                blok_lamp_en_ON        ;
                delay_ms(t_puskatel)   ;
                blok_lamp_en_OFF       ;                
            }    
            if (real_temp<t_max_razogrev)
            {
                blok_lamp_en_ON        ;   
                delay_ms(t_puskatel)   ;
            }  
            
                blok_lamp_1_ON         ; 
                blok_lamp_2_ON         ; 
                blok_lamp_3_ON         ;  
                blok_lamp_en_OFF      ; 
            break;      
        case 70		:	
                blok_lamp_1_ON         ; 
                blok_lamp_2_ON         ; 
                blok_lamp_3_ON         ;  

                blok_silovoy_en_ON    ;
            break;      
        case 80		:	
                blok_lamp_1_ON         ; 
                blok_lamp_2_ON         ; 
                blok_lamp_3_ON         ;  

                blok_silovoy_en_ON    ;
            break;      
        case 100	:	
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;
            break;          
        default	    :	
            if (regim_rabot_old==(60||70||80||100))
            {
                blok_lamp_1_OFF         ; 
                blok_lamp_2_OFF         ; 
                blok_lamp_3_OFF         ;  
                blok_lamp_en_OFF        ; 
                blok_lamp_dis_OFF       ; 
                blok_silovoy_en_OFF     ;
                blok_silovoy_dis_OFF    ; 
                blok_rezerv_OFF         ;      
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