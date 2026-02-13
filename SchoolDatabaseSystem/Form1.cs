using Microsoft.Data.SqlClient;
using System.Data;
using SchoolDatabaseSystem.Data;

namespace SchoolDatabaseSystem
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            LoadTerms();
            LoadYears();
            TestDatabaseConnection();
            LoadStudents();
            LoadAvailableSections();
        }

        private void TestDatabaseConnection()
        {
            string errorMessage;
            if (!Database.DatabaseConnection(out errorMessage))
            {
                MessageBox.Show($"Database connection failed: {errorMessage}", "Error");
                this.Close();
            }
        }


        // Load students into dropdown
        private void LoadStudents()
        {
            try
            {
                DataTable students = StudentData.GetAllStudents();
                comboBoxStudents.DisplayMember = "name";
                comboBoxStudents.ValueMember = "student_id";
                comboBoxStudents.DataSource = students;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading students: {ex.Message}", "Error");
            }
        }

        // Load available sections for selected term/year
        private void LoadAvailableSections()
        {
            if (comboBoxTerm.SelectedItem == null || comboBoxYear.SelectedItem == null)
                return;

            try
            {
                string term = comboBoxTerm.SelectedItem.ToString();
                int year = (int)comboBoxYear.SelectedItem;

                DataTable sections = CourseData.GetAvailableSections(term, year);
                dataGridViewCourses.DataSource = sections;
                dataGridViewCourses.Columns["section_id"].Visible = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading sections: {ex.Message}", "Error");
            }
        }

        // Load student's enrolled courses
        private void ShowStudentCourses()
        {
            dataGridViewSchedule.DataSource = null;

            if (comboBoxStudents.SelectedValue == null)
                return;

            int studentId = (int)comboBoxStudents.SelectedValue;

            // Disable controls
            comboBoxTerm.Enabled = false;
            comboBoxYear.Enabled = false;
            buttonAddToCart.Enabled = false;

            try
            {
                DataTable enrollments = EnrollmentData.GetStudentEnrollments(studentId);
                dataGridViewCourses.DataSource = enrollments;

                // Hide ID columns
                dataGridViewCourses.Columns["enrollment_id"].Visible = false;
                dataGridViewCourses.Columns["section_id"].Visible = false;

                dataGridViewSchedule.DataSource = null;
                dataGridViewCourses.ClearSelection();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading enrollments: {ex.Message}", "Error");
            }
        }

        // Load student's shopping cart
        private void LoadStudentCart()
        {
            if (comboBoxStudents.SelectedValue == null)
                return;

            int studentId = (int)comboBoxStudents.SelectedValue;

            try
            {
                DataTable cart = CartData.GetStudentCart(studentId);
                dataGridViewCourses.DataSource = cart;

                // Hide ID columns
                dataGridViewCourses.Columns["section_id"].Visible = false;
                dataGridViewCourses.Columns["cart_id"].Visible = false;

                dataGridViewSchedule.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading cart: {ex.Message}", "Error");
            }
        }


        private void LoadTerms()
        {
            comboBoxTerm.Items.Clear();
            comboBoxTerm.Items.Add("Fall");
            comboBoxTerm.Items.Add("Winter");
            comboBoxTerm.Items.Add("Spring");
            comboBoxTerm.Items.Add("Summer");
            comboBoxTerm.SelectedIndex = 0;
        }
        private void LoadYears()
        {
            int currentYear = (DateTime.Now.Year) - 1;
            comboBoxYear.Items.Clear();

            for (int i = 0; i <= 2; i++)
            {
                comboBoxYear.Items.Add(currentYear + i);
            }

            comboBoxYear.SelectedIndex = 0;
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        // Load course schedule
        private void LoadSchedule(int sectionId)
        {
            try
            {
                DataTable schedule = CourseData.GetCourseSchedule(sectionId);
                dataGridViewSchedule.DataSource = schedule;
                dataGridViewSchedule.ClearSelection();
                dataGridViewSchedule.ReadOnly = true;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading schedule: {ex.Message}", "Error");
            }
        }


        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxStudents.SelectedValue == null)
                return;

            radioAvailable.Checked = true;
        }




        private void comboBoxTerm_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAvailableSections();
        }

        private void comboBoxYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAvailableSections();
        }

        private void dataGridViewCourses_SelectionChanged(object sender, EventArgs e)
        {
            if (dataGridViewCourses.SelectedRows.Count == 0)
                return;

            var row = dataGridViewCourses.SelectedRows[0];

            if (row.Cells["section_id"] == null ||
                row.Cells["section_id"].Value == null ||
                row.Cells["section_id"].Value == DBNull.Value)
                return;

            if (!dataGridViewCourses.Columns.Contains("section_id"))
                return;

            int sectionId = Convert.ToInt32(row.Cells["section_id"].Value);

            LoadSchedule(sectionId);
        }


        // ============================================
        // RADIO BUTTON EVENT HANDLERS
        // ============================================
        private void studentRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (radioStudent.Checked)
            {
                comboBoxTerm.Enabled = false;
                comboBoxYear.Enabled = false;

                buttonAddToCart.Visible = false;
                buttonRegisterCart.Visible = false;
                buttonReturnCourse.Visible = true;
                ShowStudentCourses();
            }
            else
            {
                comboBoxTerm.Enabled = true;
                comboBoxYear.Enabled = true;
                buttonAddToCart.Enabled = true;
                buttonAddToCart.Enabled = true;
                dataGridViewSchedule.DataSource = null;
                LoadAvailableSections();
            }

        }

        private void radioAvailable_CheckedChanged(object sender, EventArgs e)
        {
            if (!radioAvailable.Checked) return;

            comboBoxTerm.Enabled = true;
            comboBoxYear.Enabled = true;

            buttonAddToCart.Visible = true;
            buttonRegisterCart.Visible = false;
            buttonReturnCourse.Visible = false;

            LoadAvailableSections();
        }

        private void radioCart_CheckedChanged(object sender, EventArgs e)
        {
            if (!radioCart.Checked) return;

            comboBoxTerm.Enabled = false;
            comboBoxYear.Enabled = false;

            buttonAddToCart.Visible = false;
            buttonRegisterCart.Visible = true;
            buttonReturnCourse.Visible = true;

            LoadStudentCart();
        }

        /* =================
         * CART OPERATIONS
         =================== */

        // Add course to cart
        private void AddToCart(int studentId, int sectionId)
        {
            string message;
            if (CartData.AddToCart(studentId, sectionId, out message))
            {
                MessageBox.Show(message, "Success");
            }
            else
            {
                MessageBox.Show(message, "Cannot Add");
            }
        }

        private void RegisterSelectedCartItem()
        {
            if (comboBoxStudents.SelectedValue == null || dataGridViewCourses.SelectedRows.Count == 0)
            {
                MessageBox.Show("Please select a cart item.", "No Selection");
                return;
            }

            int studentId = (int)comboBoxStudents.SelectedValue;
            int sectionId = Convert.ToInt32(dataGridViewCourses.SelectedRows[0].Cells["section_id"].Value);

            string message;
            if (CartData.RegisterCartItem(studentId, sectionId, out message))
            {
                MessageBox.Show(message, "Success");
                LoadStudentCart(); // Refresh cart
            }
            else
            {
                MessageBox.Show(message, "Registration Failed");
            }
        }

        // Remove course from cart
        private void RemoveCartItem()
        {
            if (comboBoxStudents.SelectedValue == null || dataGridViewCourses.SelectedRows.Count == 0)
                return;

            int studentId = (int)comboBoxStudents.SelectedValue;
            int sectionId = Convert.ToInt32(dataGridViewCourses.SelectedRows[0].Cells["section_id"].Value);

            string message;
            if (CartData.RemoveFromCart(studentId, sectionId, out message))
            {
                MessageBox.Show(message, "Success");
                LoadStudentCart(); // Refresh cart
            }
            else
            {
                MessageBox.Show(message, "Error");
            }
        }

        private void RemoveEnrolledCourse()
        {
            if (comboBoxStudents.SelectedValue == null || dataGridViewCourses.SelectedRows.Count == 0)
                return;

            int studentId = (int)comboBoxStudents.SelectedValue;
            int sectionId = Convert.ToInt32(dataGridViewCourses.SelectedRows[0].Cells["section_id"].Value);

            string message;
            if (EnrollmentData.RemoveEnrolledCourse(studentId, sectionId, out message))
            {
                MessageBox.Show(message, "Success");
                ShowStudentCourses(); // Refresh student's courses
            }
            else
            {
                MessageBox.Show(message, "Error");
            }
        }


        // ============================================
        // BUTTON CLICK EVENT HANDLERS
        // ============================================

        private void buttonAddToCart_Click(object sender, EventArgs e)
        {
            if (comboBoxStudents.SelectedValue == null || dataGridViewCourses.SelectedRows.Count == 0)
            {
                MessageBox.Show("Please select a student and a course.", "No Selection");
                return;
            }

            int studentId = (int)comboBoxStudents.SelectedValue;
            int sectionId = Convert.ToInt32(dataGridViewCourses.SelectedRows[0].Cells["section_id"].Value);

            AddToCart(studentId, sectionId);
        }

        private void buttonRegisterCart_Click(object sender, EventArgs e)
        {
            RegisterSelectedCartItem();
        }

        private void buttonReturnCourse_Click(object sender, EventArgs e)
        {
            if (radioCart.Checked)
            {
                RemoveCartItem();
            }
            else if (radioStudent.Checked)
            {
                RemoveEnrolledCourse();
            }

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
