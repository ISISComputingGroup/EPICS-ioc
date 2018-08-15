## NI cDAQ-9181 with NI 9375 card
epicsEnvSet("CDAQ","cDAQ9181-RFEMod1")

## CDAQ port0 is input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line0", 0, "AI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line1", 1, "AI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line2", 2, "AI","OneShot N=1 F=0")
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQ)/port0/line3", 3, "AI","OneShot N=1 F=0")


## Load record instances
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseIOC.vdb","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ,RECSIM=$(RECSIM=0)")

$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseAnIn.db","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ:AI,PORT=R0,CHAN=0")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseAnIn.db","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ:AI,PORT=R0,CHAN=1")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseAnIn.db","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ:AI,PORT=R0,CHAN=2")
$(IFNOTDEVSIM) dbLoadRecords("$(DAQMXBASE)/db/DAQmxBaseAnIn.db","DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ:AI,PORT=R0,CHAN=3")

