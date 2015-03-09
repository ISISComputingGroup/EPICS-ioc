#!../../bin/windows-x64/GALIL-IOC-01

## You may have to change GALIL-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-01.dbd"
GALIL_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

dbLoadRecords("$(ISISSUPPORT)/Common/db/bump_stop.db", "P=$(MYPVPREFIX)MOT:,BMPSTP=DMC01:Galil0Bi3_STATUS")

< st-common.cmd
