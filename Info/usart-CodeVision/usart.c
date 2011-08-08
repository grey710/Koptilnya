#include "usart.h"

//однобайтный буфер
volatile unsigned char usartRxBuf = 0;

#define RXCIE 7  
#define RXEN  4
#define TXEN  3
#define URSEL 7
#define UCSZ1 2
#define UCSZ0 1

//инициализация usart`a
void USART_Init(void)
{
  UBRRH = 0;
  UBRRL = 51; //скорость обмена 9600 бод
  UCSRB = (1<<RXCIE)|(1<<RXEN)|(1<<TXEN); //разр. прерыв при приеме, разр приема, разр передачи.
  UCSRC = (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0); //размер слова 8 разрядов
}

#define UDRE 5 
//отправка символа по usart`у
void USART_SendChar(unsigned char sym)
{
  while(!(UCSRA & (1<<UDRE)));
  UDR = sym;
}

//чтение буфера
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

//прием символа по usart`у в буфер
interrupt [USART_RXC] void usart_rxc_my(void) 
{
  usartRxBuf = UDR; 
} 

