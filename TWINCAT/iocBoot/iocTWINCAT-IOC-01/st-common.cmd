##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")
luash("st-common.lua")

asynSetTraceIOMask("MCU1", -1, 0x2)
asynSetTraceMask("MCU1", -1, 0x9)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
