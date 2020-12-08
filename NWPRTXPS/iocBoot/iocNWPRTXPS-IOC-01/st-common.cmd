
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocNWPRTXPS-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 4)

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=)", 2, 2)
## asyn port name 
epicsEnvSet("XPS_PORT", "XPS1")
epicsEnvSet("AUX_PORT", "XPS_AUX1")
epicsEnvSet("IP_PORT", "5001")
epicsEnvSet("MOVING_POLL", "50")
epicsEnvSet("IDLE_POLL", "500")

$(IFSIM) drvAsynSerialPortConfigure("$(XPS_PORT)", "NUL", 0, 1)
$(IFSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFSIM) epicsEnvSet("SIMSFX","Sim")

$(IFNOTSIM) XPSSetup(1)
$(IFNOTSIM) XPSConfig(0, "$(IP_ADDRESS)", $(IP_PORT), $(NAXES), $(MOVING_POLL), $(IDLE_POLL))
$(IFNOTSIM) drvAsynMotorConfigure("$(XPS_PORT)", "motorXPS", 0, 1)
$(IFNOTSIM) XPSInterpose("$(XPS_PORT)")

iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 4)

epicsEnvSet("NEWPORTCONFIG","$(ICPCONFIGROOT)/newport")

# configure axes
< $(NEWPORTCONFIG)/axes.cmd

# motion set points etc.
< $(NEWPORTCONFIG)/motionsetpoints.cmd
< $(NEWPORTCONFIG)/sampleChanger.cmd
< $(NEWPORTCONFIG)/motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

iocInit()

motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

< $(IOCSTARTUP)/postiocinit.cmd

stringiftest("HASMTRCTRL", "$(MTRCTRL=)", 0, 0)
$(IFNOTHASMTRCTRL) errlogSev(2, "MTRCTRL has not been set")
$(IFHASMTRCTRL) $(IFNOTSIM) create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
