## set PS before calling
## if PS = 1 then the entries for PSU 1 in this IOC will be used for the setup


# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")

# create a real serial port, unless in simulation mode then crreate an unconnected asyn port 
$(IFPORT)$(IFSIM)    drvAsynSerialPortConfigure ("L$(PN)", "NUL", 0, 1)

$(IFPORT)$(IFNOTSIM) drvAsynSerialPortConfigure ("L$(PN)", "$(PORT$(PN)=)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PN)", 0, "baud", "$(BAUD$(PN)=9600)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PN)", 0, "bits", "$(BITS$(PN)=8)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PN)", 0, "parity", "$(PARITY$(PN)=none)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PN)", 0, "stop", "$(STOP$(PN)=1)")
$(IFPORT)$(IFNOTSIM) asynOctetSetInputEos("L$(PN)",0,"$(IEOS$(PN)=\\r)")
$(IFPORT)$(IFNOTSIM) asynOctetSetOutputEos("L$(PN)",0,"$(OEOS$(PN)=\\r)")

## Initialise the comms with the PSU
$(IFPORT)$(IFNOTSIM) asynOctetConnect L$(PN) GENESYS_01$(PN)
$(IFPORT)$(IFNOTSIM) asynOctetWrite GENESYS_01$(PN) “ADR $(ADDR$(PN))”

## Load record instances for connected psu
$(IFPORT)  dbLoadRecords("db/GENESYS.db", "P=$(MYPVPREFIX)$(IOCNAME):$(PN):, PORT=L$(PN), ADR=$(ADDR$(PN))")
