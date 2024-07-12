#!../../bin/windows-x64/ENVMON-IOC-02

#- You may have to change ENVMON-IOC-02 to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase "../../dbd/ENVMON-IOC-02.dbd"
ENVMON_IOC_02_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/ENVMON-IOC-02.db","user=nxq64494")

iocInit()

## Start any sequence programs
#seq sncENVMON-IOC-02,"user=nxq64494"
