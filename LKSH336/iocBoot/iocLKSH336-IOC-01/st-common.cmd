epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH336)/data"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For emulator use:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:55626")

## For real device use:
$(IFNOTDEVSIM) drvAsynIPPortConfigure ("$(DEVICE)", "$(HOST):7777")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/lakeshore336.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd



