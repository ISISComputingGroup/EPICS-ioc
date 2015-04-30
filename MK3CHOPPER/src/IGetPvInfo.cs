using System.Collections.Generic;
using System.Collections;

namespace Server
{
    public interface IGetPvInfo
    {
        List<PVInfo> GetPvInfo();
    }
}
