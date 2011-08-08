/*************************************************/
/****                                         ****/
/****   Macros written by Ascold Volkov       ****/
/****                                         ****/
/*************************************************/

#ifdef	__IAR_SYSTEMS_ICC__
/*
typedef unsigned char uchar;
typedef signed char sbyte;
typedef unsigned int uint;
typedef unsigned long ulong;
*/
#define _setL(port,bit) port&=~(1<<bit)
#define _setH(port,bit) port|=(1<<bit)
#define _set(port,bit,val) _set##val(port,bit)
#define on(x) _set (x)
#define SET _setH

#define _clrL(port,bit) port|=(1<<bit)
#define _clrH(port,bit) port&=~(1<<bit)
#define _clr(port,bit,val) _clr##val(port,bit)
#define off(x) _clr (x)
#define CLR _clrH

#define _bitL(port,bit) (!(port&(1<<bit)))
#define _bitH(port,bit) (port&(1<<bit))
#define _bitH1(port,bit) (port&(1<<bit)&port)
#define _bit(port,bit,val) _bit##val(port,bit)
#define signal(x) _bit (x)
#define BIT _bitH

#define _cpl(port,bit,val) port^=(1<<bit)
#define cpl(x) _cpl (x)
#define CPL(port,bit) (port^=(1<<bit))

#define CLF(port,bit) port=(1<<bit)

#define _pinit_port_H 1
#define _pinit_port_L 0
#define _pinit_port_Z 0
#define _pinit_port_R 1
#define _pinit_ddr_H 1
#define _pinit_ddr_L 1
#define _pinit_ddr_Z 0
#define _pinit_ddr_R 0
#ifdef __IOM103_H
  #define _wDDRA(x) DDRA=x
  #define _wDDRB(x) DDRB=x
  #define _wDDRC(x)
  #define _wDDRD(x) DDRD=x
  #define _wDDRE(x) DDRE=x
  #define _wDDRF(x) DDRF=x
#else
  #define _wDDRA(x) DDRA=x
  #define _wDDRB(x) DDRB=x
  #define _wDDRC(x) DDRC=x
  #define _wDDRD(x) DDRD=x
  #define _wDDRE(x) DDRE=x
  #define _wDDRF(x) DDRF=x
  #define _wDDRG(x) DDRG=x
#endif
#define PINIT(port,i0,i1,i2,i3,i4,i5,i6,i7) \
  PORT##port=\
    _pinit_port_##i0|\
    _pinit_port_##i1<<1|\
    _pinit_port_##i2<<2|\
    _pinit_port_##i3<<3|\
    _pinit_port_##i4<<4|\
    _pinit_port_##i5<<5|\
    _pinit_port_##i6<<6|\
    _pinit_port_##i7<<7;\
  _wDDR##port(\
    _pinit_ddr_##i0|\
    _pinit_ddr_##i1<<1|\
    _pinit_ddr_##i2<<2|\
    _pinit_ddr_##i3<<3|\
    _pinit_ddr_##i4<<4|\
    _pinit_ddr_##i5<<5|\
    _pinit_ddr_##i6<<6|\
    _pinit_ddr_##i7<<7)
#define _pinit(p,x) PINIT (p,x)
#define INIT_PORT(p) _pinit(p,p##_INIT)

#define _bitset(bits)\
  ((byte)(\
  (bits%010)|\
  (bits/010%010)<<1|\
  (bits/0100%010)<<2|\
  (bits/01000%010)<<3|\
  (bits/010000%010)<<4|\
  (bits/0100000%010)<<5|\
  (bits/01000000%010)<<6|\
  (bits/010000000%010)<<7))
#define BITSET(bits) _bitset(0##bits)

#define delay(mks)\
  {unsigned int dly; for(dly=(unsigned)(OSC*mks/7./1000000L); dly!=0; dly--);}
#endif
