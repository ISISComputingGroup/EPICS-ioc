#!../../bin/windows-x64-debug/HVCAENA-IOC-01

## You may have to change HVCAENA-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAENA-IOC-01.dbd"
HVCAENA_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

CAENHVAsynReadOnly($(READ_ONLY=0))

stringiftest("IP0Present", "$(IP_ADDRESS_0="")", 13, "")
$(IFIP0Present) CAENHVAsynSetEpicsPrefix("$(MYPVPREFIX)$(IOCNAME):HV0:")
$(IFIP0Present) CAENHVAsynConfig("HV0",$(SYS_TYPE_0),"$(IP_ADDRESS_0)","admin","admin")

stringiftest("IP1Present", "$(IP_ADDRESS_1="")", 13, "")
$(IFIP1Present) CAENHVAsynSetEpicsPrefix("$(MYPVPREFIX)$(IOCNAME):HV1:")
$(IFIP1Present) CAENHVAsynConfig("HV1",$(SYS_TYPE_1),"$(IP_ADDRESS_1)","admin","admin")

stringiftest("IP2Present", "$(IP_ADDRESS_2="")", 13, "")
$(IFIP2Present) CAENHVAsynSetEpicsPrefix("$(MYPVPREFIX)$(IOCNAME):HV2:")
$(IFIP2Present) CAENHVAsynConfig("HV2",$(SYS_TYPE_2),"$(IP_ADDRESS_2)","admin","admin")

stringiftest("IP3Present", "$(IP_ADDRESS_3="")", 13, "")
$(IFIP3Present) CAENHVAsynSetEpicsPrefix("$(MYPVPREFIX)$(IOCNAME):HV3:")
$(IFIP3Present) CAENHVAsynConfig("HV3",$(SYS_TYPE_3),"$(IP_ADDRESS_3)","admin","admin")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
