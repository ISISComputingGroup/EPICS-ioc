##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
asynSetMinTimerPeriod(0.001)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

stringiftest("DIG0", "$(IP_ADDR_0=)", 3)
stringiftest("DIG1", "$(IP_ADDR_1=)", 3)
stringiftest("DIG2", "$(IP_ADDR_2=)", 3)
stringiftest("DIG3", "$(IP_ADDR_3=)", 3)
stringiftest("DIG4", "$(IP_ADDR_4=)", 3)
stringiftest("DIG5", "$(IP_ADDR_5=)", 3)
stringiftest("DIG6", "$(IP_ADDR_6=)", 3)
stringiftest("DIG7", "$(IP_ADDR_7=)", 3)

$(IFDIG0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=0,IP_ADDR=$(IP_ADDR_0=),INDEX=$(INDEX_0=)"
$(IFDIG1) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=1,IP_ADDR=$(IP_ADDR_1=),INDEX=$(INDEX_1=)"
$(IFDIG2) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=2,IP_ADDR=$(IP_ADDR_2=),INDEX=$(INDEX_2=)"
$(IFDIG3) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=3,IP_ADDR=$(IP_ADDR_3=),INDEX=$(INDEX_3=)"
$(IFDIG4) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=4,IP_ADDR=$(IP_ADDR_4=),INDEX=$(INDEX_4=)"
$(IFDIG5) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=5,IP_ADDR=$(IP_ADDR_5=),INDEX=$(INDEX_5=)"
$(IFDIG6) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=6,IP_ADDR=$(IP_ADDR_6=),INDEX=$(INDEX_6=)"
$(IFDIG7) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/st-dig.cmd", "DIG=7,IP_ADDR=$(IP_ADDR_7=),INDEX=$(INDEX_7=)"

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

$(IFDIG0) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=0"
$(IFDIG1) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=1"
$(IFDIG2) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=2"
$(IFDIG3) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=3"
$(IFDIG4) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=4"
$(IFDIG5) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=5"
$(IFDIG6) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=6"
$(IFDIG7) iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/postiocinit-dig.cmd", "DIG=7"
