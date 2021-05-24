epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KHLY2400)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=19200)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
asynOctetSetInputEos("$(DEVICE)", -1, "$(IEOS=\\r\\n)")
asynOctetSetOutputEos("$(DEVICE)", -1, "$(OEOS=\\r\\n)")

## Check if hardware flow control is used
stringiftest("HARDCNTL", "$(HARDFLOWCNTL=N)",5,"Y")

## Model protocol differences
stringiftest("IS2410", "$(MODEL=2400)", 5, "2410")
## DEFAULT values
epicsEnvSet("GET_V_COMMAND", ":READ?")
epicsEnvSet("GET_I_COMMAND", ":READ?")
epicsEnvSet("GET_R_COMMAND", ":READ?")
## MODEL 2410
$(IFIS2410) epicsEnvSet("GET_V_COMMAND", ":MEAS:VOLT?")
$(IFIS2410) epicsEnvSet("GET_I_COMMAND", ":MEAS:CURR?")
$(IFIS2410) epicsEnvSet("GET_R_COMMAND", ":MEAS:RES?")

# Hardware flow control
$(IFNOTHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

$(IFHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "N")
$(IFHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","Y")

# Software flow control
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","$(SOFTFLOWCNTL=N)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","$(SOFTFLOWCNTL=N)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/KHLY2400.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0),GET_V_COMMAND=$(GET_V_COMMAND),GET_I_COMMAND=$(GET_V_COMMAND),GET_R_COMMAND=$(GET_V_COMMAND)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
