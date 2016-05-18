#!../../bin/windows-x64/Lakeshore218-IOC-01

## You may have to change Lakeshore_218-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "TTY" "$(TTY=\\\\\\\\.\\\\COM4)"                                   

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/Lakeshore218-IOC-01.dbd"
Lakeshore218_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocLakeshore218-IOC-01

< st-common.cmd
