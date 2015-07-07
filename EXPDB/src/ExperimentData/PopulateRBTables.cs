using System;
using System.IO;
using ExperimentData.Sql;
using System.Security.Cryptography;
using System.Linq;

namespace ExperimentData
{   
    /// <summary>
    /// Connects to the database and populates the information from the experiments detail file.
    /// </summary>
    public class PopulateRBTables
    {
        private MySqlWrapper connection = new MySqlWrapper("SERVER=localhost;DATABASE=exp_data;UID=exp_data;PASSWORD=$exp_data;");
        private string rootPath = "C:/Data/RBNUM";
        private byte[] prevResult;
        public string filePath { get; set; }

        public string Populate()
        {
            // If no file path has been set, make a guess
            if (filePath == null)
            {
                filePath = GuessFileName();
            }

            // Check that the file exists
            if (!File.Exists(filePath))
            {
                filePath = null;
            }

            if (!String.IsNullOrWhiteSpace(filePath))
            {
                if (!FileChanged())
                {
                    return "The file has not changed";
                }

                // Try to open the database connection
                try
                {
                    this.connection.OpenConnection();
                }
                catch
                {
                    return "Database connection not possible";
                }

                // Process the XML
                ExperimentXmlReader.Read(filePath, connection, RoleIdsFetcher.Fetch(this.connection));

                // Close the database connection
                connection.CloseConnection();
            }
            else
            {
                filePath = null;
                return "Invlid path to xml file";
            }

            return "Experiment data updated";
        }

        

        private string GuessFileName()
        {
            // Get a best guess file name from the root
            string path = null;
            string[] files = Directory.GetFiles(rootPath);
            foreach (string file in files)
            {
                // This is a hazard, but should allow a file to be found
                if (file.Contains("periments"))
                {
                    path = file;
                }
            }
            return path;
        }

        public Boolean FileChanged()
        {
            // If no file path has been set, make a guess
            if (filePath == null)
            {
                filePath = GuessFileName();
            }

            if (!String.IsNullOrWhiteSpace(filePath))
            {
                return !CheckFileUnchanged();
            }
            else
            {
                filePath = null;
                throw new FileNotFoundException("Invlid path to xml file");
            }
        }

        private Boolean CheckFileUnchanged()
        {
            // Compare previous and current hash codes for the file
            byte[] data = File.ReadAllBytes(filePath);
            SHA1 sha = new SHA1CryptoServiceProvider();
            byte[] localResult = sha.ComputeHash(data);
            if (prevResult == null)
            {
                prevResult = localResult;
                return false;
            }
            if (localResult.SequenceEqual(prevResult))
            {
                return true;
            }
            else
            {
                prevResult = localResult;
                return false;
            }
        }
    }
}