#!../../bin/windows-x64-debug/SKFCHOPPER-IOC-04

## You may have to change SKFCHOPPER-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/SKFCHOPPER-IOC-04.dbd"
SKFCHOPPER_IOC_04_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

< st-common.cmd
