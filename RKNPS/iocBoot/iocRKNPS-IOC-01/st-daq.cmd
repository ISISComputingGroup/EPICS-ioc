## NI cDAQ-9181 with NI 9375 card

#epicsEnvSet("CDAQ","cDAQ1Mod1")
epicsEnvSet("CDAQ","cDAQ-R3G39Mod1")

## CDAQ port0 is input
DAQmxConfig("R0", "$(CDAQ)/port0/line0:5", 0, "BI","OneShot N=1 F=0")
#asynSetTraceMask("R0", 0, 0x11)

## CDAQ port1 is output
DAQmxConfig("W0", "$(CDAQ)/port1/line0", 0, "BO","N=1 F=0")
DAQmxConfig("W0", "$(CDAQ)/port1/line1", 1, "BO","N=1 F=0")
#asynSetTraceMask("W0", 0,0x11)

## Load record instances
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseIOC.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,RECSIM=$(RECSIM=0)")

dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigInDirect.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=0,NBITS=6")

dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOutLine.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=0,SHFT=0")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOutLine.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=1,SHFT=1")
