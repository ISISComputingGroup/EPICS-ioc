##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ITC503)/data"
epicsEnvSet "READASCII_NAME" "READASCII"
epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
$(IFNOTDEVSIM) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/ramps"
$(IFDEVSIM) epicsEnvSet "RAMP_DIR" "$(READASCII)/example_settings"
ReadASCIIConfigure("$(READASCII_NAME)", "$(RAMP_DIR)", 1, 20)

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "2")

## Flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################

dbLoadRecords("$(ITC503)/db/ITC503.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), READ=$(READASCII_NAME)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
