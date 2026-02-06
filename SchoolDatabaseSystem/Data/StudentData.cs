using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class StudentData
    {
        // Get all students for dropdown
        public static DataTable GetAllStudents()
        {
            string query = "SELECT student_id, name FROM Student";
            return Database.ExecuteQuery(query);
        }
    }
}