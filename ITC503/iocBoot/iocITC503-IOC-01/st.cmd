#!../../bin/windows-x64/ITC503-IOC-01

## You may have to change ITC503-IOC-01 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/ITC503-IOC-01.dbd",0,0)
ITC503_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/ITC503-IOC-01.db","user=ynq66733")

iocInit()

## Start any sequence programs
#seq sncITC503-IOC-01,"user=ynq66733"
