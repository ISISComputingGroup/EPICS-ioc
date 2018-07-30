## Environment Variables

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/master/danfysikMps8000App/protocol/RIKEN/:"

## use with emulator
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## use with real device
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=7)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY="space")")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")
$(IFNOTRECSIM) asynOctetSetInputEos("L0",0,"$(IEOS=\\n\\r)")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0",0,"$(OEOS=\\r)")

## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")

## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## set positions of interlock and power flags in status string
epicsEnvSet "POWER_FLAG_POSITION" "0"
epicsEnvSet "INTERLOCK_FLAG_POSITION" "9"

## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")

## Load record instances
iocshCmdLoop("< iocBoot/iocRKNPS-IOC-01/st-psu.cmd", "PS=\$(I)", "I", 1, 10)

< iocBoot/iocRKNPS-IOC-01/st-daq.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
