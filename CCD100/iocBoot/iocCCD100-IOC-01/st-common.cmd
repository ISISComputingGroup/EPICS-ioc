epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CCD100)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## a mk3 CCD100 will have an IP address specified
stringiftest("MK3", "$(IPADDR=)", 3)

## set correct protocol file
$(IFMK3) epicsEnvSet("CCD100PROTOCOL", "devCCD100_mk3")
$(IFNOTMK3) epicsEnvSet("CCD100PROTOCOL", "devCCD100")

## for mk3 use IP
$(IFMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("L0", "$(IPADDR=)")
## strip NULL bytes in returned string, CCD100 mk3 over ethernet seems to send these occasionally
$(IFMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynInterposeStripConfig("L0", 0, "\0")
## can't rememeber if asynOctetSetInputEos below is needed for ethernet or not
## it gets set in protocol file anyway, but should check if asynOctetSetInputEos would infere
## with asynInterposeStripConfig, i suspect not 

## for mk2 use serial PORT
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 0, 0, 0)

$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=57600)")
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

## Hardware flow control off
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

## Software flow control off
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

## EOL for asyn
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetInputEos("L0", -1, "\r\n")
$(IFNOTMK3) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetSetOutputEos("L0", -1, "\r\n") 

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/CCD100.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, ADDR=$(ADDRESS=a), DEV_NAME=$(DEV_NAME=), RECSIM=$(RECSIM), DEVSIM=$(DEVSIM), PROTOCOL=$(CCD100PROTOCOL)")
dbLoadRecords("${TOP}/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=ffv81422Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
