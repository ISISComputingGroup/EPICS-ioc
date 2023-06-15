#!../../bin/windows-x64/COLDVLV-IOC-01

#- You may have to change COLDVLV-IOC-01 to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/COLDVLV-IOC-01.dbd",0,0)
COLDVLV_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/COLDVLV-IOC-01.db","user=yyf77781")

iocInit()

## Start any sequence programs
#seq sncCOLDVLV-IOC-01,"user=yyf77781"
