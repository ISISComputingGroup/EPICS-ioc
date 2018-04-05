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
#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

### set initial values here ###
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetConnect("KHLY2700","L0")
## This is across multiple lines as there is a buffer limit
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":SYST:CLE\r\n"						# Clear system errors
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:CLE\r\n"						# Empty buffer readings
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":FUNC 'FRES', (@101:210)\r\n"		# Set function to 'FResistance' and set channels
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":FRES:RANG:AUTO ON\r\n"				# Set auto range to on
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":FRES:DIG 7, (@101:210)\r\n"			# Set number of digits to 7
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 ":FRES:NPLC 5.000000E+0\r\n"			# Set PLC cycles
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRIG:SOUR IMM\r\n"					# Set control source to Immediate
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRIG:DEL:AUTO 0\r\n"					# Set auto delay to On
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:CLE:AUTO ON\r\n"				# Set trace buffer to auto clear
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:POIN 1000\r\n"					# Set trace buffer points to 1000
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:FEED SENS\r\n"					# Set buffer source to raw (sens)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:FEED:CONT ALW\r\n"				# Set buffer control mode to Always
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "TRAC:TST:FORM ABS\r\n"				# Set timestamp format to Absolute
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "INIT:CONT ON\r\n"					# Set continuous initiation to On 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "ROUT:SCAN (@101:210)\r\n"			# Set scan channels start
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "ROUT:SCAN:LSEL INT\r\n"				# Set scan to Internal (starts clicks)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "SAMP:COUN 1\r\n"
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynOctetWrite KHLY2700 "FORM:ELEM READ,CHAN,TST;\r\n"		# Set readback elements (reading, channel, timestamp)




##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
