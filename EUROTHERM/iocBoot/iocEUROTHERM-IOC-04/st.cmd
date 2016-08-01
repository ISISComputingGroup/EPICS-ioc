#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths
epicsEnvSet "IOCPVPREFIX" "EUROTHERM4"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHERM-IOC-04.dbd"
EUROTHERM_IOC_04_registerRecordDeviceDriver pdbbase

< ../iocEUROTHERM-IOC-01/st-common.cmd
