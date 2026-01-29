namespace SchoolDatabaseSystem
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();
            comboBoxTerm = new ComboBox();
            comboBoxYear = new ComboBox();
            label2 = new Label();
            groupBoxTerm = new GroupBox();
            comboBoxStudents = new ComboBox();
            StudentLabel = new Label();
            label3 = new Label();
            comboBox2 = new ComboBox();
            textBoxCourses = new TextBox();
            groupBoxCourses = new GroupBox();
            groupBoxCourseDescription = new GroupBox();
            label4 = new Label();
            label_seats = new Label();
            label_action = new Label();
            label_schedule = new Label();
            label_instructor = new Label();
            label_CourseName = new Label();
            label_Code = new Label();
            groupBox_summary = new GroupBox();
            button_clear = new Button();
            button_cancel = new Button();
            button_register = new Button();
            groupBoxTerm.SuspendLayout();
            groupBoxCourses.SuspendLayout();
            groupBoxCourseDescription.SuspendLayout();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(195, 25);
            label1.Name = "label1";
            label1.Size = new Size(49, 20);
            label1.TabIndex = 0;
            label1.Text = "Term:";
            label1.Click += label1_Click;
            // 
            // comboBoxTerm
            // 
            comboBoxTerm.FormattingEnabled = true;
            comboBoxTerm.Items.AddRange(new object[] { "Fall", "Winter", "Spring", "Summer" });
            comboBoxTerm.Location = new Point(250, 22);
            comboBoxTerm.Name = "comboBoxTerm";
            comboBoxTerm.Size = new Size(108, 23);
            comboBoxTerm.TabIndex = 1;
            comboBoxTerm.SelectedIndexChanged += comboBox1_SelectedIndexChanged;
            // 
            // comboBoxYear
            // 
            comboBoxYear.FormattingEnabled = true;
            comboBoxYear.Items.AddRange(new object[] { "Need to use sample data to populate" });
            comboBoxYear.Location = new Point(419, 22);
            comboBoxYear.Name = "comboBoxYear";
            comboBoxYear.Size = new Size(108, 23);
            comboBoxYear.TabIndex = 3;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label2.Location = new Point(369, 25);
            label2.Name = "label2";
            label2.Size = new Size(44, 20);
            label2.TabIndex = 2;
            label2.Text = "Year:";
            label2.Click += label2_Click;
            // 
            // groupBoxTerm
            // 
            groupBoxTerm.BackColor = Color.Gainsboro;
            groupBoxTerm.Controls.Add(comboBoxStudents);
            groupBoxTerm.Controls.Add(StudentLabel);
            groupBoxTerm.Controls.Add(comboBoxYear);
            groupBoxTerm.Controls.Add(label2);
            groupBoxTerm.Controls.Add(comboBoxTerm);
            groupBoxTerm.Controls.Add(label1);
            groupBoxTerm.Location = new Point(12, 22);
            groupBoxTerm.Name = "groupBoxTerm";
            groupBoxTerm.Size = new Size(776, 59);
            groupBoxTerm.TabIndex = 4;
            groupBoxTerm.TabStop = false;
            groupBoxTerm.Enter += groupBox1_Enter;
            // 
            // comboBoxStudents
            // 
            comboBoxStudents.FormattingEnabled = true;
            comboBoxStudents.Items.AddRange(new object[] { "Need to use sample data to populate" });
            comboBoxStudents.Location = new Point(79, 22);
            comboBoxStudents.Name = "comboBoxStudents";
            comboBoxStudents.Size = new Size(108, 23);
            comboBoxStudents.TabIndex = 5;
            comboBoxStudents.SelectedIndexChanged += comboBox3_SelectedIndexChanged;
            // 
            // StudentLabel
            // 
            StudentLabel.AutoSize = true;
            StudentLabel.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            StudentLabel.Location = new Point(5, 25);
            StudentLabel.Name = "StudentLabel";
            StudentLabel.Size = new Size(68, 20);
            StudentLabel.TabIndex = 4;
            StudentLabel.Text = "Student:";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label3.ForeColor = Color.DimGray;
            label3.Location = new Point(6, 23);
            label3.Name = "label3";
            label3.Size = new Size(123, 15);
            label3.TabIndex = 5;
            label3.Text = "AVAILABLE COURSES";
            label3.Click += label3_Click;
            // 
            // comboBox2
            // 
            comboBox2.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            comboBox2.AutoCompleteSource = AutoCompleteSource.ListItems;
            comboBox2.FormattingEnabled = true;
            comboBox2.Items.AddRange(new object[] { "All", "Computer Science", "Mathematics", "Physics", "Statistics" });
            comboBox2.Location = new Point(300, 47);
            comboBox2.Name = "comboBox2";
            comboBox2.Size = new Size(151, 23);
            comboBox2.TabIndex = 6;
            comboBox2.Text = "All";
            // 
            // textBoxCourses
            // 
            textBoxCourses.Location = new Point(6, 50);
            textBoxCourses.Name = "textBoxCourses";
            textBoxCourses.Size = new Size(276, 23);
            textBoxCourses.TabIndex = 7;
            textBoxCourses.Text = "Search courses...";
            textBoxCourses.Enter += textBoxCourses_Enter;
            textBoxCourses.Leave += textBoxCourses_Leave;
            // 
            // groupBoxCourses
            // 
            groupBoxCourses.BackColor = Color.WhiteSmoke;
            groupBoxCourses.Controls.Add(groupBoxCourseDescription);
            groupBoxCourses.Controls.Add(textBoxCourses);
            groupBoxCourses.Controls.Add(comboBox2);
            groupBoxCourses.Controls.Add(label3);
            groupBoxCourses.Location = new Point(14, 103);
            groupBoxCourses.Name = "groupBoxCourses";
            groupBoxCourses.Size = new Size(531, 296);
            groupBoxCourses.TabIndex = 8;
            groupBoxCourses.TabStop = false;
            // 
            // groupBoxCourseDescription
            // 
            groupBoxCourseDescription.Controls.Add(label4);
            groupBoxCourseDescription.Controls.Add(label_seats);
            groupBoxCourseDescription.Controls.Add(label_action);
            groupBoxCourseDescription.Controls.Add(label_schedule);
            groupBoxCourseDescription.Controls.Add(label_instructor);
            groupBoxCourseDescription.Controls.Add(label_CourseName);
            groupBoxCourseDescription.Controls.Add(label_Code);
            groupBoxCourseDescription.Location = new Point(6, 94);
            groupBoxCourseDescription.Name = "groupBoxCourseDescription";
            groupBoxCourseDescription.Size = new Size(519, 47);
            groupBoxCourseDescription.TabIndex = 8;
            groupBoxCourseDescription.TabStop = false;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.BackColor = Color.Gainsboro;
            label4.Location = new Point(309, 23);
            label4.Name = "label4";
            label4.Size = new Size(74, 15);
            label4.TabIndex = 13;
            label4.Text = "Prerequisites";
            // 
            // label_seats
            // 
            label_seats.AutoSize = true;
            label_seats.BackColor = Color.Gainsboro;
            label_seats.Location = new Point(411, 23);
            label_seats.Name = "label_seats";
            label_seats.Size = new Size(34, 15);
            label_seats.TabIndex = 13;
            label_seats.Text = "Seats";
            // 
            // label_action
            // 
            label_action.AutoSize = true;
            label_action.BackColor = Color.Gainsboro;
            label_action.Location = new Point(461, 23);
            label_action.Name = "label_action";
            label_action.Size = new Size(42, 15);
            label_action.TabIndex = 12;
            label_action.Text = "Action";
            // 
            // label_schedule
            // 
            label_schedule.AutoSize = true;
            label_schedule.BackColor = Color.Gainsboro;
            label_schedule.Location = new Point(234, 24);
            label_schedule.Name = "label_schedule";
            label_schedule.Size = new Size(55, 15);
            label_schedule.TabIndex = 11;
            label_schedule.Text = "Schedule";
            // 
            // label_instructor
            // 
            label_instructor.AutoSize = true;
            label_instructor.BackColor = Color.Gainsboro;
            label_instructor.Location = new Point(157, 23);
            label_instructor.Name = "label_instructor";
            label_instructor.Size = new Size(58, 15);
            label_instructor.TabIndex = 10;
            label_instructor.Text = "Instructor";
            // 
            // label_CourseName
            // 
            label_CourseName.AutoSize = true;
            label_CourseName.BackColor = Color.Gainsboro;
            label_CourseName.Location = new Point(53, 23);
            label_CourseName.Name = "label_CourseName";
            label_CourseName.Size = new Size(79, 15);
            label_CourseName.TabIndex = 9;
            label_CourseName.Text = "Course Name";
            // 
            // label_Code
            // 
            label_Code.AutoSize = true;
            label_Code.BackColor = Color.Gainsboro;
            label_Code.Location = new Point(3, 23);
            label_Code.Name = "label_Code";
            label_Code.Size = new Size(35, 15);
            label_Code.TabIndex = 0;
            label_Code.Text = "Code";
            // 
            // groupBox_summary
            // 
            groupBox_summary.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            groupBox_summary.ForeColor = Color.DimGray;
            groupBox_summary.Location = new Point(551, 117);
            groupBox_summary.Name = "groupBox_summary";
            groupBox_summary.Size = new Size(240, 283);
            groupBox_summary.TabIndex = 9;
            groupBox_summary.TabStop = false;
            groupBox_summary.Text = "Registration Summary";
            // 
            // button_clear
            // 
            button_clear.BackColor = SystemColors.ControlDark;
            button_clear.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            button_clear.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            button_clear.Location = new Point(298, 405);
            button_clear.Name = "button_clear";
            button_clear.Size = new Size(144, 39);
            button_clear.TabIndex = 10;
            button_clear.Text = "Clear Selection";
            button_clear.UseVisualStyleBackColor = false;
            // 
            // button_cancel
            // 
            button_cancel.BackColor = SystemColors.ControlDark;
            button_cancel.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            button_cancel.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            button_cancel.Location = new Point(448, 406);
            button_cancel.Name = "button_cancel";
            button_cancel.Size = new Size(109, 39);
            button_cancel.TabIndex = 11;
            button_cancel.Text = "Cancel";
            button_cancel.UseVisualStyleBackColor = false;
            // 
            // button_register
            // 
            button_register.BackColor = SystemColors.MenuHighlight;
            button_register.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            button_register.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            button_register.Location = new Point(563, 406);
            button_register.Name = "button_register";
            button_register.Size = new Size(228, 39);
            button_register.TabIndex = 12;
            button_register.Text = "Register for Selected Courses";
            button_register.UseVisualStyleBackColor = false;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(button_register);
            Controls.Add(button_cancel);
            Controls.Add(button_clear);
            Controls.Add(groupBox_summary);
            Controls.Add(groupBoxCourses);
            Controls.Add(groupBoxTerm);
            Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Name = "Form1";
            Text = "University Registration";
            groupBoxTerm.ResumeLayout(false);
            groupBoxTerm.PerformLayout();
            groupBoxCourses.ResumeLayout(false);
            groupBoxCourses.PerformLayout();
            groupBoxCourseDescription.ResumeLayout(false);
            groupBoxCourseDescription.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Label label1;
        private ComboBox comboBoxTerm;
        private ComboBox comboBoxYear;
        private Label label2;
        private GroupBox groupBoxTerm;
        private Label label3;
        private ComboBox comboBox2;
        private TextBox textBoxCourses;
        private GroupBox groupBoxCourses;
        private GroupBox groupBoxCourseDescription;
        private Label label_CourseName;
        private Label label_Code;
        private Label label_action;
        private Label label_schedule;
        private Label label_instructor;
        private GroupBox groupBox_summary;
        private Button button_clear;
        private Button button_cancel;
        private Button button_register;
        private Label label_seats;
        private Label label4;
        private ComboBox comboBoxStudents;
        private Label StudentLabel;
    }
}
