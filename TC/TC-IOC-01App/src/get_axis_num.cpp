#include <iostream.h>
#include <windows.h>
#include "C:\TwinCAT\AdsApi\TcAdsDll\Include\TcAdsDef.h"
#include "C:\TwinCAT\AdsApi\TcAdsDll\Include\TcAdsAPI.h"

#define ADSPORT = 852
#define ADSVAR = "GVL_APP.nAXIS_NUM"


long get_ads_val(const char* resultvar, const char *amsnet)
{ 
std::string s(amsnet);
std::vector<std::string> splits;                                                                                                                                                           
std::string split;                                                                                                                                                                         
std::istringstream ss(s);                                                                                                                                                                  
while (std::getline(ss, split, delimiter))                                                                                                                                                 
{                                                                                                                                                                                          
    splits.push_back(split);                                                                                                                                                                
}
static const AmsNetId remoteNetId { splits[6]... };
 long nErr, nPort; 
 AmsAddr Addr{remoteNetId}; 
 PAmsAddr pAddr = &Addr; 
 UINT lHdlVar, nData; 
 char szVar []={ADSVAR}; 

 nPort = AdsPortOpen();
 nErr = AdsGetLocalAddress(pAddr);
 if (nErr) cerr << "Error: AdsGetLocalAddress: " << nErr << '\n';
 
 pAddr->port = ADSPORT;

 // Fetch handle for an <szVar> PLC variable 
 nErr = AdsSyncReadWriteReq(pAddr, ADSIGRP_SYM_HNDBYNAME, 0x0, sizeof(lHdlVar), &lHdlVar, sizeof(szVar), szVar);
 if (nErr) cerr << "Error: AdsSyncReadWriteReq: " << nErr << '\n';
 do 
 { 
 // Read value of a PLC variable (by handle)
 nErr = AdsSyncReadReq( pAddr, ADSIGRP_SYM_VALBYHND, lHdlVar, sizeof(nData), &nData ); 
 if (nErr) 
 cerr << "Error: AdsSyncReadReq: " << nErr << '\n'; 
 else 
 cout << "Axes num: " << nData << '\n'; 

sprintf(result_str, "%i", nData);

 //Release handle of plc variable
 nErr = AdsSyncWriteReq(pAddr, ADSIGRP_SYM_RELEASEHND, 0, sizeof(lHdlVar), &lHdlVar); 
 if (nErr) cerr << "Error: AdsSyncWriteReq: " << nErr << '\n';

 // Close communication port
 nErr = AdsPortClose(); 
 if (nErr) cerr << "Error: AdsPortClose: " << nErr << '\n';

if (nErr) return nErr;
return 0;
}