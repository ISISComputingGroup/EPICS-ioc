#!../../bin/windows-x64/KEIT2400-IOC-02

## You may have to change KEIT2400-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/KEIT2400-IOC-02.dbd"
KEIT2400_IOC_02_registerRecordDeviceDriver pdbbase

< ../iocKEIT2400-IOC-01/st-common.cmd