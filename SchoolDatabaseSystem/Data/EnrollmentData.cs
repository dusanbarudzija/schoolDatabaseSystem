using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class EnrollmentData
    {
        // Get student's enrolled courses
        public static DataTable GetStudentEnrollments(int studentId)
        {
            SqlParameter[] parameters = {
                new SqlParameter("@StudentId", studentId)
            };

            return Database.ExecuteSelectProcedure("sp_GetStudentEnrollments", parameters);
        }

    }
}