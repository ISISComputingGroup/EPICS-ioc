
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
asynSetMinTimerPeriod(0.001)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("HEXAGON_COPYCMD", "$(CAENMCA)/copydata.bat")
epicsEnvSet("DATAFILE_SUFFIX", "nxs2")

stringiftest("HEX0", "$(IPADDR0=)", 3)
stringiftest("HEX1", "$(IPADDR1=)", 3)

$(IFHEX0) iocshLoad "$(TOP)/iocBoot/iocCAENMCA-IOC-01/st-hexagon.cmd", "ID=0"
$(IFHEX1) iocshLoad "$(TOP)/iocBoot/iocCAENMCA-IOC-01/st-hexagon.cmd", "ID=1"

## shared parameters just defined on HEX0 and aliased if necessary
$(IFHEX0) dbLoadRecords("$(CAENMCA)/db/CAENMCA.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L0")
$(IFHEX0) dbLoadRecords("$(CAENMCA)/db/CAENdae_sync.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L0")
$(IFHEX1) dbLoadRecords("$(CAENMCA)/db/CAENMCAAlias.db","P=$(MYPVPREFIX),Q=HEX0:,QALIAS=HEX1:")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"

iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
