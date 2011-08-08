#include "lcd_lib.h"          
#include "bits_macros.h"

inline void LCD_CommonFunc(unsigned char data)
{
  PORT_DATA = data;		//вывод данных на шину индикатора 
  SetBit(PORT_SIG, EN);	        //установка E в 1
  delay_us(2);
  ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
  delay_us(40);
}

//функция записи команды 
void LCD_WriteCom(unsigned char data)
{
  ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
  LCD_CommonFunc(data);
}

//функция записи данных
void LCD_WriteData(unsigned char data)
{
  SetBit(PORT_SIG, RS);	        //установка RS в 1 - данные
  LCD_CommonFunc(data);
}

//функция инициализации
void LCD_Init(void)
{
  DDRX_DATA = 0xff;
  PORT_DATA = 0xff;	
  DDRX_SIG = 0xff;
  PORT_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
  ClearBit(PORT_SIG, RW);

  delay_ms(40);
  LCD_WriteCom(0x38); //0b00111000 - 8 разрядная шина, 2 строки
  LCD_WriteCom(0xc);  //0b00001100 - дисплей включен, курсор, мерцание выключены
  LCD_WriteCom(0x1);  //0b00000001 - очистка дисплея
  delay_ms(2);
  LCD_WriteCom(0x6);  //0b00000110 - курсор движется вправо, сдвига нет
}

//функция вывода строки 
void LCD_SendStringFlash(unsigned char __flash *str)
{
  unsigned char data;
  SetBit(PORT_SIG, RS);			
  while (*str)
  {
    data = *str++;
    LCD_CommonFunc(data);
  }
}

