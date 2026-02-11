using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class StudentData
    {
        // Get all students for dropdown
        public static DataTable GetAllStudents()
        {
            return Database.ExecuteSelectProcedure("sp_GetAllStudents");
        }
    }
}