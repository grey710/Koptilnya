#ifndef	RS232_H__
#define	RS232_H__
#include	<stdint.h>

extern unsigned char hasinput(void);
extern char getchar(void);
extern void putchar(char);
extern void puts(const char*);
extern void puts_P(const char __flash *);
static uint8_t txdone(void)	{ return UCSRA & (1<<TXC); }

#ifndef	CR
#define	CR	"\r\n"
#endif

#define	putString(string) {				\
	static __flash char str[] = string;	\
	puts_P(str);							\
}

#endif	//RS232_H__
