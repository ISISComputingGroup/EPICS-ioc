##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TPG)/data"

## For emulator use this:
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:55626")

## For real device use this:
$(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)

$(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")  
$(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "none")   
$(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "1")
$(IFNOTDEVSIM) asynOctetSetInputEos("L0", -1, "\r\n")
$(IFNOTDEVSIM) asynOctetSetOutputEos("L0", -1, "\r\n")

## For debugging:
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

#####################
## Load record instances

dbLoadRecords("$(TPG)/db/tpg26x.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

## Finished loading record instances
#########################

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=hgv27692Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
