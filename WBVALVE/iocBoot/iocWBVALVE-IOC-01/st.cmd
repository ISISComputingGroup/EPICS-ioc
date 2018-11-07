#!../../bin/windows-x64/WBVALVE-IOC-01

## You may have to change WBVALVE-IOC-01 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/WBVALVE-IOC-01.dbd",0,0)
WBVALVE_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/WBVALVE-IOC-01.db","user=znx23966")

iocInit()

## Start any sequence programs
#seq sncWBVALVE-IOC-01,"user=znx23966"
