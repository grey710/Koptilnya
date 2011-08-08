using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AvrUsbDevice;

namespace ADCTest
{
    public partial class Form1 : Form
    {
        ushort vid = 0x16C0, pid = 0x05DC;
        ATMega16 dev;
        
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dev = new ATMega16(vid, pid);
            if (!dev.IsOpen()) // С USB что-то не так...
            {
                MessageBox.Show(String.Format("Невозможно найти устройство vid = 0x{0:X}, pid = 0x{1:X}", vid, pid),
                                              "Ошибка USB", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
            }
            else    // С USB все в порядке, инициализируем АЦП
            {
                dev.ADMUX = (3 << ATMega16.REFS0); // Будем использовать внутренний источник опорного напряжения
                // Внутренняя частота АЦП не должна превышать 200 кГц. Поэтомк тактовая частота микроконтроллера
                // должна быть поделена на 128 (биты ADPS0, ADPS1 и ADPS2 установим в 1). Т.о. получим 125 кГц.
                // Время преобразования будет (1/125000)*13 = 104 мкс, соответственно частота - 9.6 кГц
                // Установка бита ADEN в 1 разрешает работу АЦП
                dev.ADCSRA = (1 << ATMega16.ADEN) | (1 << ATMega16.ADPS2) | (1 << ATMega16.ADPS1) | (1 << ATMega16.ADPS0);
                timer1.Start(); // Запускаем таймер
            }
        }

         private void timer1_Tick(object sender, EventArgs e)
        {
            dev.ADMUX = (byte)((dev.ADMUX & 0xE0) | 0);     // Работает один канал - ADC0
            dev.ADCSRA |= (1 << ATMega16.ADSC);             // Запуск АЦП
            // Время преобразования мало (около 100 мкс). Поэтому просто подождем готовности в цикле
            while ((dev.ADCSRA & (1 << ATMega16.ADIF)) == 0);
            int d = (dev.ADCL + (((int)dev.ADCH) << 8));    // Формируем число
            textBoxValue.Text = d.ToString();               // Выводим значение на панель
        }
    }
}
