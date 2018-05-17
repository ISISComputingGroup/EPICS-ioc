## we have no .req files to load
epicsEnvSet ("AUTOSAVEREQ", "#")

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocPIMOT-IOC-01", "")

## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial1")
epicsEnvSet("AMOTOR", "motor1")

# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=1)", 2, 2)

# PN is 1->8 so we can safely add a 0
epicsEnvSet("PN", "1")
epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0$(PN)")

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")

$(IFSIM) motorSimCreateController("$(AMOTOR)", 1) 
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 32000, -32000,  0, 0) 
$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)

$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\n") 
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\n") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=38400)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","8") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","1") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","none") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N") 
$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", 0, 2)

$(IFNOTSIM) PI_GCS2_CreateController("$(AMOTOR)","$(ASERIAL)", 1, 0, 0, 500, 1000)

asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 0)

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_$(PN)_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
