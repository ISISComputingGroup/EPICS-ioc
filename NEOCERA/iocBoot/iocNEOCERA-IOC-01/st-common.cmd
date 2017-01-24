
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(NEOCERA)/data"

< $(IOCSTARTUP)/init.cmd

$(IFRECSIM) $(IFDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFRECSIM) $(IFDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFRECSIM) $(IFDEVSIM) asynSetOption("L0", -1, "bits", "8")
$(IFRECSIM) $(IFDEVSIM) asynSetOption("L0", -1, "parity", "none")
$(IFRECSIM) $(IFDEVSIM) asynSetOption("L0", -1, "stop", "1")

< $(IOCSTARTUP)/dbload.cmd

##
##
##
##
##
dbLoadRecords("$(TOP)/db/devNeocera.db","P=$(MYPVPREFIX)$(IOCNAME):,DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

