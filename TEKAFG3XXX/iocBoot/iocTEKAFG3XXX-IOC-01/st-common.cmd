epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TEKAFG3XXX)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd


## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("GPIB0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("GPIB0", "localhost:$(EMULATOR_PORT=)")
$(IFDEVSIM) asynOctetSetOutputEos("GPIB0", -1, "$(IEOS=\\n)")  # For testing set the output eos

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) vxi11Configure("GPIB0", $(ADDR), 0, 0.0,"inst0", 0, 0)

#asynSetTraceIOMask("GPIB0",0,2)
#asynSetTraceMask("GPIB0",0,255)


##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd





## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################

dbLoadRecords("$(TEKAFG3XXX)/db/devAFG3XXX.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=GPIB0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
