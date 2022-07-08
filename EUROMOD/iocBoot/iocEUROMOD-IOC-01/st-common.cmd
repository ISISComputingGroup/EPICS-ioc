< $(IOCSTARTUP)/init.cmd

stringiftest  "LOCALCALIB"  "$(LOCAL_CALIB="no")"  5  "yes"

$(IFNOTLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPSETTINGSDIR)/config/common"
$(IFNOTLOCALCALIB) epicsEnvSet "SENS_DIR" "temp_sensors"
$(IFNOTLOCALCALIB) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/ramps"

$(IFLOCALCALIB) epicsEnvSet "CALIB_BASE_DIR" "$(ICPCONFIGBASE)/$(INSTRUMENT)"
$(IFLOCALCALIB) epicsEnvSet "SENS_DIR" "calib/temp_sensors"
$(IFLOCALCALIB) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/calib/ramps"



drvAsynSerialPortConfigure("L0", "COM37", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "19200")
asynSetOption("L0", -1, "bits", "8")
asynSetOption("L0", -1, "parity", "even")
asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
asynSetOption("L0", 0, "clocal", "Y")
asynSetOption("L0",0,"crtscts","N")

# Software flow control off
asynSetOption("L0",0,"ixon","N") 
asynSetOption("L0",0,"ixoff","N")

modbusInterposeConfig("L0",1, 2000, 0)

drvModbusAsynConfigure("L0_MASTER_RX","L0",1, 3,-1,1, 0,1000, "")
drvModbusAsynConfigure("L0_MASTER_TX","L0",1, 6,-1,1, 0,0, "")

asynSetTraceMask("L0", -1, 0x9)
asynSetTraceIOMask("L0", -1, 0x2)

< $(IOCSTARTUP)/dbload.cmd

## Load the sim and disable records
## These are loaded separately to allow one SIM and DISABLE to be used for ALL EUROMODs
# dbLoadRecords("$(TOP)/db/devSimDis.db","Q=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")
dbLoadRecords("$(EUROTHERMMODBUS)/db/eurothermDis.template","device=$(MYPVPREFIX)$(IOCNAME),modbus_prefix=L0,rregu=0")
dbLoadRecords("$(EUROTHERMMODBUS)/db/eurothermL1.template","device=$(MYPVPREFIX)$(IOCNAME),modbus_prefix=L0,rregu=0")
dbLoadRecords("$(EUROTHERMMODBUS)/db/eurothermL2.template","device=$(MYPVPREFIX)$(IOCNAME),modbus_prefix=L0,rregu=0")



< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

