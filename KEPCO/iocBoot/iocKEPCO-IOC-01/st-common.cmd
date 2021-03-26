epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KEPCO)/kepcoApp/protocol"

cd ${TOP}

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

stringiftest  "LOCALCALIB"  "$(LOCAL_CALIB="no")"  5  "yes"

$(IFNOTLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPSETTINGSDIR)/config/common"
$(IFNOTLOCALCALIB) epicsEnvSet "SENS_DIR" "magnets"

$(IFLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPCONFIGBASE)/$(INSTRUMENT)"
$(IFLOCALCALIB) epicsEnvSet "SENS_DIR" "calib/magnets"

epicsEnvSet "SENS_PAT" ".*"

## Use the example sensor files
$(IFDEVSIM) epicsEnvSet "CALIB_BASE_DIR" "$(SUPPORT)"
$(IFDEVSIM) epicsEnvSet "SENS_DIR" "kepco/master/example_calibration"

FileListConfigure("SENSORFILELIST", "$(CALIB_BASE_DIR)/$(SENS_DIR)", "$(SENS_PAT)", 0) 

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT)")

# Fake port for recsim
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "NO_PORT", 0, 0, 0, 0)

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "crtscts", "N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "ixon", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "ixoff", "Y")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

ReadASCIIConfigure("READASCII", "", $(STEP_NUMBER=20), 1)

## Load record instances
dbLoadRecords($(FILELIST)/db/calibration.db, "P=$(MYPVPREFIX)$(IOCNAME):, DEFAULT_FILE=default_calib.dat, CALIB_BASE_DIR=$(CALIB_BASE_DIR), SDIR=$(SENS_DIR), CALIBLIST=SENSORFILELIST, CONV_TO_PV=FIELD, CONV_FROM_PV=CURRENT:, CONV_TO_DESC=Field, CONV_TO_EGU=G")

dbLoadRecords("$(KEPCO)/db/kepco.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RESET=NO, DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0), RESET_ON_START=$(RESET_ON_START=0)")
dbLoadRecords("$(KEPCO)/db/kepco_ramping.db","P=$(MYPVPREFIX)$(IOCNAME):, READ=READASCII, CURRENT_MAX=$(CURRENT_MAX=0)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
