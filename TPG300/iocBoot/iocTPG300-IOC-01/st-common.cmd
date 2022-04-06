##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TPG)/data"

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

#####################
## Load record instances

stringiftest("PRESSURA1", $(PRESA1ON="Y"), 5, "Y")
stringiftest("PRESSURA2", $(PRESA2ON="Y"), 5, "Y")
stringiftest("PRESSURB1", $(PRESB1ON="Y"), 5, "Y")
stringiftest("PRESSURB2", $(PRESB2ON="Y"), 5, "Y")

dbLoadRecords("$(TPG)/db/devTPG300.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
dbLoadRecords("$(TPG)/db/TPG300_channels.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), IFPRESSURA1=$(IFPRESSURA1),IFPRESSURA2=$(IFPRESSURA2),IFPRESSURB1=$(IFPRESSURB1),IFPRESSURB2=$(IFPRESSURB2)")
dbLoadRecords("$(TPG)/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")
dbLoadRecordsList("$(TPG)/db/TPG300_switching_functions_rb.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)", "Q", "1;2;3;4;A;B", ";")
dbLoadRecordsList("$(TPG)/db/TPG300_switching_functions.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)", "Q", "SEL;1;2;3;4;A;B", ";")

## Finished loading record instances
#########################

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
