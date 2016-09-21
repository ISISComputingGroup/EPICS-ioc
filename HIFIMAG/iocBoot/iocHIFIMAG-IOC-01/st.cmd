#!../../bin/windows-x64/HIFIMAG-IOC-01

## You may have to change HIFIMAG-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HIFIMAG-IOC-01.dbd"
HIFIMAG_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

lvDCOMConfigure("lvfp", "frontpanel", "${TOP}/data/lv_controls.xml")
#lvDCOMConfigure("lvfp", "frontpanel", "${TOP}/data/lv_controls.xml", "ndxicap", 6, "", "spudulike", "reliablebeam")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/controls.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
