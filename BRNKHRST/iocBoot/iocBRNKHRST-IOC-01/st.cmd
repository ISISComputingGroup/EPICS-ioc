#!../../bin/windows-x64/BRNKHRST-IOC-01

## You may have to change BRNKHRST-IOC-01 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/BRNKHRST-IOC-01.dbd",0,0)
BRNKHRST_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/BRNKHRST-IOC-01.db","user=ynq66733")

iocInit()

## Start any sequence programs
#seq sncBRNKHRST-IOC-01,"user=ynq66733"
