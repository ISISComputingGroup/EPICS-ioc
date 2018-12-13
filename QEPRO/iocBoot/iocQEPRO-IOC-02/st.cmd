#!../../bin/win32-x86/QEPRO-IOC-02

## You may have to change QEPRO-IOC-02 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/QEPRO-IOC-02.dbd",0,0)
QEPRO_IOC_02_registerRecordDeviceDriver(pdbbase) 

cd ../iocQEPRO-IOC-01

epicsEnvSet("DEVICE_ID",1)

< st-common.cmd
