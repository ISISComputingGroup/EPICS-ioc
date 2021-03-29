epicsEnvSet("DEVICE", "L0")
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocHUBER-IOC-01", "")

# Hard coded values for current setup
epicsEnvSet("AXIS1", "yes")
epicsEnvSet("AXIS2", "yes")
dcalc("VELO1", "15000/$(MSTP1)", 1, 2)  # Feed rate / steps to give velocity
dcalc("VELO2", "15000/$(MSTP2)", 1, 2)  # Feed rate / steps to give velocity

epicsEnvSet("DHLM1", "570")
epicsEnvSet("DHLL1", "-0.5")
epicsEnvSet("DHLM2", "640")
epicsEnvSet("DHLL2", "-0.2")
# 2^data format * Gear factor denomentor / Gear factor numerator
dcalc("MSTP1", "100*10/5", 1, 1) 
dcalc("MSTP2", "100*10/1", 1, 1) 

#pad motor control to the right length
calc("MTRCTRL", "$(MTRCTRL=12)", 2, 2)

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("AMOTOR", "HUBERMOTOR")

## For recsim:
$(IFRECSIM) motorSimCreateController("$(AMOTOR)", $(NAXES=1)) 
$(IFRECSIM) drvAsynSerialPortConfigure("$(AMOTOR)", "NUL", 0, 1)


## For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"baud","$(BAUD=9600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"bits","$(BITS=8)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"stop","$(STOP=2)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"parity","$(PARITY=none)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"clocal","D") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","D") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceIOMask("$(DEVICE)", 0, 2)
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

# (driver port, serial port, axis num, ms mov poll, ms idle poll, egu per step)
$(IFNOTRECSIM) HuberCreateController("$(AMOTOR)", "$(DEVICE)", "$(NAXES=1)", 100, 1000)


iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("HUBERCONFIG","$(ICPCONFIGROOT)/$(IOCNAME)")

# axes (if configured otherwise this will error)
< $(HUBERCONFIG)/axes.cmd

# motion set points (if configured otherwise this will error)
< $(HUBERCONFIG)/motionsetpoints.cmd

# sample changer (if configured otherwise this will error)
< $(HUBERCONFIG)/sampleChanger.cmd

# sample changer (if configured otherwise this will error)
< $(HUBERCONFIG)/motorextensions.cmd


## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")
dbLoadRecords("$(MOTOR)/db/HUBER_extra.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX), PORT=$(AMOTOR), ADDR=0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
