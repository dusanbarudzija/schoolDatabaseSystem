using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class CourseData
    {
        // Get available sections for a term/year
        public static DataTable GetAvailableSections(string term, int year)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@Term", term),
                new SqlParameter("@Year", year)
            };

            return Database.ExecuteSelectProcedure("sp_GetAvailableSections", parameters);
        }

        // Get course schedule for a section
        public static DataTable GetCourseSchedule(int sectionId)
        {
            SqlParameter[] parameters =
            {
                new SqlParameter("@SectionId", sectionId)
            };

            return Database.ExecuteSelectProcedure("sp_GetCourseSchedule", parameters);
        }
    }
}
