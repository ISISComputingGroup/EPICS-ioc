##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("PREFIX", "$(MYPVPREFIX)$(IOCNAME):")
epicsEnvSet("PORT", "SP1")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd


< envPaths
errlogInit(20000)

#dbLoadDatabase("$(TOP)/dbd/spinnakerApp.dbd")
spinnakerApp_registerRecordDeviceDriver(pdbbase) 

# Use this line for a specific camera by serial number, in this case a BlackFlyS GigE
epicsEnvSet("CAMERA_ID", "23160024")

epicsEnvSet("GENICAM_DB_FILE", "$(ADGENICAM)/db/PGR_Blackfly_50S5C.template")

< ${TOP}/iocBoot/iocPEARLCAM-IOC-01/st.cmd.base



##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(PREFIX)")
