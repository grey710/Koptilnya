//***************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru   
//
//  Target(s)...: ATMega8535
//
//  Compiler....: CodeVision 2.04
//
//  Description.: USART/UART. ���������� ��������� �����
//
//  Data........: 3.01.10 
//
//***************************************************************************
#ifndef USART_H
#define USART_H

#include <mega8535.h>

//������ ������
#define SIZE_BUF 16

void USART_Init(void); //������������� usart`a
unsigned char USART_GetTxCount(void); //����� ����� �������� ����������� ������
void USART_FlushTxBuf(void); //�������� ���������� �����
void USART_PutChar(unsigned char sym); //�������� ������ � �����
void USART_SendStr(unsigned char * data); //������� ������ �� usart`�
unsigned char USART_GetRxCount(void); //����� ����� �������� � �������� ������
void USART_FlushRxBuf(void); //�������� �������� �����
unsigned char USART_GetChar(void); //��������� �������� ����� usart`a 

#endif //USART_H