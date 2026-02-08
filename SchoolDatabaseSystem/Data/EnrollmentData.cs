using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class EnrollmentData
    {
        // Get student's enrolled courses
        public static DataTable GetStudentEnrollments(int studentId)
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

            SqlParameter[] parameters = {
                new SqlParameter("@studentId", studentId)
            };

            return Database.ExecuteQuery(query, parameters);
        }

        // Check if student is already enrolled
        public static bool IsAlreadyEnrolled(int studentId, int sectionId)
        {
            string query = @"
                SELECT COUNT(*)
                FROM Enrollment
                WHERE student_id = @studentId AND section_id = @sectionId";

            SqlParameter[] parameters = {
                new SqlParameter("@studentId", studentId),
                new SqlParameter("@sectionId", sectionId)
            };

            int count = (int)Database.ExecuteScalar(query, parameters);
            return count > 0;
        }

        // Check if section is full
        public static bool IsSectionFull(int sectionId)
        {
            string query = @"
        SELECT cs.max_capacity, ISNULL(v.enrolled_count, 0) as enrolled_count
        FROM CourseSection cs
        LEFT JOIN vw_SectionEnrollmentCount v ON cs.section_id = v.section_id
        WHERE cs.section_id = @sectionId";

            SqlParameter[] parameters = {
                new SqlParameter("@sectionId", sectionId)
            };

            object result = Database.ExecuteScalar(query, parameters);

            if (result == null || result == DBNull.Value)
                return true;

            int seatsRemaining = Convert.ToInt32(result);
            return seatsRemaining <= 0;
        }
    }
}