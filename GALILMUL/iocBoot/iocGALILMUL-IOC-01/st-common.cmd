
##ISIS## Run IOC initialisation 
epicsEnvSet("IFIOC_GALILMUL_01", "#")
epicsEnvSet("IFIOC_GALILMUL_02", "#")
< $(IOCSTARTUP)/init.cmd

## whether to use autosaved SP for jaws on IOC restart
stringiftest("INIT_JAWS_FROM_AS", "$(JAWS_POS_FROM_AS=N)", 5, "Y")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

### autosave
# specify additional directories in which to to search for included request files
set_requestfile_path("${GALIL}/GalilSup/Db", "")
set_requestfile_path("${MOTOR}/motorApp/Db", "")

## as all Galils cd to GALIL-IOC-01 need to add this explicitly so info generated req files are found
set_requestfile_path("${TOP}/iocBoot/iocGALILMUL-IOC-01", "")

## Make sure controller numbers are 2 digits long
calc("MTRCTRL1", "$(MTRCTRL1)", 2, 2)
calc("MTRCTRL2", "$(MTRCTRL2)", 2, 2)

epicsEnvSet("GALILCONFIG","$(GALILCONFIGDIR=$(MOTOREXT)/settings/$(INSTRUMENT)/galilmul)")

iocshCmdLoop("< st-motor-controller.cmd", "CN=\$(I)", "I", 1, 2)

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
< $(GALILCONFIG)/motorExtensions.cmd

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

# Save motor positions every 5 seconds - these could be used for restore on controller reset, but req file contents currently disable this
$(IFNOTDEVSIM)$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:,MTRCTRL1=$(MTRCTRL1=),MTRCTRL2=$(MTRCTRL2=)")

# Save motor positions every 5 seconds, these are not used for automatic restore, they are just for information
# They could be manually applied for a restore, or used with autosave asVerify to check current positions  
$(IFNOTDEVSIM)$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_positions_norestore.req", 5, "P=$(MYPVPREFIX)MOT:,MTRCTRL1=$(MTRCTRL1=),MTRCTRL2=$(MTRCTRL2=)")

# Save motor settings every 30 seconds
$(IFNOTDEVSIM)$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,MTRCTRL1=$(MTRCTRL1=),MTRCTRL2=$(MTRCTRL2=)")
