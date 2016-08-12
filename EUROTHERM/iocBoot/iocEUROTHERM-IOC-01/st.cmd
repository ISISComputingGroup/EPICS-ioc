#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet "IOCPVPREFIX" "EUROTHERM1"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHERM-IOC-01.dbd"
EUROTHERM_IOC_01_registerRecordDeviceDriver pdbbase

< st-common.cmd
