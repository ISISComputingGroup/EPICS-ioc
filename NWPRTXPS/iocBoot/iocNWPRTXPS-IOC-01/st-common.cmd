
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocNWPRTXPS-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 4)

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
## asyn port name 
epicsEnvSet("XPS_PORT", "XPS1")
epicsEnvSet("AUX_PORT", "XPS_AUX1")
epicsEnvSet("IP_PORT", "5001")
epicsEnvSet("MOVING_POLL", "10")
epicsEnvSet("IDLE_POLL", "10")

$(IFSIM) drvAsynSerialPortConfigure("$(XPS_PORT)", "NUL", 0, 1)
$(IFSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFSIM) epicsEnvSet("SIMSFX","Sim")

$(IFNOTSIM) XPSAuxConfig("$(AUX_PORT)", "$(HOSTNAME)", $(IP_PORT), $(IDLE_POLL))
$(IFNOTSIM) XPSSetup(1)
$(IFNOTSIM) XPSConfig(0, "$(HOSTNAME)", $(IP_PORT), $(NAXES), $(MOVING_POLL), $(IDLE_POLL))
$(IFNOTSIM) drvAsynMotorConfigure("$(XPS_PORT)", "motorXPS", 0, 1)
$(IFNOTSIM) XPSInterpose("$(XPS_PORT)")

iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 4)

$(IFNOTSIM) dbLoadRecords("$(TOP)/db/controller.db", "P=$(MYPVPREFIX),AUX_PORT=$(AUX_PORT)")

epicsEnvSet("NEWPORTCONFIG","$(ICPCONFIGROOT)/newport")

# configure axes
< axes.cmd

# motion set points etc.
< motionsetpoints.cmd
< sampleChanger.cmd
< motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

iocInit()

< $(IOCSTARTUP)/postiocinit.cmd

$(IFHASMTRCTRL) $(IFNOTDEVSIM) $(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
