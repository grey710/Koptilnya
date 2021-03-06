//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru   
//
//  Target(s)...: ATMega8535
//
//  Compiler....: CodeVision
//
//  Description.: UART/USART. ��������� ������ �����������
//
//  Data........: 15.12.09 
//
//***************************************************************************
#include <mega8535.h>
#include "lcd_lib.h"
#include "usart.h"

void main( void )
{
  unsigned char sym;
  
  USART_Init();
  LCD_Init();
  #asm("sei");
  LCD_SendStringFlash("uart:");
  
  while(1){
    sym = USART_GetChar(); //������ �����
    if (sym){             //���� ���-�� �������, �� 
      LCD_Goto(6,0);
      LCD_WriteData(sym); //���������� �� lcd �������� ������
      USART_SendChar('O'); //�������� ����� "Ok "
      USART_SendChar('k');  
      USART_SendChar(' ');  
    }
  }    

}
