#!../../bin/windows-x64/LINMOT-IOC-03

## You may have to change LINMOT-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LINMOT-IOC-03.dbd"
LINMOT_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocLINMOT-IOC-01

< st-common.cmd
