##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")

epicsEnvSet("TWINCATCONFIG","$(TWINCATCONFIG=$(ICPCONFIGROOT)/twincat)")

luash("st-common.lua")

## configure jaws
< $(TWINCATCONFIG)/jaws.cmd

## configure axes
< $(TWINCATCONFIG)/axes.cmd

## motion set points 
< $(TWINCATCONFIG)/motionsetpoints.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor settings every 30 seconds, this requests file is written dynamically by LUA
set_requestfile_path("${MOTOR}/motorApp/Db", "")
set_requestfile_path("$(TOP)")
$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30)
