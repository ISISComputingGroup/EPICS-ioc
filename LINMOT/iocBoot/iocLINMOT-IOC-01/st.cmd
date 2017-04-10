#!../../bin/windows-x64/LINMOT-IOC-01

## You may have to change LINMOT-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase "$(TOP)/dbd/LINMOT-IOC-01.dbd"
LINMOT_IOC_01_registerRecordDeviceDriver pdbbase

# enable debugging
var drvLinMotDebug 5

< st-common.cmd
