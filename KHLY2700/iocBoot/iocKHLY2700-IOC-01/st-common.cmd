epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KHLY2700)/Keithley_2700Sup"
epicsEnvSet "DEVICE" "L0"

## Environment Variables
epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
epicsEnvSet "CALIB_DIR" "cryomagnet_scanner"
epicsEnvSet "CALIB_FILE" "8_shim_xy.txt"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

# Configurable terminators
asynOctetSetInputEos("$(DEVICE)", -1, "$(IEOS=\\r\\n)")
asynOctetSetOutputEos("$(DEVICE)", -1, "$(OEOS=\\r\\n)")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/keithley2700.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
dbLoadRecords("${TOP}/db/keithley2700_channels.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), CALIB_BASE_DIR=$(CALIB_BASE_DIR),CALIB_DIR=$(CALIB_DIR),CALIB_FILE=$(CALIB_FILE), DRVHI=$(DRIVE_HIGH=10000),DRVLO=$(DRIVE_LOW=0)")

## For debugging:
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
