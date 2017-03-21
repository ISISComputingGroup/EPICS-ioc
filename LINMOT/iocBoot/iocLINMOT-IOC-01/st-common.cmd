
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocLINMOT-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(MTRCTRL)")

$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFSIM) epicsEnvSet("SIMSFX","Sim")
 
$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", -1, 0xFF )
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r")
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=9600)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS=8)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP=1)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","(PARITY=none") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","Y") 

# PM304Setup(controller count, poll rate (1 to 60Hz))
$(IFNOTSIM) LinMotSetup(1,5)

# LinMotConfig(card being configured, asyn port name,  number of axes)
$(IFNOTSIM) LinMotConfig(0, "$(ASERIAL)", "$(NAXES=1)")

iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("LINMOTCONFIG","$(ICPCONFIGROOT)/linmot")

# Special configurations
< axes.cmd
< jaws.cmd
< motionsetpoints.cmd
< sampleChanger.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
