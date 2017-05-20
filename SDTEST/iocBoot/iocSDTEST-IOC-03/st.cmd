#!../../bin/windows-x64/SDTEST-IOC-03

## You may have to change SDTEST-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "$(TOP)/dbd/SDTEST-IOC-03.dbd"
SDTEST_IOC_03_registerRecordDeviceDriver pdbbase

cd ../iocSDTEST-IOC-01

< st-common.cmd

#
