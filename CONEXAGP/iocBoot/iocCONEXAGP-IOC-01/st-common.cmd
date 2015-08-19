
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocCONEXAGP-IOC-01", "")

epicsEnvSet(PN,1)
< st-port.cmd

epicsEnvSet(PN,2)
< st-port.cmd

epicsEnvSet(PN,3)
< st-port.cmd

epicsEnvSet(PN,4)
< st-port.cmd

epicsEnvSet(PN,5)
< st-port.cmd

epicsEnvSet(PN,6)
< st-port.cmd

epicsEnvSet(PN,7)
< st-port.cmd

epicsEnvSet(PN,8)
< st-port.cmd

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

# Save motor positions every 5 seconds
#create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:")

# Save motor settings every 30 seconds
$(IFPORT1) create_monitor_set("$(IOCNAME)_1_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT2) create_monitor_set("$(IOCNAME)_2_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT3) create_monitor_set("$(IOCNAME)_3_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT4) create_monitor_set("$(IOCNAME)_4_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT5) create_monitor_set("$(IOCNAME)_5_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT6) create_monitor_set("$(IOCNAME)_6_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT7) create_monitor_set("$(IOCNAME)_7_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")
$(IFPORT8) create_monitor_set("$(IOCNAME)_8_built_settings.req", 30, "P=$(MYPVPREFIX)MOT:")

#create_monitor_set("$(IOCNAME)_settings.req", 5, "P=$(MYPVPREFIX)MOT:")
