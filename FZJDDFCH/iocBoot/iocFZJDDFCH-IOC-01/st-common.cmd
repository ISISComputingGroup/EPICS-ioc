epicsEnvSet "STREAM_PROTOCOL_PATH" "$(FZJDDFERMCHOP)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

# Commands for turning on debugging.  Shows traffic on connection.
# asynSetTraceMask("L0",-1,0x9) 
# asynSetTraceIOMask("L0",-1,0x2)

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(CHOP)","$(IPADDR):$(IPPORT=3323)",0,0,1)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/FZJDDFCH.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), ADDR=$(ADDR)")
dbLoadRecords("${TOP}/db/error_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user="

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
