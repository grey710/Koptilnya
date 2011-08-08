/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  Модификация: Samodelkin (Danil Pervakov)
  08 апреля 2008 года.

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE LCD IS CONNECTED!

  EXAMPLE FOR PORTB:

    #asm
        .equ __lcd_port=0x18
    #endasm
    #include <lcd_rus.h>

*/

#ifndef _LCD_INCLUDED_
#define _LCD_INCLUDED_

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);

// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);

// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);

// включить курсор (немигающий)
void lcd_cursor_on(void);

// включить курсор (мигающий )
void lcd_cursor_blink(void);

// выключить курсор
void lcd_cursor_off(void);

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
#pragma library lcd_rus.lib

#endif

