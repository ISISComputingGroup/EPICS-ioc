< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data")

epicsEnvSet(PN,1)
< st-port.cmd

epicsEnvSet(PN,2)
< st-port.cmd

epicsEnvSet(PN,3)
< st-port.cmd

epicsEnvSet(PN,4)
< st-port.cmd

epicsEnvSet(PN,5)
< st-port.cmd

epicsEnvSet(PN,6)
< st-port.cmd

epicsEnvSet(PN,7)
< st-port.cmd

epicsEnvSet(PN,8)
< st-port.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

#