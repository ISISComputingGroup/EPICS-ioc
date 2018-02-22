
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Configure devices
#drvAsynIPPortConfigure("MC_CPU1","127.0.0.1:5024",0,0,0)
drvAsynIPPortConfigure("MC_CPU1","192.168.1.67:200",0,0,0)
asynOctetSetOutputEos("MC_CPU1", -1, ";\n")
asynOctetSetInputEos("MC_CPU1", -1, ";\n")
#eemcuCreateController("MCU1", "MC_CPU1", "32", "200", "1000")
#eemcuCreateController("MCU1", "MC_CPU1", "2", "200", "1000")
EssMCAGmotorCreateController("MCU1", "MC_CPU1", "2", "200", "1000")
  #define ASYN_TRACE_ERROR     0x0001
  #define ASYN_TRACEIO_DEVICE  0x0002
  #define ASYN_TRACEIO_FILTER  0x0004
  #define ASYN_TRACEIO_DRIVER  0x0008
  #define ASYN_TRACE_FLOW      0x0010
  #define ASYN_TRACE_WARNING   0x0020
  #define ASYN_TRACE_INFO      0x0040
asynSetTraceMask("MC_CPU1", -1, 0x41)
##asynSetTraceMask("MC_CPU1", -1, 0x48)

  #define ASYN_TRACEIO_NODATA 0x0000
  #define ASYN_TRACEIO_ASCII  0x0001
  #define ASYN_TRACEIO_ESCAPE 0x0002
  #define ASYN_TRACEIO_HEX    0x0004
asynSetTraceIOMask("MC_CPU1", -1, 2)
##asynSetTraceIOMask("MC_CPU1", -1, 6)

  #define ASYN_TRACEINFO_TIME 0x0001
  #define ASYN_TRACEINFO_PORT 0x0002
  #define ASYN_TRACEINFO_SOURCE 0x0004
  #define ASYN_TRACEINFO_THREAD 0x0008
asynSetTraceInfoMask("MC_CPU1", -1, 15)

#Parameter 3 eemcuCreateAxis
#define AMPLIFIER_ON_FLAG_CREATE_AXIS  (1)
#define AMPLIFIER_ON_FLAG_WHEN_HOMING  (1<<1)
#define AMPLIFIER_ON_FLAG_USING_CNEN   (1<<2)

#eemcuCreateAxis("MCU1", "1", "1", "")
#eemcuCreateAxis("MCU1", "2", "1", "")
EssMCAGmotorCreateAxis("MCU1", "1", "1", "")
EssMCAGmotorCreateAxis("MCU1", "2", "1", "")
#eemcuCreateAxis("MCU1", "1", "4", "")
#eemcuCreateAxis("MCU1", "2", "4", "")

#eemcuCreateAxis("MCU1", "1", "6", "")
##eemcuCreateAxis("MCU1", "2")
##eemcuCreateAxis("MCU1", "3")
##eemcuCreateAxis("MCU1", "4")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/IMAT.db","P=$(MYPVPREFIX),PORT=MCU1,M1=MOT:MTR0901,M2=MOT:MTR0902")

## motor util package
## note: IOC name needs to have been added to _FAN element of this DB file
dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=MOT:MTR0901")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=MOT:MTR0902")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

motorUtilInit("$(MYPVPREFIX)$(IOCNAME):")

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

