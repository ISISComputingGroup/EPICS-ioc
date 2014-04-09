#!../../bin/windows-x64-debug/GALIL-IOC-07

## You may have to change GALIL-IOC-07 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-07.dbd"
GALIL_IOC_07_registerRecordDeviceDriver pdbbase

epicsEnvSet("GALIL01","${TOP}/iocBoot/iocGALIL-IOC-01")

< $(GALIL01)/st-common.cmd