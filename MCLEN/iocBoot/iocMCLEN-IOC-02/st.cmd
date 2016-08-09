#!../../bin/windows-x64/MCLEN-IOC-02

## You may have to change MCLEN-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MCLEN-IOC-02.dbd"
MCLEN_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocMCLEN-IOC-01

< st-common.cmd
