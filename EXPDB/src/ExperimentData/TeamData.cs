using System;
using sql = ExperimentData.Sql;

namespace ExperimentData
{
    /// <summary>
    /// ExperimentTeams class to hold the data between reading and writing
    /// </summary>
    public class experimentTeams
    {
        // Fields to match the columns in the table
        public string ExperimentId { get; set; }
        public int UserId { get; set; }
        public int RoleId { get; set; }

        // Constructors
        public experimentTeams()
        {
            this.ExperimentId = "UNKNOWN";
            this.UserId = 0;
            this.RoleId = 0;
        }
        public experimentTeams(int userID, int roleID)
        {
            this.ExperimentId = "UNASSIGNED";
            this.UserId = userID;
            this.RoleId = roleID;
        }
        public experimentTeams(string experimentID, int userID, int roleID)
        {
            this.ExperimentId = experimentID;
            this.UserId = userID;
            this.RoleId = roleID;
        }

        // Display code for use in development and testing
        public string displayExperimentTeams()
        {
            return "User ID " + this.UserId + " has role ID of " + this.RoleId + " in experiment " + this.ExperimentId;
        }

        // Add a team entry to the database
        public void addExperimentTeam(sql.MySqlWrapper connection)
        {
            // Check if team entry already exists
            bool teamExists = CheckExperimentTeam(connection);
            if (teamExists == false)
            {
                // Team entry doesn't exist, so add to the database
                connection.ClearParameters();
                connection.command.CommandText = "INSERT INTO experimentteams (experimentID, userID, roleID) VALUES (?experiment, ?user, ?role)";
                connection.command.Parameters.AddWithValue("?experiment", this.ExperimentId);
                connection.command.Parameters.AddWithValue("?user", this.UserId);
                connection.command.Parameters.AddWithValue("?role", this.RoleId);
                connection.NonQuery();
            }
        }

        // Check that an entry exists for that team member and return whether or not that entry exists
        private bool CheckExperimentTeam(sql.MySqlWrapper connection)
        {
            bool teamExists = false;
            connection.ClearParameters();
            connection.command.CommandText = "SELECT experimentID FROM experimentteams WHERE experimentID = ?experimentID AND userID = ?userID AND roleID = ?roleID";
            connection.command.Parameters.AddWithValue("?experimentID", this.ExperimentId);
            connection.command.Parameters.AddWithValue("?userID", this.UserId);
            connection.command.Parameters.AddWithValue("?roleID", this.RoleId);
            teamExists = connection.RecordExists();
            return teamExists;
        }
    }
}
