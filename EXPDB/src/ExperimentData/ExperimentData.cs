using System;
using sql = ExperimentData.Sql;

namespace ExperimentData
{
    /// <summary>
    /// Experiment class to hold the data between reading and writing 
    /// </summary>
    public class ExperimentData
    {
        // Fields to match the columns in the table
        public string ExperimentId { get; set; }
        public DateTime StartDate { get; set; }
        public int Duration { get; set; }

        // Constructors
        public ExperimentData()
        {
            this.ExperimentId = "UNKNOWN";
            this.StartDate = new DateTime();
            this.Duration = 0;
        }

        // Display code for use in development and testing
        public string returnExperimentDetails()
        {
            return "Experiment " + this.ExperimentId + " will start on " + this.StartDate + " and run for " + this.Duration + " days";
        }

        // Add an experiment to the database
        public void addExperiment(sql.MySqlWrapper connection)
        {
            // Check to see if the ezperiment already exists
            bool experimentExists = CheckExperiment(connection);
            if (experimentExists == false)
            {
                // Experiment does not exist so add it
                connection.ClearParameters();
                connection.command.CommandText = "INSERT INTO experiment (experimentID, startDate, duration) VALUES (?ID, ?start, ?duration)";
                connection.command.Parameters.AddWithValue("?ID", this.ExperimentId);
                connection.command.Parameters.AddWithValue("?start", this.StartDate);
                connection.command.Parameters.AddWithValue("?duration", this.Duration);
                connection.NonQuery();
            }
        }

        // Check that a user exists, update the organisation if required and return the existing user Id
        private bool CheckExperiment(sql.MySqlWrapper connection)
        {
            bool experimentExists = false;
            connection.ClearParameters();
            connection.command.CommandText = "SELECT experimentID FROM experiment WHERE experimentID = ?experimentID AND startDate = ?start AND duration = ?duration";
            connection.command.Parameters.AddWithValue("?experimentID", ExperimentId);
            connection.command.Parameters.AddWithValue("?start", StartDate);
            connection.command.Parameters.AddWithValue("?duration", Duration);
            experimentExists = connection.RecordExists();
            return experimentExists;
        }
    }
}
