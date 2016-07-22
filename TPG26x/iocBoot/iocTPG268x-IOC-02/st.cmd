#!../../bin/windows-x64/TPG268x-IOC-02

## You may have to change TPG268x-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TPG268x-IOC-02.dbd"
TPG268x_IOC_02_registerRecordDeviceDriver pdbbase

< ${TOP}/iocBoot/iocTPG268x-IOC-01/st-common.cmd
