
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocMCLEN-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(MTRCTRL)")


# For rec sim use built-in sim
$(IFRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFRECSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFRECSIM) epicsEnvSet("SIMSFX","Sim")

# For dev sim use emulator
$(IFDEVSIM) drvAsynIPPortConfigure("$(ASERIAL)", "localhost:$(EMULATOR_PORT=57677)")

# For real device
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceIOMask("$(ASERIAL)", -1, 0xFF )
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=9600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS=7)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP=1)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"parity","$(PARITY=even)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"crtscts","D") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N")

$(IFNOTRECSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTRECSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r")

# Test for Mclennan PM600 stepper motor controller
# Note that setup must be done in sim mode too or unconfigured card will crash at first caput
# PM304Setup(controller count, poll rate (1 to 60Hz))
$(IFNOTRECSIM) PM304Setup(1,5)

< st-homing.cmd

# PM304Config(card being configured, asyn port name,  number of axes)
$(IFNOTRECSIM) PM304Config(0, "$(ASERIAL)", "$(NAXES=1)", "$(COMBINED_HOMING_MODES=0)", 1)

iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("MCLENCONFIG","$(ICPCONFIGROOT)/mclennan")

# configure axes
< axes.cmd

# motion set points
< motionsetpoints.cmd
< sampleChanger.cmd
< motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX),MTRCTRL=$(MTRCTRL)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
