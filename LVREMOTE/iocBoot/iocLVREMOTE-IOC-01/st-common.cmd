epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LVREMOTE)/data"
epicsEnvSet "STRING_PORT" "L0"
epicsEnvSet "NUM_PORT" "L1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

cd "${TOP}/iocBoot/${IOC}"
##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Startup for specific devices: DB files, Ports etc.
< devices/$(DEVCMD1=missing).cmd


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

