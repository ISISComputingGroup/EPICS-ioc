#!../../bin/windows-x64/LVTEST-IOC-03

## You may have to change LVTEST-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "$(TOP)/dbd/LVTEST-IOC-03.dbd"
LVTEST_IOC_03_registerRecordDeviceDriver pdbbase

cd ../iocLVTEST-IOC-01

< st-common.cmd
