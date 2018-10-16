#!../../bin/windows-x64/BRNKHRST-IOC-02

## You may have to change BRNKHRST-IOC-02 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/BRNKHRST-IOC-02.dbd",0,0)
BRNKHRST_IOC_02_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/BRNKHRST-IOC-02.db","user=ynq66733")

iocInit()

## Start any sequence programs
#seq sncBRNKHRST-IOC-02,"user=ynq66733"
