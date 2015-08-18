#!../../bin/win32-x86/SDTEST-IOC-02

## You may have to change SDTEST-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase("$(TOP)/dbd/SDTEST-IOC-02.dbd",0,0)
SDTEST_IOC_02_registerRecordDeviceDriver(pdbbase) 

cd ../iocSDTEST-IOC-01

< st-common.cmd

#
