epicsEnvSet "STREAM_PROTOCOL_PATH" "$(JULABO)/julaboApp/protocol"

cd ${TOP}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTTESTDEVSIM) $(IFNOTTESTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTTESTDEVSIM) $(IFNOTTESTRECSIM) asynSetOption("L0", -1, "baud", "4800")
$(IFNOTTESTDEVSIM) $(IFNOTTESTRECSIM) asynSetOption("L0", -1, "bits", "7")
$(IFNOTTESTDEVSIM) $(IFNOTTESTRECSIM) asynSetOption("L0", -1, "parity", "even")
$(IFNOTTESTDEVSIM) $(IFNOTTESTRECSIM) asynSetOption("L0", -1, "stop", "1")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(DB_FILE)","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
