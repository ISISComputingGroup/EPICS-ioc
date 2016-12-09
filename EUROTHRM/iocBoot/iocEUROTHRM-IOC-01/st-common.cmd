
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(EUROTHERM2K)/data"
epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
epicsEnvSet "SENS_DIR" "temp_sensors"
epicsEnvSet "SENS_PAT" "^C.*"
epicsEnvSet "RAMP_DIR" "ramps"
epicsEnvSet "RAMP_PAT" ".*"

< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
asynSetOption("L0", -1, "bits", "$(BITS=7)")
asynSetOption("L0", -1, "parity", "$(PARITY=even)")
asynSetOption("L0", -1, "stop", "$(STOP=1)")

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL EUROTHRMs
dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

epicsEnvSet(EURO_NUM,1)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,2)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,3)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,4)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,5)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,6)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,7)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd


< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

