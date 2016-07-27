#!../../bin/windows-x64/LKSH336-IOC-02

## You may have to change LKSH336-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LKSH336-IOC-02.dbd"
LKSH336_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocLKSH336-IOC-01

< st-common.cmd
