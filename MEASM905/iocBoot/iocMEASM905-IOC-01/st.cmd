#!../../bin/windows-x64/MEASM905-IOC-01

#- You may have to change MEASM905-IOC-01 to something else
#- everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/MEASM905-IOC-01.dbd",0,0)
MEASM905_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/MEASM905-IOC-01.db","user=yyf77781")

## calling common command file in ioc 01 boot dir
< st-common.cmd
## Start any sequence programs
#seq sncMEASM905-IOC-01,"user=yyf77781"
