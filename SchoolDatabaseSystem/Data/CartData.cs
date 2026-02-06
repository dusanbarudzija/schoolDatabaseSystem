using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class CartData
    {
        // Add course to cart
        public static bool AddToCart(int studentId, int sectionId, out string message)
        {
            message = string.Empty;

            try
            {
                // Check if already enrolled
                if (EnrollmentData.IsAlreadyEnrolled(studentId, sectionId))
                {
                    message = "Student already enrolled.";
                    return false;
                }

                // Check if already in cart
                string existsQuery = "SELECT COUNT(*) FROM Cart WHERE student_id=@s AND section_id=@sec";
                SqlParameter[] existsParams = {
                    new SqlParameter("@s", studentId),
                    new SqlParameter("@sec", sectionId)
                };

                int count = (int)Database.ExecuteScalar(existsQuery, existsParams);
                if (count > 0)
                {
                    message = "Course already in cart.";
                    return false;
                }

                /*
                    ====================================
                    SCHEDULE CONFLICT CHECK GOES HERE
                    PREREQUISITE CHECK GOES HERE
                    ====================================
                */

                // Add to cart
                string insertQuery = "INSERT INTO Cart(student_id, section_id) VALUES(@s,@sec)";
                SqlParameter[] insertParams = {
                    new SqlParameter("@s", studentId),
                    new SqlParameter("@sec", sectionId)
                };

                Database.ExecuteNonQuery(insertQuery, insertParams);

                message = "Added to cart.";
                return true;
            }
            catch (Exception ex)
            {
                message = $"Error: {ex.Message}";
                return false;
            }
        }

        // Get student's cart
        public static DataTable GetStudentCart(int studentId)
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
                FROM Cart ct
                JOIN CourseSection cs ON ct.section_id = cs.section_id
                JOIN Course c ON cs.course_id = c.course_id
                JOIN Instructor i ON cs.instructor_id = i.instructor_id
                WHERE ct.student_id = @studentId";

            SqlParameter[] parameters = {
                new SqlParameter("@studentId", studentId)
            };

            return Database.ExecuteQuery(query, parameters);
        }

        // Remove from cart
        public static bool RemoveFromCart(int studentId, int sectionId)
        {
            string query = "DELETE FROM Cart WHERE student_id=@s AND section_id=@sec";
            SqlParameter[] parameters = {
                new SqlParameter("@s", studentId),
                new SqlParameter("@sec", sectionId)
            };

            try
            {
                Database.ExecuteNonQuery(query, parameters);
                return true;
            }
            catch
            {
                return false;
            }
        }

        // Register cart item (move from cart to enrollment)
        public static bool RegisterCartItem(int studentId, int sectionId, out string message)
        {
            message = string.Empty;

            try
            {
                // Check if section is full
                if (EnrollmentData.IsSectionFull(sectionId))
                {
                    message = "No space available.";
                    return false;
                }

                // Insert into enrollment
                string insertEnroll = @"
                    INSERT INTO Enrollment(enrollment_id, student_id, section_id)
                    VALUES((SELECT ISNULL(MAX(enrollment_id),0)+1 FROM Enrollment),@s,@sec)";

                SqlParameter[] enrollParams = {
                    new SqlParameter("@s", studentId),
                    new SqlParameter("@sec", sectionId)
                };

                Database.ExecuteNonQuery(insertEnroll, enrollParams);

                // Delete from cart
                string deleteCart = "DELETE FROM Cart WHERE student_id=@s AND section_id=@sec";
                SqlParameter[] deleteParams = {
                    new SqlParameter("@s", studentId),
                    new SqlParameter("@sec", sectionId)
                };

                Database.ExecuteNonQuery(deleteCart, deleteParams);

                message = "Registered.";
                return true;
            }
            catch (Exception ex)
            {
                message = $"Error: {ex.Message}";
                return false;
            }
        }
    }
}