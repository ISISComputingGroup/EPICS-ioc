epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KHLY2700)/Keithley_2700Sup"
epicsEnvSet "DEVICE" "L0"

## Environment Variables
epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
epicsEnvSet "CALIB_DIR" "cryomagnet_scanner"

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

## Check if hardware flow control is used
stringiftest("HARDCNTL", "$(HARDFLOWCNTL=N)",5,"Y")

# Hardware flow control
$(IFNOTHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

$(IFHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "N")
$(IFHARDCNTL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","Y")

# Software flow control
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","$(SOFTFLOWCNTL=N)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","$(SOFTFLOWCNTL=N)")

# Configurable terminators
asynOctetSetInputEos("$(DEVICE)", -1, "$(IEOS=\\r)")
asynOctetSetOutputEos("$(DEVICE)", -1, "$(OEOS=\\r)")

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
## note: buffer size should be a multiple of the number of items per point
## we need. So as we have 3 items per point, a multiple of 3
dbLoadRecords("${TOP}/db/keithley2700.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),BUFFER_SIZE=$(BUFFER_SIZE=999)")
dbLoadRecords("${TOP}/db/keithley2700_channels.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), CALIB_BASE_DIR=$(CALIB_BASE_DIR),CALIB_DIR=$(CALIB_DIR), DRVHI=$(DRIVE_HIGH=10000),DRVLO=$(DRIVE_LOW=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
