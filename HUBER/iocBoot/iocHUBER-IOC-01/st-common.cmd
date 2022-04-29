
< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")
## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocHUBER-IOC-01", "")

epicsEnvSet(PN,1)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,2)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,3)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,4)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,5)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,6)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,7)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

epicsEnvSet(PN,8)
< ${TOP}/iocBoot/iocHUBER-IOC-01/st-port.cmd

## motor util package
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

## per controller PVs
dbLoadRecords("$(MOTOR)/db/motorController.db","P=$(MYPVPREFIX),Q=MOT:MTR$(MTRCTRL):")

epicsEnvSet("HUBERCONFIG","$(ICPCONFIGROOT)/$(IOCNAME)")

# axes (if configured otherwise this will error)
< $(HUBERCONFIG)/axes.cmd

# motion set points (if configured otherwise this will error)
< $(HUBERCONFIG)/motionsetpoints.cmd

# sample changer (if configured otherwise this will error)
< $(HUBERCONFIG)/sampleChanger.cmd

# sample changer (if configured otherwise this will error)
< $(HUBERCONFIG)/motorextensions.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

## motor util package
#var motorUtil_debug 1
motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd



## make sure motor MRES and HUBERCreateController agree
#dbpf "M1.MRES", "$(MRES)"


#create_monitor_set("$(IOCNAME)_settings.req", 5, "P=$(MYPVPREFIX)MOT:")


