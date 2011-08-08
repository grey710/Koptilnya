#ifndef USART_H
#define USART_H

#include <mega8535.h>

void USART_Init(void); //инициализация usart`a
void USART_SendChar(unsigned char sym); //послать символ по usart`у
unsigned char USART_GetChar(void); //прочитать приемный буфер usart`a 

#endif //USART_H