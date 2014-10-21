#!../../bin/windows-x64/FINS-IOC-01

## You may have to change FINS-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/FINS-IOC-01.dbd"
FINS_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

< st-common.cmd
