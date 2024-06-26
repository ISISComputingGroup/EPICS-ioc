epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LVREMOTE)/data"
epicsEnvSet "STRING_PORT" "L0"
epicsEnvSet "NUM_PORT" "L1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## create STRING_PORT (Required for String and Enum template)
$(IFNOTRECSIM) drvAsynIPPortConfigure("$(STRING_PORT)", "$(IPADDR):64008 TCP")
$(IFNOTRECSIM) asynOctetConnect("STRINGINIT","$(STRING_PORT)")
$(IFNOTRECSIM) asynOctetWrite("STRINGINIT" "*IDN? ")
$(IFRECSIM) drvAsynSerialPortConfigure("$(STRING_PORT)", "$(PORT=NUL)", 0, 1, 0, 0)
## create NUM_PORT (Requred for binary, enum and double template)
$(IFNOTRECSIM) drvAsynIPPortConfigure("$(NUM_PORT)", "$(IPADDR):64009 TCP")
$(IFNOTRECSIM) asynOctetConnect("NUMINIT","$(NUM_PORT)")
$(IFNOTRECSIM) asynOctetWrite("NUMINIT" "*IDN? ")
$(IFRECSIM) drvAsynSerialPortConfigure("$(NUM_PORT)", "$(PORT=NUL)", 0, 1, 0, 0)
# Wait for labview to initalise
$(IFNOTRECSIM) epicsThreadSleep(5)
#$(IFNOTRECSIM) asynSetTraceIOMask("$(NUM_PORT)", -1, 0x4)
#$(IFNOTRECSIM) asynSetTraceMask("$(NUM_PORT)", -1, 0x9)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(DDSSTRES)/db/lvremote_dds_tensile_stress_rig.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),IFNOTRECSIM=$(IFNOTRECSIM),DISABLE=$(DISABLE=0),STRING_PORT=$(STRING_PORT), NUM_PORT=$(NUM_PORT), VI_PATH=$(VI_PATH)")
dbLoadRecords("$(DDSSTRES)/db/tensile_stress_rig_internal.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")



##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=wtn43451"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
