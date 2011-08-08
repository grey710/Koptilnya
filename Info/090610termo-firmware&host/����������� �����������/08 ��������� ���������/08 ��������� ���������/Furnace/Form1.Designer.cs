namespace Furnace
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.numericUpDownPower = new System.Windows.Forms.NumericUpDown();
            this.buttonPowerReset = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxT0 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.textBoxTC = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.textBoxT1 = new System.Windows.Forms.TextBox();
            this.buttonFix = new System.Windows.Forms.Button();
            this.textBoxInfo = new System.Windows.Forms.TextBox();
            this.timer1sec = new System.Windows.Forms.Timer(this.components);
            this.timer750ms = new System.Windows.Forms.Timer(this.components);
            this.label6 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownPower)).BeginInit();
            this.SuspendLayout();
            // 
            // numericUpDownPower
            // 
            this.numericUpDownPower.Location = new System.Drawing.Point(141, 5);
            this.numericUpDownPower.Name = "numericUpDownPower";
            this.numericUpDownPower.Size = new System.Drawing.Size(47, 20);
            this.numericUpDownPower.TabIndex = 0;
            this.numericUpDownPower.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.numericUpDownPower.ValueChanged += new System.EventHandler(this.numericUpDownPower_ValueChanged);
            // 
            // buttonPowerReset
            // 
            this.buttonPowerReset.Location = new System.Drawing.Point(6, 31);
            this.buttonPowerReset.Name = "buttonPowerReset";
            this.buttonPowerReset.Size = new System.Drawing.Size(182, 23);
            this.buttonPowerReset.TabIndex = 1;
            this.buttonPowerReset.Text = "Сброс мощности на 0";
            this.buttonPowerReset.UseVisualStyleBackColor = true;
            this.buttonPowerReset.Click += new System.EventHandler(this.buttonPowerReset_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(118, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Мощность нагрева, %";
            // 
            // textBoxT0
            // 
            this.textBoxT0.Location = new System.Drawing.Point(141, 61);
            this.textBoxT0.Name = "textBoxT0";
            this.textBoxT0.ReadOnly = true;
            this.textBoxT0.Size = new System.Drawing.Size(47, 20);
            this.textBoxT0.TabIndex = 5;
            this.textBoxT0.TabStop = false;
            this.textBoxT0.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(3, 64);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(127, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Т-ра окр. среды (T0), °С";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(2, 88);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(137, 13);
            this.label3.TabIndex = 8;
            this.label3.Text = "Термопара (TC, код АЦП)";
            // 
            // textBoxTC
            // 
            this.textBoxTC.Location = new System.Drawing.Point(141, 85);
            this.textBoxTC.Name = "textBoxTC";
            this.textBoxTC.ReadOnly = true;
            this.textBoxTC.Size = new System.Drawing.Size(47, 20);
            this.textBoxTC.TabIndex = 7;
            this.textBoxTC.TabStop = false;
            this.textBoxTC.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(3, 112);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(130, 13);
            this.label4.TabIndex = 10;
            this.label4.Text = "Т-ра термостата (T1), °С";
            // 
            // textBoxT1
            // 
            this.textBoxT1.Location = new System.Drawing.Point(141, 109);
            this.textBoxT1.Name = "textBoxT1";
            this.textBoxT1.Size = new System.Drawing.Size(47, 20);
            this.textBoxT1.TabIndex = 9;
            this.textBoxT1.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // buttonFix
            // 
            this.buttonFix.Location = new System.Drawing.Point(6, 135);
            this.buttonFix.Name = "buttonFix";
            this.buttonFix.Size = new System.Drawing.Size(182, 23);
            this.buttonFix.TabIndex = 11;
            this.buttonFix.Text = "Зафиксировать значения";
            this.buttonFix.UseVisualStyleBackColor = true;
            this.buttonFix.Click += new System.EventHandler(this.buttonFix_Click);
            // 
            // textBoxInfo
            // 
            this.textBoxInfo.Location = new System.Drawing.Point(195, 31);
            this.textBoxInfo.Multiline = true;
            this.textBoxInfo.Name = "textBoxInfo";
            this.textBoxInfo.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxInfo.Size = new System.Drawing.Size(149, 127);
            this.textBoxInfo.TabIndex = 12;
            // 
            // timer1sec
            // 
            this.timer1sec.Interval = 1000;
            this.timer1sec.Tick += new System.EventHandler(this.timer1sec_Tick);
            // 
            // timer750ms
            // 
            this.timer750ms.Interval = 750;
            this.timer750ms.Tick += new System.EventHandler(this.timer750ms_Tick);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(196, 9);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(116, 13);
            this.label6.TabIndex = 15;
            this.label6.Text = "   T0         TC           T1";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(351, 164);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.textBoxInfo);
            this.Controls.Add(this.buttonFix);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBoxT1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.textBoxTC);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBoxT0);
            this.Controls.Add(this.buttonPowerReset);
            this.Controls.Add(this.numericUpDownPower);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Furnace";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownPower)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NumericUpDown numericUpDownPower;
        private System.Windows.Forms.Button buttonPowerReset;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxT0;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBoxTC;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBoxT1;
        private System.Windows.Forms.Button buttonFix;
        private System.Windows.Forms.TextBox textBoxInfo;
        private System.Windows.Forms.Timer timer1sec;
        private System.Windows.Forms.Timer timer750ms;
        private System.Windows.Forms.Label label6;
    }
}

