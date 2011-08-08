#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>  /* ��� sei() */
#include <util/delay.h>     /* ��� _delay_ms() */

#include <avr/pgmspace.h>   /* ��������� ��� usbdrv.h */
#include "usbdrv.h"

typedef unsigned char byte;

#define RQ_IO_READ        0x11
#define RQ_IO_WRITE       0x12
#define RQ_MEM_READ       0x13
#define RQ_MEM_WRITE      0x14

#define RQ_EOP_RES        0x1E
#define RQ_EOP_FLAG       0x1F
#define RQ_TEST           0x20

#define RQ_OW_WBIT        0x21
#define RQ_OW_WBYTE       0x22
#define RQ_OW_RBIT        0x23
#define RQ_OW_RBYTE       0x24
#define RQ_OW_RESET       0x25
#define RQ_OW_COMMAND     0x26
#define RQ_OW_FIRST       0x27
#define RQ_OW_NEXT        0x28
#define RQ_OW_GET_ROM     0x29
#define RQ_OW_SET_ROM     0x2A
#define RQ_OW_SEARCH_ALL  0x2B
#define RQ_OW_GET_ROMI    0x2C

#define DQDDR             DDRB
#define DQPORT            PORTB
#define DQPIN             PINB
#define DQ                PB1

#define TRUE              1
#define FALSE             0
#define NULL              0

#define DMAX              16

//=============================================================================
// ��������� �������
//=============================================================================
// ������ � ����� 1-Wire
//-----------------------------------------------------------------------------
void OWWriteBit(byte bit_value);
void OWWriteByte(byte byte_value);
byte OWReadBit(void);
byte OWReadByte(void);
int OWReset(void);
void OWCommand(byte *rom, byte cmd);
int OWFirst(void);
int OWNext(void);
int OWSearch(void);
//=============================================================================
// ����������� ����������
//=============================================================================
byte ROM_NO[8];
byte rom[DMAX][8];  // ������ ��� ROM ���������� (DMAX, ������ - 16) ���������
byte dNum = 0;      // ������� ���������� ��������
byte dCur = 0;      // ����� ��������� 1-Wire ����������
int LastDiscrepancy; 
int LastDeviceFlag;
char s[16];
byte dataBuffer[4];
byte buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
int eopFlag;       // ���� ��������� ���������� �������
byte eopRes;
//=============================================================================
// ������� ��� ������ � 1-Wire
// ������ ����������� �� ��������� ������� (����� ��������� - OWFirst, OWNext �
// OWSearch) ����� �� ��������� Dallas Semiconductor: 
// "Application Note 187: 1-Wire Search Algorithm"
// http://www.maxim-ic.com/appnotes.cfm/appnote_number/187
//=============================================================================
// Send 1 bit of data to the 1-Wire bus
//-----------------------------------------------------------------------------
void OWWriteBit(byte bit_value){
  cli();
  if(bit_value == 0){
    DQDDR |= _BV(DQ);
    _delay_us(60);
    DQDDR &= ~_BV(DQ);
    _delay_us(10);
  }else{
    DQDDR |= _BV(DQ);
    _delay_us(6);
    DQDDR &= ~_BV(DQ);
    _delay_us(64);
  }
  sei();
}
//-----------------------------------------------------------------------------
// Send 8 bits of data to the 1-Wire bus
//-----------------------------------------------------------------------------
void OWWriteByte(byte byte_value){
  byte i;
  for(i = 0; i < 8; i++) {
    OWWriteBit(byte_value & 0x01);
    byte_value >>= 1;
  }
}
//-----------------------------------------------------------------------------
// Read 1 bit of data from the 1-Wire bus
// Return 1 : bit read is 1
// 0 : bit read is 0
//-----------------------------------------------------------------------------
byte OWReadBit(){
  byte ret;
  cli();
  DQDDR |= _BV(DQ);
  _delay_us(6);
  DQDDR &= ~_BV(DQ);
  _delay_us(9);
  ret = (DQPIN & _BV(DQ));
  _delay_us(55);
  sei();
  return ret >> DQ; // �������� ���� - � ������� ������
}
//-----------------------------------------------------------------------------
// ������ ����� � ����
//-----------------------------------------------------------------------------
byte OWReadByte(void){
  byte i, mask = 0x01, ret = 0x00;
  for(i = 0; i < 8; i++) {
    if(OWReadBit())
      ret |= mask;
    mask <<= 1;
  }
  return ret;
}
//-----------------------------------------------------------------------------
// Reset the 1-Wire bus and return the presence of any device
// Return TRUE : device present
// FALSE : no device present
//-----------------------------------------------------------------------------
int OWReset(){
  byte ret;
  cli();
  DQDDR |= _BV(DQ);
  _delay_us(480);
  DQDDR &= ~_BV(DQ);
  _delay_us(70);
  ret = (DQPIN & _BV(DQ));
  _delay_us(410);
  sei();
  return (1 - (ret >> DQ));
}
//-----------------------------------------------------------------------------
// ������� ������ ���. E��� rom == NULL, �� ������� ���������� ���� �����������
// �� ����. ���� rom != NULL, �� ����������, ������������� �������� �����������
// � ������� rom.
//-----------------------------------------------------------------------------
void OWCommand(byte *rom, byte cmd) {
  byte i;
  if(rom == NULL) // ������� ���� ������������ �����������
    OWWriteByte(0xCC);
  else { // ������� ����������� ���������� (rom)
    OWWriteByte(0x55);
    for(i = 0; i < 8; i++)
      OWWriteByte(rom[i]);
  }
  OWWriteByte(cmd);
}
//-----------------------------------------------------------------------------
// Find the 'first' devices on the 1-Wire bus
// Return TRUE : device found, ROM number in ROM_NO buffer
// FALSE : no device present
//-----------------------------------------------------------------------------
int OWFirst(void){
  // reset the search state
  LastDiscrepancy = 0;
  LastDeviceFlag = FALSE;
  return OWSearch();
}
//-----------------------------------------------------------------------------
// Find the 'next' devices on the 1-Wire bus
// Return TRUE : device found, ROM number in ROM_NO buffer
// FALSE : device not found, end of search
//-----------------------------------------------------------------------------
int OWNext(void){
  // leave the search state alone
  return OWSearch();
}
//-----------------------------------------------------------------------------
// Perform the 1-Wire Search Algorithm on the 1-Wire bus using the existing
// search state.
// Return TRUE : device found, ROM number in ROM_NO buffer
// FALSE : device not found, end of search
//-----------------------------------------------------------------------------
int OWSearch(void){
  int id_bit_number;
  int last_zero, rom_byte_number, search_result;
  int id_bit, cmp_id_bit;
  byte rom_byte_mask, search_direction;
  // initialize for search
  id_bit_number = 1;
  last_zero = 0;
  rom_byte_number = 0;
  rom_byte_mask = 1;
  search_result = 0;
  // if the last call was not the last one
  if(!LastDeviceFlag){
    // 1-Wire reset
    if(!OWReset()){
      // reset the search
      LastDiscrepancy = 0;
      LastDeviceFlag = 0;
      return FALSE;
    }
    // issue the search command
    OWWriteByte(0xF0);
    // loop to do the search
    do{
      // read a bit and its complement
      id_bit = OWReadBit();
      cmp_id_bit = OWReadBit();
      // check for no devices on 1-wire
      if ((id_bit == 1) && (cmp_id_bit == 1))
        break;
      else{
        // all devices coupled have 0 or 1
        if (id_bit != cmp_id_bit)
          search_direction = id_bit; // bit write value for search
        else{
          // if this discrepancy if before the Last Discrepancy
          // on a previous next then pick the same as last time
          if (id_bit_number < LastDiscrepancy)
            search_direction = ((ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
          else
            // if equal to last pick 1, if not then pick 0
            search_direction = (id_bit_number == LastDiscrepancy);
          // if 0 was picked then record its position in LastZero
          if (search_direction == 0)
            last_zero = id_bit_number;
        }
        // set or clear the bit in the ROM byte rom_byte_number
        // with mask rom_byte_mask
        if (search_direction == 1)
          ROM_NO[rom_byte_number] |= rom_byte_mask;
        else
          ROM_NO[rom_byte_number] &= ~rom_byte_mask;
        // serial number search direction write bit
        OWWriteBit(search_direction);
        // increment the byte counter id_bit_number
        // and shift the mask rom_byte_mask
        id_bit_number++;
        rom_byte_mask <<= 1;
        // if the mask is 0 then go to new SerialNum byte rom_byte_number and reset mask
        if (rom_byte_mask == 0){
          rom_byte_number++;
          rom_byte_mask = 1;
        }
      }
    } while(rom_byte_number < 8); // loop until through all ROM bytes 0-7
    // if the search was successful then
    if (id_bit_number > 64){
      // search successful so set LastDiscrepancy,LastDeviceFlag,search_result
      LastDiscrepancy = last_zero;
      // check for last device
      if (LastDiscrepancy == 0)
        LastDeviceFlag = TRUE;
      search_result = TRUE;
    }
  }
  // if no device found then reset counters so next 'search' will be like a first
  if (!search_result || !ROM_NO[0]){
    LastDiscrepancy = 0;
    LastDeviceFlag = FALSE;
    search_result = FALSE;
  }
  return search_result;
}
//-----------------------------------------------------------------------------
// ����� ���� ��������� �� ���� 1-Wire
// ������������ ���������� �������� ��������� (���� 0 - ��� ���������)
//-----------------------------------------------------------------------------
int OWSearchAll(void){
  byte j;
  dNum = 0;
  int ret = OWFirst();
  while(ret){
    for(j = 0; j < 8; j++)
      rom[dNum][j] = ROM_NO[j];
    ret = OWNext();
    if(++dNum == DMAX)
      break;
  }
  return dNum;
}
/* -------------------------------------------------------------------------- */
/* ----------------------------- ��������� USB ------------------------------ */
/* -------------------------------------------------------------------------- */
usbMsgLen_t usbFunctionSetup(uchar data[8])
{
  usbRequest_t    *rq = (void *)data;
  byte addr = rq->wIndex.bytes[0]; // ����� �����
  byte val = rq->wValue.bytes[0];  // �������� ��� ������ � ����
  byte i;
    
  switch(rq->bRequest){
    //---------------------------
    case RQ_IO_READ:        // ������ ����� � ����� �����/������
      dataBuffer[0] = _SFR_IO8(addr);
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_IO_WRITE:       // ������ ����� � ���� �����/������
      _SFR_IO8(addr) = val;
      return 0;
    //---------------------------
    case RQ_MEM_READ:       // ������ ����� �� �������� addr
      dataBuffer[0] = _SFR_MEM8(addr);
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_MEM_WRITE:      // ������ ����� � ������� addr
      _SFR_MEM8(addr) = val;
      return 0;
    //---------------------------
    case RQ_OW_WBIT:        // ������ ���� �� ���� 1-Wire
      OWWriteBit(val);
      return 0;
    //---------------------------
    case RQ_OW_WBYTE:       // ������ ����� �� ���� 1-Wire
      OWWriteByte(val);
      return 0;
    //---------------------------
    case RQ_OW_RBIT:        // ������ ���� � ���� 1-Wire
      dataBuffer[0] = OWReadBit();
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_OW_RBYTE:       // ������ ����� � ���� 1-Wire
      dataBuffer[0] = OWReadByte();
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_OW_RESET:       // ������� �����-�����������
      dataBuffer[0] = (byte)(OWReset() & 0x0F);
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_OW_COMMAND:     // ������ ������� �� ���� 1-Wire
      if(addr == 0xFF) // �������� ������� ���� ����������� �� ����
        OWCommand(NULL, val);
      else         // ������� ���������� ID �������� ����� ������� � rom[addr]
        OWCommand(rom[addr], val);
      return 0;
    //---------------------------
    case RQ_OW_FIRST:       // ����� ������� ���������� �� ���� 1-Wire
      dataBuffer[0] = OWFirst();
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_OW_NEXT:        // ����� ���������� ���������� �� ���� 1-Wire
      dataBuffer[0] = OWNext();
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
    case RQ_OW_GET_ROM:     // ��������� � �� RON
      usbMsgPtr = ROM_NO;
      return 8;
    //---------------------------
    case RQ_OW_SET_ROM:     // �������� �� �� ROM
      ROM_NO[addr] = val;
      return 0;
    //---------------------------
    case RQ_OW_SEARCH_ALL:  // ����� ���������� ���������� �� ���� 1-Wire
      eopFlag = FALSE;
      dataBuffer[0] = OWSearchAll();
      usbMsgPtr = dataBuffer;
      eopRes = dataBuffer[0];
      eopFlag = TRUE;
      return 1;
    //---------------------------
    case RQ_OW_GET_ROMI:     // ��������� � �� RON addr-�� ����������
      if(addr >= DMAX){
        for(i = 0; i < 8; i++)
          buf[i] = 0;
        usbMsgPtr = buf;
      } else
        usbMsgPtr = rom[addr];
      return 8;
    //---------------------------
    case RQ_TEST:
     return 0;
    //---------------------------
     case RQ_EOP_FLAG:      // ������ ����� ��������� ��������
      dataBuffer[0] = eopFlag;
      usbMsgPtr = dataBuffer;
      return 1;
    //---------------------------
     case RQ_EOP_RES:      // ������ ���������� ���������� ��������
      // � ��������������� ������� ��������� (1 ����) ������ ���� 
      // ������� � eopRes
      dataBuffer[0] = eopRes;
      usbMsgPtr = dataBuffer;
      return 1;
  }
  return 0;   /* default ��� �� ������������� ��������: �� ���� ������� ������ �� ������������ */
}

/* -------------------------------------------------------------------------- */

int main(void)
{
  uchar   i;

  wdt_enable(WDTO_1S);
  /* ���� �� ������������ watchdog, ��������� ��� �������. ��� ����� ���������
     ������ watchdog (on/off, period) ����������� ����� ������!
  */
  /* ������ RESET: ��� ����� ������ � ������ ����� ��� ����������� ���������� (pull-up).
     ��� ��, ��� ����� ��� D+ and D-, ����� �������, �� �� ��������� � �������������� ����������
     �������������.
  */
  usbInit();              // ��. usbdrv.h � usbdrv.c
  usbDeviceDisconnect();  /* ��. usbdrv.h - ��������� ������������, ������ ���, ���� ��������� ����������! */
  i = 0;
  while(--i){            /* ���������� USB disconnect �� ����� > 250 ms */
    wdt_reset();
    _delay_ms(1);
  }
  usbDeviceConnect();     // ��. usbdrv.h

  DQDDR &= ~_BV(DQ);  // ���� - �� ����
  DQPORT &= ~_BV(DQ); // � �������� - 0
    
  sei();
  for(;;){                /* ������� ���� ������� */
    wdt_reset();
    usbPoll();
  }
  return 0;
}

/* -------------------------------------------------------------------------- */
