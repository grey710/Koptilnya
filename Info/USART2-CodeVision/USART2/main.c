//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru   
//
//  Target(s)...: ATMega8535
//
//  Compiler....: CodeVision 2.04
//
//  Description.: USART/UART. Используем кольцевой буфер
//
//  Data........: 3.01.10 
//
//***************************************************************************
#include <mega8535.h>
#include "usart.h"

void main( void )
{
  unsigned char symbol;
  USART_Init();
  #asm("sei");

  while(1){
    symbol = USART_GetChar();   //взять символ из буфера
    if (symbol == 't')          //если 't' - ответить
      USART_SendStr(" test - OK ");
  }    
}
