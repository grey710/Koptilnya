//***************************************************************************
//
//  Description.: Драйвер знакосинтезирующего жк дисплея
//
//***************************************************************************
#ifndef LCD_LIB_H
#define LCD_LIB_H   

#include <delay.h>
#include <mega8535.h>

//порт к которому подключена шина данных ЖКД
#define PORT_DATA PORTC
#define PIN_DATA  PINC
#define DDRX_DATA DDRC

//порт к которому подключены управляющие выводы ЖКД
#define PORT_SIG PORTB
#define PIN_SIG  PINB
#define DDRX_SIG DDRB

//Номера выводов к которым подключены управляющие выводы ЖКД 
#define RS 2
#define RW 3
#define EN 4

//******************************************************************************
//макросы

/*позиционирование курсора*/
#define LCD_Goto(x,y) LCD_WriteCom(((((y)& 1)*0x40)+((x)& 7))|128) 


//прототипы функций
void LCD_Init(void);//инициализация портов и жкд
void LCD_WriteData(unsigned char data); //выводит байт данных на жкд
void LCD_WriteCom(unsigned char data); //посылает команду жкд
void LCD_SendStringFlash(unsigned char __flash *str); //выводит строку на lcd
#endif