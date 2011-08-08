#include <ioavr.h>

#define OSC             (16000000ULL) // MHz oscillator 4.0
#define RS232_BAUDRATE 38400

#define   LED  PORTD,3,H
//#define   KEY_L  PIND,5,L

#define   KHz              *1000L          // просто чтобы в нулях не запутаться
#define   MHz              *1000L KHz      // просто чтобы в нулях не запутаться
#define   TICKS_PER_CYCLE  10               // количество тактов на 1 итерацию цикла задержки
#define   MS               * OSC / TICKS_PER_CYCLE / 1000  // сколько итераций цикла задержки надо на одну миллисекунду
#define   MKS               MS / 1000                     // на микросекунду в 1000 раз меньше

