#!../../bin/windows-x64/MERCURY-IOC-01
## You may have to change MERCURY-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

epicsEnvSet(IOC_NUM,1)
## Register all support components
dbLoadDatabase "dbd/MERCURY-IOC-01.dbd"
MERCURY_IOC_01_registerRecordDeviceDriver pdbbase

< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-common.cmd
