##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TPG)/data"

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")  
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")   
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

$(IFNOTRECSIM) asynOctetSetInputEos("L0", -1, "\r\n")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0", -1, "\r\n")

stringiftest("PRESSUR1", $(PRES1ON="Y"), 5, "Y")
stringiftest("PRESSUR2", $(PRES2ON="Y"), 5, "Y")

## For debugging:
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

#####################
## Load record instances

dbLoadRecords("$(TPG)/db/tpg26x.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IFPRESSUR1=$(IFPRESSUR1),IFPRESSUR2=$(IFPRESSUR2),IF361=#,IFNOT361=' '")

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
