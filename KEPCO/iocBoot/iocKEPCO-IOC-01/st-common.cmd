epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KEPCO)/kepcoApp/protocol"

cd ${TOP}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT)")

# Fake port for recsim
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "NO_PORT", 0, 0, 0, 0)

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "crtscts", "N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "ixon", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "ixoff", "Y")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load record instances
dbLoadRecords("$(KEPCO)/db/kepco.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RESET=NO, DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
