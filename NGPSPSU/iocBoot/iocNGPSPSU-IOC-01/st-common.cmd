epicsEnvSet "STREAM_PROTOCOL_PATH" "$(NGPSPSU)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IPADDR=NUL):$(IPPORT=NUL)")

## Set the out terminator character, default to \\r
asynOctetSetOutputEos("$(DEVICE)", -1, "$(OEOS=\\r)") 

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(NGPSPSU)/db/ngpspsu.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(NGPSPSU)/db/status_hex.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("$(NGPSPSU)/db/current_and_voltage.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=olz75487"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
