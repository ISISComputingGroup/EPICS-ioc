epicsEnvSet "DEVICE" "L$(CHAIN)"

## use with emulator
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT$(CHAIN))")

## use with real device
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(CHAIN$(CHAIN)_PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(CHAIN$(CHAIN)_BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(CHAIN$(CHAIN)_BITS=7)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(CHAIN$(CHAIN)_PARITY="space")")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(CHAIN$(CHAIN)_STOP=2)")
$(IFNOTRECSIM) asynOctetSetInputEos("$(DEVICE)",0,"$(CHAIN$(CHAIN)_IEOS=\\n\\r)")
$(IFNOTRECSIM) asynOctetSetOutputEos("$(DEVICE)",0,"$(CHAIN$(CHAIN)_OEOS=\\r)")

## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")

## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## set positions of interlock and power flags in status string
epicsEnvSet "POWER_FLAG_POSITION" "0"
epicsEnvSet "INTERLOCK_FLAG_POSITION" "9"

## Load record instances
iocshCmdLoop("< iocBoot/iocRKNPS-IOC-01/st-psu.cmd", "PS=\$(I)", "I", 1, 10)

