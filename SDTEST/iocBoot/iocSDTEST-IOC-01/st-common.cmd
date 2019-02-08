## we have no .req files to load
epicsEnvSet ("AUTOSAVEREQ", "#")

< $(IOCSTARTUP)/init.cmd

< $(IOCSTARTUP)/dbload.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data:$(ICPCONFIGROOT)/ioc/SDTEST")

epicsEnvSet(PN,1)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,2)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,3)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,4)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,5)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,6)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,7)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

epicsEnvSet(PN,8)
< st-port-$(PORT$(PN)_TYPE=serial).cmd

## as we are common, we need to explicity define the 01 area for when we are ran by 02, 03 etc 
set_requestfile_path("${TOP}/iocBoot/iocSDTEST-IOC-01", "")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

#
