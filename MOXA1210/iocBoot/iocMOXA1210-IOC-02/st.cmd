#!../../bin/windows-x64/MOXA1210-IOC-02

## You may have to change MOXA1210-IOC-02 to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/MOXA1210-IOC-02.dbd"
MOXA1210_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC common boot file
< ${TOP}/iocBoot/iocMOXA1210-IOC-01/st-common.cmd