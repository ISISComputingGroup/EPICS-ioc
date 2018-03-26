
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
#dbLoadRecords("$(SSCAN)/sscanApp/Db/scan.db","P=$(MYPVPREFIX)$(IOCNAME):,MAXPTS1=8000,MAXPTS2=1000,MAXPTS3=10,MAXPTS4=10,MAXPTSH=8000")

### autosave
# specify additional directories in which to to search for included request files
set_requestfile_path("${GALIL}/GalilSup/Db", "")
set_requestfile_path("${MOTOR}/motorApp/Db", "")

## as all Galils cd to GALIL-IOC-01 need to add this explicitly so info generated req files are found
set_requestfile_path("${TOP}/iocBoot/iocGALIL-IOC-01", "")

## Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL)", 2, 2)

epicsEnvSet("GALILCONFIG","$(ICPCONFIGROOT)/galil")

## uncomment to see every command sent to every galil, of define in st.cmd for just one galil
#epicsEnvSet("GALIL_DEBUG_FILE", "galil_debug.txt")

## create simulated motor if required (asyn port GalilSim)
$(IFSIM) < motorsim.cmd

## configure the galil, if we are simulated this will not be used to drive the 
## actual device, but creating this asyn port at least allows record initialisation 
## to complete
< $(GALILCONFIG)/galil$(MTRCTRL).cmd

# GALIL_MTR_PORT is the asyn port used to load the motor record
$(IFSIM) epicsEnvSet("GALIL_MTR_PORT", "GalilSim")
$(IFNOTSIM) epicsEnvSet("GALIL_MTR_PORT", "Galil")

## load the galil db files
< galildb.cmd

## load the generic ISIS axis db for each axis
iocshCmdLoop("< st-axis.cmd", "MN=\$(I)", "I", 1, 8)

## configure jaws
< $(GALILCONFIG)/jaws.cmd

## configure barndoors
< $(GALILCONFIG)/barndoors.cmd

## configure axes
< $(GALILCONFIG)/axes.cmd

## motion set points
< $(GALILCONFIG)/motionsetpoints.cmd

## sample changer
< $(GALILCONFIG)/sampleChanger.cmd

# motor extensions
$(IFNOTTESTDEVSIM) < $(GALILCONFIG)/motorExtensions.cmd
$(IFTESTDEVSIM) < $(MOTOREXT)/settings/motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

stringiftest("MOTORCONFIG", "$(MOTORCONFIG=)", 0, 0)
$(IFMOTORCONFIG) dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=$(MYPVPREFIX)$(IOCNAME):CONFIG:,CONFIG=$(MOTORCONFIG=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

## trace mask: 0x1=trace_error,0x2=traceio_device,0x4=traceio_filter, 0x8=traceio_driver, 0x10=trace_flow, 0x20=trace_warning  
#asynSetTraceMask("Galil",-1,0x39)
#asynSetTraceFile("Galil",-1,"galil.trace")
#asynSetTraceIOMask("Galil",-1,0x2)

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

stringiftest("HASMTRCTRL", "$(MTRCTRL=)", 0, 0)
$(IFNOTHASMTRCTRL) errlogSev(2, "MTRCTRL has not been set")

# Save motor positions every 5 seconds
$(IFHASMTRCTRL) $(IFNOTSIM) create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

# Save motor settings every 30 seconds
$(IFHASMTRCTRL) $(IFNOTSIM) create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

$(IFHASMTRCTRL) $(IFNOTSIM) $(IFMOTORCONFIG) create_manual_set("$(MOTORCONFIG=)Menu.req","P=$(MYPVPREFIX)MOT:,CMP=$(MYPVPREFIX)$(IOCNAME):CONFIG:,CONFIG=$(MOTORCONFIG=),IOCNAME=$(IOCNAME),MTRCTRL=$(MTRCTRL),CONFIGMENU=1")

## Start any sequence programs
#seq sncxxx,"user=icsHost"
