using System;
using System.Collections.Generic;
using ExperimentData.Sql;

namespace ExperimentData
{
    /// <summary>
    /// Get the information for the Role IDs in the Database
    /// </summary>
    public class RoleIdsFetcher
    {
        public static Dictionary<string, int> Fetch(MySqlWrapper connection)
        {
            Dictionary<string, int> roleIds = new Dictionary<string, int>();
            connection.command.CommandText = "SELECT name, roleID FROM role";
            connection.reader = connection.command.ExecuteReader();
            while (connection.reader.Read())
            {
                string name = "";
                int id = 0;
                if (!connection.reader.IsDBNull(0))
                {
                    name = (string)connection.reader["name"];
                    id = (int)connection.reader["roleID"];
                    roleIds.Add(name, id);
                }
            }
            connection.reader.Close();
            return roleIds;
        }
    }
}