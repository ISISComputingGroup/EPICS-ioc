## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

$(IFPORT)$(IFNOTSIM) asynOctetSetOutputEos("SD$(PN)",0,"$(OEOS$(PN)=\\r\\n)")
$(IFPORT)$(IFNOTSIM) asynOctetSetInputEos("SD$(PN)",0,"$(IEOS$(PN)=\\r\\n)")

stringiftest("TRACEMASK", "$(TRACEMASK$(PN)=)")
$(IFTRACEMASK) asynSetTraceMask("SD$(PN)",0,"$(TRACEMASK$(PN)=)")

stringiftest("TRACEIOMASK", "$(TRACEIOMASK$(PN)=)")
$(IFTRACEIOMASK) asynSetTraceIOMask("SD$(PN)",0,"$(TRACEIOMASK$(PN)=)")

## Load record instances for connected port
dbLoadRecords("$(TOP)/db/SDTEST-IOC-01.db","P=$(MYPVPREFIX),Q=$(IOCNAME):P$(PN):,PORT=SD$(PN),DEV=$(PORT$(PN)=),NAME=$(NAME$(PN)=),DISABLE=$(DISABLE),SIM=$(SIMULATE),SCAN=$(SCAN$(PN)=Passive),GETOUT=$(GETOUT$(PN)=),GETIN=$(GETIN$(PN)=),SETOUTA=$(SETOUTA$(PN)=),SETOUTB=$(SETOUTB$(PN)=),SETOUTC=$(SETOUTC$(PN)=),SETIN=$(SETIN$(PN)=),INITOUT=$(INITOUT$(PN)=),INITIN=$(INITIN$(PN)=),INITP=$(INITP$(PN)=NO),PROTO=$(PROTO$(PN)=SDTEST-default.proto)")

dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(MYPVPREFIX),R=$(IOCNAME):P$(PN):ASYNREC,PORT=SD$(PN),ADDR=0,OMAX=80,IMAX=80")

#
