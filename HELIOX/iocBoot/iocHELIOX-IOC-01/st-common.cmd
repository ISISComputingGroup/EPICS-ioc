##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(HELIOX)/data"

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=COM9)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=57600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=2)")

## Flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################

dbLoadRecords("$(HELIOX)/db/heliox.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto)")
dbLoadRecords("$(HELIOX)/db/heliox_regeneration.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto),HE3POT_COARSE_TEMP_DELTA=$(HE3POT_COARSE_TEMP_DELTA=0.05),HE3POT_COARSE_TIME=$(HE3POT_COARSE_TIME=600),DRIFT_BUFFER_SIZE=$(DRIFT_BUFFER_SIZE=200),DRIFT_THRESHOLD_KMIN=$(DRIFT_THRESHOLD_KMIN=0.0005),TIME=$(MYPVPREFIX)CS:IOC:$(IOCNAME):DEVIOS:GTIM_TIME")

# Individual channels.
dbLoadRecords("$(HELIOX)/db/heliox_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto),NAME=HE3SORB,PROTOCOL_NAME=$(HE3SORB_NAME=He3Sorb)")
dbLoadRecords("$(HELIOX)/db/heliox_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto),NAME=HE4POT,PROTOCOL_NAME=$(HE4POT_NAME=He4Pot)")
dbLoadRecords("$(HELIOX)/db/heliox_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto),NAME=HEHIGH,PROTOCOL_NAME=$(HEHIGH_NAME=HeHigh)")
dbLoadRecords("$(HELIOX)/db/heliox_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO=$(PROTO=heliox.proto),NAME=HELOW,PROTOCOL_NAME=$(HELOW_NAME=HeLow)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

asynSetTraceMask("L0", -1, 0x9)
asynSetTraceIOMask("L0", -1, 0x2)
asynSetTraceIOTruncateSize("L0", -1, 1024)
