#!../../bin/windows-x64/TRITON-IOC-02

## You may have to change TRITON-IOC-02 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/TRITON-IOC-02.dbd",0,0)
TRITON_IOC_02_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/TRITON-IOC-02.db","user=ynq66733")

iocInit()

## Start any sequence programs
#seq sncTRITON-IOC-02,"user=ynq66733"
