#!../../bin/windows-x64-debug/CONEXAGP-IOC-01

## You may have to change CONEXAGP-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/CONEXAGP-IOC-01.dbd"
CONEXAGP_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

< st-common.cmd
