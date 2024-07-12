#!../../bin/windows-x64/ENVMON-IOC-01

#- You may have to change ENVMON-IOC-01 to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase "../../dbd/ENVMON-IOC-01.dbd"
ENVMON_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/ENVMON-IOC-01.db","user=nxq64494")

iocInit()

## Start any sequence programs
#seq sncENVMON-IOC-01,"user=nxq64494"
