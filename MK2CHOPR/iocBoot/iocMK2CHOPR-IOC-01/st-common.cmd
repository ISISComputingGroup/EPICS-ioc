epicsEnvSet "STREAM_PROTOCOL_PATH" "$(MK2CHOPR)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For emulator use:
$(IFNOTRECSIM) $(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFNOTRECSIM) $(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFNOTRECSIM) $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(FREEPORT=0)")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=7)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=even)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r)")
$(IFNOTDEVSIM) asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\r)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(TOP)/db/MK2CHOPR.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
