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

## main args are:  portName, configSection, configFile, pollPeriod, options (see NetShrVarConfigure() documentation in NetShrVarDriver.cpp)
##
## portName ("nsv" below) refers to the asyn driver port name - it is the external name used in epics DB files to refer to the driver instance
## configSection ("sec1" below) refers to the section of configFile ("netvarconfig.xml" below) where settings are read from
## configFile is the path to the main configuration file (netvarconfig.xml)
## pollPeriod (100) is the interval (ms) at which the driver will pull values from variables accessed via a BufferedReader connection 
## options (0 below) is currently unused but would map to values in #NetShrVarOptions    
#NetShrVarConfigure("nsv", "sec1", "$(TOP)/data/DELFTDCMAG_nv.xml", 100, 0)

lvDCOMConfigure("lvfp", "frontpanel", "$(TOP)/data/mag1.xml", "", 1, "")
#lvDCOMConfigure("lvfp", "frontpanel", "$(TOP)/data/mag2.xml", "", 1, "")

lvDCOMConfigure("polrev", "frontpanel", "$(TOP)/data/polarity_reverser.xml", "", 1, "")
lvDCOMConfigure("arduino", "frontpanel", "$(TOP)/data/arduino_stepper.xml", "", 1, "")


## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/NSV.db","P=$(MYPVPREFIX)DCMAG:")

dbLoadRecords("db/mag1.db","P=$(MYPVPREFIX)DCMAG:")
#dbLoadRecords("db/mag2.db","P=$(MYPVPREFIX)DCMAG:")

dbLoadRecords("db/polarity_reverser.db","P=$(MYPVPREFIX)POLREV:,PORT=polrev")
dbLoadRecords("db/arduino_stepper.db","P=$(MYPVPREFIX)ARDSTEP:,PORT=arduino")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
