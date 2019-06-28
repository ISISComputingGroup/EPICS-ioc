##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load our record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")
luash("st-common.lua")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
