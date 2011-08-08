#include "usart.h"

//����������� �����
volatile unsigned char usartRxBuf = 0;

#define RXCIE 7  
#define RXEN  4
#define TXEN  3
#define URSEL 7
#define UCSZ1 2
#define UCSZ0 1

//������������� usart`a
void USART_Init(void)
{
  UBRRH = 0;
  UBRRL = 51; //�������� ������ 9600 ���
  UCSRB = (1<<RXCIE)|(1<<RXEN)|(1<<TXEN); //����. ������ ��� ������, ���� ������, ���� ��������.
  UCSRC = (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0); //������ ����� 8 ��������
}

#define UDRE 5 
//�������� ������� �� usart`�
void USART_SendChar(unsigned char sym)
{
  while(!(UCSRA & (1<<UDRE)));
  UDR = sym;
}

//������ ������
unsigned char USART_GetChar(void)
{
  unsigned char tmp;
  unsigned char saveState = SREG;
  #asm("cli");
  tmp = usartRxBuf;
  usartRxBuf = 0;
  SREG = saveState;
  return tmp;  
}

//����� ������� �� usart`� � �����
interrupt [USART_RXC] void usart_rxc_my(void) 
{
  usartRxBuf = UDR; 
} 

