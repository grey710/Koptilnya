using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Threading;

namespace AvrUsbDevice
{
    unsafe class ATMega16
    {
        #region Интерфейс с libusb

        #region Константы

        public const int LIBUSB_PATH_MAX = 512;
        const string LIBUSB_NATIVE_LIBRARY = "libusb0.dll";

        // Тип запроса (bmRequestType) формируется побитовым "или" 
        // констант из трех групп ниже.
        const byte USB_ENDPOINT_IN = 0x80;
        const byte USB_ENDPOINT_OUT = 0x00;

        const byte USB_TYPE_STANDARD = (0x00 << 5);
        const byte USB_TYPE_CLASS = (0x01 << 5);
        const byte USB_TYPE_VENDOR = (0x02 << 5);
        const byte USB_TYPE_RESERVED = (0x03 << 5);

        const byte USB_RECIP_DEVICE = 0x00;
        const byte USB_RECIP_INTERFACE = 0x01;
        const byte USB_RECIP_ENDPOINT = 0x02;
        const byte USB_RECIP_OTHER = 0x03;

        // Коды стандартных запросов (bRequest) с номерами 0 - 12 зарезервированы 
        // в спецификации USB поэтому все пользовательские будут начинаться с RQ_USER_BEG
        const byte RQ_USER_BEG = 13;

        #endregion

        #region Структуры

        /* Оригинальная структура из usb.h
        struct usb_endpoint_descriptor {
            unsigned char  bLength;
            unsigned char  bDescriptorType;
            unsigned char  bEndpointAddress;
            unsigned char  bmAttributes;
            unsigned short wMaxPacketSize;
            unsigned char  bInterval;
            unsigned char  bRefresh;
            unsigned char  bSynchAddress;

            unsigned char *extra;	// Extra descriptors
            int extralen;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_endpoint_descriptor
        {
            public byte bLength;
            public byte bDescriptorType;
            public byte bEndpointAddress;
            public byte bmAttributes;
            public byte wMaxPacketSize;
            public byte bInterval;
            public byte bRefresh;
            public byte bSynchAddress;
            public byte* extra;	// Extra descriptors
            public int extralen;
        };

        /* Оригинальная структура  из usb.h
        struct usb_interface_descriptor {
            unsigned char  bLength;
            unsigned char  bDescriptorType;
            unsigned char  bInterfaceNumber;
            unsigned char  bAlternateSetting;
            unsigned char  bNumEndpoints;
            unsigned char  bInterfaceClass;
            unsigned char  bInterfaceSubClass;
            unsigned char  bInterfaceProtocol;
            unsigned char  iInterface;
            struct usb_endpoint_descriptor *endpoint;
            unsigned char *extra;	// Extra descriptors 
            int extralen;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_interface_descriptor
        {
            public byte bLength;
            public byte bDescriptorType;
            public byte bInterfaceNumber;
            public byte bAlternateSetting;
            public byte bNumEndpoints;
            public byte bInterfaceClass;
            public byte bInterfaceSubClass;
            public byte bInterfaceProtocol;
            public byte iInterface;
            public usb_endpoint_descriptor* endpoint;
            public byte* extra;	// Extra descriptors 
            public int extralen;
        };

        /* Оригинальная структура  из usb.h
        struct usb_interface {
            struct usb_interface_descriptor *altsetting;
            int num_altsetting;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_interface
        {
            public usb_interface_descriptor* altsetting;
            public int num_altsetting;
        };

        /* Оригинальная структура  из usb.h
        struct usb_config_descriptor {
            unsigned char  bLength;
            unsigned char  bDescriptorType;
            unsigned short wTotalLength;
            unsigned char  bNumInterfaces;
            unsigned char  bConfigurationValue;
            unsigned char  iConfiguration;
            unsigned char  bmAttributes;
            unsigned char  MaxPower;
            struct usb_interface *interface;
            unsigned char *extra;	// Extra descriptors
            int extralen;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_config_descriptor
        {
            public byte bLength;
            public byte bDescriptorType;
            public ushort wTotalLength;
            public byte bNumInterfaces;
            public byte bConfigurationValue;
            public byte iConfiguration;
            public byte bmAttributes;
            public byte MaxPower;
            public usb_interface* pinterface;
            public byte* extra;	// Extra descriptors
            public int extralen;
        };

        /*  Оригинальная структура  из usb.h
        struct usb_device_descriptor {
            unsigned char  bLength;
            unsigned char  bDescriptorType;
            unsigned short bcdUSB;
            unsigned char  bDeviceClass;
            unsigned char  bDeviceSubClass;
            unsigned char  bDeviceProtocol;
            unsigned char  bMaxPacketSize0;
            unsigned short idVendor;
            unsigned short idProduct;
            unsigned short bcdDevice;
            unsigned char  iManufacturer;
            unsigned char  iProduct;
            unsigned char  iSerialNumber;
            unsigned char  bNumConfigurations;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_device_descriptor
        {
            public byte bLength;
            public byte bDescriptorType;
            public ushort bcdUSB;
            public byte bDeviceClass;
            public byte bDeviceSubClass;
            public byte bDeviceProtocol;
            public byte bMaxPacketSize0;
            public ushort idVendor;
            public ushort idProduct;
            public ushort bcdDevice;
            public byte iManufacturer;
            public byte iProduct;
            public byte iSerialNumber;
            public byte bNumConfigurations;
        };

        /*  Оригинальная структура  из usb.h
        struct usb_device 
        {
            struct usb_device *next, *prev;
            char filename[LIBUSB_PATH_MAX];
            struct usb_bus *bus;
            struct usb_device_descriptor descriptor;
            struct usb_config_descriptor *config;
            void *dev;		// Darwin support
            unsigned char devnum;
            unsigned char num_children;
            struct usb_device **children;
        }; */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_device
        {
            public usb_device* next;
            public usb_device* prev;
            public fixed byte filename[LIBUSB_PATH_MAX];
            public usb_bus* bus;
            public usb_device_descriptor descriptor;
            public usb_config_descriptor* config;
            public IntPtr dev;		// Darwin support
            public byte devnum;
            public byte num_children;
            public IntPtr children;
        };

        /* Оригинальная структура  из usb.h
        struct usb_bus 
        {
            struct usb_bus *next, *prev;
            char dirname[LIBUSB_PATH_MAX];
            struct usb_device *devices;
            unsigned long location;
            struct usb_device *root_dev;
        };
        */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public struct usb_bus
        {
            public usb_bus* next;
            public usb_bus* prev;
            public fixed byte filename[LIBUSB_PATH_MAX];
            public usb_device* devices;
            public uint location;
            public usb_device* root_dev;
        };

        /* Оригинальная структура  из usbi.h
        struct usb_dev_handle {
            int fd;
            struct usb_bus *bus;
            struct usb_device *device;
            int config;
            int interface;
            int altsetting; 
            void *impl_info; // Added by RMT so implementations can store other per-open-device data
        };*/
        public struct usb_dev_handle
        {
            public int fd;
            public usb_bus* bus;
            public usb_device* device;
            public int config;
            public int iinterface;
            public int altsetting;
            public IntPtr impl_info; // Added by RMT so implementations can store other per-open-device data
        };
        #endregion

        #region Импорт функций libusb
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern void usb_init();
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern int usb_find_busses();
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern int usb_find_devices();
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern usb_bus* usb_get_busses();
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern usb_dev_handle* usb_open(usb_device* dev);
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern int usb_close(usb_dev_handle* dev);
        [DllImport(LIBUSB_NATIVE_LIBRARY)]
        public static extern int usb_control_msg(usb_dev_handle* dev, int requesttype, int request,
                                                 int value, int index, byte[] bytes, int size, int timeout);
        #endregion

        #endregion

        #region Адреса портов, регистров и пины микроконтроллера ATMega16
        public const byte aPINA = 0x19;
        public const byte aDDRA = 0x1A;
        public const byte aPORTA = 0x1B;

        public const byte aPINB = 0x16;
        public const byte aDDRB = 0x17;
        public const byte aPORTB = 0x18;

        public const byte aPINC = 0x13;
        public const byte aDDRC = 0x14;
        public const byte aPORTC = 0x15;

        public const byte aPIND = 0x10;
        public const byte aDDRD = 0x11;
        public const byte aPORTD = 0x12;

        public const byte PIN0 = 0;
        public const byte PIN1 = 1;
        public const byte PIN2 = 2;
        public const byte PIN3 = 3;
        public const byte PIN4 = 4;
        public const byte PIN5 = 5;
        public const byte PIN6 = 6;
        public const byte PIN7 = 7;

        public const byte aADCL     = 0x04;
        public const byte aADCH     = 0x05;

        public const byte aADCSRA   = 0x06;
        public const byte ADPS0     = 0;
        public const byte ADPS1     = 1;
        public const byte ADPS2     = 2;
        public const byte ADIE      = 3;
        public const byte ADIF      = 4;
        public const byte ADATE     = 5;
        public const byte ADSC      = 6;
        public const byte ADEN      = 7;

        public const byte aADMUX    = 0x07;
        public const byte MUX0      = 0;
        public const byte MUX1      = 1;
        public const byte MUX2      = 2;
        public const byte MUX3      = 3;
        public const byte MUX4      = 4;
        public const byte ADLAR     = 5;
        public const byte REFS0     = 6;
        public const byte REFS1     = 7;
        #endregion

        #region Константы
        const int RQ_IO_READ        = 0x11;
        const int RQ_IO_WRITE       = 0x12;
        const int RQ_MEM_READ       = 0x13;
        const int RQ_MEM_WRITE      = 0x14;

        const int RQ_EOP_RES        = 0x1E;
        const int RQ_EOP_FLAG       = 0x1F;

        const int RQ_TEST           = 0x20;
        const int RQ_OW_WBIT        = 0x21;
        const int RQ_OW_WBYTE       = 0x22;
        const int RQ_OW_RBIT        = 0x23;
        const int RQ_OW_RBYTE       = 0x24;
        const int RQ_OW_RESET       = 0x25;

        const int RQ_OW_COMMAND     = 0x26;
        const int RQ_OW_FIRST       = 0x27;
        const int RQ_OW_NEXT        = 0x28;
        const int RQ_OW_GET_ROM     = 0x29;
        const int RQ_OW_SET_ROM     = 0x2A;
        const int RQ_OW_SEARCH_ALL  = 0x2B;
        const int RQ_OW_GET_ROMI    = 0x2C;

        #endregion

        #region Приватные члены
        private ushort vid, pid;
        private usb_dev_handle* handle = null;
        private usb_bus* bus;
        private usb_device* dev;
        private byte[] buffer = new byte[4];
        private int LastDiscrepancy;
        private bool LastDeviceFlag;
        #endregion

        public ATMega16(ushort vid, ushort pid)
        {
            this.vid = vid; this.pid = pid;
            usb_init();
            int fb = usb_find_busses();
            int fd = usb_find_devices();
            byte[] buffer = new byte[4];

            for (bus = usb_get_busses(); bus != null && handle == null; bus = bus->next)
                for (dev = bus->devices; dev != null; dev = dev->next)
                    if (dev->descriptor.idVendor == vid && dev->descriptor.idProduct == pid)
                    {
                        handle = usb_open(dev);
                        break;
                    }
        }
        public bool IsOpen()
        {
            return handle != null;
        }
        public bool Close()
        {
            if (handle == null)
                return false;
            usb_close(handle);
            return true;
        }

        #region Работа с портами МК
        public byte DDRA
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aDDRA, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aDDRA, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PORTA
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aPORTA, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINA, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PINA
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINA, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte DDRB
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aDDRB, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aDDRB, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PORTB
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aPORTB, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINB, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PINB
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINB, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte DDRC
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aDDRC, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aDDRC, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PORTC
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aPORTC, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINC, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PINC
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPINC, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte DDRD
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aDDRD, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aDDRD, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PORTD
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aPORTD, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPIND, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte PIND
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aPIND, buffer, 1, 5000);

                return buffer[0];
            }
        }
        #endregion 
        
        #region Работа с АЦП
        public byte ADCL    // Младшие биты кода АЦП
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aADCL, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte ADCH    // Старшие биты кода АЦП
        {
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aADCH, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte ADCSRA  // Регистр статуса
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aADCSRA, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aADCSRA, buffer, 1, 5000);

                return buffer[0];
            }
        }
        public byte ADMUX   // Регистр мультиплексора и типа источника опорного напряжения
        {
            set
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_IO_WRITE, value, aADMUX, null, 0, 5000);
            }
            get
            {
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                                RQ_IO_READ, 0, aADMUX, buffer, 1, 5000);

                return buffer[0];
            }
        }
        #endregion

        public byte[] rom = new byte[8];
        public byte[] romH = new byte[8];
        
        #region Методы для работы с шиной 1-Wire
        public void OWWriteBit(byte bit_value)
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                            RQ_OW_WBIT, bit_value, 0, null, 0, 5000);
        }
        public void OWWriteByte(byte byte_value)
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                            RQ_OW_WBYTE, byte_value, 0, null, 0, 5000);
        }
        public byte OWReadBit()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_RBIT, 0, 0, buffer, 1, 5000);
            return buffer[0];
        }
        public byte OWReadByte()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_RBYTE, 0, 0, buffer, 1, 5000);
            return buffer[0];
        }
        public bool OWReset()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_RESET, 0, 0, buffer, 1, 5000);
            return ((buffer[0] == 0)? false : true);
        }
        public bool OWFirst()
        {
            LastDiscrepancy = 0;
            LastDeviceFlag = false;
            return OWSearch();
        }
        public bool OWNext()
        {
            return OWSearch();
        }
        public bool OWSearch()
        {
            int id_bit_number;
            int last_zero, rom_byte_number;
            bool search_result;
            int id_bit, cmp_id_bit;
            byte rom_byte_mask, search_direction;

            // initialize for search
            id_bit_number = 1;
            last_zero = 0;
            rom_byte_number = 0;
            rom_byte_mask = 1;
            search_result = false;

            // if the last call was not the last one
            if (!LastDeviceFlag)
            {
                // 1-Wire reset
                if (!OWReset())
                {
                    // reset the search
                    LastDiscrepancy = 0;
                    LastDeviceFlag = false;
                    return false;
                }
                // issue the search command 
                OWWriteByte(0xF0);
                // loop to do the search
                do
                {
                    // read a bit and its complement
                    id_bit = OWReadBit();
                    cmp_id_bit = OWReadBit();

                    // check for no devices on 1-wire
                    if ((id_bit == 1) && (cmp_id_bit == 1))
                        break;
                    else
                    {
                        // all devices coupled have 0 or 1
                        if (id_bit != cmp_id_bit)
                            search_direction = (byte)id_bit;  // bit write value for search
                        else
                        {
                            // if this discrepancy if before the Last Discrepancy
                            // on a previous next then pick the same as last time
                            if (id_bit_number < LastDiscrepancy)
                                search_direction = (byte)(((rom[rom_byte_number] & rom_byte_mask) > 0) ? 1 : 0);
                            else
                                // if equal to last pick 1, if not then pick 0
                                search_direction = (byte)((id_bit_number == LastDiscrepancy) ? 1 : 0);

                            // if 0 was picked then record its position in LastZero
                            if (search_direction == 0)
                                last_zero = id_bit_number;
                        }

                        // set or clear the bit in the ROM byte rom_byte_number
                        // with mask rom_byte_mask
                        if (search_direction == 1)
                            rom[rom_byte_number] |= rom_byte_mask;
                        else
                            rom[rom_byte_number] &= (byte)(~rom_byte_mask);

                        // serial number search direction write bit
                        OWWriteBit(search_direction);

                        // increment the byte counter id_bit_number
                        // and shift the mask rom_byte_mask
                        id_bit_number++;
                        rom_byte_mask <<= 1;

                        // if the mask is 0 then go to new SerialNum byte rom_byte_number and reset mask
                        if (rom_byte_mask == 0)
                        {
                            rom_byte_number++;
                            rom_byte_mask = 1;
                        }
                    }
                } while (rom_byte_number < 8);  // loop until through all ROM bytes 0-7

                // if the search was successful then
                if (id_bit_number >= 65)
                {
                    // search successful so set LastDiscrepancy,LastDeviceFlag,search_result
                    LastDiscrepancy = last_zero;

                    // check for last device
                    if (LastDiscrepancy == 0)
                        LastDeviceFlag = true;
                    search_result = true;
                }
            }

            // if no device found then reset counters so next 'search' will be like a first
            if (!search_result || (rom[0] == 0))
            {
                LastDiscrepancy = 0;
                LastDeviceFlag = false;
                search_result = false;
            }
            return search_result;
        }

        public bool OWFirstH()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_FIRST, 0, 0, buffer, 1, 5000);
            return (buffer[0] != 0);
        }
        public bool OWNextH()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_NEXT, 0, 0, buffer, 1, 5000);
            return (buffer[0] != 0);
        }
        public byte OWSearchAll()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_SEARCH_ALL, 0, 0, buffer, 1, 5000);
            int c = 0;
            while (!OWEopFlag())
                c++;

            Thread.Sleep(50);

            return OWEopRes();
        }

        public void OWGetROM()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_GET_ROM, 0, 0, romH, 8, 5000);
        }
        public void OWGetROM(int i)
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_OW_GET_ROMI, 0, i, romH, 8, 5000);
        }
        public void OWSetROM()
        {
            for(int i = 0; i < 8; i++)
                usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                                RQ_OW_SET_ROM, romH[i], i, null, 0, 5000);
        }
        public void OWTest()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                            RQ_TEST, 0, 0, null, 0, 5000);
        }
        public bool OWEopFlag()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_EOP_FLAG, 0, 0, buffer, 1, 5000);
            return (buffer[0] != 0x00);
        }
        public byte OWEopRes()
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
                            RQ_EOP_RES, 0, 0, buffer, 1, 5000);
            return buffer[0];
        }
        public void OWCommand(byte cmd) // Команда всем устройствам
        {
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                            RQ_OW_COMMAND, cmd, 0xFF, null, 0, 5000);
        }
        public void OWCommand(byte cmd, byte addr) // Команда устройству с индексом addr
        {
            // addr - номер устройства, найденный в процессе OWSearchAll()
            usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_OUT,
                            RQ_OW_COMMAND, cmd, addr, null, 0, 5000);
        }
        #endregion
    }
}
