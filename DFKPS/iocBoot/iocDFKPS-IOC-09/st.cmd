#!../../bin/linux-x86_64/DFKPS-IOC-09

## You may have to change DFKPS-IOC-09 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "DFKPS_02"
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/master/danfysikMps8000App/protocol"
epicsEnvSet "CALIB_PATH" "C:/"
epicsEnvSet "CALIB_FILE" "CRISP - magnet - calibration.dat"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DFKPS-IOC-09.dbd"
DFKPS_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "9600")
asynSetOption("L0", -1, "bits", "8")
asynSetOption("L0", -1, "parity", "none")
asynSetOption("L0", -1, "stop", "2")

## Load FileList
## A seperate instance must be created for each danfysik
FileListConfigure("RAMPFILELIST1", $(RAMP_DIR), $(RAMP_PAT)) 
epicsEnvSet "RAMP_DIR" "C:/Instrument/Settings"
epicsEnvSet "RAMP_PAT" ".*"

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "UNLOCK\r"

## Load our record instances
#dbLoadRecords("db/xxx.db","user=faa59Host")
dbLoadRecords("$(TOP)/Db/DFKPS.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, CDIR=$(CALIB_PATH), CFILE=$(CALIB_FILE), port=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
