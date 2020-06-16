#!../../bin/Windows-x64/AG33220A-IOC-02

#- You may have to change AG33220A-IOC-02 to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/AG33220A-IOC-02.dbd",0,0)
AG33220A_IOC_02_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/AG33220A-IOC-02.db","user=xup33938")

iocInit()

## Start any sequence programs
#seq sncAG33220A-IOC-02,"user=xup33938"
