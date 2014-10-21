#!../../bin/windows-x64/FINS-IOC-02

## You may have to change FINS-IOC-02 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/FINS-IOC-02.dbd"
FINS_IOC_02_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/iocFINS-IOC-01"

< st-common.cmd

