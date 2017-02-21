#!../../bin/windows-x64/CCD100-IOC-02

## You may have to change CCD100-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/CCD100-IOC-02.dbd"
CCD100_IOC_02_registerRecordDeviceDriver pdbbase

< ../iocCCD100-IOC-01/st-common.cmd
