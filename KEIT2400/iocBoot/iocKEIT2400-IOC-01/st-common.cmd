epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KEIT2400)/Keithley2400Sup"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For emulator use:
$(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(FREEPORT)")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=19200)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r)")
$(IFNOTDEVSIM) asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\r)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/KEIT2400.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
