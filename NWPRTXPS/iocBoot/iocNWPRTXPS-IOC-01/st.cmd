#!../../bin/windows-x64/NWPRTXPS-IOC-01

## You may have to change NWPRTXPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "$(TOP)/dbd/NWPRTXPS-IOC-01.dbd"
NWPRTXPS_IOC_01_registerRecordDeviceDriver pdbbase

# enable debugging
var drvPM304Debug 0

< st-common.cmd
