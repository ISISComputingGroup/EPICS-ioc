epicsEnvSet "STREAM_PROTOCOL_PATH" "$(AMINT2L)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N") 

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################

dbLoadRecords("$(AMINT2L)/db/amint2l.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), ADDR=$(ADDR)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
