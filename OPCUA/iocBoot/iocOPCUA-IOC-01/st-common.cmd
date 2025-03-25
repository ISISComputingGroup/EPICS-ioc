##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("OPCUA_IGNORE_NONFATAL_CPU", "$(IGNORE_NONFATAL_CPU_ERROR=0)")

epicsEnvSet("OPCUACONFIG","$(OPCUACONFIGDIR=$(ICPCONFIGROOT)/opcua)")

## configure PLCs - will look for OPCUA_01.cmd etc based on IOC name
# dbLoadRecords is done here, in Instrument/Settings/config
< $(OPCUACONFIG)/$(IOCNAME).cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

#! $(SUPPORT)/OPCUA/bin/windows-x64/opcua

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
