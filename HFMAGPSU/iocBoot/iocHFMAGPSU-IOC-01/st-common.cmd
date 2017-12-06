epicsEnvSet "STREAM_PROTOCOL_PATH" "$(HFMAGPSU)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")


# probably remove - adding in/out terminators
$(IFNOTRECSIM) asynOctetSetInputEos("L0",0,"$(IEOS=\\023)")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0",0,"$(OEOS=\\r\\n)")

# debugging into
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceMask("L0", -1, 0x9)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceIOMask("L0", -1, 0x2)
# send debug info to log
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetTraceFile("L0",-1,"temp.log")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# probably remove later
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetConnect("FRED","L0")
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetRead FRED 


## Load our record instances
dbLoadRecords("db/HFMAGPSU.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")




##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 

< $(IOCSTARTUP)/postiocinit.cmd

epicsEnvSet "P" "$(MYPVPREFIX)$(IOCNAME)"

# Directory of ramp rate table
epicsEnvSet "RAMPTABLEDIR" "C:\\Instrument\\Settings\\config\\NDLT658\\configurations\\hifi_ramp_table.txt"
#epicsEnvSet "RAMPTABLEDIR" "C:\\Instrument\\Settings\\config\\NDW1801\\configurations\\cryomag_ramp_table.txt"
## Start any sequence programs

seq fsm, "P=$(P), RAMPTABLEDIR=$(RAMPTABLEDIR)"
