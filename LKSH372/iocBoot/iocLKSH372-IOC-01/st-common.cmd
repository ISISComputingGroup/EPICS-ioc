epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH372)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "NUL", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IPADDR=NUL):$(IPPORT=7777)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(LKSH372)/db/lakeshore372.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
