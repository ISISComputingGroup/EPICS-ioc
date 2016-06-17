
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

# how many galil crates we have
# GALILNUMCRATES set in icpconfig

# this defines macros we can use for conditional loading later
stringtest("IFDMC01", "$(GALILADDR01=)")
stringtest("IFDMC02", "$(GALILADDR02=)")
stringtest("IFDMC03", "$(GALILADDR03=)")
stringtest("IFDMC04", "$(GALILADDR04=)")
stringtest("IFDMC05", "$(GALILADDR05=)")
stringtest("IFDMC06", "$(GALILADDR06=)")
stringtest("IFDMC07", "$(GALILADDR07=)")
stringtest("IFDMC08", "$(GALILADDR08=)")
stringtest("IFDMC09", "$(GALILADDR09=)")
stringtest("IFDMC10", "$(GALILADDR10=)")


epicsEnvSet("GALILCONFIG","$(ICPCONFIGROOT)/galil")

## uncomment to see every command sent to every galil, of define in st.cmd for just one galil
#epicsEnvSet("GALIL_DEBUG_FILE", "galil_debug.txt")

# configure galil and motors
< galil.cmd

# configure jaws
< jaws.cmd

# configure axes
< axes.cmd

# motion set points
< motionsetpoints.cmd
< sampleChanger.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,PVPREFIX=$(MYPVPREFIX),IFDMC01=$(IFDMC01),IFDMC02=$(IFDMC02),IFDMC03=$(IFDMC03),IFDMC04=$(IFDMC04),IFDMC05=$(IFDMC05),IFDMC06=$(IFDMC06),IFDMC07=$(IFDMC07),IFDMC08=$(IFDMC08),IFDMC09=$(IFDMC09),IFDMC10=$(IFDMC10)")

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

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:,IFDMC01=$(IFDMC01),IFDMC02=$(IFDMC02),IFDMC03=$(IFDMC03),IFDMC04=$(IFDMC04),IFDMC05=$(IFDMC05),IFDMC06=$(IFDMC06),IFDMC07=$(IFDMC07),IFDMC08=$(IFDMC08),IFDMC09=$(IFDMC09),IFDMC10=$(IFDMC10)")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,IFDMC01=$(IFDMC01),IFDMC02=$(IFDMC02),IFDMC03=$(IFDMC03),IFDMC04=$(IFDMC04),IFDMC05=$(IFDMC05),IFDMC06=$(IFDMC06),IFDMC07=$(IFDMC07),IFDMC08=$(IFDMC08),IFDMC09=$(IFDMC09),IFDMC10=$(IFDMC10)")

## Start any sequence programs
#seq sncxxx,"user=icsHost"
