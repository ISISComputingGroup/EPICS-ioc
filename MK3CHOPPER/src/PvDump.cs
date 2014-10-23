using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;

namespace Server
{
    public class PvDump
    {
        String _db = "";

        public PvDump(String db)
        {
            _db = db;
        }

        public void ClearPVs(String ioc)
        {
            try
            {
                SQLiteConnection conn = new SQLiteConnection("Data Source=" + _db + ";Version=3;");
                conn.Open();

                string sql = "DELETE FROM pvs WHERE iocname IS '" + ioc + "'";
                SQLiteCommand command = new SQLiteCommand(sql, conn);
                command.ExecuteNonQuery();

                conn.Close();
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }
        }

        public void DumpPVs(List<PVInfo> pvs, string ioc)
        {
            try
            {
                SQLiteConnection conn = new SQLiteConnection("Data Source=" + _db + ";Version=3;");
                conn.Open();

                foreach (PVInfo pv in pvs)
                {
                    try
                    {
                        string sql = "insert into pvs (pvname, record_type, record_desc, iocname) values ('" + pv.Name + "', '" + pv.Type + "', '', '" + ioc + "')";
                        SQLiteCommand command = new SQLiteCommand(sql, conn);
                        command.ExecuteNonQuery();
                    }
                    catch
                    {
                        //May already exist
                    }
                }
                conn.Close();
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }
        }

        public void DumpInterestingPVs(List<PVInfo> pvs)
        {
            try
            {
                SQLiteConnection conn = new SQLiteConnection("Data Source=" + _db + ";Version=3;");
                conn.Open();

                foreach (PVInfo pv in pvs)
                {
                    if (!String.IsNullOrEmpty(pv.Interest.Trim()))
                    {
                        try
                        {
                            string sql = "insert into pvinfo (pvname, infoname, value) values ('" + pv.Name + "', 'INTEREST', '" + pv.Interest.Trim() + "')";
                            SQLiteCommand command = new SQLiteCommand(sql, conn);
                            command.ExecuteNonQuery();
                        }
                        catch
                        {
                        }
                    }
                }
                conn.Close();
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }

        }
    }
}
