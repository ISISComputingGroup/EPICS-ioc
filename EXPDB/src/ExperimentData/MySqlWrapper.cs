using System;
using MySql.Data.MySqlClient;

namespace ExperimentData.Sql
{
    /// <summary>
    /// A wrapper class for MySQL database interaction
    /// </summary>
    public class MySqlWrapper
    {
        private MySqlConnection connection;
        public MySqlCommand command;
        public MySqlDataReader reader;

        public MySqlWrapper(string connectionString)
        {
            this.connection = new MySqlConnection(connectionString);
            this.command = connection.CreateCommand();
        }

        public void SendData()
        {
            OpenConnection();
            NonQuery();
            CloseConnection();
        }

        public void OpenConnection()
        {
            this.connection.Open();
        }

        public void CloseConnection()
        {
            this.connection.Close();
        }

        public void NonQuery()
        {
            this.command.ExecuteNonQuery();
        }

        public void ClearParameters()
        {
            this.command.Parameters.Clear();
        }

        public bool RecordExists()
        {
            bool exists = false;
            MySqlDataReader Reader = this.command.ExecuteReader();
            while (Reader.Read())
            {
                if (!Reader.IsDBNull(0))
                {
                    exists = true;
                }
            }
            Reader.Close();
            return exists;
        }
    }
}
