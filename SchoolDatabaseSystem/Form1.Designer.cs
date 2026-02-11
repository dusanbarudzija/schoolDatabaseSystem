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
            radioAvailable = new RadioButton();
            radioCart = new RadioButton();
            radioStudent = new RadioButton();
            comboBoxStudents = new ComboBox();
            StudentLabel = new Label();
            label3 = new Label();
            groupBoxCourses = new GroupBox();
            dataGridViewCourses = new DataGridView();
            groupBoxCourseDescription = new GroupBox();
            label4 = new Label();
            label_seats = new Label();
            label_action = new Label();
            label_schedule = new Label();
            label_instructor = new Label();
            label_CourseName = new Label();
            label_Code = new Label();
            groupBox_summary = new GroupBox();
            dataGridViewSchedule = new DataGridView();
            button_clear = new Button();
            button_cancel = new Button();
            buttonAddToCart = new Button();
            buttonRegisterCart = new Button();
            buttonReturnCourse = new Button();
            groupBoxTerm.SuspendLayout();
            groupBoxCourses.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridViewCourses).BeginInit();
            groupBoxCourseDescription.SuspendLayout();
            groupBox_summary.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridViewSchedule).BeginInit();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(195, 25);
            label1.Name = "label1";
            label1.Size = new Size(59, 25);
            label1.TabIndex = 0;
            label1.Text = "Term:";
            // 
            // comboBoxTerm
            // 
            comboBoxTerm.FormattingEnabled = true;
            comboBoxTerm.Items.AddRange(new object[] { "Fall", "Winter", "Spring", "Summer" });
            comboBoxTerm.Location = new Point(250, 22);
            comboBoxTerm.Name = "comboBoxTerm";
            comboBoxTerm.Size = new Size(108, 28);
            comboBoxTerm.TabIndex = 1;
            comboBoxTerm.SelectedIndexChanged += comboBoxTerm_SelectedIndexChanged;
            // 
            // comboBoxYear
            // 
            comboBoxYear.FormattingEnabled = true;
            comboBoxYear.Items.AddRange(new object[] { "Need to use sample data to populate" });
            comboBoxYear.Location = new Point(419, 22);
            comboBoxYear.Name = "comboBoxYear";
            comboBoxYear.Size = new Size(108, 28);
            comboBoxYear.TabIndex = 3;
            comboBoxYear.SelectedIndexChanged += comboBoxYear_SelectedIndexChanged;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label2.Location = new Point(369, 25);
            label2.Name = "label2";
            label2.Size = new Size(54, 25);
            label2.TabIndex = 2;
            label2.Text = "Year:";
            // 
            // groupBoxTerm
            // 
            groupBoxTerm.BackColor = Color.Gainsboro;
            groupBoxTerm.Controls.Add(radioAvailable);
            groupBoxTerm.Controls.Add(radioCart);
            groupBoxTerm.Controls.Add(radioStudent);
            groupBoxTerm.Controls.Add(comboBoxStudents);
            groupBoxTerm.Controls.Add(StudentLabel);
            groupBoxTerm.Controls.Add(comboBoxYear);
            groupBoxTerm.Controls.Add(label2);
            groupBoxTerm.Controls.Add(comboBoxTerm);
            groupBoxTerm.Controls.Add(label1);
            groupBoxTerm.Location = new Point(12, 22);
            groupBoxTerm.Name = "groupBoxTerm";
            groupBoxTerm.Size = new Size(1150, 59);
            groupBoxTerm.TabIndex = 4;
            groupBoxTerm.TabStop = false;
            groupBoxTerm.Enter += groupBox1_Enter;
            // 
            // radioAvailable
            // 
            radioAvailable.AutoSize = true;
            radioAvailable.Location = new Point(722, 23);
            radioAvailable.Name = "radioAvailable";
            radioAvailable.Size = new Size(147, 24);
            radioAvailable.TabIndex = 9;
            radioAvailable.TabStop = true;
            radioAvailable.Text = "Available Courses";
            radioAvailable.UseVisualStyleBackColor = true;
            radioAvailable.CheckedChanged += radioAvailable_CheckedChanged;
            // 
            // radioCart
            // 
            radioCart.AutoSize = true;
            radioCart.Location = new Point(875, 23);
            radioCart.Name = "radioCart";
            radioCart.Size = new Size(112, 24);
            radioCart.TabIndex = 8;
            radioCart.TabStop = true;
            radioCart.Text = "Student Cart";
            radioCart.UseVisualStyleBackColor = true;
            radioCart.CheckedChanged += radioCart_CheckedChanged;
            // 
            // radioStudent
            // 
            radioStudent.AutoSize = true;
            radioStudent.Location = new Point(997, 23);
            radioStudent.Name = "radioStudent";
            radioStudent.Size = new Size(136, 24);
            radioStudent.TabIndex = 7;
            radioStudent.TabStop = true;
            radioStudent.Text = "Student Courses";
            radioStudent.UseVisualStyleBackColor = true;
            radioStudent.CheckedChanged += studentRadioButton_CheckedChanged;
            // 
            // comboBoxStudents
            // 
            comboBoxStudents.FormattingEnabled = true;
            comboBoxStudents.Items.AddRange(new object[] { "Need to use sample data to populate" });
            comboBoxStudents.Location = new Point(81, 21);
            comboBoxStudents.Name = "comboBoxStudents";
            comboBoxStudents.Size = new Size(108, 28);
            comboBoxStudents.TabIndex = 5;
            comboBoxStudents.SelectedIndexChanged += comboBox3_SelectedIndexChanged;
            // 
            // StudentLabel
            // 
            StudentLabel.AutoSize = true;
            StudentLabel.Font = new Font("Segoe UI", 10.8F, FontStyle.Bold, GraphicsUnit.Point, 0);
            StudentLabel.Location = new Point(0, 25);
            StudentLabel.Name = "StudentLabel";
            StudentLabel.Size = new Size(84, 25);
            StudentLabel.TabIndex = 4;
            StudentLabel.Text = "Student:";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label3.ForeColor = Color.DimGray;
            label3.Location = new Point(6, 19);
            label3.Name = "label3";
            label3.Size = new Size(158, 20);
            label3.TabIndex = 5;
            label3.Text = "AVAILABLE COURSES";
            // 
            // groupBoxCourses
            // 
            groupBoxCourses.BackColor = Color.WhiteSmoke;
            groupBoxCourses.Controls.Add(dataGridViewCourses);
            groupBoxCourses.Controls.Add(groupBoxCourseDescription);
            groupBoxCourses.Controls.Add(label3);
            groupBoxCourses.Location = new Point(14, 103);
            groupBoxCourses.Name = "groupBoxCourses";
            groupBoxCourses.Size = new Size(685, 296);
            groupBoxCourses.TabIndex = 8;
            groupBoxCourses.TabStop = false;
            // 
            // dataGridViewCourses
            // 
            dataGridViewCourses.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCourses.Location = new Point(4, 47);
            dataGridViewCourses.Name = "dataGridViewCourses";
            dataGridViewCourses.RowHeadersWidth = 51;
            dataGridViewCourses.Size = new Size(863, 243);
            dataGridViewCourses.TabIndex = 13;
            dataGridViewCourses.SelectionChanged += dataGridViewCourses_SelectionChanged;
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
            groupBoxCourseDescription.Location = new Point(6, 47);
            groupBoxCourseDescription.Name = "groupBoxCourseDescription";
            groupBoxCourseDescription.Size = new Size(861, 47);
            groupBoxCourseDescription.TabIndex = 8;
            groupBoxCourseDescription.TabStop = false;
            groupBoxCourseDescription.Visible = false;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.BackColor = Color.Gainsboro;
            label4.Location = new Point(309, 23);
            label4.Name = "label4";
            label4.Size = new Size(93, 20);
            label4.TabIndex = 13;
            label4.Text = "Prerequisites";
            // 
            // label_seats
            // 
            label_seats.AutoSize = true;
            label_seats.BackColor = Color.Gainsboro;
            label_seats.Location = new Point(411, 23);
            label_seats.Name = "label_seats";
            label_seats.Size = new Size(44, 20);
            label_seats.TabIndex = 13;
            label_seats.Text = "Seats";
            // 
            // label_action
            // 
            label_action.AutoSize = true;
            label_action.BackColor = Color.Gainsboro;
            label_action.Location = new Point(461, 23);
            label_action.Name = "label_action";
            label_action.Size = new Size(52, 20);
            label_action.TabIndex = 12;
            label_action.Text = "Action";
            // 
            // label_schedule
            // 
            label_schedule.AutoSize = true;
            label_schedule.BackColor = Color.Gainsboro;
            label_schedule.Location = new Point(234, 24);
            label_schedule.Name = "label_schedule";
            label_schedule.Size = new Size(69, 20);
            label_schedule.TabIndex = 11;
            label_schedule.Text = "Schedule";
            // 
            // label_instructor
            // 
            label_instructor.AutoSize = true;
            label_instructor.BackColor = Color.Gainsboro;
            label_instructor.Location = new Point(157, 23);
            label_instructor.Name = "label_instructor";
            label_instructor.Size = new Size(71, 20);
            label_instructor.TabIndex = 10;
            label_instructor.Text = "Instructor";
            // 
            // label_CourseName
            // 
            label_CourseName.AutoSize = true;
            label_CourseName.BackColor = Color.Gainsboro;
            label_CourseName.Location = new Point(53, 23);
            label_CourseName.Name = "label_CourseName";
            label_CourseName.Size = new Size(98, 20);
            label_CourseName.TabIndex = 9;
            label_CourseName.Text = "Course Name";
            // 
            // label_Code
            // 
            label_Code.AutoSize = true;
            label_Code.BackColor = Color.Gainsboro;
            label_Code.Location = new Point(3, 23);
            label_Code.Name = "label_Code";
            label_Code.Size = new Size(44, 20);
            label_Code.TabIndex = 0;
            label_Code.Text = "Code";
            // 
            // groupBox_summary
            // 
            groupBox_summary.Controls.Add(dataGridViewSchedule);
            groupBox_summary.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            groupBox_summary.ForeColor = Color.DimGray;
            groupBox_summary.Location = new Point(726, 103);
            groupBox_summary.Name = "groupBox_summary";
            groupBox_summary.Size = new Size(436, 297);
            groupBox_summary.TabIndex = 9;
            groupBox_summary.TabStop = false;
            groupBox_summary.Text = "Course Schedule";
            // 
            // dataGridViewSchedule
            // 
            dataGridViewSchedule.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewSchedule.Location = new Point(6, 47);
            dataGridViewSchedule.Name = "dataGridViewSchedule";
            dataGridViewSchedule.RowHeadersWidth = 51;
            dataGridViewSchedule.Size = new Size(573, 243);
            dataGridViewSchedule.TabIndex = 0;
            // 
            // button_clear
            // 
            button_clear.BackColor = SystemColors.ControlDark;
            button_clear.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            button_clear.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            button_clear.Location = new Point(443, 405);
            button_clear.Name = "button_clear";
            button_clear.Size = new Size(144, 39);
            button_clear.TabIndex = 10;
            button_clear.Text = "Clear Selection";
            button_clear.UseVisualStyleBackColor = false;
            button_clear.Visible = false;
            // 
            // button_cancel
            // 
            button_cancel.BackColor = SystemColors.ControlDark;
            button_cancel.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            button_cancel.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            button_cancel.Location = new Point(593, 405);
            button_cancel.Name = "button_cancel";
            button_cancel.Size = new Size(109, 39);
            button_cancel.TabIndex = 11;
            button_cancel.Text = "Cancel";
            button_cancel.UseVisualStyleBackColor = false;
            button_cancel.Visible = false;
            // 
            // buttonAddToCart
            // 
            buttonAddToCart.BackColor = SystemColors.MenuHighlight;
            buttonAddToCart.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            buttonAddToCart.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            buttonAddToCart.Location = new Point(1008, 399);
            buttonAddToCart.Name = "buttonAddToCart";
            buttonAddToCart.Size = new Size(118, 39);
            buttonAddToCart.TabIndex = 12;
            buttonAddToCart.Text = "Add to Cart";
            buttonAddToCart.UseVisualStyleBackColor = false;
            buttonAddToCart.Click += buttonAddToCart_Click;
            // 
            // buttonRegisterCart
            // 
            buttonRegisterCart.BackColor = SystemColors.MenuHighlight;
            buttonRegisterCart.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            buttonRegisterCart.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            buttonRegisterCart.Location = new Point(1008, 399);
            buttonRegisterCart.Name = "buttonRegisterCart";
            buttonRegisterCart.Size = new Size(118, 39);
            buttonRegisterCart.TabIndex = 13;
            buttonRegisterCart.Text = "Register Course";
            buttonRegisterCart.UseVisualStyleBackColor = false;
            buttonRegisterCart.Click += buttonRegisterCart_Click;
            // 
            // buttonReturnCourse
            // 
            buttonReturnCourse.BackColor = SystemColors.ControlDark;
            buttonReturnCourse.FlatAppearance.BorderColor = SystemColors.ActiveBorder;
            buttonReturnCourse.Font = new Font("Segoe UI", 9F, FontStyle.Bold, GraphicsUnit.Point, 0);
            buttonReturnCourse.Location = new Point(893, 399);
            buttonReturnCourse.Name = "buttonReturnCourse";
            buttonReturnCourse.Size = new Size(109, 39);
            buttonReturnCourse.TabIndex = 14;
            buttonReturnCourse.Text = "Remove Course";
            buttonReturnCourse.UseVisualStyleBackColor = false;
            buttonReturnCourse.Visible = false;
            buttonReturnCourse.Click += buttonReturnCourse_Click;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1246, 453);
            Controls.Add(buttonAddToCart);
            Controls.Add(buttonReturnCourse);
            Controls.Add(buttonRegisterCart);
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
            ((System.ComponentModel.ISupportInitialize)dataGridViewCourses).EndInit();
            groupBoxCourseDescription.ResumeLayout(false);
            groupBoxCourseDescription.PerformLayout();
            groupBox_summary.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dataGridViewSchedule).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Label label1;
        private ComboBox comboBoxTerm;
        private ComboBox comboBoxYear;
        private Label label2;
        private GroupBox groupBoxTerm;
        private Label label3;
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
        private Button buttonAddToCart;
        private Label label_seats;
        private Label label4;
        private ComboBox comboBoxStudents;
        private Label StudentLabel;
        private DataGridView dataGridViewCourses;
        private DataGridView dataGridViewSchedule;
        private RadioButton radioStudent;
        private Button buttonRegisterCart;
        private Button buttonReturnCourse;
        private RadioButton radioCart;
        private RadioButton radioAvailable;
    }
}
