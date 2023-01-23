#!../../bin/windows-x64/INSTRONA-IOC-01

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(INSTRONARBY)/data"
epicsEnvSet "DEVICE" "L0"

## You may have to change INSTRONA-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/INSTRONA-IOC-01.dbd"
INSTRONA_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For unit testing:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=)")

## For normal devsim:
# $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:57677")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
drvAsynInstronArbyConfigure("$(DEVICE)", 0, "\r\n")

# Uncomment the following lines to get some debug output
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

# Need to set these for DEVSIM mode as lewis can't handle not having termination characters.
$(IFDEVSIM) asynOctetSetOutputEos("$(DEVICE)",0,"\r\n")
$(IFDEVSIM) asynOctetSetInputEos("$(DEVICE)",0,"\r\n")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(INSTRONARBY)/db/controls.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(INSTRONARBY)/db/controls_channel.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(INSTRONARBY)/db/controls_channel_specific.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(INSTRONARBY)/db/controls_waveform.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

dbLoadRecords("$(INSTRONARBY)/db/logging.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MYPVPREFIX=$(MYPVPREFIX)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

# Uncomment the following line to get an excesive amount of debug information
# var streamDebug 1

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
