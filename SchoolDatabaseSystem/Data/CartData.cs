using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
    public class CartData
    {
        // Add course to cart
        public static bool AddToCart(int studentId, int sectionId, out string message)
        {
            /*
            ====================================
            SCHEDULE CONFLICT CHECK GOES HERE
            PREREQUISITE CHECK GOES HERE
            ====================================
            */
            message = string.Empty;
            bool isSuccess = false;

            try
            {
                // Create parameters for stored procedure
                SqlParameter[] parameters = {
                    new SqlParameter("@StudentId", studentId),
                    new SqlParameter("@SectionId", sectionId),
                    new SqlParameter("@ResultMessage", SqlDbType.VarChar, 500)
                    {
                        Direction = ParameterDirection.Output
                    },
                    new SqlParameter("@IsSuccess", SqlDbType.Bit)
                    {
                        Direction = ParameterDirection.Output
                    }
                };

                // Execute stored procedure
                Database.ExecuteStoredProcedure("sp_AddToCart", parameters, out message, out isSuccess);

                return isSuccess;
            }
            catch (Exception ex)
            {
                message = $"Application error: {ex.Message}";
                return false;
            }
        }



        // Get student's cart
        public static DataTable GetStudentCart(int studentId)
        {
            string query = @"
        SELECT
            v.section_id,
            c.course_code,
            c.title,
            v.section_number,
            i.name AS instructor,
            v.term,
            v.year
        FROM vw_StudentCartDetails v
        JOIN Course c ON v.course_id = c.course_id
        JOIN Instructor i ON v.instructor_id = i.instructor_id
        WHERE v.student_id = @studentId";

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