## set PS before calling
## if PS = 1 then the entries for PSU 1 in this IOC will be used for the setup


# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PS)=)")

# create a real serial port, unless in simulation mode then create an unconnected asyn port 
$(IFPORT)$(IFSIM)    drvAsynSerialPortConfigure ("L$(PS)", "NUL", 0, 1)

$(IFPORT)$(IFNOTSIM) drvAsynSerialPortConfigure ("L$(PS)", "$(PORT$(PS)=)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PS)", 0, "baud", "$(BAUD$(PS)=9600)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PS)", 0, "bits", "$(BITS$(PS)=8)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PS)", 0, "parity", "$(PARITY$(PS)=none)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("L$(PS)", 0, "stop", "$(STOP$(PS)=1)")
$(IFPORT)$(IFNOTSIM) asynOctetSetInputEos("L$(PS)",0,"$(IEOS$(PS)=\\r)")
$(IFPORT)$(IFNOTSIM) asynOctetSetOutputEos("L$(PS)",0,"$(OEOS$(PS)=\\r)")

## Initialise the comms with the PSU
$(IFPORT)$(IFNOTSIM) asynOctetConnect("GENESYS_01$(PS)","L$(PS)")
$(IFPORT)$(IFNOTSIM) asynOctetWrite GENESYS_01$(PS) “ADR $(ADDR$(PS))”

## Load record instances for connected psu
$(IFPORT)  dbLoadRecords("$(TOP)/db/TDK_LAMBDA_GENESYS.db", "P=$(MYPVPREFIX)$(IOCNAME):$(PS):, PORT=L$(PS), ADR=$(ADDR$(PS)), SP_PINI=$(SP_AT_STARTUP$(PS)=NO)")
