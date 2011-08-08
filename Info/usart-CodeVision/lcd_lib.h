//***************************************************************************
//
//  Description.: ������� ������������������� �� �������
//
//***************************************************************************
#ifndef LCD_LIB_H
#define LCD_LIB_H   

#include <delay.h>
#include <mega8535.h>

//���� � �������� ���������� ���� ������ ���
#define PORT_DATA PORTC
#define PIN_DATA  PINC
#define DDRX_DATA DDRC

//���� � �������� ���������� ����������� ������ ���
#define PORT_SIG PORTB
#define PIN_SIG  PINB
#define DDRX_SIG DDRB

//������ ������� � ������� ���������� ����������� ������ ��� 
#define RS 2
#define RW 3
#define EN 4

//******************************************************************************
//�������

/*���������������� �������*/
#define LCD_Goto(x,y) LCD_WriteCom(((((y)& 1)*0x40)+((x)& 7))|128) 


//��������� �������
void LCD_Init(void);//������������� ������ � ���
void LCD_WriteData(unsigned char data); //������� ���� ������ �� ���
void LCD_WriteCom(unsigned char data); //�������� ������� ���
void LCD_SendStringFlash(unsigned char __flash *str); //������� ������ �� lcd
#endif