using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ExperimentData;
using System.Timers;
using System.IO;


namespace ExperimentDataTestHarness
{
    /// <summary>
    /// An executable to update the experiment data
    /// </summary>
    class Program
    {
        private static Timer testTimer;
        private static PopulateRBTables expData = new PopulateRBTables();
        private static string menu = "Enter: M to display menu, U to update the Experiment Database, F to set the file or Q to Quit";

        static void Main(string[] args)
        {
            // Check for a path in the first argument
            if (args.Length > 0)
            {
                Console.WriteLine(args[0]);
                if (File.Exists(args[0]))
                {
                    expData.filePath = args[0];
                }
            }

            // Populate the tables on first running, and display result
            Console.WriteLine(expData.Populate());

            // Generate a timer that runs every hour
            testTimer = new Timer(3600000);
            testTimer.Elapsed += OnTimedEvent;
            testTimer.Enabled = true;

            // Display a menu that allows interaction
            Console.WriteLine(menu);

            Boolean running = true;
            string enteredOnConsole = "";
            while (running)
            {
                // Wait for an entry from the console
                enteredOnConsole = Console.ReadLine();
                enteredOnConsole = enteredOnConsole.ToUpper();
                switch (enteredOnConsole)
                {
                    case "F":
                        Console.WriteLine("Enter full path to file to use:");
                        enteredOnConsole = Console.ReadLine();
                        expData.filePath = enteredOnConsole;
                        break;
                    case "M":
                        Console.WriteLine(menu);
                        break;
                    case "Q":
                        running = false;
                        break;
                    case "U":
                        Console.WriteLine(expData.Populate());
                        break;
                    default:
                        Console.WriteLine("Command not recognised. Enter M to view menu.");
                        break;
                }
            }
        }


        private static void OnTimedEvent(Object source, ElapsedEventArgs e)
        {
            Console.WriteLine("Periodic check on Experiment Data file at {0}", e.SignalTime);
            Console.WriteLine(expData.Populate());
        }
    }
}