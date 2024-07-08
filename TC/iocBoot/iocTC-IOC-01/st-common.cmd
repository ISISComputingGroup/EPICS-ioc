##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")

epicsEnvSet("TWINCATCONFIG","$(TWINCATCONFIG=$(ICPCONFIGROOT)/twincat)")

## to stop lots of logs of writes to ASTAXES_*:STCONTROL-BENABLE
epicsEnvSet("CAPUTLOGCONFIG", "0")


epicsEnvSet("LOCAL_AMSNET", "127.0.0.1.1.1")
AdsSetLocalAMSNetID($(LOCAL_AMSNET))
epicsEnvSet("IP_AD", $(IP_AD="192.168.1.221"))
epicsEnvSet("PORT", "ads-port")
epicsEnvSet("ADS_PORT", $(ADS_PORT=852))

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# Get the number of axes from the controller before we starting spinning up dbs for each axis. the NUM_AXES macro is set to this number by getAdsVar() 
getAdsVar("NUM_AXES", "GVL_APP.nAXIS_NUM", "$(IP_AD)", "$(AMS_ID)", $(ADS_PORT))

# If the above didn't work, exit now to avoid trying to autosave incorrect values
stringiftest("CONNECTED", "$(NUM_AXES=)")
$(IFNOTCONNECTED=#)epicsThreadSleep(5)
$(IFNOTCONNECTED=#) iocInit
$(IFNOTCONNECTED=#) dbpf $(MYPVPREFIX)CS:IOC:$(IOCNAME):DEVIOS:SYSRESET 1
$(IFNOTCONNECTED=#) exit




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



dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

set_requestfile_path("${MOTOR}/motorApp/Db", "")
set_requestfile_path("$(TOP)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

# AdsOpen(port_name, ip_addr, ams_net_id, sum_buffer_nelem, ads_timeout, device_read_ads_port, sum_read_period)
# sum_read_period is 200ms, matching the motor record update frequency for idle and moving
AdsOpen("$(PORT)", $(IP_AD), $(AMS_ID), 500, 500, $(ADS_PORT), 200)

cd "${TOP}/iocBoot/${IOC}"
iocInit

## set trace mask to warnings and errors
asynSetTraceMask("$(PORT)", 0, 0x21)

motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor settings every 30 seconds, this requests file is written dynamically by LUA
$(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30)
