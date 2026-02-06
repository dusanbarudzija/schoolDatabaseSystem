using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class CourseData
    {
        // Get available sections for a term/year
        public static DataTable GetAvailableSections(string term, int year)
        {
            string query = @"
                SELECT
                    cs.section_id,
                    c.course_code,
                    c.title,
                    cs.section_number,
                    i.name AS instructor,
                    cs.max_capacity -
                        (SELECT COUNT(*) FROM Enrollment e WHERE e.section_id = cs.section_id)
                        AS seats_remaining
                FROM CourseSection cs
                JOIN Course c ON cs.course_id = c.course_id
                JOIN Instructor i ON cs.instructor_id = i.instructor_id
                WHERE cs.term = @term
                  AND cs.year = @year";

            SqlParameter[] parameters = {
                new SqlParameter("@term", term),
                new SqlParameter("@year", year)
            };

            return Database.ExecuteQuery(query, parameters);
        }

        // Get course schedule
        public static DataTable GetCourseSchedule(int sectionId)
        {
            string query = @"
                SELECT day_of_week, start_time, end_time
                FROM CourseSchedule
                WHERE section_id = @sectionId";

            SqlParameter[] parameters = {
                new SqlParameter("@sectionId", sectionId)
            };

            return Database.ExecuteQuery(query, parameters);
        }
    }
}