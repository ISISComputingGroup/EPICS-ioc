
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocESP300-IOC-01", "")

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_built_settings.sav")

##
## connect to serial port
##
epicsEnvSet("ASERIAL", "serial0")
$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(COMPORT)", 0, 0, 0)
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",-1,"\n")
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",-1,"\r")
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD=19200)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","8") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","1") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","none") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
# controller has hardware flow control
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","N") 

asynInterposeThrottleConfig("$(ASERIAL)", 0, 0.01)

asynSetTraceIOMask($(ASERIAL), 0, ESCAPE)
#asynSetTraceMask($(ASERIAL), 0, ERROR|DRIVER|FLOW)
##
## create controller
##
# Newport ESP300 driver setup parameters: 
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz,max=60Hz)
$(IFNOTSIM) ESP300Setup(1, $(POLL=5))

# Newport ESP300 driver configuration parameters: 
#     (1) controller# being configured,
#     (2) ASYN port name
#     (3) address (GPIB only)

## as this is a model 0 driver we need to adjust DTYP in
## the record via  MDEV and MSIM macros to get
## simulation mode to work.
$(IFNOTSIM) ESP300Config(0, "$(ASERIAL)")
$(IFNOTSIM) epicsEnvSet("MDEV","ESP300")

#var drvESP300debug 4

## the controller low/high limits are in motor steps
$(IFSIM) motorSimCreate(0, 0, -200000, 200000, 0, 1, 3)
$(IFSIM) epicsEnvSet("MDEV","Motor Simulation")
$(IFSIM) epicsEnvSet("MSIM","motorSim")


##
## configure axes
##
iocshLoad "st-axis.cmd" "SLOT=0"
iocshLoad "st-axis.cmd" "SLOT=1"
iocshLoad "st-axis.cmd" "SLOT=2"

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

## per controller PVs
dbLoadRecords("$(MOTOR)/db/motorController.db","P=$(MYPVPREFIX),Q=MOT:MTR$(MTRCTRL):")

## asyn record
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(IOCNAME):ASYNREC,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256")

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 0)

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
