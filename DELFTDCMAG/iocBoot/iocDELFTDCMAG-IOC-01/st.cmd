#!../../bin/windows-x64-debug/DELFTDCMAG-IOC-01

## You may have to change DELFTDCMAG-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DELFTDCMAG-IOC-01.dbd"
DELFTDCMAG_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFDEVSIM=#) epicsEnvSet("NETSHRVAR_SIMULATE", 1)
$(IFRECSIM=#) epicsEnvSet("NETSHRVAR_SIMULATE", 1)

## main args are:  portName, configSection, configFile, pollPeriod, options (see NetShrVarConfigure() documentation in NetShrVarDriver.cpp)
##
## portName ("nsv" below) refers to the asyn driver port name - it is the external name used in epics DB files to refer to the driver instance
## configSection ("sec1" below) refers to the section of configFile ("netvarconfig.xml" below) where settings are read from
## configFile is the path to the main configuration file (netvarconfig.xml)
## pollPeriod (100) is the interval (ms) at which the driver will pull values from variables accessed via a BufferedReader connection 
## options (0 below) is currently unused but would map to values in #NetShrVarOptions    
## NetShrVarConfigure("nsv", "sec1", "$(TOP)/data/DELFTDCMAG_nv.xml", 100, 0)
## Modify polling rate of the shared variable list from 100ms to 2.5s. This means... Poll every variable in the list every 2.5s.
NetShrVarConfigure("nsv", "sec1", "$(TOP)/data/DELFTDCMAG_nv.xml", 10, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("PVROOT", "$(MYPVPREFIX)")
#epicsEnvSet("PVROOT", "$(MYPVPREFIX)$(IOCNAME):")

## Load our record instances
#dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR1:,Q=A")
#dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR2:,Q=G")
# Changed to read-write for Larmor Diffraction
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR1A:,Q=A")
#dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR1A:,Q=A")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR1B:,Q=B")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR1C:,Q=C")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR1D:,Q=D")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR1E:,Q=E")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR1F:,Q=F")
# Changed to read-write for Larmor Diffraction
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR2A:,Q=G")
#dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR2A:,Q=G")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR2B:,Q=H")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR2C:,Q=I")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR2D:,Q=J")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR2E:,Q=K")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR2F:,Q=L")
# Changed to read-write for Larmor Diffraction
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR3A:,Q=M")
#dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR3A:,Q=M")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR3B:,Q=N")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR3C:,Q=O")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR3D:,Q=P")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR3E:,Q=Q")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR3F:,Q=R")
# Changed to read-write for Larmor Diffraction
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR4A:,Q=S")
#dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR4A:,Q=S")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR4B:,Q=T")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR4C:,Q=U")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR4D:,Q=V")
dbLoadRecords("db/NSV.db","P=$(PVROOT)MOTOR4E:,Q=W")
dbLoadRecords("db/NSV_read_only.db","P=$(PVROOT)MOTOR4F:,Q=X")
dbLoadRecords("db/NSV1.db","P=$(PVROOT)")

dbLoadRecords("db/NSV1T.db","P=$(PVROOT)")
## list any 4 element arrays from above that we want to break out into individual PVs for logging 
dbLoadRecords("db/NSVTSubarray4.db","P=$(PVROOT),PARAM=AWGCARRIERFREQEPICS")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
