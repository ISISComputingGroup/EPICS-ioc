#!../../bin/linux-x86_64/DFKPS-IOC-01

## You may have to change DFKPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "DFKPS_01"
epicsEnvSet "DEFAULT_CFILE" "default_calib.dat"
epicsEnvSet "DEFAULT_CPATH" "C:/Instrument/Settings/calib/danfysik/"
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/master/danfysikMps8000App/protocol/:$(DANFYSIK8000)/master/danfysikMps8000App/protocol/DFK$(DEV_TYPE=8000)/"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DFKPS-IOC-01.dbd"
DFKPS_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## use with emulator
#drvAsynIPPortConfigure("L0", "localhost:xxxxx")

## use with real device
drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
asynSetOption("L0", -1, "bits", "$(BITS=8)")
asynSetOption("L0", -1, "parity", "$(PARITY="none")")
asynSetOption("L0", -1, "stop", "$(STOP=2)")

## checks used for loading db files
stringiftest  "POLAR"  "$(POLARITY="BIPOLAR")"  5  "BIPOLAR"
stringiftest  "CALIB"  "$(CALIBRATED=1)"  5  "1"
stringiftest  "SLEW"  "$(USE_SLEW=0)"  5  "1"

## Load FileList
## A seperate instance must be created for each danfysik
epicsEnvSet "RAMP_DIR" "C:/Instrument/Settings"
epicsEnvSet "RAMP_PAT" ".*"
FileListConfigure("RAMPFILELIST1", $(RAMP_DIR), $(RAMP_PAT)) 

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load record instances
dbLoadRecords("$(TOP)/db/DFKPS_common.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, FAC=$(FACTOR=1000), port=L0")
$(IFPOLAR) dbLoadRecords("$(TOP)/db/DFKPS_polarity.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0")
$(IFCALIB) dbLoadRecords("$(TOP)/db/DFKPS_calibrated.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, CALIB_FILE=$(CFILE=$(DEFAULT_CFILE)), CALIB_PATH=$(CPATH=$(DEFAULT_CPATH)),DRVHI=$(DRIVE_HIGH=5000000),DRVLO=$(DRIVE_LOW=-5000000), port=L0")
$(IFSLEW) dbLoadRecords("$(TOP)/db/DFKPS_slew.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0")

## Load device type specific st.cmd
< iocBoot/iocDFKPS-IOC-01/st-$(DEV_TYPE=8000).cmd
