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
            SqlParameter[] parameters = {
                new SqlParameter("@StudentId", studentId)
            };

            return Database.ExecuteSelectProcedure("sp_GetStudentCart", parameters);
        }


        // Remove from cart
        public static bool RemoveFromCart(int studentId, int sectionId, out string message)
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

                Database.ExecuteStoredProcedure("sp_RemoveFromCart", parameters, out message, out isSuccess);

                return isSuccess;
            }
            catch (Exception ex)
            {
                message = $"Application error: {ex.Message}";
                return false;
            }
        }

        // Register cart item (move from cart to enrollment)
        public static bool RegisterCartItem(int studentId, int sectionId, out string message)
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

                Database.ExecuteStoredProcedure("sp_RegisterStudent", parameters, out message, out isSuccess);

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