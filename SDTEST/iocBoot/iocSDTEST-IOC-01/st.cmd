#!../../bin/win32-x86/SDTEST-IOC-01

## You may have to change SDTEST-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/SDTEST-IOC-01.dbd",0,0)
SDTEST_IOC_01_registerRecordDeviceDriver(pdbbase) 

< $(IOCSTARTUP)/init.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data")

epicsEnvSet(PN,1)
< st-common.cmd

epicsEnvSet(PN,2)
< st-common.cmd

epicsEnvSet(PN,3)
< st-common.cmd

epicsEnvSet(PN,4)
< st-common.cmd

epicsEnvSet(PN,5)
< st-common.cmd

epicsEnvSet(PN,6)
< st-common.cmd

epicsEnvSet(PN,7)
< st-common.cmd

epicsEnvSet(PN,8)
< st-common.cmd

iocInit()

#