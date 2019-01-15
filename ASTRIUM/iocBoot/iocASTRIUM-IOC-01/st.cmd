#!../../bin/windows-x64-debug/ASTRIUM-IOC-01

## You may have to change ASTRIUM-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/ASTRIUM-IOC-01.dbd"
ASTRIUM_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data")

# Portname, port address
astriumDriverConfigure("ASTRIUM", "$(IP_ADDR):$(IP_PORT)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances (conditionally!) 
dbLoadRecordsLoop("db/astrium.db","P=$(MYPVPREFIX)$(IOCNAME):, Q=CH\$(I):, I=\$(I), PORT=ASTRIUM, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)", "I", 1, 2, 1)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
