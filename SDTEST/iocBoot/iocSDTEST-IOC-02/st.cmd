#!../../bin/win32-x86/SDTEST-IOC-02

## You may have to change SDTEST-IOC-02 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/SDTEST-IOC-02.dbd",0,0)
SDTEST_IOC_02_registerRecordDeviceDriver(pdbbase) 

cd ../iocSDTEST-IOC-01

< st-common.cmd

iocInit()

## Start any sequence programs
#seq sncSDTEST-IOC-02,"user=faa59"
