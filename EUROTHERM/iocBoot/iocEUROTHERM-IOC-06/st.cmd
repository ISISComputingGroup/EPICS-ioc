#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths
epicsEnvSet "IOCPVPREFIX" "EUROTHERM6"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHERM-IOC-06.dbd"
EUROTHERM_IOC_06_registerRecordDeviceDriver pdbbase

< ../iocEUROTHERM-IOC-01/st-common.cmd
