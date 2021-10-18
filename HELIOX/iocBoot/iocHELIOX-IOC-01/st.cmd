#!../../bin/windows-x64/HELIOX-IOC-01

## You may have to change HELIOX to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/HELIOX-IOC-01.dbd"
HELIOX_IOC_01_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocHELIOX-IOC-01/st-common.cmd
