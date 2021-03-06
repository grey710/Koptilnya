/* ���: asmcommon.inc
 * ������: ������� AVR USB
 * �����: Christian Starkjohann
 * �������: microsin.ru
 * ���� ��������: 2007-11-05
 * ���������: 4
 * Copyright: (c) 2007 by OBJECTIVE DEVELOPMENT Software GmbH
 * ��������: GNU GPL v2 (��. License.txt) ��� ������������� (CommercialLicense.txt)
 * �������: $Id$
 */

/* �� �������� ���� ����! ������ ����� �������� usbdrvasm.S, ������� � ��������
 * ��������������� ���������� ����!
 */

/*
�������� ��������:
���� ���� �������� ������������ ���, ������� �������� ����� ����� ������������ �������� USB
��� ��������� �������� ������ CPU. ��������� ��� ������ ����������� � ������� ����� ������,
�� �������� �� ���� ���� � ���������� (#included).

��������, ���������� �������:
    sofError: ����������, ����� ������� ������������������ no start (��� �� ������� ������������������ start?).
    se0: 			����������, ����� ����� ������� ������.
    overflow: ����������, ����� ����� ������ ����������.
    doReturn: ���������� ����� �������� ������.

�������� ������ �� ����� ������:
    waitForJ: ���������� ��� ������ ��� ���������� ������.
    sendAckAndReti:
    sendNakAndReti:
    sendCntAndReti:
    usbSendAndReti:

��������� ������ ������ ���� ����� ����� ���, ��� ���� ���� ������ ���� ���������:
    .macro POP_STANDARD
    .endm
    .macro POP_RETI
    .endm
*/

#define token   x1

overflow:
    ldi     x2, 1<<USB_INTR_PENDING_BIT
    USB_STORE_PENDING(x2)       ; ������� ����� ��������� ����������
ignorePacket:
    clr     token
    rjmp    storeTokenAndReturn

;----------------------------------------------------------------------------
; ��������� ��������� ������ (����� � ������� ��������� �� ���������� ����� ����� center of SE0)
;----------------------------------------------------------------------------
;����� ������ ����� ���� non-error ��� ����� ��������� ������.
;�� �� ��������� ����� CRC, ������ ��� ��� ���������� ��� �������.
se0:
    subi    cnt, USB_BUFSIZE    ;[5]
    neg     cnt                 ;[6]
    sub     YL, cnt             ;[7]
    sbci    YH, 0               ;[8]
    ldi     x2, 1<<USB_INTR_PENDING_BIT ;[9]
    USB_STORE_PENDING(x2)       ;[10] ������� ���������� ���������� � ����� �������� �����. SE0 ������ �����������.

    ld      token, y            ;[11]
    cpi     token, USBPID_DATA0 ;[13]
    breq    handleData          ;[14]
    cpi     token, USBPID_DATA1 ;[15]
    breq    handleData          ;[16]
    lds     shift, usbDeviceAddr;[17]
    ldd     x2, y+1             ;[19] ADDR � 1 ��� ������ �������� ����� (endpoint)
    lsl     x2                  ;[21] �������� 1 ��� endpoint
    cpse    x2, shift           ;[22]
    rjmp    ignorePacket        ;[23]
/* ��������� ������ ����� endpoint � x3, ���� ��������� ����� */
#if USB_CFG_HAVE_INTRIN_ENDPOINT || USB_CFG_IMPLEMENT_FN_WRITEOUT
    ldd     x3, y+2             ;[24] ����� endpoint + crc
    rol     x3                  ;[26] ������� ������� ��� (LSB) endpoint
#endif
    cpi     token, USBPID_IN    ;[27]
    breq    handleIn            ;[28]
    cpi     token, USBPID_SETUP ;[29]
    breq    handleSetupOrOut    ;[30]
    cpi     token, USBPID_OUT   ;[31]
    brne    ignorePacket        ;[32] ������ ���� ack, nak ��� ��� ������
;   rjmp    handleSetupOrOut    ;������ ����

;��������� � ����� (����� ���� ����� ������) ���� ��� ������� (16 cycles) �����
; ��������� SE0. ��� ������������� ��������� �� 40 ������ �������� �� ������ ������ 
; ������� ������������� �� ������� 1-�� ����. ����� 56 ������.
handleSetupOrOut:               ;[32]
#if USB_CFG_IMPLEMENT_FN_WRITEOUT   /* ���� �� ����� ������ ��� endpoint != 0, ���������� � usbCurrentTok ����� */
    andi    x3, 0xf             ;[32]
    breq    storeTokenAndReturn ;[33]
    mov     token, x3           ;[34] ���������, ��� ��� endpoint x OUT
#endif
storeTokenAndReturn:
    sts     usbCurrentTok, token;[35]
doReturn:
    POP_STANDARD                ;[37] 12...16 ������
    USB_LOAD_PENDING(YL)        ;[49]
    sbrc    YL, USB_INTR_PENDING_BIT;[50] ��������, ����� �� ������
    rjmp    waitForJ            ;[51] ���������� �������� pop � push -- ��������� ����� ����������
sofError:
    POP_RETI                    ;����� �������
    reti

handleData:
    lds     token, usbCurrentTok;[18]
    tst     token               ;[20]
    breq    doReturn            ;[21]
    lds     x2, usbRxLen        ;[22]
    tst     x2                  ;[24]
    brne    sendNakAndReti      ;[25]
; 2006-03-11: ��������� 2 ������ ���������� �������� � ���, ��� ���������� �� ������������,
; ���� usbPoll() ��� ������ ����� ����� ��� ������ 4 ms.
    cpi     cnt, 4              ;[26] ������ � ������� �������� ����� ���� ������� -- ������������ � ack
    brmi    sendAckAndReti      ;[27] ��������� rx ����� ������ -- �� �� ������ ������ NAK � ��������� SETUP
    sts     usbRxLen, cnt       ;[28] ��������� �������� ������, ������ ������
    sts     usbRxToken, token   ;[30]
    lds     x2, usbInputBufOffset;[32] ������ ������
    ldi     cnt, USB_BUFSIZE    ;[34]
    sub     cnt, x2             ;[35]
    sts     usbInputBufOffset, cnt;[36] ������ �������� �������
    rjmp    sendAckAndReti      ;[38] 40 + 17 = 57 �� ������� SOP

handleIn:
;�� �� ���������� ����� �� �� �� ���� ������ ���� ��� C �� ���������� ������� ������� ������
; � ������������ ����������� �������� ������. ��� ����� ���������� � ������ ������� ����,
; ��� ������� ������� tx ����� ����� ������.
    lds     x1, usbRxLen        ;[30]
    cpi     x1, 1               ;[32] ������������� �������� ��� ���������� ������� (flow control), 0 �������� "����� ����"
    brge    sendNakAndReti      ;[33] �������������� ������� �����?
    ldi     x1, USBPID_NAK      ;[34] ���������� �������� ��� usbTxLen
#if USB_CFG_HAVE_INTRIN_ENDPOINT
    andi    x3, 0xf             ;[35] x3 �������� endpoint
    brne    handleIn1           ;[36]
#endif
    lds     cnt, usbTxLen       ;[37]
    sbrc    cnt, 4              ;[39] ��� ������� handshake ����� ����� �� 4 ���
    rjmp    sendCntAndReti      ;[40] 42 + 16 = 58 �� ��������� SOP
    sts     usbTxLen, x1        ;[41] x1 == USBPID_NAK �� ���� �����
    ldi     YL, lo8(usbTxBuf)   ;[43]
    ldi     YH, hi8(usbTxBuf)   ;[44]
    rjmp    usbSendAndReti      ;[45] 57 + 12 = 59 �� ��������� SOP

;���������, ��� ������������� usbTxLen ��� USBPID_NAK:
; �� ������ ���������� ��� ����� ����� �� ������� ACK �� �����. ��� ����� �����������:
; ���� ����������� ����������, ������� ��������� ��������� tx ��� endpoint 0 � 1 �
; �������� � ��������� ��� ���������� ACK. ������ �� �������� ��� ������� ����� �����
; �� ���������� ����� ��������, ��� ������ ��� � ���� ���������� ACK. �� ��������� 
; ���� �������� 1 ���� RAM � ������������ �������� ������������� ������� � ������������
; ��������� ��������. ��� ����� ������� ������������ �������� ��� ������.

#if USB_CFG_HAVE_INTRIN_ENDPOINT    /* ��� ��������� ����� ��� ������������� ��������� */
handleIn1:                      ;[38]
#if USB_CFG_HAVE_INTRIN_ENDPOINT3
; 2006-06-10 ��� ��������� O.Tamura: ��������� ������ INTR IN / BULK IN endpoint
    cpi     x3, USB_CFG_EP3_NUMBER;[38]
    breq    handleIn3           ;[39]
#endif
    lds     cnt, usbTxLen1      ;[40]
    sbrc    cnt, 4              ;[42] ��� ������� handshake ����� ����� �� 4 ���
    rjmp    sendCntAndReti      ;[43] 47 + 16 = 63 �� ��������� SOP
    sts     usbTxLen1, x1       ;[44] x1 == USBPID_NAK �� ���� �����
    ldi     YL, lo8(usbTxBuf1)  ;[46]
    ldi     YH, hi8(usbTxBuf1)  ;[47]
    rjmp    usbSendAndReti      ;[48] 50 + 12 = 62 �� ��������� SOP
#endif

#if USB_CFG_HAVE_INTRIN_ENDPOINT && USB_CFG_HAVE_INTRIN_ENDPOINT3
handleIn3:
    lds     cnt, usbTxLen3      ;[41]
    sbrc    cnt, 4              ;[43]
    rjmp    sendCntAndReti      ;[44] 49 + 16 = 65 �� ��������� SOP
    sts     usbTxLen3, x1       ;[45] x1 == USBPID_NAK �� ���� �����
    ldi     YL, lo8(usbTxBuf3)  ;[47]
    ldi     YH, hi8(usbTxBuf3)  ;[48]
    rjmp    usbSendAndReti      ;[49] 51 + 12 = 63 �� ��������� SOP
#endif
