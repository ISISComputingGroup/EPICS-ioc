#!../../bin/windows-x64-debug/MUONTPAR-IOC-01

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MUONTPAR-IOC-01.dbd"
MUONTPAR_IOC_01_registerRecordDeviceDriver pdbbase


##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("PORT1", "fservtpar")
epicsEnvSet("PORT2", "fservtparbooster")
epicsEnvSet("CURRENT_FILE", "$(TPAR_CURRENT_FILE=current.tpar)")
epicsEnvSet("CURRENT_BOOSTER_FILE", "$(BOOSTER_TPAR_CURRENT_FILE=current_booster.tpar)")
FileContentsServerConfigure($(PORT1), "$(EDITOR_TPAR_FILE_DIR)", "$(TPAR_FILE)", "$(CURRENT_FILE)")
FileContentsServerConfigure($(PORT2), "$(EDITOR_TPAR_FILE_DIR)", "$(BOOSTER_TPAR_FILE)", "$(CURRENT_BOOSTER_FILE)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
## Simple string PVs
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(CURRENT_FILE),TPAR_FILE_PV_NAME=TPAR_FILE")
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(CURRENT_BOOSTER_FILE),TPAR_FILE_PV_NAME=BOOSTER_TPAR_FILE")
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(BOOSTER_TYPE),TPAR_FILE_PV_NAME=BOOSTER_TYPE")

## FileContentsServer dbs for TPAR file editing
dbLoadRecords("$(FILESERVER)/db/FileContentsServer.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PORT1)")
dbLoadRecords("$(FILESERVER)/db/FileContentsServer.db","P=$(MYPVPREFIX)$(IOCNAME):BOOSTER:,PORT=$(PORT2)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
