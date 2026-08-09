epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TEKAFG3XXX)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# stringiftest
# Needs defaults because if ioc config is set to default macro is not passed down and it won't be able to expand $(CHANNEL1)
stringiftest("CHANNEL1", "$(CHANNEL1=yes)", 5, "yes")
stringiftest("CHANNEL2", "$(CHANNEL2=yes)", 5, "yes")

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

############################
## Load our record instances
############################

dbLoadRecords("$(TEKAFG3XXX)/db/devAFG3XXXheader.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=GPIB0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
$(IFCHANNEL1) dbLoadRecords("$(TEKAFG3XXX)/db/devAFG3XXXchannel.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=GPIB0,SCAN=$(SCAN=5 second),C=1,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
$(IFCHANNEL2) dbLoadRecords("$(TEKAFG3XXX)/db/devAFG3XXXchannel.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=GPIB0,SCAN=$(SCAN=5 second),C=2,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
