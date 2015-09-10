#!../../bin/windows-x64-debug/AG33220A-IOC-01

## You may have to change AG33220A-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(AGILENT33220A)/agilent33220AApp/protocol"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/AG33220A-IOC-01.dbd"
AG33220A_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynIPPortConfigure ("IP", "130.246.49.196:5025")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/agilent33220A.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=IP")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
