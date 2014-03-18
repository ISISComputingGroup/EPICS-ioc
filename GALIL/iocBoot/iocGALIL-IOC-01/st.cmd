#!../../bin/windows-x64/GALIL-IOC-01

## You may have to change GALIL-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-01.dbd"
GALIL_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

cd ${TOP}/iocBoot/${IOC}

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
#dbLoadRecords("$(SSCAN)/sscanApp/Db/scan.db","P=$(MYPVPREFIX)$(IOCNAME):,MAXPTS1=8000,MAXPTS2=1000,MAXPTS3=10,MAXPTS4=10,MAXPTSH=8000")

### autosave
# specify additional directories in which to to search for included request files
set_requestfile_path("${GALIL}/db/", "")
set_requestfile_path("${MOTOR}/motorApp/Db", "")

# how many galil crates we have
# GALILNUMCRATES set in icpconfig

# this defines macros we can use for conditional loading later
calc("IFDMC01", "$(GALILNUMCRATES) >= 1", 4)
calc("IFDMC02", "$(GALILNUMCRATES) >= 2", 4)
calc("IFDMC03", "$(GALILNUMCRATES) >= 3", 4)
calc("IFDMC04", "$(GALILNUMCRATES) >= 4", 4)
calc("IFDMC05", "$(GALILNUMCRATES) >= 5", 4)
calc("IFDMC06", "$(GALILNUMCRATES) >= 6", 4)
calc("IFDMC07", "$(GALILNUMCRATES) >= 7", 4)

# configure galil and motors
< galil.cmd

# configure jaws
< jaws.cmd

# motion set points
< motionsetpoints.cmd

# set Galil driver debug level (output only printed if code compiled with DEBUG support)
var devG21X3Debug 0
#var devG21X3Debug 1

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):, PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

## Start any sequence programs
#seq sncxxx,"user=icsHost"
