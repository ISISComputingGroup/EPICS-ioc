
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

$(IFRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFRECSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFRECSIM) epicsEnvSet("SIMSFX","Sim")

$(IFDEVSIM) drvAsynIPPortConfigure("$(ASERIAL)", "localhost:$(EMULATOR_PORT=57677)")
$(IFDEVSIM) epicsEnvSet("SIMSFX","")
 
$(IFNOTRECSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r") 
$(IFNOTRECSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r\n")
 
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=9600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS=8)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP=1)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"parity","(PARITY=none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N") 

# PM304Setup(controller count, poll rate (1 to 60Hz))
$(IFNOTRECSIM) LinMotSetup(1,5)

# LinMotConfig(card being configured, asyn port name,  number of axes)
$(IFNOTRECSIM) LinMotConfig(0, "$(ASERIAL)", "$(NAXES=1)")

iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("LINMOTCONFIG","$(ICPCONFIGROOT)/linmot")

# Special configurations
< axes.cmd
< jaws.cmd
< motionsetpoints.cmd
< sampleChanger.cmd

# motor extensions
$(IFNOTRECSIM) < $(LINMOTCONFIG)/motorExtensions.cmd
$(IFRECSIM) < $(MOTOREXT)/settings/motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
