epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LINKAM95)/data"
epicsEnvSet "DEVICE" "L0"


##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=19200)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\r)")

asynSetTraceMask("L0",-1,0x9) 
asynSetTraceIOMask("L0",-1,0x2)

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/LINKAM95.db","P=$(MYPVPREFIX)$(IOCNAME):, port=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
#dbLoadRecords("db/xxx.db","user=iew83206Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
