#!../../bin/windows-x64/BKHOFF-IOC-02

## You may have to change BKHOFF-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/BKHOFF-IOC-02.dbd"
BKHOFF_IOC_02_registerRecordDeviceDriver pdbbase

< iocBoot/iocBKHOFF-IOC-01/st-common.cmd



