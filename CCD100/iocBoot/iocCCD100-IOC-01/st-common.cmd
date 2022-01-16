epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CCD100)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 0, 0, 0)

## for mk3 IP
## drvAsynIPPortConfigure("L0", "$(IPADDR)")
## strip NULL bytes in returned string, CCD100 mk3 over ethernet seems to send these occasionally
## asynInterposeStripConfig("L0", 0, "\0")

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=57600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetInputEos("L0", -1, "\r\n")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetOutputEos("L0", -1, "\r\n") 

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/CCD100.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, ADDR=$(ADDRESS=a), DEV_NAME=$(DEV_NAME=), RECSIM=$(RECSIM), DEVSIM=$(DEVSIM)")
dbLoadRecords("${TOP}/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=ffv81422Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
