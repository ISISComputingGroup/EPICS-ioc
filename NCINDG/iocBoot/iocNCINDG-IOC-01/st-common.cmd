##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
asynSetMinTimerPeriod(0.001)
callbackSetQueueSize(20000)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

stringiftest("DIGIP0", "$(IP_ADDR_0=)", 3)
stringiftest("DIGIP1", "$(IP_ADDR_1=)", 3)
stringiftest("DIGIP2", "$(IP_ADDR_2=)", 3)
stringiftest("DIGIP3", "$(IP_ADDR_3=)", 3)
stringiftest("DIGIP4", "$(IP_ADDR_4=)", 3)
stringiftest("DIGIP5", "$(IP_ADDR_5=)", 3)
stringiftest("DIGIP6", "$(IP_ADDR_6=)", 3)
stringiftest("DIGIP7", "$(IP_ADDR_7=)", 3)

$(IFDIGIP0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=0,IP_ADDR=$(IP_ADDR_0=),INDEX=$(INDEX_0=)"
$(IFDIGIP1) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=1,IP_ADDR=$(IP_ADDR_1=),INDEX=$(INDEX_1=)"
$(IFDIGIP2) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=2,IP_ADDR=$(IP_ADDR_2=),INDEX=$(INDEX_2=)"
$(IFDIGIP3) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=3,IP_ADDR=$(IP_ADDR_3=),INDEX=$(INDEX_3=)"
$(IFDIGIP4) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=4,IP_ADDR=$(IP_ADDR_4=),INDEX=$(INDEX_4=)"
$(IFDIGIP5) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=5,IP_ADDR=$(IP_ADDR_5=),INDEX=$(INDEX_5=)"
$(IFDIGIP6) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=6,IP_ADDR=$(IP_ADDR_6=),INDEX=$(INDEX_6=)"
$(IFDIGIP7) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=7,IP_ADDR=$(IP_ADDR_7=),INDEX=$(INDEX_7=)"

dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigGlobal.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IFDIG0=$(IFDIGIP0),IFDIG1=$(IFDIGIP1),IFDIG2=$(IFDIGIP2),IFDIG3=$(IFDIGIP3),IFDIG4=$(IFDIGIP4),IFDIG5=$(IFDIGIP5),IFDIG6=$(IFDIGIP6),IFDIG7=$(IFDIGIP7)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

$(IFDIGIP0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=0"
$(IFDIGIP1) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=1"
$(IFDIGIP2) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=2"
$(IFDIGIP3) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=3"
$(IFDIGIP4) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=4"
$(IFDIGIP5) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=5"
$(IFDIGIP6) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=6"
$(IFDIGIP7) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=7"
