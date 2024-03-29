#!../../bin/windows-x64/FMR-IOC-01
## You may have to change FMR-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

epicsEnvSet(IOC_NUM,1)
## Register all support components
dbLoadDatabase "dbd/FMR-IOC-01.dbd"
FMR_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

stringiftest("VNAST", "$(VNASTANDALONE=)", 3)

# Configure lvDCOM interface
$(IFNOTVNAST)lvDCOMConfigure("lvfp", "frontpanel", "${FMR}/data/lv_FMR.xml", "$(LVDCOM_HOST=)", $(LVDCOM_OPTIONS=2))
$(IFVNAST)lvDCOMConfigure("lvfp", "frontpanel", "${FMR}/data/lv_RSVNA.xml", "$(LVDCOM_HOST=)", $(LVDCOM_OPTIONS=2))

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

$(IFNOTVNAST)dbLoadRecords("$(FMR)/db/FMR.db", "P=$(MYPVPREFIX)$(IOCNAME):")
$(IFVNAST)dbLoadRecords("$(FMR)/db/RSVNA.db", "P=$(MYPVPREFIX)$(IOCNAME):")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
