#!../../bin/windows-x64-debug/HVCAEN-IOC-01

## You may have to change HVCAEN-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAEN-IOC-01.dbd"
HVCAEN_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFREADONLY= ) epicsEnvSet CAN_WRITE "#"

# use -D argument to turn on debugging

stringiftest("IP0Present", "$(HVCAENIP0="")", 13, "")
stringiftest("IP1Present", "$(HVCAENIP1="")", 13, "")
stringiftest("IP2Present", "$(HVCAENIP2="")", 13, "")
stringiftest("IP3Present", "$(HVCAENIP3="")", 13, "")
stringiftest("IP4Present", "$(HVCAENIP4="")", 13, "")
stringiftest("IP5Present", "$(HVCAENIP5="")", 13, "")
stringiftest("IP6Present", "$(HVCAENIP6="")", 13, "")
stringiftest("IP7Present", "$(HVCAENIP7="")", 13, "")


## arguments to CAENx527ConfigureCreate are: name, ip_address, username, password
## username, password are optional and the crate factory default is used if these are not specified
$(IFIP0Present) CAENx527ConfigureCreate "hv0!$(HVCAENSYSTYPE0=SY1527)", "$(HVCAENIP0="")"
$(IFIP1Present) CAENx527ConfigureCreate "hv1!$(HVCAENSYSTYPE1=SY1527)", "$(HVCAENIP1="")"
$(IFIP2Present) CAENx527ConfigureCreate "hv2!$(HVCAENSYSTYPE2=SY1527)", "$(HVCAENIP2="")"
$(IFIP3Present) CAENx527ConfigureCreate "hv3!$(HVCAENSYSTYPE3=SY1527)", "$(HVCAENIP3="")"
$(IFIP4Present) CAENx527ConfigureCreate "hv4!$(HVCAENSYSTYPE4=SY1527)", "$(HVCAENIP4="")"
$(IFIP5Present) CAENx527ConfigureCreate "hv5!$(HVCAENSYSTYPE5=SY1527)", "$(HVCAENIP5="")"
$(IFIP6Present) CAENx527ConfigureCreate "hv6!$(HVCAENSYSTYPE6=SY1527)", "$(HVCAENIP6="")"
$(IFIP7Present) CAENx527ConfigureCreate "hv7!$(HVCAENSYSTYPE7=SY1527)", "$(HVCAENIP7="")"


##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=faa59Host")
$(CAN_WRITE= ) CAENx527DbLoadRecords("P=$(MYPVPREFIX)CAEN, ALARM_WHEN_ON=$(ALARM_WHEN_ON=NO_ALARM), ALARM_WHEN_RAMPING=$(ALARM_WHEN_RAMPING=NO_ALARM), ASG=READONLY")
$(IFREADONLY= ) CAENx527DbLoadRecords("P=$(MYPVPREFIX)CAEN, ALARM_WHEN_ON=$(ALARM_WHEN_ON=NO_ALARM), ALARM_WHEN_RAMPING=$(ALARM_WHEN_RAMPING=NO_ALARM), ASG=DEFAULT")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq sncSummary, "P=$(MYPVPREFIX)CAEN"
