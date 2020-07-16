#!../../bin/windows-x64/GALILMUL-IOC-01

## You may have to change GALILMUL-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALILMUL-IOC-01.dbd"
GALILMUL_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

dbLoadRecords("$(COMMON)/db/bump_stop.db", "P=$(MYPVPREFIX)MOT:,BMPSTP=DMC01:Galil0Bi3_STATUS")

## uncomment to see every command sent to this galil, or define in st-common.cmd for every galil
#epicsEnvSet("GALIL_DEBUG_FILE", "galil1_debug.txt")

< st-common.cmd
