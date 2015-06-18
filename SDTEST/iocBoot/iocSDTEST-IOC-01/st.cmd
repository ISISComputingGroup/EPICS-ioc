#!../../bin/win32-x86/SDTEST-IOC-01

## You may have to change SDTEST-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase("$(TOP)/dbd/SDTEST-IOC-01.dbd",0,0)
SDTEST_IOC_01_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("PORT1","130.246.51.169:23")

< st-common.cmd

#