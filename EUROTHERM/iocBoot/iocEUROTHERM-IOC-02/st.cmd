#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet "IOCNAME" "EUROTHERM_02"
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SUPPORT)/eurotherm2k/1-11/eurotherm2kApp/protocol"
epicsEnvSet "TTY" "$(TTY=COM22)"
epicsEnvSet "SENS_DIR" "C:/Instrument/Settings/calib/sensors"
epicsEnvSet "SENS_PAT" "^C.*"
epicsEnvSet "RAMP_DIR" "C:/Instrument/Settings"
epicsEnvSet "RAMP_PAT" ".*"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/EUROTHERM-IOC-02.dbd"
EUROTHERM_IOC_02_registerRecordDeviceDriver pdbbase

< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "9600")
asynSetOption("L0", -1, "bits", "7")
asynSetOption("L0", -1, "parity", "even")
asynSetOption("L0", -1, "stop", "1")

## Load FileList
## A seperate instance must be created for each eurotherm
FileListConfigure("RAMPFILELIST1", $(RAMP_DIR), $(RAMP_PAT)) 
FileListConfigure("RAMPFILELIST2", $(RAMP_DIR), $(RAMP_PAT))
FileListConfigure("RAMPFILELIST3", $(RAMP_DIR), $(RAMP_PAT))
FileListConfigure("SENSORFILELIST1", $(SENS_DIR), $(SENS_PAT)) 
FileListConfigure("SENSORFILELIST2", $(SENS_DIR), $(SENS_PAT))
FileListConfigure("SENSORFILELIST3", $(SENS_DIR), $(SENS_PAT))

## Load ReadASCII
## A seperate instance must be created for each eurotherm
ReadASCIIConfigure("READASCII1")
ReadASCIIConfigure("READASCII2")
ReadASCIIConfigure("READASCII3")

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL eurotherms
dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)EUROTHERM2:")

## Load record instances
## GAD = Greater Eurtotherm address part
## LAD = Lesser Eurotherm address part
## For example: eurotherm address 1 => GAD = 0 and LAD = 1
## For example: eurotherm address 10 => GAD = 1 and LAD = 0
dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)EUROTHERM2:A01:, Q=$(MYPVPREFIX)EUROTHERM2:, GAD=0, LAD=1, PORT=L0, LDIR = $(RAMP_DIR), SDIR=$(SENS_DIR), READ=READASCII1, RAMPLIST=RAMPFILELIST1, RAMPSEARCH=$(RAMP_PAT), SENSORLIST=SENSORFILELIST1, SENSORSEARCH=$(SENS_PAT)")
dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)EUROTHERM2:A02:, Q=$(MYPVPREFIX)EUROTHERM2:, GAD=0, LAD=2, PORT=L0, LDIR = $(RAMP_DIR), SDIR=$(SENS_DIR), READ=READASCII2, RAMPLIST=RAMPFILELIST2, RAMPSEARCH=$(RAMP_PAT), SENSORLIST=SENSORFILELIST2, SENSORSEARCH=$(SENS_PAT)")
dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)EUROTHERM2:A03:, Q=$(MYPVPREFIX)EUROTHERM2:, GAD=0, LAD=3, PORT=L0, LDIR = $(RAMP_DIR), SDIR=$(SENS_DIR), READ=READASCII3, RAMPLIST=RAMPFILELIST3, RAMPSEARCH=$(RAMP_PAT), SENSORLIST=SENSORFILELIST3, SENSORSEARCH=$(SENS_PAT)")


< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

