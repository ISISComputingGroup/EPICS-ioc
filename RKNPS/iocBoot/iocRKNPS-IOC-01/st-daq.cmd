## NI cDAQ-9181 with NI 9375 card
epicsEnvSet("CDAQ","cDAQ9181-RFEMod1")

## CDAQ port0 is input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line0", 0, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line1", 1, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line2", 2, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line3", 3, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line4", 4, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line5", 5, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line6", 6, "BI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line7", 7, "BI","OneShot N=1 F=0")

## CDAQ port1 is output
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQ)/port1/line0", 0, "BO","N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQ)/port1/line1", 1, "BO","N=1 F=0")

## Load record instances
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseIOC.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,RECSIM=$(RECSIM=0)")

$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=0,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=1,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=2,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=3,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=4,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=5,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=6,NBITS=8")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigIn.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=R0,CHAN=7,NBITS=8")

$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOut.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=0,WVAL=1")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseDigOut.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,PORT=W0,CHAN=1,WVAL=2")
