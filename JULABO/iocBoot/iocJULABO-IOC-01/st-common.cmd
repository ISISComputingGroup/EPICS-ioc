epicsEnvSet "STREAM_PROTOCOL_PATH" "$(JULABO)/julaboApp/protocol"

cd ${TOP}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For testing framework only:
$(TESTDEVSIM) epicsEnvSet "IFDEVSIM" " "
$(TESTDEVSIM) epicsEnvSet "IFNOTDEVSIM" "#" 
$(TESTDEVSIM) epicsEnvSet "RECSIM" "0"
$(TESTRECSIM) epicsEnvSet "IFDEVSIM" "#"
$(TESTRECSIM) epicsEnvSet "IFNOTDEVSIM" " " 
$(TESTRECSIM) epicsEnvSet "RECSIM" "1"

## For emulator use:
$(IFDEVSIM) epicsEnvShow("EMULATOR_PORT") 
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT)")

## For real device use:
$(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "4800")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "7")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "even")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "1")

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
