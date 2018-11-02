#!../../bin/win32-x86/QEPRO-IOC-02

## You may have to change QEPRO-IOC-02 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/QEPRO-IOC-02.dbd",0,0)
QEPRO_IOC_02_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/QEPRO-IOC-02.db","user=faa59")

iocInit()

## Start any sequence programs
#seq sncQEPRO-IOC-02,"user=faa59"
