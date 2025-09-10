
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocESP300-IOC-01", "")

epicsEnvSet("AMOTOR", "ctrl0")
epicsEnvSet("ASERIAL", "serial0")

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_built_settings.sav")

$(IFSIM) motorSimCreateController("$(AMOTOR)", 3)
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 32000, -32000,  0, 0) 
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 1, 32000, -32000,  0, 0) 
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 2, 32000, -32000,  0, 0) 
$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)

$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT)", 0, 0, 0)
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",-1,"\r\n")
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",-1,"\r")
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=19200)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","8") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","1") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","none") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N") 
#$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", 0, 2)

# Newport ESP300 driver setup parameters: 
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz,max=60Hz)
$(IFNOTSIM) ESP300Setup(1, 10)

# Newport ESP300 driver configuration parameters: 
#     (1) controller# being configured,
#     (2) ASYN port name
#     (3) address (GPIB only)
$(IFNOTSIM) ESP300Config(0, "$(ASERIAL)")

#var drvESP300debug 4

dbLoadRecords("$(MOTOR)/db/motor.db","P=$(MYPVPREFIX),M=MOT:MTR$(MTRCTRL)01,DTYP=ESP300,C=0,S=0,DESC=ESP300,EGU=mm,DIR=Pos,VELO=1,VBAS=.1,ACCL=.2,BDST=0,BVEL=1,BACC=.2,MRES=5e-5,PREC=5,DHLM=100,DLLM=-100,INIT="
dbLoadRecords("$(MOTOR)/db/motor.db","P=$(MYPVPREFIX),M=MOT:MTR$(MTRCTRL)02,DTYP=ESP300,C=0,S=1,DESC=ESP300,EGU=mm,DIR=Pos,VELO=1,VBAS=.1,ACCL=.2,BDST=0,BVEL=1,BACC=.2,MRES=5e-5,PREC=5,DHLM=100,DLLM=-100,INIT="
dbLoadRecords("$(MOTOR)/db/motor.db","P=$(MYPVPREFIX),M=MOT:MTR$(MTRCTRL)03,DTYP=ESP300,C=0,S=2,DESC=ESP300,EGU=mm,DIR=Pos,VELO=1,VBAS=.1,ACCL=.2,BDST=0,BVEL=1,BACC=.2,MRES=5e-5,PREC=5,DHLM=100,DLLM=-100,INIT="

#asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances

# Load asyn record 
#dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256") 
#dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=0") 
#dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),IOCNAME=$(IOCNAME)") 
#dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 0)


## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

## per controller PVs
dbLoadRecords("$(MOTOR)/db/motorController.db","P=$(MYPVPREFIX),Q=MOT:MTR$(MTRCTRL):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
#create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
create_monitor_set("$(IOCNAME)_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

#create_monitor_set("$(IOCNAME)_settings.req", 5, "P=$(MYPVPREFIX)MOT:")
