#!../../bin/windows-x64/kepco

## You may have to change kepco to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KEPCO)/kepcoApp/protocol"
epicsEnvSet "TTY" "$(TTY=COM19)"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/KEPCO-IOC-01.dbd"
KEPCO_IOC_01_registerRecordDeviceDriver pdbbase

< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "9600")
asynSetOption("L0", -1, "bits", "8")
asynSetOption("L0", -1, "parity", "none")
asynSetOption("L0", -1, "stop", "1")
asynSetOption("L0", -1, "ixon", "Y")
asynSetOption("L0", -1, "ixoff", "Y")

< $(IOCSTARTUP)/dbload.cmd

## Load record instances
dbLoadRecords("$(KEPCO)/db/kepco.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RESET=NO")

< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

