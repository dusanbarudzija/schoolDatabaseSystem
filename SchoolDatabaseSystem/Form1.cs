using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem
{
    public partial class Form1 : Form
    {
        private readonly string connectionString = "Server=localhost;Database=UniRegistration;Trusted_Connection=True;TrustServerCertificate=True;";

        private void DatabaseConnection()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    //MessageBox.Show("Database connection successful!");
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString(), "Error");
                    this.Close();
                }
            }
        }
        public Form1()
        {
            InitializeComponent();
            LoadTerms();
            LoadYears();
            DatabaseConnection();
            LoadStudents();
            LoadAvailableSections();
        }


        private void LoadStudents()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT student_id, name FROM Student";

                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable table = new DataTable();
                adapter.Fill(table);

                comboBoxStudents.DisplayMember = "name";
                comboBoxStudents.ValueMember = "student_id";
                comboBoxStudents.DataSource = table;
            }
        }

        private void LoadAvailableSections()
        {
            if (comboBoxTerm.SelectedItem == null || comboBoxYear.SelectedItem == null)
                return;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Materialized view
                string query = @"
        SELECT
            v.section_id,
            c.course_code,
            c.title,
            v.section_number,
            i.name AS instructor,
            v.seats_remaining
        FROM vw_CourseAvailability v
        JOIN Course c ON v.course_id = c.course_id
        JOIN Instructor i ON v.instructor_id = i.instructor_id
        WHERE v.term = @term AND v.year = @year";

                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@term", comboBoxTerm.SelectedItem.ToString());
                adapter.SelectCommand.Parameters.AddWithValue("@year", (int)comboBoxYear.SelectedItem);

                DataTable table = new DataTable();
                adapter.Fill(table);

                dataGridViewCourses.DataSource = table;
                dataGridViewCourses.Columns["section_id"].Visible = false;

            }
        }


        private void RegisterStudent(int studentId, int sectionId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // Already enrolled check
                    if (IsAlreadyEnrolled(studentId, sectionId))
                    {
                        MessageBox.Show("Student already enrolled in this course.");
                        transaction.Rollback();
                        return;
                    }

                    // Capacity check (INSIDE transaction)
                    if (IsSectionFull(conn, transaction, sectionId))
                    {
                        MessageBox.Show("No space available in this course.");
                        transaction.Rollback();
                        return;
                    }

                    string insertQuery = @"
            INSERT INTO Enrollment (enrollment_id, student_id, section_id)
            VALUES (
                (SELECT ISNULL(MAX(enrollment_id),0)+1 FROM Enrollment),
                @studentId,
                @sectionId
            )";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn, transaction);
                    cmd.Parameters.AddWithValue("@studentId", studentId);
                    cmd.Parameters.AddWithValue("@sectionId", sectionId);

                    cmd.ExecuteNonQuery();

                    transaction.Commit();

                    MessageBox.Show("Registration successful!");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    MessageBox.Show("Registration failed:\n" + ex.Message);
                }
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

        private bool IsSectionFull(SqlConnection conn, SqlTransaction tran, int sectionId)
        {
            string query = @"
    SELECT 
        cs.max_capacity -
        COUNT(e.enrollment_id)
    FROM CourseSection cs
    LEFT JOIN Enrollment e ON cs.section_id = e.section_id
    WHERE cs.section_id = @sectionId
    GROUP BY cs.max_capacity";

            SqlCommand cmd = new SqlCommand(query, conn, tran);
            cmd.Parameters.AddWithValue("@sectionId", sectionId);

            object result = cmd.ExecuteScalar();

            if (result == null)
                return true;

            int seatsRemaining = Convert.ToInt32(result);

            return seatsRemaining <= 0;
        }


        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void LoadSchedule(int sectionId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
        SELECT
            day_of_week,
            start_time,
            end_time
        FROM CourseSchedule
        WHERE section_id = @sectionId";

                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@sectionId", sectionId);

                DataTable table = new DataTable();
                adapter.Fill(table);

                dataGridViewSchedule.DataSource = table;

                dataGridViewSchedule.ClearSelection();
                dataGridViewSchedule.ReadOnly = true;
            }
        }


        private void textBoxCourses_Enter(object sender, EventArgs e)
        {
            if (textBoxCourses.Text == "Select courses...")
            {
                textBoxCourses.Text = "";
                textBoxCourses.ForeColor = Color.Black;
            }
        }

        private void textBoxCourses_Leave(object sender, EventArgs e)
        {
            if (textBoxCourses.Text == "")
            {
                textBoxCourses.Text = "Select courses...";
                textBoxCourses.ForeColor = Color.Gray;
            }
        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (studentCourseCheckBox.Checked)
                ShowStudentCourses();

        }
        private void studentCourseCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            if (studentCourseCheckBox.Checked)
            {
                ShowStudentCourses();
            }
            else
            {
                comboBoxTerm.Enabled = true;
                comboBoxYear.Enabled = true;
                buttonRegister.Enabled = true;
                buttonRegister.Enabled = true;
                dataGridViewSchedule.DataSource = null;
                LoadAvailableSections();
            }
        }
        private void ShowStudentCourses()
        {
            dataGridViewSchedule.DataSource = null;
            if (comboBoxStudents.SelectedValue == null)
                return;

            int studentId = (int)comboBoxStudents.SelectedValue;

            comboBoxTerm.Enabled = false;
            comboBoxYear.Enabled = false;
            buttonRegister.Enabled = false;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
        SELECT
            cs.section_id,
            c.course_code,
            c.title,
            cs.section_number,
            i.name AS instructor,
            cs.term,
            cs.year
        FROM Enrollment e
        JOIN CourseSection cs ON e.section_id = cs.section_id
        JOIN Course c ON cs.course_id = c.course_id
        JOIN Instructor i ON cs.instructor_id = i.instructor_id
        WHERE e.student_id = @studentId";

                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@studentId", studentId);

                DataTable table = new DataTable();
                adapter.Fill(table);
                dataGridViewCourses.DataSource = table;
                dataGridViewCourses.Columns["section_id"].Visible = false;
                dataGridViewSchedule.DataSource = null;


                dataGridViewCourses.ClearSelection();
            }
        }

        private void comboBoxTerm_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAvailableSections();
        }

        private void comboBoxYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAvailableSections();
        }


        private void buttonRegister_Click(object sender, EventArgs e)
        {
            if (comboBoxStudents.SelectedValue == null || dataGridViewCourses.SelectedRows.Count == 0)
            {
                MessageBox.Show("Please select a student and a course section.");
                return;
            }

            int studentId = (int)comboBoxStudents.SelectedValue;
            int sectionId = Convert.ToInt32(
                dataGridViewCourses.SelectedRows[0].Cells["section_id"].Value
            );

            RegisterStudent(studentId, sectionId);
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
        private bool IsAlreadyEnrolled(int studentId, int sectionId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
        SELECT COUNT(*)
        FROM Enrollment
        WHERE student_id = @studentId
          AND section_id = @sectionId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@studentId", studentId);
                cmd.Parameters.AddWithValue("@sectionId", sectionId);

                conn.Open();

                int count = (int)cmd.ExecuteScalar();

                return count > 0;
            }
        }


    }
}
