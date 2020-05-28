

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

stringiftest  "LOCALCALIB"  "$(LOCAL_CALIB="no")"  5  "yes"

## Environment Variables

$(IFNOTLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
$(IFNOTLOCALCALIB) epicsEnvSet "CALIB_DIR" "magnets"

$(IFLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/$(INSTRUMENT)"
$(IFLOCALCALIB) epicsEnvSet "CALIB_DIR" "calib/magnets"

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/master/danfysikMps8000App/protocol/:$(DANFYSIK8000)/master/danfysikMps8000App/protocol/DFK$(DEV_TYPE=8000)/"

## use with emulator
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT)")

## use with real device
$(IFNOTRECSIM) $(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "$(PARITY="none")")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "$(STOP=2)")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

$(IFNOTRECSIM) asynOctetSetInputEos("L0",0,"$(IEOS=\\n\\r)")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0",0,"$(OEOS=\\r)")

## checks used for loading db files
stringiftest  "POLAR"  "$(POLARITY="BIPOLAR")"  5  "BIPOLAR"
stringiftest  "CALIB"  "$(CALIBRATED=1)"  5  "1"
stringiftest  "SLEW"  "$(USE_SLEW=0)"  5  "1"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet "SP_PINI" "$(SP_AT_STARTUP=NO)"

## Load record instances
dbLoadRecords("$(TOP)/db/DFKPS_common.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, FWI=$(FACTOR_WRITE_I=1000), FRI=$(FACTOR_READ_I=1), FRV=$(FACTOR_READ_V=1), port=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),SP_PINI=$(SP_PINI), VADC=$(VADC=2), DEV_TYPE=$(DEV_TYPE=8000), CALIBRATED=$(CALIBRATED=1), USE_SLEW=$(USE_SLEW=0), POLARITY=$(POLARITY=BIPOLAR), MAX_RAW_SETPOINT=$(MAX_RAW_SETPOINT=1000000), OFF_TOLERANCE=$(OFF_TOLERANCE=0), DISABLE_AUTOONOFF=$(DISABLE_AUTOONOFF=1)"
dbLoadRecords("$(UTILITIES)/db/check_stability.db", "P=$(MYPVPREFIX)$(IOCNAME):,INP_VAL=$(MYPVPREFIX)$(IOCNAME):CURR,SP=$(MYPVPREFIX)$(IOCNAME):CURR:SP:RBV,NSAMP=5,TOLERANCE=$(STAB_TOLERANCE=2)")
$(IFPOLAR) dbLoadRecords("$(TOP)/db/DFKPS_polarity.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0")
$(IFCALIB) dbLoadRecords("$(TOP)/db/DFKPS_calibrated.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, CALIB_BASE_DIR=$(CALIB_BASE_DIR),CALIB_DIR=$(CALIB_DIR),CALIB_FILE=$(CALIB_FILE=default_calib.dat),DRVHI=$(DRIVE_HIGH=5000000),DRVLO=$(DRIVE_LOW=-5000000), port=L0, FWI=$(FACTOR_WRITE_I=1000)")
$(IFSLEW) dbLoadRecords("$(TOP)/db/DFKPS_slew.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0")

## Load device type specific st.cmd
< iocBoot/iocDFKPS-IOC-01/st-$(DEV_TYPE=8000).cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
