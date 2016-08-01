#!../../bin/windows-x64/eurotherm

## You may have to change eurotherm to something else
## everywhere it appears in this file

< envPaths
epicsEnvSet "IOCPVPREFIX" "EUROTHERM3"

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROTHERM-IOC-03.dbd"
EUROTHERM_IOC_03_registerRecordDeviceDriver pdbbase

< ../iocEUROTHERM-IOC-01/st-common.cmd
