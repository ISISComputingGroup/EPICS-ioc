#!../../bin/windows-x64-debug/SKFCHOPPER-IOC-03

## You may have to change SKFCHOPPER-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/SKFCHOPPER-IOC-03.dbd"
SKFCHOPPER_IOC_03_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocSKFCHOPPER-IOC-01

< st-common.cmd
