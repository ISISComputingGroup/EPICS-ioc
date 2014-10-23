using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net;

namespace Server
{
    class Configuration
    {
        public string Prefix { get; set; }
        public bool Simulation { get; set; }
        public int NumSimulated { get; set; }
        public int ConfiguredPort { get; set; }
        public string ConfigFilePath { get; set; }
        public IPAddress ServerAddress { get; set; }
        public string DatabaseFile { get; set; }

        public Configuration()
        {
            Prefix = "";
            Simulation = false;
            NumSimulated = 0;
            ConfiguredPort = 5064;
            ServerAddress = null;
            DatabaseFile = "C:\\Instrument\\Apps\\EPICS\\iocs.sq3";
        }

        public void ParseStartup(string filepath)
        {
            FileInfo fi = new FileInfo(filepath);

            if (fi.Exists)
            {
                Dictionary<string, string> values = new Dictionary<string, string>();

                using (StreamReader sr = new StreamReader(fi.FullName))
                {
                    string line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        line = line.Trim();

                        if (!String.IsNullOrEmpty(line) && !line.StartsWith("#"))
                        {
                            if (line.Contains('='))
                            {
                                string[] split = line.Split('=');
                                if (!String.IsNullOrEmpty(split[0].Trim()))
                                {
                                    values[split[0].Trim()] = split[1].Trim();
                                }
                            }
                        }

                    }
                }

                //Process the values
                foreach (string key in values.Keys)
                {
                    if (key.ToUpper() == "PREFIX")
                    {
                        Prefix = expandMacros(values[key]);
                    }
                    else if (key.ToUpper() == "SIMULATION")
                    {
                        string ans = expandMacros(values[key]);

                        if (ans.ToLower().StartsWith("t") || ans.StartsWith("1"))
                        {
                            Simulation = true;
                        }
                        else
                        {
                            Simulation = false;
                        }
                    }
                    else if (key.ToUpper() == "NUM_SIMULATED_CHOPPERS")
                    {
                        NumSimulated = Int32.Parse(expandMacros(values[key]));
                    }
                    else if (key.ToUpper() == "CONFIGURED_PORT")
                    {
                        ConfiguredPort = Int32.Parse(expandMacros(values[key]));
                    }
                    else if (key.ToUpper() == "CHOPPER_CONFIG")
                    {
                        ConfigFilePath = expandMacros(values[key]);
                    }
                    else if (key.ToUpper() == "SERVER_ADDRESS")
                    {
                        string address = expandMacros(values[key]);
                        if (!String.IsNullOrEmpty(address))
                        {
                            ServerAddress = IPAddress.Parse(expandMacros(values[key]));
                        }
                    }
                    else if (key.ToUpper() == "DATABASE_FILE")
                    {
                        DatabaseFile = expandMacros(values[key]);
                    }
                }
            }
            else
            {
                throw new FileNotFoundException("Could not find the startup file");
            }
        }

        private string expandMacros(string input)
        {
            //Does not work for nested env vars
            string temp = input;

            while (temp.Contains("$("))
            {
                int start = input.IndexOf("$(");
                int end = input.LastIndexOf(')') + 1;

                string macro = temp.Substring(start, end);
                macro = macro.Substring(2);
                macro = macro.Substring(0, macro.Length - 1);
                string ans = Environment.GetEnvironmentVariable(macro);
                if (ans == null) ans = "";

                temp = temp.Replace(temp.Substring(start, end), ans);                
            }

            return temp;
        }

    }
}
