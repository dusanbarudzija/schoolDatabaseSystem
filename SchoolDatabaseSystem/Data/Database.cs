using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolDatabaseSystem.Data
{
	public class Database
	{
        private static string connectionString = "Server=localhost;Database=UniRegistration;Trusted_Connection=True;TrustServerCertificate=True;";

        public static bool DatabaseConnection(out string errorMessage)
        {
            errorMessage = string.Empty;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    return true;
                }
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                return false;
            }
        }

        // Execute SELECT queries that return data
        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                        cmd.Parameters.AddRange(parameters);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }
                }
            }
            return dt;
        }

        // Execute INSERT, UPDATE, DELETE
        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                        cmd.Parameters.AddRange(parameters);

                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }


        // Execute queries that return single value (COUNT, MAX, etc.)
        public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                        cmd.Parameters.AddRange(parameters);

                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }


    public static bool ExecuteStoredProcedure(
        string procedureName,
        SqlParameter[] parameters,
        out string resultMessage,
        out bool isSuccess)
    {
            resultMessage = string.Empty;
            isSuccess = false;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(procedureName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        if (parameters != null)
                            cmd.Parameters.AddRange(parameters);

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // Extract output parameters
                        foreach (SqlParameter param in cmd.Parameters)
                        {
                            if (param.Direction == ParameterDirection.Output ||
                                param.Direction == ParameterDirection.InputOutput)
                            {
                                if (param.ParameterName == "@ResultMessage" ||
                                    param.ParameterName == "@resultMessage" ||
                                    param.ParameterName.Contains("Message"))
                                {
                                    resultMessage = param.Value?.ToString() ?? string.Empty;
                                }
                                else if (param.ParameterName == "@IsSuccess" ||
                                         param.ParameterName == "@isSuccess" ||
                                         param.ParameterName.Contains("Success"))
                                {
                                    isSuccess = param.Value != DBNull.Value && Convert.ToBoolean(param.Value);
                                }
                            }
                        }

                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                resultMessage = $"Database error: {ex.Message}";
                isSuccess = false;
                return false; 
            }
        }

    }

}