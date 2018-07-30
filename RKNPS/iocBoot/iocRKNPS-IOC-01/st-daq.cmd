## NI cDAQ-9181 with NI 9375 card

#epicsEnvSet("CDAQ","cDAQ1Mod1")
epicsEnvSet("CDAQ","cDAQ-R3G39Mod1")

## CDAQ port0 is input
DAQmxConfig("R0", "$(CDAQ)/port0/line0", 0, "BI","OneShot N=1 F=0")
DAQmxConfig("R0", "$(CDAQ)/port0/line1", 1, "BI","OneShot N=1 F=0")
DAQmxConfig("R0", "$(CDAQ)/port0/line2", 2, "BI","OneShot N=1 F=0")
DAQmxConfig("R0", "$(CDAQ)/port0/line3", 3, "BI","OneShot N=1 F=0")
DAQmxConfig("R0", "$(CDAQ)/port0/line4", 4, "BI","OneShot N=1 F=0")
DAQmxConfig("R0", "$(CDAQ)/port0/line5", 5, "BI","OneShot N=1 F=0")
#asynSetTraceMask("R0", 0, 0x11)

## CDAQ port1 is output
DAQmxConfig("W0", "$(CDAQ)/port1/line0", 0, "BO","N=1 F=0")
DAQmxConfig("W0", "$(CDAQ)/port1/line1", 1, "BO","N=1 F=0")
#asynSetTraceMask("W0", 0,0x11)

## Load record instances
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseIOC.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,RECSIM=$(RECSIM=0)")

dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=0")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=1")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=2")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=3")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=4")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=5")

dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOut.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=0")
dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOut.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=1")
