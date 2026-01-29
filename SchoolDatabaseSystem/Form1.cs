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
            DatabaseConnection();
            LoadStudents();
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



        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        //private void textBox1_TextChanged(object sender, EventArgs e)
        //{

        //}

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

        }
    }
}
