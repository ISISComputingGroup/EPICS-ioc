#!../../bin/win32-x86/SDTEST-IOC-01

## You may have to change SDTEST-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/SDTEST-IOC-01.dbd",0,0)
SDTEST_IOC_01_registerRecordDeviceDriver(pdbbase) 

< st-common.cmd

iocInit()

#