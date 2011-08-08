# Имя: Makefile
# Проект: пример custom-class
# Автор: Christian Starkjohann
# Перевод: microsin.ru 
# Дата создания: 2008-04-07
# Табуляция: 4
# Copyright: (c) 2008 by OBJECTIVE DEVELOPMENT Software GmbH
# Лицензия: GNU GPL v2 (см. License.txt) или проприетарная (CommercialLicense.txt)
# Ревизия: $Id: Makefile 553 2008-04-17 19:00:20Z cs $

DEVICE  = atmega16
F_CPU   = 16000000	# в Герцах
# у ATMega16 функционал перемычек почти совпадают с ATMega8 - отличие только в 2 битах FUSE_H (6 и 7)
FUSE_L  = ff
FUSE_H  = 09

#AVRDUDE = avrdude -c jtag2 -p $(DEVICE) -P usb:xx -v 
JTAGICEII = "c:/Program Files/Atmel/AVR Tools/JTAGICEmkII/jtagiceii.exe" -d $(DEVICE) -mi

CFLAGS  = -Iusbdrv -I. -DDEBUG_LEVEL=0
OBJECTS = usbdrv/usbdrv.o usbdrv/usbdrvasm.o main.o

#COMPILE = avr-gcc -Wall -Os -DF_CPU=$(F_CPU) $(CFLAGS) -mmcu=$(DEVICE)
#COMPILE = avr-gcc -Wall -O0 -gdwarf-2 -DF_CPU=$(F_CPU) $(CFLAGS) -mmcu=$(DEVICE)
COMPILE = avr-gcc -Wall -Os -gstabs -DF_CPU=$(F_CPU) $(CFLAGS) -mmcu=$(DEVICE)
RAR = "c:/Program Files/WinRAR/WinRAR.exe"

##############################################################################
# Значения перемычек (фьюзов) для отдельных типов микроконтроллеров
##############################################################################
# Если Ваш микроконтроллер не присутствует здесь, см. ссылку
#  http://palmavr.sourceforge.net/cgi-bin/fc.cgi
#  и выберите опции для частоты кварца и отсутствие делителя тактовой частоты
#
################################## ATMega8 ##################################
# ATMega8 FUSE_L (младший байт фьюзов):
# 0x9f = 1 0 0 1   1 1 1 1
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL 3..0 (внешний кристалл с частотой > 8 МГц)
#        | |  +--------------- SUT 1..0 (генератор с кристаллом, BOD разрешен)
#        | +------------------ BODEN (BrownOut Detector разрешен)
#        +-------------------- BODLEVEL (2.7V)
# ATMega8 FUSE_H (старший байт фьюзов):
# 0xc9 = 1 1 0 0   1 0 0 1 <-- BOOTRST (вектор сброса загрузки 0x0000)
#        ^ ^ ^ ^   ^ ^ ^------ BOOTSZ0
#        | | | |   | +-------- BOOTSZ1
#        | | | |   + --------- EESAVE (не сохранять EEPROM при стирании чипа)
#        | | | +-------------- CKOPT (полный размах выхода генератора)
#        | | +---------------- SPIEN (разрешить последовательное программирование)
#        | +------------------ WDTON (WDT включен не всегда)
#        +-------------------- RSTDISBL (ножка сброса разрешена)
#
################################## ATMega16 ##################################
# ATMega16 FUSE_L (младший байт фьюзов):
# 0xff = 1 1 1 1   1 1 1 1
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL 3..0 (внешний кристалл с частотой > 8 МГц)
#        | |  +--------------- SUT 1..0 (генератор с кристаллом, медленное нарастание уровня питания)
#        | +------------------ BODEN (BrownOut Detector запрещен)
#        +-------------------- BODLEVEL (2.7V)
# ATMega16 FUSE_H (старший байт фьюзов):
# 0x09 = 0 0 0 0   1 0 0 1 <-- BOOTRST (вектор сброса загрузки 0x0000)
#        ^ ^ ^ ^   ^ ^ ^------ BOOTSZ0
#        | | | |   | +-------- BOOTSZ1
#        | | | |   + --------- EESAVE (не сохранять EEPROM при стирании чипа)
#        | | | +-------------- CKOPT (полный размах выхода генератора)
#        | | +---------------- SPIEN (разрешить последовательное программирование)
#        | +------------------ JTAGEN (запрограммирован, JTAG разрешен)
#        +-------------------- OCDEN (запрограммирован, OCD разрешен)
#
############################## ATMega48/88/168 ##############################
# ATMega*8 FUSE_L (младший байт фьюзов):
# 0xdf = 1 1 0 1   1 1 1 1
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL 3..0 (внешний кристалл с частотой > 8 МГц)
#        | |  +--------------- SUT 1..0 (генератор с кристаллом, BOD разрешен)
#        | +------------------ CKOUT (если 0: выход тактов разрешен)
#        +-------------------- CKDIV8 (если 0: включен делитель тактов 8)
# ATMega*8 FUSE_H (старший байт фьюзов):
# 0xde = 1 1 0 1   1 1 1 0
#        ^ ^ ^ ^   ^ \-+-/
#        | | | |   |   +------ BODLEVEL 0..2 (110 = 1.8 V)
#        | | | |   + --------- EESAVE (сохранять EEPROM при стирании чипа)
#        | | | +-------------- WDTON (если 0: watchdog всегда включен)
#        | | +---------------- SPIEN (разрешить последовательное программирование)
#        | +------------------ DWEN (разрешить debug wire)
#        +-------------------- RSTDISBL (ножка сброса разрешена)
#
############################## ATTiny25/45/85 ###############################
# ATMega*5 FUSE_L (младший байт фьюзов):
# 0xef = 1 1 1 0   1 1 1 1
#        ^ ^ \+/   \--+--/
#        | |  |       +------- CKSEL 3..0 (выбор тактовой частоты -> кристалл @ 12 MHz)
#        | |  +--------------- SUT 1..0 (BOD разрешен, быстрое нарастание уровня питания)
#        | +------------------ CKOUT (выход тактов на ножке CKOUT -> запрещен)
#        +-------------------- CKDIV8 (делитель тактов на 8 -> запрещен)
# ATMega*5 FUSE_H (старший байт фьюзов):
# 0xdd = 1 1 0 1   1 1 0 1
#        ^ ^ ^ ^   ^ \-+-/ 
#        | | | |   |   +------ BODLEVEL 2..0 (уровень триггера brownout -> 2.7V)
#        | | | |   +---------- EESAVE (сохранять EEPROM при стирании чипа -> нет)
#        | | | +-------------- WDTON (watchdog всегда включен -> запрещено)
#        | | +---------------- SPIEN (разрешить последовательное программирование -> да)
#        | +------------------ DWEN (разрешить debug wire)
#        +-------------------- RSTDISBL (запрет внешнего сброса -> нет)
#
################################ ATTiny2313 #################################
# ATTiny2313 FUSE_L (младший байт фьюзов):
# 0xef = 1 1 1 0   1 1 1 1
#        ^ ^ \+/   \--+--/
#        | |  |       +------- CKSEL 3..0 (выбор тактовой частоты -> кристалл @ 12 MHz)
#        | |  +--------------- SUT 1..0 (BOD разрешен, быстрое нарастание уровня питания)
#        | +------------------ CKOUT (выход тактов на ножке CKOUT -> запрещен)
#        +-------------------- CKDIV8 (делитель тактов на 8 -> запрещен)
# ATTiny2313 FUSE_H (старший байт фьюзов):
# 0xdb = 1 1 0 1   1 0 1 1
#        ^ ^ ^ ^   \-+-/ ^
#        | | | |     |   +---- RSTDISBL (запрет внешнего сброса -> нет)
#        | | | |     +-------- BODLEVEL 2..0 (уровень триггера brownout -> 2.7V)
#        | | | +-------------- WDTON (watchdog всегда включен -> запрещено)
#        | | +---------------- SPIEN (разрешить последовательное программирование -> да)
#        | +------------------ EESAVE (сохранять EEPROM при стирании чипа -> нет)
#        +-------------------- DWEN (разрешить debug wire)


# символические цели (symbolic targets):
help:
	@echo "This Makefile has no default rule. Use one of the following:"
	@echo "make hex ....... to build main.hex"
	@echo "make program ... to flash fuses and firmware"
	@echo "make fuse ...... to flash the fuses"
	@echo "make flash ..... to flash the firmware"
	@echo "make clean ..... to delete objects and hex file"
	@echo "make erase ..... erase AVR chip"
	@echo "make backup ..... backup project"

hex: main.hex

program: flash fuse

# правило для программирования бит фьюзов:
fuse:
	@[ "$(FUSE_H)" != "" -a "$(FUSE_L)" != "" ] || \
		{ echo "*** Edit Makefile and choose values for FUSE_L and FUSE_H!"; exit 1; }
#	$(AVRDUDE) -U hfuse:w:$(FUSE_H):m -U lfuse:w:$(FUSE_L):m
	$(JTAGICEII) -f 0x$(FUSE_H)$(FUSE_L)

# правило для прошивки firmware:
flash: main.hex
#	$(AVRDUDE) -U flash:w:main.hex:i
	$(JTAGICEII) -pf -if main.hex

# правило для удаления файлов зависимостей (которые могут быть построены утилитой Make):
clean:
	rm -f main.hex main.lst main.obj main.cof main.list main.map main.eep.hex main.elf *.o usbdrv/*.o main.s usbdrv/oddebug.s usbdrv/usbdrv.s
	rm -f usbdrv/*.*
	rmdir usbdrv

# Обычное (generic) правило для компилирования файлов на языке C:
.c.o:
	$(COMPILE) -c $< -o $@
	
# Обычное (generic) правило для компиляции файлов на языке ассемблера:
.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" не должен быть необходим, поскольку тип файлов
#  с расширением .S (здесь заглавная S) задан по умолчанию. Однако, символы 
#  в верхнем регистре не всегда сохраняются в именах на Windows. Чтобы обеспечить
#  совместимость с WinAVR задайте тип файла вручную. 

# Generic правило для компилирования файлов языка C в ассемблер, успользуется только для отладки.
.c.s:
	$(COMPILE) -S $< -o $@
 
# файловые цели (file targets): 
# Поскольку мы не хотим поставлять драйвер много раз с каждым пректом, мы копируем драйвер 
#  в этот проект:
usbdrv:
	cp -r ../../../usbdrv .

main.elf: usbdrv $(OBJECTS)	# зависимость (dependency) usbdrv нужна только для копирования
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex main.eep.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-objcopy --debugging -O coff-ext-avr $< main.cof
	avr-size main.hex

# цели отладки:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c

# цель очистки кристалла микроконтроллера
erase:
	$(JTAGICEII) -e

# цель бекапа
backup:
	$(RAR) a -r -dh -ep1 avrusb.rar ../../../../avrusb-20080513
	mv avrusb.rar c:\!MyDoc\FLOPPI\avr\usb\obdev.at
	autoname /pattern:YYMMDDhhmmss c:/!MyDoc/FLOPPI/avr/usb/obdev.at/avrusb.rar
	