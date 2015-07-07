using System;
using System.Xml;
using sql = ExperimentData.Sql;
using System.Collections.Generic;

namespace ExperimentData
{
    /// <summary>
    /// Reads the XML file and populates the database with experiment data
    /// </summary>
    public class ExperimentXmlReader
    {
        public static void Read(string path, sql.MySqlWrapper connection, Dictionary<string, int> roleIDs)
        {
            // List of experiments for reduction of data
            List<String> xml_experiments = new List<String>();

            // Process the XML File
            using (XmlReader reader = XmlReader.Create(path))
            {
                ExperimentData expData = new ExperimentData();
                List<experimentTeams> teamMembers = new List<experimentTeams>();
                UserData PI = new UserData();
                UserData local = new UserData();
                List<UserData> users = new List<UserData>();      

                while (reader.Read())
                {
                    if (reader.IsStartElement())
                    {
                        switch (reader.Name)
                        {
                            case "Experiment":
                                expData = new ExperimentData();
                                teamMembers = new List<experimentTeams>();
                                PI = new UserData();
                                local = new UserData();
                                users = new List<UserData>();
                                break;
                            case "PI":
                                while (reader.Read())
                                {
                                    if (reader.IsStartElement())
                                    {
                                        switch (reader.Name)
                                        {
                                            case "Name":
                                                if (reader.Read())
                                                {
                                                    PI.Name = reader.Value;
                                                }
                                                break;
                                            case "Organisation":
                                                if (reader.Read())
                                                {
                                                    PI.Organisation = reader.Value;
                                                }
                                                break;
                                        }
                                    }
                                    if (reader.NodeType == XmlNodeType.EndElement)
                                    {
                                        if (reader.Name == "PI")
                                        {
                                            int role = roleIDs["PI"];
                                            int user = PI.GetUserId(connection);
                                            experimentTeams newTeamMember = new experimentTeams(user, role);
                                            teamMembers.Add(newTeamMember);
                                            break;
                                        }
                                    }
                                }
                                break;
                            case "Local":
                                while (reader.Read())
                                {
                                    if (reader.IsStartElement())
                                    {
                                        switch (reader.Name)
                                        {
                                            case "Name":
                                                if (reader.Read())
                                                {
                                                    local.Name = reader.Value;
                                                }
                                                break;
                                            case "Organisation":
                                                if (reader.Read())
                                                {
                                                    local.Organisation = reader.Value;
                                                }
                                                break;
                                        }
                                    }
                                    if (reader.NodeType == XmlNodeType.EndElement)
                                    {
                                        if (reader.Name == "Local")
                                        {
                                            int role = roleIDs["Contact"];
                                            int user = local.GetUserId(connection);
                                            experimentTeams newTeamMember = new experimentTeams(user, role);
                                            teamMembers.Add(newTeamMember);
                                            break;
                                        }
                                    }
                                }
                                break;
                            case "User":
                                UserData newUser = new UserData();
                                while (reader.Read())
                                {
                                    if (reader.IsStartElement())
                                    {
                                        switch (reader.Name)
                                        {
                                            case "Name":
                                                if (reader.Read())
                                                {
                                                    newUser.Name = reader.Value;
                                                }
                                                break;
                                            case "Organisation":
                                                if (reader.Read())
                                                {
                                                    newUser.Organisation = reader.Value;
                                                }
                                                break;
                                        }
                                    }
                                    if (reader.NodeType == XmlNodeType.EndElement)
                                    {
                                        if (reader.Name == "User")
                                        {
                                            int role = roleIDs["User"];
                                            int user = newUser.GetUserId(connection);
                                            experimentTeams newTeamMember = new experimentTeams(user, role);
                                            teamMembers.Add(newTeamMember);
                                            break;
                                        }
                                    }
                                }
                                break;
                            case "RB":
                                if (reader.Read())
                                {
                                    expData.ExperimentId = reader.Value;
                                }
                                break;
                            case "Duration":
                                if (reader.Read())
                                {
                                    try
                                    {
                                        expData.Duration = Convert.ToInt32(reader.Value);
                                    }
                                    catch
                                    {
                                        //If duration not convertable, then will default to 0
                                    }
                                }
                                break;
                            case "StartDate":
                                if (reader.Read())
                                {
                                    try
                                    {
                                        expData.StartDate = DateTime.Parse(reader.Value);
                                    }
                                    catch
                                    {
                                        //If the date time is not convertable, the the default is acceptable
                                    }
                                }
                                break;
                        }
                    }
                    if (reader.NodeType == XmlNodeType.EndElement)
                    {
                        switch (reader.Name)
                        {
                            case "Experiment":
                                expData.addExperiment(connection);
                                teamMembers.ForEach(i => i.ExperimentId = expData.ExperimentId);
                                teamMembers.ForEach(i => i.addExperimentTeam(connection));
                                xml_experiments.Add(expData.ExperimentId);
                                break;
                        }
                    }
                }
            }

            // Delete out of date information
            // Get All Experiment IDs from database
            List<String> db_experiments = new List<String>();
            connection.ClearParameters();
            connection.command.CommandText = "SELECT experimentID FROM experiment";
            connection.reader = connection.command.ExecuteReader();
            while (connection.reader.Read())
            {
                string experimentID = "";
                if (!connection.reader.IsDBNull(0))
                {
                    experimentID = (string)connection.reader["experimentID"];
                    db_experiments.Add(experimentID);
                }
            }
            connection.reader.Close();

            // Remove all experiments not in current XML
            foreach (String ex in db_experiments)
            {
                if (!xml_experiments.Contains(ex)){
                    connection.ClearParameters();
                    connection.command.CommandText = "DELETE FROM experiment WHERE experimentID = ?ID";
                    connection.command.Parameters.AddWithValue("?ID", ex);
                    connection.NonQuery();

                    connection.ClearParameters();
                    connection.command.CommandText = "DELETE FROM experimentteams WHERE experimentID = ?ID";
                    connection.command.Parameters.AddWithValue("?ID", ex);
                    connection.NonQuery();
                }
            }

            // Remove all users no longer referenced
            List<int> usersToRemove = new List<int>();
            connection.ClearParameters();
            connection.command.CommandText = "SELECT userID FROM user WHERE userID NOT IN (SELECT userID FROM experimentteams)";
            connection.reader = connection.command.ExecuteReader();
            while (connection.reader.Read())
            {
                int userID = 0;
                if (!connection.reader.IsDBNull(0))
                {
                    userID = (int)connection.reader["userID"];
                    usersToRemove.Add(userID);
                }
            }
            connection.reader.Close();

            foreach (int userID in usersToRemove)
            {
                connection.ClearParameters();
                connection.command.CommandText = "DELETE FROM user WHERE userID = ?ID";
                connection.command.Parameters.AddWithValue("?ID", userID);
                connection.NonQuery();
            }
        }
    }
}
