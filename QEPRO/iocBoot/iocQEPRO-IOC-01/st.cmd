#!../../bin/win32-x86/QEPRO-IOC-01

## You may have to change QEPRO-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/QEPRO-IOC-01.dbd",0,0)
QEPRO_IOC_01_registerRecordDeviceDriver(pdbbase) 

< st-common.cmd
