#ifndef USART_H
#define USART_H

#include <mega8535.h>

void USART_Init(void); //������������� usart`a
void USART_SendChar(unsigned char sym); //������� ������ �� usart`�
unsigned char USART_GetChar(void); //��������� �������� ����� usart`a 

#endif //USART_H