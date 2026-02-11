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

        // Remove enrolled course
        public static bool RemoveEnrolledCourse(int studentId, int sectionId, out string message)
        {
            message = string.Empty;
            bool isSuccess = false;

            try
            {
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

                Database.ExecuteStoredProcedure("sp_RemoveEnrolledCourse", parameters, out message, out isSuccess);

                return isSuccess;
            }
            catch (Exception ex)
            {
                message = $"Application error: {ex.Message}";
                return false;
            }
        }

    }
}