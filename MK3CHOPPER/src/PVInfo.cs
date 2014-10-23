using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Server
{
    public class PVInfo
    {
        public String Name { get; private set; }
        public String Type { get; private set; }
        public String Interest { get; private set; }

        public PVInfo(string name, string type, string interest)
        {
            Name = name;
            Type = type;
            Interest = interest;
        }
    }
}
