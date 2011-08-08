#include	<stdint.h>
#include	"Hardware.h"

#define	UART_RX_BBUFF_SIZE	16	//; must be power of 2
#define	UART_TX_BBUFF_SIZE	8	//; must be power of 2

static char RxBuffer[UART_RX_BBUFF_SIZE];
static volatile uint8_t RxHead, RxTail;

#pragma vector = USART_RXC_vect
__interrupt void  Rx232Handler(void) {
	char RxData = UDR;
	uint8_t Tmp = RxHead;
	if((uint8_t)(Tmp - RxTail) <  (uint8_t) UART_RX_BBUFF_SIZE) {
		RxBuffer[ Tmp++ % UART_RX_BBUFF_SIZE ] = RxData;
		RxHead = Tmp;
	}
}

char getchar (void) {
	uint8_t Tmp = RxTail;
	char RxData;
	while (Tmp == RxHead)
		;
	RxData = RxBuffer[ Tmp++ % UART_RX_BBUFF_SIZE ];
	RxTail = Tmp;
	return(RxData);
}

unsigned char hasinput (void) {
	uint8_t Tmp = RxHead;
	return (Tmp - RxTail);
}

static char TxBuffer[UART_TX_BBUFF_SIZE];
static volatile uint8_t TxHead, TxTail;

#pragma vector = USART_UDRE_vect
__interrupt void  Tx232Handler(void) {
	uint8_t Tmp = TxTail;
	UDR = TxBuffer[ Tmp++ % UART_TX_BBUFF_SIZE ];
	TxTail = Tmp;
	if(Tmp == TxHead) {
		UCSRB &= ~(1<<UDRIE);
	}
}

void putchar (char Byte) {
	uint8_t Tmp = TxHead;
	while((uint8_t)(Tmp - TxTail) >=  (uint8_t) UART_TX_BBUFF_SIZE);	// Buffer full
	TxBuffer[ Tmp++ % UART_TX_BBUFF_SIZE ] = Byte;
	TxHead = Tmp;
	UCSRB |= (1<<UDRIE);
}

void puts_P (const char __flash * string) {
	char c;
	while(c = *string++) {
		putchar(c);
	}
}

void puts (const char * string) {
	char c;
	while(c = *string++) {
		putchar(c);
	}
}
