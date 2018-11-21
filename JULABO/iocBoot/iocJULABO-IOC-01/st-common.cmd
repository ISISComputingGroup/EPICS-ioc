epicsEnvSet "STREAM_PROTOCOL_PATH" "$(JULABO)/julaboApp/protocol"

cd ${TOP}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "4800")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "7")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "even")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

$(IFNOTRECSIM) asynOctetSetInputEos("L0", -1, "$(OEOS=\\r\\n)")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0", -1, "$(IEOS=\\r)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load the julabo DB
## Note: the macro defaults correspond to the "Big" or "Default" labview settings. 
## These macros may need to be changed to communicate with other types of water bath
## See https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Julabo for more details
dbLoadRecords("db/julabo.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),READ_POWER_CMD_NUMBER=$(READ_POWER_CMD_NUMBER=01),READ_EXT_TEMP_CMD_NUMBER=$(READ_EXT_TEMP_CMD_NUMBER=02),READ_HIGH_LIM_CMD_NUMBER=$(READ_HIGH_LIM_CMD_NUMBER=01),READ_LOW_LIM_CMD_NUMBER=$(READ_LOW_LIM_CMD_NUMBER=02)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
