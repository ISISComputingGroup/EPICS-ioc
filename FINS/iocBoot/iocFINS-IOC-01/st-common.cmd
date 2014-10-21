##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# this defines macros we can use for conditional loading later
stringtest("IFPLC01", "$(FINS_01_PLCIP=)")
stringtest("IFPLC02", "$(FINS_02_PLCIP=)")

epicsEnvSet("FINSCONFIG","$(ICPCONFIGROOT)/fins")

#configure PLCs
$(IFPLC01) < $(FINSCONFIG)/fins1.cmd
$(IFPLC02) < $(FINSCONFIG)/fins2.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
