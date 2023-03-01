< $(IOCSTARTUP)/init.cmd

stringiftest  "LOCALCALIB"  "$(LOCAL_CALIB="no")"  5  "yes"

$(IFNOTLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPSETTINGSDIR)/config/common"
$(IFNOTLOCALCALIB) epicsEnvSet "SENS_DIR" "temp_sensors"
$(IFNOTLOCALCALIB) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/ramps"

$(IFLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPCONFIGBASE)/$(INSTRUMENT)"
$(IFLOCALCALIB) epicsEnvSet "SENS_DIR" "calib/temp_sensors"
$(IFLOCALCALIB) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/calib/ramps"

epicsEnvSet "SENS_PAT" "^C.*"
epicsEnvSet "RAMP_PAT" ".*"
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(EUROTHERM2K)/data"

## Use the example ramp file
$(IFDEVSIM) epicsEnvSet "RAMP_DIR" "$(READASCII)/example_settings"

## Use the example sensor files
$(IFDEVSIM) epicsEnvSet "CALIB_BASE_DIR" "$(SUPPORT)"
$(IFDEVSIM) epicsEnvSet "SENS_DIR" "eurotherm2k/master/example_temp_sensor"

stringiftest("USES_BISYNCH", "$(COMMS_MODE=eibisynch)",4,"eibisynch")

$(IFUSES_BISYNCH) < ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-comms-eibisynch.cmd 
$(IFNOTUSES_BISYNCH) < ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-comms-modbus.cmd 

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL EUROTHRMs
dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-timing.cmd

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

epicsEnvSet(EURO_NUM,8)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,9)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

epicsEnvSet(EURO_NUM,10)
< ${TOP}/iocBoot/iocEUROTHRM-IOC-01/st-euro.cmd

< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

