
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(EUROTHERM2K)/eurotherm2kApp/protocol"
epicsEnvSet "SENS_DIR" "C:/Instrument/Settings/calib/sensors"
epicsEnvSet "SENS_PAT" "^C.*"
epicsEnvSet "RAMP_DIR" "C:/Instrument/Settings"
epicsEnvSet "RAMP_PAT" ".*"

< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
asynSetOption("L0", -1, "bits", "$(BITS=7)")
asynSetOption("L0", -1, "parity", "$(PARITY=even)")
asynSetOption("L0", -1, "stop", "$(STOP=1)")

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL eurotherms
dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)$(IOCPVPREFIX):")

epicsEnvSet(EURO_NUM,1)
< st-euro.cmd

epicsEnvSet(EURO_NUM,2)
< st-euro.cmd

epicsEnvSet(EURO_NUM,3)
< st-euro.cmd

epicsEnvSet(EURO_NUM,4)
< st-euro.cmd

epicsEnvSet(EURO_NUM,5)
< st-euro.cmd

epicsEnvSet(EURO_NUM,6)
< st-euro.cmd

epicsEnvSet(EURO_NUM,7)
< st-euro.cmd


< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

