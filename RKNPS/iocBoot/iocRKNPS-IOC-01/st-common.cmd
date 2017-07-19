## Environment Variables

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/master/danfysikMps8000App/protocol/RIKEN/:"

## use with emulator
#drvAsynIPPortConfigure("L0", "localhost:xxxxx")

## use with real device
drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
asynSetOption("L0", -1, "bits", "$(BITS=7)")
asynSetOption("L0", -1, "parity", "$(PARITY="space")")
asynSetOption("L0", -1, "stop", "$(STOP=1)")
asynOctetSetInputEos("L0",0,"$(IEOS=\\n\\r)")
asynOctetSetOutputEos("L0",0,"$(OEOS=\\r)")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## set positions of interlock and power flags in status string
epicsEnvSet "POWER_FLAG_POSITION" "0"
epicsEnvSet "INTERLOCK_FLAG_POSITION" "9"

## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")

## Load record instances
iocshCmdLoop("< iocBoot/iocRKNPS-IOC-01/st-psu.cmd", "PS=\$(I)", "I", 1, 10)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
