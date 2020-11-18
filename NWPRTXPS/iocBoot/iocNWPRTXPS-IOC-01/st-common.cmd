
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocNWPRTXPS-IOC-01", "")

#iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
#iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

# Make sure controller number is 2 digits long
#calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
## asyn serial port internal device name and motor name 
#epicsEnvSet("ASERIAL", "serial$(MTRCTRL)")

XPSSetup(1)

XPSConfig(0, "XPS-6be9", 5001, 1, 10, 5000)

#XPSCreateController("XPS1", "XPS-6be9", 5001, 0, 20, 500, 0, 500)

drvAsynMotorConfigure("XPS1", "motorXPS", 0, 1)
asynSetTraceIOMask("XPS1", -1, 0x2)
asynSetTraceMask("XPS1", -1, 0x9)
XPSInterpose("XPS1")

#XPSAuxConfig("XPS_AUX1", "XPS-6be9", 5001, 50)

XPSConfigAxis(0,0,"Axis.Pos",1000)

dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=0101,DIR=Pos")

iocInit()

< $(IOCSTARTUP)/postiocinit.cmd
