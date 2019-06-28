epicsEnvSet "DEVICE" "IP1"
epicsEnvSet "MOTOR_PORT" "ANC1"
epicsEnvSet "NUM_AXES" "3"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(IP_ADDR=NO_PORT_MACRO):2101", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)","130.246.51.234:2101",0,0,0)

## For real device or devsim
$(IFNOTRECSIM) anc350AsynMotorCreate("$(DEVICE)", "0", "0", "$(NUM_AXES)")
$(IFNOTRECSIM) drvAsynMotorConfigure("$(MOTOR_PORT)", "anc350AsynMotor", "0", "$(NUM_AXES)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")
luash("load_dbs.lua")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
