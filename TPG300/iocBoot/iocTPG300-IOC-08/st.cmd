#!../../bin/windows-x64-debug/TPG300-IOC-08

## You may have to change TPG300-IOC-08 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TPG300-IOC-08.dbd"
TPG300_IOC_08_registerRecordDeviceDriver pdbbase

< ${TOP}/iocBoot/iocTPG300-IOC-01/st-common.cmd
