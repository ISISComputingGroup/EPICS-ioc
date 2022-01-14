#!../../bin/windows-x64-debug/SKFCHOPPER-IOC-06

## You may have to change SKFCHOPPER-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/SKFCHOPPER-IOC-06.dbd"
SKFCHOPPER_IOC_06_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

# set name of chopper port for use later
epicsEnvSet("CHOP", "c6")

< ../iocSKFCHOPPER-IOC-01/st-common.cmd
