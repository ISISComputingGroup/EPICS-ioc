#!../../bin/windows-x64/LKSH336-IOC-01

## You may have to change LKSH336-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH336)/protocol"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LKSH336-IOC-01.dbd"
LKSH336_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
##]##< $(IOCSTARTUP)/init.cmd

drvAsynIPPortConfigure ("IP", "ls336-1:7777")

## Load record instances

##ISIS## Load common DB records 
##]##< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=iew83206Host")
dbLoadRecords("db/lakeshore336.db", "P=$(MYPVPREFIX)LKSH336, PORT=IP")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
##]##< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
##]##< $(IOCSTARTUP)/postiocinit.cmd
