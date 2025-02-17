#!../../bin/windows-x64-debug/MUONTPAR-IOC-01

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MUONTPAR-IOC-01.dbd"
MUONTPAR_IOC_01_registerRecordDeviceDriver pdbbase


##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("PORT", "fserv")
epicsEnvSet("EDITOR_TPAR_FILE_DIR", $(EDITOR_TPAR_FILE_DIR="C:/Instrument/Settings")

FileContentsServerConfigure($(PORT), "$(EDITOR_TPAR_FILE_DIR)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(TPAR_FILE=),TPAR_FILE_PV_NAME=TPAR_FILE")
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(BOOSTER_TPAR_FILE=),TPAR_FILE_PV_NAME=BOOSTER_TPAR_FILE")
dbLoadRecords("$(TOP)/db/muon_tpar.db","P=$(MYPVPREFIX)$(IOCNAME):,TPAR_FILE=$(BOOSTER_TYPE=OXF13),TPAR_FILE_PV_NAME=BOOSTER_TYPE")
dbLoadRecords("$(FILESERVER)/db/FileContentsServer.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PORT)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
