#!../../bin/windows-x64/GALIL-IOC-01

## You may have to change GALIL-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-01.dbd"
GALIL_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

## uncomment to see every command sent to this galil, or define in st-common.cmd for every galil
#epicsEnvSet("GALIL_DEBUG_FILE", "galil1_debug.txt")

< st-common.cmd
