##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(OMIBTHX)/data"
epicsEnvSet "DEVICE" "L0"

$(IFDEVSIM) epicsEnvSet "IPADDR" "localhost"
$(IFDEVSIM) epicsEnvSet "IPPORT" "$(EMULATOR_PORT=57677)"

$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPADDR" "$(IPADDR=localhost)"
$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPPORT" "$(IPPORT=10000)"

$(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IPADDR=NUL):$(IPPORT=NUL)")
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "NUL")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("$(OMIBTHX)/db/omibthx.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IPADDR=$(IPADDR=NUL)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
