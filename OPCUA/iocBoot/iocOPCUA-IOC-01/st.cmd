#!../../bin/windows-x64/OPCUA-IOC-01

## You may have to change OPCUA-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/OPCUA-IOC-01.dbd"
OPCUA_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

< st-common.cmd
