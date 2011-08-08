using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AvrUsbDevice;

namespace Furnace
{
    public partial class Form1 : Form
    {
        ushort vid = 0x16C0, pid = 0x05DC;
        ATMega16 dev;
        byte dm;                // Количество датчиков DS18B20, обнаруженных на шине
        double T0;
        int TC, T1;
        int valICR1 = 31250;    // Это число заносится в регистр ICR1 и определяет период ШИМ-сигнала.
                                // Тактовая частота процессора делится на 256. 
                                // В результате период получится около 1 сек
        double k;

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
            else    // С USB все в порядке
            {
                #region Инициализация АЦП
                dev.ADMUX = (3 << ATMega16.REFS0); // Будем использовать внутренний источник опорного напряжения
                // Внутренняя частота АЦП не должна превышать 200 кГц. Поэтомк тактовая частота микроконтроллера
                // должна быть поделена на 128 (биты ADPS0, ADPS1 и ADPS2 установим в 1). Т.о. получим 125 кГц.
                // Время преобразования будет (1/125000)*13 = 104 мкс, соответственно частота - 9.6 кГц
                // Установка бита ADEN в 1 разрешает работу АЦП
                dev.ADCSRA = (1 << ATMega16.ADEN) | (1 << ATMega16.ADPS2) | (1 << ATMega16.ADPS1) | (1 << ATMega16.ADPS0);
                #endregion

                timer1sec.Start();      // Запускаем секундный таймер

                dev.DDRB |= 0x01;   // Бит 0 порта B - на вывод

                #region Инициализация TIMER1 в режием ШИМ (Phase and Frequency Correct)
                dev.DDRD = 0x20;    // PD5 (OC1A) - выход ШИМ TIMER1
                dev.DDRB &= 0xFD;   // !!!! Костылик для 1-Wire !!!!
                dev.TCCR1B = 0x00;  // Остановим таймер

                // Нам нужен обратный ШИМ, чтобы при нулевой мощности на выходе была 1,
                // так, чтобы симистор был закрыт    
                dev.TCCR1A = (1 << ATMega16.COM1A1) | 
                             (1 << ATMega16.COM1A0);    // Здесь WGM11, WGM10 = 0 для режима 8 см. ниже
                dev.TCCR1B = (1 << ATMega16.WGM13) |    // WGM13 = 1, WGM12 = 0 - это режим 8 : PWM, Phase and Frequency Correct
                             0x04;                      // Тактовая частота делится на 256
                dev.ICR1H = (byte)(valICR1 >> 8);
                dev.ICR1L = (byte)(valICR1 & 0xFF);

                dev.OCR1AH = 0x00;
                dev.OCR1AL = 0x00;

                k = valICR1 / 100.0;
                #endregion
            }
        }

        private void numericUpDownPower_ValueChanged(object sender, EventArgs e)
        {
            // При изменении мощности - обновляем содержимое регистра OCR1AH - скважность ШИМ-импульсов
            int v = (int)(k * ((double)numericUpDownPower.Value));
            dev.OCR1AH = (byte)(v >> 8);
            dev.OCR1AL = (byte)v;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            numericUpDownPower.Value = 0;
        }

        private void buttonPowerReset_Click(object sender, EventArgs e)
        {
            numericUpDownPower.Value = 0;
        }

        private void timer1sec_Tick(object sender, EventArgs e)
        {
            // Работаем с датчиком окружающей среды
            dm = dev.OWSearchAll();     // Ищем датчики на шине 1-wire
            if (dm > 0)                 // Датчики есть
            {
                dev.OWReset();          // Общий сброс
                dev.OWCommand(0x44);    // Запуск преобразования на всех устройствах
                timer750ms.Start();     // Запускаем таймер на 750 мс, дальнейшая работа - в timer750ms_Tick()
            }
            else
                textBoxT0.Text = "Нет";

            // Работаем с термопарой (АЦП)
            dev.ADMUX = (byte)((dev.ADMUX & 0xE0) | 0);     // Работает один канал - ADC0
            dev.ADCSRA |= (1 << ATMega16.ADSC);             // Запуск АЦП
            // Время преобразования мало (около 100 мкс). Поэтому просто подождем готовности в цикле
            while ((dev.ADCSRA & (1 << ATMega16.ADIF)) == 0) ;
            TC = (dev.ADCL + (((int)dev.ADCH) << 8));    // Формируем число
            textBoxTC.Text = TC.ToString();                  // Выводим значение в окно вывода кода АЦП
        }

        private void timer750ms_Tick(object sender, EventArgs e)
        {
            timer750ms.Stop();
            dev.OWReset();                          // Сброс, как обычно
            dev.OWCommand(0xBE, 0);                 // Команда чтения результата 1-го датчика
            ushort w = dev.OWReadByte();            // Читаем сначала младший байт
            w |= (ushort)(dev.OWReadByte() << 8);   // Читаем и добавим старший байт
            bool negFlag = ((w & 0x1000) != 0);     // Признак отрицательного числа
            if (negFlag)                            // Вычислим модуль
                w = (ushort)(65536 - w);
            // Из 4 младших бит формируем дробную часть
            double dt = (((w & 0x0008) != 0) ? 0.5 : 0) +
                        (((w & 0x0004) != 0) ? 0.25 : 0) +
                        (((w & 0x0002) != 0) ? 0.125 : 0) +
                        (((w & 0x0001) != 0) ? 0.0625 : 0);
            T0 = ((double)(w >> 4)) + dt;
            if (negFlag)                            // Теперь учтем знак
                T0 = -T0;
            textBoxT0.Text = T0.ToString("f2");      // Выводим с двумя знаками после запятой
        }

        private void buttonFix_Click(object sender, EventArgs e)
        {
            T1 = int.Parse(textBoxT1.Text);
            string s = "  " + T0.ToString("f2") + "\t" + TC.ToString("f0") + "\t" + T1.ToString();
            textBoxInfo.Text += s + "\r\n";
        }
    }
}
