##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances
tcSetAlias("PLC:TEST:")
tcSetScanRate(10, 5)
tcLoadRecords ("$(TPY_FILE)", "-eo -devtc")

devMotorCreateController("MCU1", "Controller", "1")
devMotorCreateAxis("MCU1", "0")

dbLoadRecords("db/single_axis.db","MYPVPREFIX=$(MYPVPREFIX), MOTOR_PV=MTR0101, MOTOR_PORT=MCU1, ADDR=0")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
