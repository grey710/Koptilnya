#include <ioavr.h>

#define OSC             (16000000ULL) // MHz oscillator 4.0
#define RS232_BAUDRATE 38400

#define   LED  PORTD,3,H
//#define   KEY_L  PIND,5,L

#define   KHz              *1000L          // ������ ����� � ����� �� ����������
#define   MHz              *1000L KHz      // ������ ����� � ����� �� ����������
#define   TICKS_PER_CYCLE  10               // ���������� ������ �� 1 �������� ����� ��������
#define   MS               * OSC / TICKS_PER_CYCLE / 1000  // ������� �������� ����� �������� ���� �� ���� ������������
#define   MKS               MS / 1000                     // �� ������������ � 1000 ��� ������

