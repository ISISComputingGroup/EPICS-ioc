#!../../bin/IBEX/SAMSM300-IOC-01

## You may have to change SAMSM300-IOC-01 to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/SAMSM300-IOC-01.dbd",0,0)
SAMSM300_IOC_01_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/SAMSM300-IOC-01.db","user=hgv27692")

iocInit()

## Start any sequence programs
#seq sncSAMSM300-IOC-01,"user=hgv27692"
