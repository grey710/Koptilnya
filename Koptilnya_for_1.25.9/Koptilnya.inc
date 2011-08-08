
	.DEF _rx_wr_index=R5
	.DEF _rx_counter=R4
_6:
	.DB  0x73
_7:
	.DB  0x4B
_8:
	.DB  0x69
_9:
	.DB  0x41
_10:
	.DB  0x4
_11:
	.DB  0x1E
_12:
	.DB  0xA
_13:
	.DB  0x1
_14:
	.DB  0x1
	.DEF _zadergka_pri_nagatii=R7
_15:
	.DB  0xC8
	.DEF _zadergka_zastavka=R8
_16:
	.DB  0xE8,0x3
	.DEF _t_puskatel=R6
_17:
	.DB  0x64
_tbl10_G2:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G2:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
_341:
	.DB  0x80,0xC0
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13
_350:
	.DW  0x00
_0:
	.DB  0x4B,0x6F,0xBE,0xBF,0xB8,0xBB,0xC4,0xBD
	.DB  0xC7,0x0,0x76,0x2E,0x32,0x2E,0x30,0x20
	.DB  0x72,0x75,0x0,0x4D,0x61,0xBA,0x63,0x20
	.DB  0x54,0x20,0x70,0x61,0xB7,0x6F,0xB4,0x70
	.DB  0x65,0xB3,0x61,0x0,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x0,0x4D,0xB8,0xBD,0x20,0x54
	.DB  0x20,0x70,0x61,0xB7,0x6F,0xB4,0x70,0x65
	.DB  0xB3,0x61,0x0,0x4D,0x61,0xBA,0x63,0x20
	.DB  0x54,0x20,0x70,0x61,0xB2,0x6F,0xBF,0xC3
	.DB  0x0,0x4D,0xB8,0xBD,0x20,0x54,0x20,0x70
	.DB  0x61,0xB2,0x6F,0xBF,0xC3,0x0,0x42,0x70
	.DB  0x2E,0x20,0x70,0x61,0xB2,0x6F,0xBF,0xC3
	.DB  0x2C,0x20,0xC0,0x61,0x63,0xC3,0x0,0x42
	.DB  0x70,0x2E,0x20,0x70,0x61,0xB2,0x6F,0xBF
	.DB  0xC3,0x2C,0x20,0xBC,0xB8,0xBD,0x2E,0x0
	.DB  0x42,0x70,0x2E,0x20,0xE3,0xC3,0xBC,0x2C
	.DB  0x20,0xC0,0x61,0x63,0xC3,0x0,0x42,0x70
	.DB  0x2E,0x20,0xE3,0xC3,0xBC,0x2C,0x20,0xBC
	.DB  0xB8,0xBD,0x79,0xBF,0xC3,0x0,0x20,0x20
	.DB  0x20,0x20,0x50,0x41,0xA4,0x4F,0xA1,0x50
	.DB  0x45,0x42,0x0,0x25,0x63,0x25,0x63,0x3A
	.DB  0x25,0x63,0x25,0x63,0x3A,0x25,0x63,0x25
	.DB  0x63,0x20,0x54,0x3D,0x25,0x63,0x25,0x63
	.DB  0x25,0x63,0x20,0x43,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x50,0x41,0xA0,0x4F,0x54,0x41
	.DB  0x0,0x20,0x20,0x20,0x20,0x42,0xAE,0x54
	.DB  0xB1,0xA3,0x4B,0x41,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x43,0x54,0x4F,0xA8,0x0
	.DB  0x77,0x77,0x77,0x2E,0x78,0x78,0x78,0x2E
	.DB  0x75,0x61,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _t_max_razogrev
	.DW  _6*2

	.DW  0x01
	.DW  _t_max_rabochee
	.DW  _7*2

	.DW  0x01
	.DW  _t_min_razogrev
	.DW  _8*2

	.DW  0x01
	.DW  _t_min_rabochee
	.DW  _9*2

	.DW  0x01
	.DW  _time_rabota_ch
	.DW  _10*2

	.DW  0x01
	.DW  _time_rabota_min
	.DW  _11*2

	.DW  0x01
	.DW  _time_smoke_min
	.DW  _12*2

	.DW  0x01
	.DW  _regim_rabot
	.DW  _13*2

	.DW  0x01
	.DW  _regim_rabot_old
	.DW  _14*2

	.DW  0x01
	.DW  0x07
	.DW  _15*2

	.DW  0x02
	.DW  0x08
	.DW  _16*2

	.DW  0x01
	.DW  0x06
	.DW  _17*2

	.DW  0x02
	.DW  __base_y_G3
	.DW  _341*2

	.DW  0x02
	.DW  _p_S61
	.DW  _350*2

	.DW  0
_0x16A: