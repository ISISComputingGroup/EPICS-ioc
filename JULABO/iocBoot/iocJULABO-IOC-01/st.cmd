#!../../bin/windows-x64-debug/JULABO-IOC-01

## You may have to change JULABO-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/JULABO-IOC-01.dbd"
JULABO_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocJULABO-IOC-01

< st-common.cmd
