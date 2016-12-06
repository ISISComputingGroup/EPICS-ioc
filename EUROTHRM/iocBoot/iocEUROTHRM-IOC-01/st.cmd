#!../../bin/windows-x64/EUROTHRM

## You may have to change EUROTHRM to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet "IOCPVPREFIX" "EUROTHRM_01"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHRM-IOC-01.dbd"
EUROTHRM_IOC_01_registerRecordDeviceDriver pdbbase

< st-common.cmd
