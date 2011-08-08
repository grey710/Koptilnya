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
#include "usart.h"

//���������� �����
unsigned char usartTxBuf[SIZE_BUF];
unsigned char txBufTail = 0;
unsigned char txBufHead = 0;
unsigned char txCount = 0;

//�������� �����
unsigned char usartRxBuf[SIZE_BUF];
unsigned char rxBufTail = 0;
unsigned char rxBufHead = 0;
unsigned char rxCount = 0;

//������������� usart`a
void USART_Init(void)
{
  UBRRH = 0;
  UBRRL = 51; //�������� ������ 9600 ���
  UCSRB = (1<<RXCIE)|(1<<TXCIE)|(1<<RXEN)|(1<<TXEN); //����. ������ ��� ������ � ��������, ���� ������, ���� ��������.
  UCSRC = (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0); //������ ����� 8 ��������
}

//______________________________________________________________________________
//���������� ����������� �������� ����������� ������
unsigned char USART_GetTxCount(void)
{
  return txCount;  
}

//"�������" ���������� �����
void USART_FlushTxBuf(void)
{
  txBufTail = 0; 
  txCount = 0;
  txBufHead = 0;
}

//�������� ������ � �����, ���������� ������ ��������
void USART_PutChar(unsigned char sym)
{
  //���� ������ usart �������� � ��� ������ ������
  //����� ��� ����� � ������� UDR
  if(((UCSRA & (1<<UDRE)) != 0) && (txCount == 0)) UDR = sym;
  else {
    if (txCount < SIZE_BUF){    //���� � ������ ��� ���� �����
      usartTxBuf[txBufTail] = sym; //�������� � ���� ������
      txCount++;                   //�������������� ������� ��������
      txBufTail++;                 //� ������ ������ ������
      if (txBufTail == SIZE_BUF) txBufTail = 0;
    }
  }
}

//������� ���������� ������ �� usart`�
void USART_SendStr(unsigned char * data)
{
  unsigned char sym;
  while(*data){
    sym = *data++;
    USART_PutChar(sym);
  }
}

//���������� ���������� �� ���������� �������� 
interrupt [USART_TXC] void usart_txc_my(void) 
{
  if (txCount > 0){              //���� ����� �� ������
    UDR = usartTxBuf[txBufHead]; //���������� � UDR ������ �� ������
    txCount--;                   //��������� ������� ��������
    txBufHead++;                 //�������������� ������ ������ ������
    if (txBufHead == SIZE_BUF) txBufHead = 0;
  } 
} 

//______________________________________________________________________________
//���������� ����������� �������� ����������� � �������� ������
unsigned char USART_GetRxCount(void)
{
  return rxCount;  
}

//"�������" �������� �����
void USART_FlushRxBuf(void)
{
  unsigned char saveSreg = SREG;
  #asm("cli");
  rxBufTail = 0;
  rxBufHead = 0;
  rxCount = 0;
  SREG = saveSreg;
}

//������ ������
unsigned char USART_GetChar(void)
{
  unsigned char sym;
  if (rxCount > 0){                     //���� �������� ����� �� ������  
    sym = usartRxBuf[rxBufHead];        //��������� �� ���� ������    
    rxCount--;                          //��������� ������� ��������
    rxBufHead++;                        //���������������� ������ ������ ������  
    if (rxBufHead == SIZE_BUF) rxBufHead = 0;
    return sym;                         //������� ����������� ������
  }
  return 0;
}


//���������� �� ���������� ������
interrupt [USART_RXC] void usart_rxc_my(void) 
{
  if (rxCount < SIZE_BUF){                //���� � ������ ��� ���� �����                     
      usartRxBuf[rxBufTail] = UDR;        //������� ������ �� UDR � �����
      rxBufTail++;                             //��������� ������ ������ ��������� ������ 
      if (rxBufTail == SIZE_BUF) rxBufTail = 0;  
      rxCount++;                                 //��������� ������� �������� ��������
    }
} 

