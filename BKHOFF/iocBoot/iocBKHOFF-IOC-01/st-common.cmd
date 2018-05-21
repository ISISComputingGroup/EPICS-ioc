
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Configure devices
drvAsynIPPortConfigure("MC_CPU1","$(HOST=127.0.0.1:23)",0,0,0)

asynOctetSetOutputEos("MC_CPU1", -1, ";\n")
asynOctetSetInputEos("MC_CPU1", -1, ";\n")
#eemcuCreateController("MCU1", "MC_CPU1", "32", "200", "1000")
#eemcuCreateController("MCU1", "MC_CPU1", "2", "200", "1000")
$(IFNOTDEVSIM=) $(IFNOTRECSIM=) EssMCAGmotorCreateController("MCU1", "MC_CPU1", "2", "200", "1000")
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
$(IFNOTDEVSIM=) $(IFNOTRECSIM=) EssMCAGmotorCreateAxis("MCU1", "1", "1", "")
$(IFNOTDEVSIM=) $(IFNOTRECSIM=) EssMCAGmotorCreateAxis("MCU1", "2", "1", "")
#eemcuCreateAxis("MCU1", "1", "4", "")
#eemcuCreateAxis("MCU1", "2", "4", "")

#eemcuCreateAxis("MCU1", "1", "6", "")
##eemcuCreateAxis("MCU1", "2")
##eemcuCreateAxis("MCU1", "3")
##eemcuCreateAxis("MCU1", "4")

$(IFDEVSIM) < iocBoot/iocBKHOFF-IOC-01/motorsim.cmd 
$(IFRECSIM) < iocBoot/iocBKHOFF-IOC-01/motorsim.cmd

epicsEnvSet("MTRCTRL", "09")
## Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL)", 2, 2)
stringiftest("HASMTRCTRL", "$(MTRCTRL=)", 0, 0)
$(IFNOTHASMTRCTRL) errlogSev(2, "MTRCTRL has not been set")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# specify additional directories in which to to search for included request files
set_requestfile_path("${MOTOR}/motorApp/Db", "")

## as all cd to BKHOFF-IOC-01 need to add this explicitly so info generated req files are found
set_requestfile_path("${TOP}/iocBoot/iocBKHOFF-IOC-01", "")

## Load our record instances
dbLoadRecords("db/IMAT.db","P=$(MYPVPREFIX),PORT=MCU1,M1=MOT:MTR0901,M2=MOT:MTR0902")

## motor util package
## note: IOC name needs to have been added to _FAN element of this DB file
dbLoadRecords("$(AXISRECORD)/db/axisUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")

dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=MOT:MTR0901")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=MOT:MTR0902")

## Load any motor extras from the config directory, e.g. jaws, motion setpoints, motor_extensions
< iocBoot/iocBKHOFF-IOC-01/motor_extras_from_config.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

axisUtilInit("$(MYPVPREFIX)$(IOCNAME):")

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# Save motor positions every 5 seconds
$(IFHASMTRCTRL) $(IFNOTDEVSIM) $(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_positions.req", 5, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")

# Save motor settings every 30 seconds
$(IFHASMTRCTRL) $(IFNOTDEVSIM) $(IFNOTRECSIM) create_monitor_set("$(IOCNAME)_settings.req", 30, "P=$(MYPVPREFIX)MOT:,CCP=$(MTRCTRL)")
