## we have no .req files to load
epicsEnvSet ("AUTOSAVEREQ", "#")

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TDKLAMBDAGENESYS)/data"

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
