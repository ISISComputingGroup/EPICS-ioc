#!../../bin/windows-x64/HELIOX-IOC-02

## You may have to change HELIOX to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/HELIOX-IOC-02.dbd"
HELIOX_IOC_02_registerRecordDeviceDriver pdbbase

< $(TOP)/iocboot/iocHELIOX-IOC-01/st-common.cmd
