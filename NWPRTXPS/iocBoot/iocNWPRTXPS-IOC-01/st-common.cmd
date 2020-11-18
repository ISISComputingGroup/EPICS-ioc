
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
#epicsEnvSet("XPS", "XPS1")

#XPSAuxConfig("XPS_AUX1", "XPS-6be9", 5001, 50)

XPSSetup(1)

XPSConfig(0, "XPS-6be9", 5001, 1, 10, 5000)

drvAsynMotorConfigure("XPS1", "motorXPS", 0, 1)
XPSInterpose("XPS1")

XPSConfigAxis(0,0,"Axis.Pos",1000)

dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=0101,DIR=Pos")

epicsEnvSet("NEWPORTCONFIG","$(ICPCONFIGROOT)/newport")

# configure axes
< axes.cmd

# motion set points
< motionsetpoints.cmd
< sampleChanger.cmd
< motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

iocInit()

< $(IOCSTARTUP)/postiocinit.cmd
