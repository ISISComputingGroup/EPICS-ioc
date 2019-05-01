#!../../bin/windows-x64/SECI2IBEX-IOC-01

## You may have to change SECI2IBEX-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/SECI2IBEX-IOC-01.dbd"
SECI2IBEX_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## option 64 is lvSECINoSetter as we only want to read PVs
## add blocks_match after options e.g. "DetectorTemp.*"
lvDCOMSECIConfigure("lvfp", "P=$(MYPVPREFIX)CS:SB:,SCAN=5 second", "frontpanel", "$(TOP)/db/seci.xml", "$(TOP)/db/seci.substitutions", "", 64, ".*")

## option 16 is lvNoStart 
lvDCOMConfigure("lvdae", "frontpanel", "$(TOP)/data/seci_dae.xml", "", 16)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadTemplate("$(TOP)/db/seci.substitutions")
dbLoadRecords("$(TOP)/db/seci_dae.db","P=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
