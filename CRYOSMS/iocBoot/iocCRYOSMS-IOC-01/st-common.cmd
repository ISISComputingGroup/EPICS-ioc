##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynIPPortConfigure("$(PORT=STREAM_PORT)", "localhost:$(EMULATOR_PORT=57677)")
CRYOSMSConfigure("ASYN_PORT", "$(MYPVPREFIX)$(IOCNAME):")

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CRYOSMS)/data"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

############################
## Load our record instances
############################
dbLoadRecords("$(CRYOSMS)/db/cryosms.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PORT=STREAM_PORT),ASYN_PORT=ASYN_PORT,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PROTO==cryosms.proto,DISPLAY_UNIT=$(DISPLAY_UNIT),WRITE_UNIT=$(WRITE_UNIT),T_TO_A=$(T_TO_A)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd