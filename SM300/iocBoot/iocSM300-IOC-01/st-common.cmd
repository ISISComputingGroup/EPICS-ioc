
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocSM300-IOC-01", "")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

$(IFRECSIM) motorSimCreateController("$(DEVICE)", 1) 
$(IFRECSIM) motorSimConfigAxis("$(DEVICE)", 0, 32000, -32000,  0, 0) 
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "NUL", 0, 1)

## For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"baud","$(BAUD=57600)") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"bits","8") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"stop","1") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"parity","none") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"clocal","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceIOMask("$(DEVICE)", 0, 2)
asynSetTraceMask("L0",-1,0x9) 
asynSetTraceIOMask("L0",-1,0x2)


## Always set termination codes
asynOctetSetInputEos("$(DEVICE)",0,"\04") 
asynOctetSetOutputEos("$(DEVICE)",0,"\04") 



#iocshCmdLoop("< st-ctrl.cmd", "CNUM=\$(I)", "I", 1, 24)
#iocshCmdLoop("< st-max-axis.cmd", "MN=\$(I)", "I", 1, 8)


# (driver port, serial port, axis num, ms mov poll, ms idle poll, egu per step)
#epicsEnvSet("MRES","0.0005")
#$(IFNOTRECSIM) SM300CreateController("HI", "$(DEVICE)", "$(NAXES=1)", 100, 0, "$(MRES)")


#iocshCmdLoop("< st-port.cmd", "PN=\$(I)", "I", 1, 8)


## motor util package
#dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
#motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
#< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
#create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
#$(IFPORT1) create_monitor_set("$(IOCNAME)_1_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT2) create_monitor_set("$(IOCNAME)_2_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT3) create_monitor_set("$(IOCNAME)_3_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT4) create_monitor_set("$(IOCNAME)_4_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT5) create_monitor_set("$(IOCNAME)_5_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT6) create_monitor_set("$(IOCNAME)_6_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT7) create_monitor_set("$(IOCNAME)_7_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
#$(IFPORT8) create_monitor_set("$(IOCNAME)_8_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

#create_monitor_set("$(IOCNAME)_settings.req", 5, "P=$(MYPVPREFIX)MOT:")
