epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TEKOSC)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) vxi11Configure("$(DEVICE)", "$(ADDR=)", 0, 0.0,"inst0", 0, 0)

#asynSetTraceIOMask("$(DEVICE)",0,2)
#asynSetTraceMask("$(DEVICE)",0,255)


##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################

dbLoadRecords("$(TEKOSC)/db/tektronixOsc.db","P=$(MYPVPREFIX)$(IOCNAME),PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mkq48465"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
