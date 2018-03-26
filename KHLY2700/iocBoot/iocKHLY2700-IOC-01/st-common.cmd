epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KHLY2700)/Keithley_2700Sup"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/keithley2700.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
dbLoadRecords("${TOP}/db/keithley2700_channels.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

## For debugging:
asynSetTraceMask("L0",-1,0x9) 
asynSetTraceIOMask("L0",-1,0x2)

### set initial values here ###
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetConnect("KHLY2700","L0")
## This is across multiple lines as there is a buffer limit
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":SYST:CLE;TRAC:CLE;:FUNC "FRES", (@101:210);:FRES:RANG:AUTO ON, (@101:210)\r\n"
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":FRES:DIG 7, (@101:210);:FRES:NPLC 5.000000E+0;TRIG:SOUR IMM;TRIG:DEL:AUTO 0\r\n"
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:CLE:AUTO ON;TRAC:POIN 1000;TRAC:FEED SENS;TRAC:FEED:CONT ALW;TRAC:TST:FORM ABS\r\n"
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "INIT:CONT ON\r\n"
##$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "ROUT:SCAN (@101:205);ROUT:SCAN:LSEL INT;SAMP:COUN 1\r\n"
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "ROUT:SCAN:LSEL INT;ROUT:SCAN:LSEL NONE\r\n"


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
