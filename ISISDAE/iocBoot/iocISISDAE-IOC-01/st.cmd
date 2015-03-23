#!../../bin/windows-x64-debug/ISISDAE-IOC-01

## You may have to change ISISDAE-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 4096)

< envPaths

epicsEnvSet "WIRING_DIR" "C:/Instrument/Settings/Tables"
epicsEnvSet "WIRING_PATTERN" ".*wiring.*"
epicsEnvSet "DETECTOR_DIR" "C:/Instrument/Settings/Tables"
epicsEnvSet "DETECTOR_PATTERN" ".*detector.*"
epicsEnvSet "SPECTRA_DIR" "C:/Instrument/Settings/Tables"
epicsEnvSet "SPECTRA_PATTERN" ".*spectra.*"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/ISISDAE-IOC-01.dbd"
ISISDAE_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## local dae, no dcom/labview
isisdaeConfigure("icp", $(DAEDCOM=0), $(DAEHOST=localhost), "spudulike", "reliablebeam")
## pass 1 as second arg to signify DCOM to either local or remote dae
#isisdaeConfigure("icp", 1, "localhost")
#isisdaeConfigure("icp", 1, "ndxchipir", "spudulike", "reliablebeam")

## Load the FileLists
FileListConfigure("WLIST", $(WIRING_DIR), $(WIRING_PATTERN), 1)
FileListConfigure("DLIST", $(DETECTOR_DIR), $(DETECTOR_PATTERN), 1)
FileListConfigure("SLIST", $(SPECTRA_DIR), $(SPECTRA_PATTERN), 1)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(ISISDAE)/db/isisdae.db","P=$(MYPVPREFIX)DAE:, WIRINGLIST=WLIST, WIRINGDIR=$(WIRING_DIR), WIRINGSEARCH=$(WIRING_PATTERN), DETECTORLIST=DLIST, DETECTORDIR=$(DETECTOR_DIR), DETECTORSEARCH=$(DETECTOR_PATTERN), SPECTRALIST=SLIST, SPECTRADIR=$(SPECTRA_DIR), SPECTRASEARCH=$(SPECTRA_PATTERN)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)DAE:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)DAE:")
