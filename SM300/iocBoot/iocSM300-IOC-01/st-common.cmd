epicsEnvSet("DEVICE", "L0")
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocSM300-IOC-01", "")

iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("AMOTOR", "SM300MOTOR")

## For recsim:
$(IFRECSIM) motorSimCreateController("$(AMOTOR)", $(NAXES=1)) 
$(IFRECSIM) drvAsynSerialPortConfigure("$(AMOTOR)", "NUL", 0, 1)


## For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"baud","$(BAUD=9600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"bits","8") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"stop","2") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"parity","none") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"clocal","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceIOMask("$(DEVICE)", 0, 2)
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

# (driver port, serial port, axis num, ms mov poll, ms idle poll, egu per step)
$(IFNOTRECSIM) SM300CreateController("$(AMOTOR)", "$(DEVICE)", "$(NAXES=1)", 100, 1000)


iocshCmdLoop("< st-axes.cmd", "MN=\$(I)", "I", 1, 8)

epicsEnvSet("SM300CONFIG","$(ICPCONFIGROOT)/$(IOCNAME)")

# configure axes
< $(SM300CONFIG)/axes.cmd

# motion set points
< $(SM300CONFIG)/motionsetpoints.cmd

# sample changer
< $(SM300CONFIG)/sampleChanger.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")
dbLoadRecords("$(MOTOR)/db/SM300_extra.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX), PORT=$(AMOTOR), ADDR=0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
