using System;
using ExperimentData.Sql;

namespace ExperimentData
{
    /// <summary>
    /// User class to hold the data between reading and writing 
    /// </summary>
    public class UserData
    {
        // Fields to match the columns in the table
        public string Name { get; set; }
        public string Organisation { get; set; }
        
        // Constructors
        public UserData()
        {
            this.Name = "UNKNOWN";
            this.Organisation = "UNKNOWN";
        }

        public UserData(string name, string organisation)
        {
            this.Name = name;
            this.Organisation = organisation;
        }

        // Display code for use in development and testing
        public string DisplayUserDetails()
        {
            return "User " + this.Name + " is affiliated with " + this.Organisation;
        }

        // Add a User to the database
        public int GetUserId(MySqlWrapper connection)
        {
            connection.ClearParameters();
            int userID = 0;
            // Check to see if the User exists, and get the ID
            userID = CheckUser(connection);
            if (userID == 0)
            {
                // The User does not exist, so add to the database and get the ID
                connection.ClearParameters();
                connection.command.CommandText = "INSERT INTO user (name, organisation) VALUES (?name, ?facility)";
                connection.command.Parameters.AddWithValue("?name", this.Name);
                connection.command.Parameters.AddWithValue("?facility", this.Organisation);
                connection.NonQuery();
                userID = CheckUser(connection);
            }
            // Return the UserID for use elsewhere
            return userID;
        }

        // Check that a user exists, update the organisation if required and return the existing user Id
        private int CheckUser(MySqlWrapper connection)
        {
            int userID = 0;
            string facility;
            bool updateOrganisation = false;

            // Check to see if the user exists by getting all users of the same name
            connection.ClearParameters();
            connection.command.CommandText = "SELECT userID, organisation FROM user WHERE name = ?name";
            connection.command.Parameters.AddWithValue("?name", this.Name);
            connection.reader = connection.command.ExecuteReader();
            while (connection.reader.Read())
            {
                if (!connection.reader.IsDBNull(0))
                {
                    // If a record is found, return that user ID
                    userID = (int)connection.reader["userID"];
                    facility = (string)connection.reader["organisation"];
                    if (!(facility == this.Organisation))
                    {
                        // If the user is not at that organisation, update the information held when finished with this query
                        if (String.IsNullOrWhiteSpace(facility))
                        {
                            updateOrganisation = true;
                        }
                    }
                }
            }
            connection.reader.Close();
            // Update the organisation if required
            if (updateOrganisation)
            {
                connection.ClearParameters();
                connection.command.CommandText = "UPDATE user SET organisation=?facility WHERE userID=?userID";
                connection.command.Parameters.AddWithValue("?facility", this.Organisation);
                connection.command.Parameters.AddWithValue("?userID", userID);
                connection.NonQuery();
            }
            return userID;
        }
    }
}