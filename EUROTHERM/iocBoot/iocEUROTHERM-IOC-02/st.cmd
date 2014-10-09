#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet "IOCNAME" "EUROTHERM"
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SUPPORT)/eurotherm2k/1-11/eurotherm2kApp/protocol"
epicsEnvSet "TTY" "$(TTY=\\\\\\\\.\\\\COM18)"
epicsEnvSet "SENS_DIR" "C:/InstrumentSettings/calib/sensors"
epicsEnvSet "LOOK_DIR" "C:/InstrumentSettings"

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

## Load ReadASCII
## A seperate instance must be created for each eurotherm
ReadASCIIConfigure("READASCII1")
ReadASCIIConfigure("READASCII2")

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL eurotherms
dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)EUROTHERM:")

## Load record instances
## GAD = Greater Eurtotherm address part
## LAD = Lesser Eurotherm address part
## For example: eurotherm address 1 => GAD = 0 and LAD = 1
## For example: eurotherm address 10 => GAD = 1 and LAD = 0
dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)EUROTHERM1:, Q=$(MYPVPREFIX)EUROTHERM:, GAD=0, LAD=1, PORT=L0, LDIR = $(LOOK_DIR), SDIR=$(SENS_DIR), READ=READASCII1")
dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)EUROTHERM2:, Q=$(MYPVPREFIX)EUROTHERM:, GAD=0, LAD=2, PORT=L0, LDIR = $(LOOK_DIR), SDIR=$(SENS_DIR), READ=READASCII2")


< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

