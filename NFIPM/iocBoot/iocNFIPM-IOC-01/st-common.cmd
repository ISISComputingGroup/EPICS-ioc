
< $(IOCSTARTUP)/init.cmd

## whether to use autosaved SP for jaws on IOC restart
stringiftest("INIT_JAWS_FROM_AS", "$(JAWS_POS_FROM_AS=N)", 5, "Y")

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are run by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocNFIPM-IOC-01", "")

iocshCmdLoop("< ${TOP}/iocBoot/iocNFIPM-IOC-01/st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< ${TOP}/iocBoot/iocNFIPM-IOC-01/st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(MTRCTRL)")

$(IFRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFRECSIM) motorSimCreateController("motorSim", $(NAXES))
$(IFRECSIM) epicsEnvSet("SIMSFX","Sim")

$(IFDEVSIM) drvAsynIPPortConfigure("$(ASERIAL)", "localhost:$(EMULATOR_PORT=57677)")
$(IFDEVSIM) epicsEnvSet("SIMSFX","")
  
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTRECSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r") 
$(IFNOTRECSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r\n")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=9600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS=8)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP=1)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"parity","$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N") 

# PMNC87xxSetup(controller count, drivers per controller, poll rate (1 to 60Hz))
$(IFNOTRECSIM) PMNC87xxSetup(1, $(NAXES=1), 10) 

# PMNC87xxConfig(card being configured, asyn port name)
$(IFNOTRECSIM) PMNC87xxConfig(0, "$(ASERIAL)")

iocshCmdLoop("< ${TOP}/iocBoot/iocNFIPM-IOC-01/st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("NFIPMCONFIG","$(NFIPMCONFIGDIR=$(MOTOREXT)/settings/$(INSTRUMENT)/nfipm)")

# Special configurations
< ${TOP}/iocBoot/iocNFIPM-IOC-01/axes.cmd
< ${TOP}/iocBoot/iocNFIPM-IOC-01/jaws.cmd
< ${TOP}/iocBoot/iocNFIPM-IOC-01/motionsetpoints.cmd


# motor extensions
$(IFNOTRECSIM) < $(NFIPMCONFIG)/motorExtensions.cmd
$(IFRECSIM) < $(MOTOREXT)/settings/motorExtensions.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

## per controller PVs
dbLoadRecords("$(MOTOR)/db/motorController.db","P=$(MYPVPREFIX),Q=MOT:MTR$(MTRCTRL):,AXES_NUM=$(NAXES=1)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
#motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

# Save motor positions every 5 seconds
create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
