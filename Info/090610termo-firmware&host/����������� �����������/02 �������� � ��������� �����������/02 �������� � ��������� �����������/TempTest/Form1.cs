using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AvrUsbDevice;

namespace TempTest
{
    public partial class Form1 : Form
    {
        ushort vid = 0x16C0, pid = 0x05DC;
        ATMega16 dev;

        byte dm;        // Количество датчиков, обнаруженных на шине
        double t;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dev = new ATMega16(vid, pid);
            if (!dev.IsOpen())
            {
                MessageBox.Show(String.Format("Невозможно найти устройство vid = 0x{0:X}, pid = 0x{1:X}", vid, pid),
                                              "Ошибка USB", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
            }
            else
                timer1sec.Start();
        }

        private void timer1sec_Tick(object sender, EventArgs e)
        {
            dm = dev.OWSearchAll();     // Ищем датчики на шине 1-wire
            if (dm > 0)                 // Датчики есть
            {
                dev.OWReset();          // Общий сброс
                dev.OWCommand(0x44);    // Запуск преобразования на всех устройствах
                timer750ms.Start();     // Запускаем таймер на 750 мс, дальнейшая работа - в timer750ms_Tick()
            }
            else
                textBoxInfo.Text = "Нет";
        }

        private void timer750ms_Tick(object sender, EventArgs e)
        {
            string rom;
            timer750ms.Stop();
            textBoxInfo.Clear();
            for (byte i = 0; i < dm; i++)               // Опрашиваем все датчики по порядку
            {
                dev.OWGetROM(i); rom = "";
                for (byte j = 0; j < 8; j++)
                    rom += dev.romH[j].ToString() + " ";
                dev.OWReset();                          // Сброс, как обычно
                dev.OWCommand(0xBE, i);                 // Команда чтения результата i-го датчика
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
                t = ((double)(w >> 4)) + dt;
                if (negFlag)                            // Теперь учтем знак
                    t = -t;
                textBoxInfo.Text += ("    " + (i + 1).ToString() + "\t\t" + rom + "\t\t" + t.ToString("f2") + "\r\n");
            }
        }
    }
}
