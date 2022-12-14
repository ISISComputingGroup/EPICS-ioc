##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")

epicsEnvSet("TWINCATCONFIG","$(TWINCATCONFIG=$(ICPCONFIGROOT)/twincat)")

## to stop lots of logs of writes to ASTAXES_*:STCONTROL-BENABLE
epicsEnvSet("CAPUTLOGCONFIG", "0")

epicsEnvSet("IP_AD", "127.0.0.1")
epicsEnvSet("AMS_ID", "$(IP_AD).1.1")
AdsSetLocalAMSNetID($(AMS_ID))

luash("st-common.lua")

## configure jaws
< $(TWINCATCONFIG)/jaws.cmd

## configure barndoors
< $(TWINCATCONFIG)/barndoors.cmd

## configure axes
< $(TWINCATCONFIG)/axes.cmd

## motion set points 
< $(TWINCATCONFIG)/motionsetpoints.cmd

## sample changer
< $(TWINCATCONFIG)/sampleChanger.cmd

## motor extensions
< $(TWINCATCONFIG)/motorExtensions.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

AdsOpen("$(PORT=852)", "$(IP_AD)", "$(AMS_ID)")


cd "${TOP}/iocBoot/${IOC}"
iocInit

motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor settings every 30 seconds, this requests file is written dynamically by LUA
set_requestfile_path("${MOTOR}/motorApp/Db", "")
set_requestfile_path("$(TOP)")
$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30)
