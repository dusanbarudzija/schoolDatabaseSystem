namespace SchoolDatabaseSystem
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
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
            if(textBoxCourses.Text == "Select courses...") 
            {
                textBoxCourses.Text = "";
                textBoxCourses.ForeColor = Color.Black;
            }
        }

        private void textBoxCourses_Leave(object sender, EventArgs e)
        {
            if(textBoxCourses.Text == "")
            {
                textBoxCourses.Text = "Select courses...";
                textBoxCourses.ForeColor = Color.Gray;
            }
        }
    }
}
