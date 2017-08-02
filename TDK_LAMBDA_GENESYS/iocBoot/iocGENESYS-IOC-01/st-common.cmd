## we have no .req files to load
epicsEnvSet ("AUTOSAVEREQ", "#")

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TDKLAMBDAGENESYS)/data"



# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

epicsEnvSet(PS,1)
< st-psu.cmd

epicsEnvSet(PS,2)
< st-psu.cmd

epicsEnvSet(PS,3)
< st-psu.cmd

epicsEnvSet(PS,4)
< st-psu.cmd

epicsEnvSet(PS,5)
< st-psu.cmd

epicsEnvSet(PS,6)
< st-psu.cmd

epicsEnvSet(PS,7)
< st-psu.cmd

epicsEnvSet(PS,8)
< st-psu.cmd

epicsEnvSet(PS,9)
< st-psu.cmd

epicsEnvSet(PS,10)
< st-psu.cmd

## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocGENESYS-IOC-01", "")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit

## Start any sequence programs
#seq sncxxx,"user=kvlb23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
