epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SMARTMON)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IP_ADDRESS):502")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(SMARTMON)/db/smrtmon.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(SMARTMON)/db/channels.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
