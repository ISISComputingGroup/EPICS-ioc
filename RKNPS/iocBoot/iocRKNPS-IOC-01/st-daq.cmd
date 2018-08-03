## NI cDAQ-9181 with NI 9375 card
epicsEnvSet("CDAQ","cDAQ-R3G39Mod1")

## CDAQ port0 is input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line0:5", 0, "BI","OneShot N=1 F=0")

## CDAQ port1 is output
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQ)/port1/line0", 0, "BO","N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQ)/port1/line1", 1, "BO","N=1 F=0")

## Load record instances
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseIOC.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,RECSIM=$(RECSIM=0)")

$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigInDirect.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=0,NBITS=6")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigInDirect.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=1,NBITS=6")

$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOutLine.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=0,SHFT=0")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOutLine.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=1,SHFT=1")
