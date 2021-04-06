#!../../bin/windows-x64-debug/TEKMSO4104B-IOC-01

## You may have to change TEKMSO4104B-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TEKMSO4104B)/Tektronix_MSO_4104BSup"
epicsEnvSet "EPICS_CA_MAX_ARRAY_BYTES" "100000"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TEKMSO4104B-IOC-01.dbd"
TEKMSO4104B_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

vxi11Configure("IP", "130.246.49.179", 0, 0.0,"inst0", 0, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/devTektronix_MSO_4104B.db","P=$(MYPVPREFIX)$(IOCNAME),PORT=IP,NELM=10000,RECSIM=$(RECSIM)")
dbLoadRecords("db/devTektronix_MSO_4104B_ch.db","P=$(MYPVPREFIX)$(IOCNAME),PORT=IP,NELM=10000")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
