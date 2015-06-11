## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")

$(IFPORT) drvAsynSerialPortConfigure ("SD$(PN)", "$(PORT$(PN)=)")
$(IFPORT) asynSetOption ("SD$(PN)", 0, "baud", "$(BAUD$(PN)=9600)")
$(IFPORT) asynSetOption ("SD$(PN)", 0, "bits", "$(BITS$(PN)=8)")
$(IFPORT) asynSetOption ("SD$(PN)", 0, "parity", "$(PARITY$(PN)=none)")
$(IFPORT) asynSetOption ("SD$(PN)", 0, "stop", "$(STOP$(PN)=1)")
$(IFPORT) asynSetOption ("SD$(PN)", 0, "clocal", "$(CLOCAL$(PN)=Y)") # if N, output flow control using DSR signal
$(IFPORT) asynSetOption ("SD$(PN)", 0, "crtscts", "$(CRTSCTS$(PN)=N)") # if Y, use hardware flow control (RTS/CTS)
$(IFPORT) asynSetOption ("SD$(PN)", 0, "ixon", "$(IXON$(PN)=N)") # if Y, use software flow control for output
$(IFPORT) asynSetOption ("SD$(PN)", 0, "ixoff", "$(IXOFF$(PN)=N)") # if Y, use software flow control for input
$(IFPORT) asynOctetSetOutputEos("SD$(PN)",0,"$(OEOS$(PN)=\\r\\n)")
$(IFPORT) asynOctetSetInputEos("SD$(PN)",0,"$(IEOS$(PN)=\\r\\n)")
$(IFPORT) asynSetTraceMask("SD$(PN)",0,"$(TRACEMASK$(PN)=0x0)")
$(IFPORT) asynSetTraceIOMask("SD$(PN)",0,"$(TRACEIOMASK$(PN)=0x0)")

## Load record instances for connected port
$(IFPORT) dbLoadRecords("$(TOP)/db/SDTEST-IOC-01.db","P=$(MYPVPREFIX),Q=$(IOCNAME):P$(PN):,PORT=SD$(PN),DEV=$(PORT$(PN)=),NAME=$(PORT$(PN)_NAME=),DISABLE=0,SIM=0")

$(IFPORT) dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(MYPVPREFIX),R=$(IOCNAME):P$(PN):ASYNREC,PORT=SD$(PN),ADDR=0,OMAX=80,IMAX=80")

## Load record instances for undefined port
## not quite working - need something better than NUL
#$(IFNOTPORT) drvAsynSerialPortConfigure ("SD$(PN)", "$(PORT$(PN)=NUL)")
#$(IFNOTPORT) dbLoadRecords("$(TOP)/db/SDTEST-IOC-01.db","P=$(MYPVPREFIX),Q=$(IOCNAME):P$(PN):,PORT=SD$(PN),DEV=,NAME=$(PORT$(PN)_NAME=),DISABLE=1,SIM=1")

#