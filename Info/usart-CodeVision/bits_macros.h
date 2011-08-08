#ifndef BITS_MACROS_
#define BITS_MACROS_

#define ClearBit(reg, bit)       reg &= (~(1<<(bit)))
//������: ClearBit(PORTB, 1); //�������� 1-� ��� PORTB

#define SetBit(reg, bit)          reg |= (1<<(bit))	
//������: SetBit(PORTB, 3); //���������� 3-� ��� PORTB

#define BitIsClear(reg, bit)    ((reg & (1<<(bit))) == 0)
//������: if (BitIsClear(PORTB,1)) {...} //���� ��� ������

#define BitIsSet(reg, bit)       ((reg & (1<<(bit))) != 0)
//������: if(BitIsSet(PORTB,2)) {...} //���� ��� ����������

#define InvBit(reg, bit)	  reg ^= (1<<(bit))
//������: InvBit(PORTB, 1); //������������� 1-� ��� PORTB

#endif//BITS_MACROS_



